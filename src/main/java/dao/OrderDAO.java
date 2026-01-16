package dao;

import java.sql.*;
import java.util.*;
import util.KoneksiDB;
import model.Order;

public class OrderDAO {

    // INPUT PESANAN BARU
    public boolean insertOrder(Order o) {
        Connection c = null;
        PreparedStatement psOrder = null;
        PreparedStatement psService = null;
        ResultSet rs = null;

        try {
            c = KoneksiDB.getConnection();
            c.setAutoCommit(false);

            // Query Insert Lengkap
            String sqlOrder = "INSERT INTO orders (user_id, total_kg, total_amount, status, notes, delivery_type, pickup_address, pickup_phone) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            
            psOrder = c.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, o.getUserId());
            psOrder.setDouble(2, o.getTotalKg());
            psOrder.setDouble(3, o.getTotalAmount());
            psOrder.setString(4, "Pending");
            psOrder.setString(5, o.getNotes());
            psOrder.setString(6, o.getDeliveryType());
            psOrder.setString(7, o.getPickupAddress());
            psOrder.setString(8, o.getPickupPhone()); // Pastikan ini tersimpan
            
            psOrder.executeUpdate();

            // Ambil ID Order yang baru dibuat
            int newOrderId = 0;
            rs = psOrder.getGeneratedKeys();
            if (rs.next()) {
                newOrderId = rs.getInt(1);
            } else {
                throw new SQLException("Gagal membuat order, ID tidak kembali.");
            }

            // Simpan detail layanan (Order Services)
            String sqlService = "INSERT INTO order_services (order_id, service_id, kg, subtotal) VALUES (?, ?, ?, ?)";
            psService = c.prepareStatement(sqlService);
            psService.setInt(1, newOrderId);
            psService.setInt(2, o.getServiceId());
            psService.setDouble(3, o.getTotalKg());
            psService.setDouble(4, o.getTotalAmount());
            
            psService.executeUpdate();

            c.commit(); // Transaction Success
            return true;

        } catch (Exception e) {
            try { if (c != null) c.rollback(); } catch (Exception ex) {}
            e.printStackTrace();
            return false;
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (psOrder != null) psOrder.close(); } catch (Exception e) {}
            try { if (psService != null) psService.close(); } catch (Exception e) {}
            try { if (c != null) c.close(); } catch (Exception e) {}
        }
    }

    // =========================================================================
    // PERBAIKAN UTAMA ADA DI SINI (GET ALL ORDERS)
    // =========================================================================
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        
        // KITA TAMBAHKAN: o.pickup_phone DAN u.phone AS user_phone
        String sql = "SELECT o.order_id, o.order_date, o.total_kg, o.total_amount, o.status, " +
                     "o.delivery_type, o.pickup_address, o.pickup_phone, " + // <--- Ambil Phone Order
                     "u.name AS user_name, u.phone AS user_phone, " +        // <--- Ambil Phone User
                     "s.name AS service_name " +
                     "FROM orders o " +
                     "JOIN users u ON o.user_id = u.user_id " +
                     "JOIN order_services os ON o.order_id = os.order_id " +
                     "JOIN services s ON os.service_id = s.service_id " +
                     "ORDER BY o.order_date DESC";

        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while(rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getInt("order_id"));
                o.setOrderDate(rs.getTimestamp("order_date"));
                o.setTotalKg(rs.getDouble("total_kg"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setStatus(rs.getString("status"));
                o.setDeliveryType(rs.getString("delivery_type"));
                o.setPickupAddress(rs.getString("pickup_address"));
                o.setUserName(rs.getString("user_name"));
                o.setServiceName(rs.getString("service_name"));
                
                // --- LOGIKA CERDAS PENGAMBILAN NOMOR HP ---
                // 1. Ambil nomor dari inputan order
                String hpPesanan = rs.getString("pickup_phone");
                // 2. Ambil nomor dari profil user
                String hpUser = rs.getString("user_phone");
                
                // 3. Prioritas: Pakai nomor order, kalau kosong pakai nomor user
                if(hpPesanan != null && !hpPesanan.isEmpty()) {
                    o.setPickupPhone(hpPesanan);
                } else {
                    o.setPickupPhone(hpUser);
                }
                // ------------------------------------------

                list.add(o);
            }
        } catch (Exception e) {
            System.out.println("Error getAllOrders: " + e.getMessage());
        }
        return list;
    }

    // UPDATE STATUS
    public void updateStatus(int orderId, String newStatus) {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (Exception e) {
             System.out.println("Error updateStatus: " + e.getMessage());
        }
    }

    // RIWAYAT PESANAN USER
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.order_id, o.order_date, o.total_kg, o.total_amount, o.status, " +
                     "o.delivery_type, " + 
                     "s.name AS service_name " +
                     "FROM orders o " +
                     "JOIN order_services os ON o.order_id = os.order_id " +
                     "JOIN services s ON os.service_id = s.service_id " +
                     "WHERE o.user_id = ? " +
                     "ORDER BY o.order_date DESC";

        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while(rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getInt("order_id"));
                    o.setOrderDate(rs.getTimestamp("order_date"));
                    o.setTotalKg(rs.getDouble("total_kg"));
                    o.setTotalAmount(rs.getDouble("total_amount"));
                    o.setStatus(rs.getString("status"));
                    o.setDeliveryType(rs.getString("delivery_type"));
                    o.setServiceName(rs.getString("service_name"));
                    list.add(o);
                }
            }
        } catch (Exception e) {
            System.out.println("Error getOrdersByUserId: " + e.getMessage());
        }
        return list;
    }

    // DETAIL PESANAN (UNTUK INVOICE)
    public Order getOrderById(int orderId) {
        Order o = null;
        String sql = "SELECT o.order_id, o.order_date, o.total_kg, o.total_amount, o.status, " +
                     "o.delivery_type, o.pickup_address, o.pickup_phone, " + 
                     "u.name AS user_name, " + 
                     "s.name AS service_name, s.price AS service_price " +
                     "FROM orders o " +
                     "JOIN users u ON o.user_id = u.user_id " +
                     "JOIN order_services os ON o.order_id = os.order_id " +
                     "JOIN services s ON os.service_id = s.service_id " +
                     "WHERE o.order_id = ?";

        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            
            ps.setInt(1, orderId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if(rs.next()) {
                    o = new Order();
                    o.setOrderId(rs.getInt("order_id"));
                    o.setOrderDate(rs.getTimestamp("order_date"));
                    o.setTotalKg(rs.getDouble("total_kg"));
                    o.setTotalAmount(rs.getDouble("total_amount"));
                    o.setStatus(rs.getString("status"));
                    o.setDeliveryType(rs.getString("delivery_type"));
                    o.setPickupAddress(rs.getString("pickup_address"));
                    
                    o.setPickupPhone(rs.getString("pickup_phone")); 
                    
                    o.setUserName(rs.getString("user_name"));
                    o.setServiceName(rs.getString("service_name"));
                }
            }
        } catch (Exception e) {
            System.out.println("Error getOrderById: " + e.getMessage());
        }
        return o;
    }
    
    // LAPORAN PENDAPATAN
    public List<Order> getReportByDate(String startDate, String endDate) {
        List<Order> list = new ArrayList<>();
        
        String sql = "SELECT o.order_id, o.order_date, o.status, o.total_amount, o.total_kg, "
                   + "u.name as user_name, "      
                   + "s.name as service_name "    
                   + "FROM orders o "
                   + "JOIN users u ON o.user_id = u.user_id "               
                   + "JOIN order_services os ON o.order_id = os.order_id "  
                   + "JOIN services s ON os.service_id = s.service_id "     
                   + "WHERE o.order_date BETWEEN ? AND ? "
                   + "ORDER BY o.order_date DESC";
        
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            
            String startFull = startDate + " 00:00:00";
            String endFull = endDate + " 23:59:59";
            
            ps.setTimestamp(1, java.sql.Timestamp.valueOf(startFull)); 
            ps.setTimestamp(2, java.sql.Timestamp.valueOf(endFull));
            
            try (ResultSet rs = ps.executeQuery()) {
                while(rs.next()) {
                    Order o = new Order();
                    
                    o.setOrderId(rs.getInt("order_id"));          
                    o.setOrderDate(rs.getTimestamp("order_date"));
                    o.setStatus(rs.getString("status"));
                    o.setTotalAmount(rs.getDouble("total_amount"));
                    o.setTotalKg(rs.getDouble("total_kg"));
                    
                    o.setUserName(rs.getString("user_name"));
                    o.setServiceName(rs.getString("service_name"));
                    
                    list.add(o);
                }
            }
        } catch (Exception e) {
            System.out.println("ERROR SQL LAPORAN: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }
}