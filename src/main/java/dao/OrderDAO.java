package dao;

import java.sql.*;
import java.util.*;
import util.KoneksiDB;
import model.Order;

public class OrderDAO {

    // 1. INPUT PESANAN BARU
    public boolean insertOrder(Order o) {
        Connection c = null;
        PreparedStatement psOrder = null;
        PreparedStatement psService = null;
        ResultSet rs = null;

        try {
            c = KoneksiDB.getConnection();
            c.setAutoCommit(false); // Transaction Start

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

    // 2. AMBIL SEMUA PESANAN (UNTUK ADMIN DASHBOARD)
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.order_id, o.order_date, o.total_kg, o.total_amount, o.status, " +
                     "o.delivery_type, o.pickup_address, " +
                     "u.name AS user_name, " +
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
                list.add(o);
            }
        } catch (Exception e) {
            System.out.println("Error getAllOrders: " + e.getMessage());
        }
        return list;
    }

    // 3. UPDATE STATUS
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

    // 4. RIWAYAT PESANAN USER
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

    // 5. DETAIL PESANAN (UNTUK INVOICE)
    // *** BAGIAN INI SUDAH DIPERBAIKI UNTUK MENGAMBIL NO HP DARI ORDERS ***
    public Order getOrderById(int orderId) {
        Order o = null;
        String sql = "SELECT o.order_id, o.order_date, o.total_kg, o.total_amount, o.status, " +
                     "o.delivery_type, o.pickup_address, o.pickup_phone, " + // Ambil pickup_phone dari tabel orders
                     "u.name AS user_name, " + 
                     "s.name AS service_name, s.price AS service_price " +
                     "FROM orders o " +
                     "JOIN users u ON o.user_id = u.user_id " +
                     "JOIN order_services os ON o.order_id = os.order_id " +
                     "JOIN services s ON os.service_id = s.service_id " +
                     "WHERE o.order_id = ?";

        try (java.sql.Connection c = util.KoneksiDB.getConnection();
             java.sql.PreparedStatement ps = c.prepareStatement(sql)) {
            
            ps.setInt(1, orderId);
            
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if(rs.next()) {
                    o = new Order();
                    o.setOrderId(rs.getInt("order_id"));
                    o.setOrderDate(rs.getTimestamp("order_date"));
                    o.setTotalKg(rs.getDouble("total_kg"));
                    o.setTotalAmount(rs.getDouble("total_amount"));
                    o.setStatus(rs.getString("status"));
                    o.setDeliveryType(rs.getString("delivery_type"));
                    o.setPickupAddress(rs.getString("pickup_address"));
                    
                    // --- PERBAIKAN: Ambil phone dari Order, bukan User ---
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
}