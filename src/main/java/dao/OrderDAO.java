package dao;

import java.sql.*;
import util.KoneksiDB;
import model.Order;

public class OrderDAO {

    public boolean insertOrder(Order o) {
        Connection c = null;
        PreparedStatement psOrder = null;
        PreparedStatement psService = null;
        ResultSet rs = null;

        try {
            c = KoneksiDB.getConnection();
            c.setAutoCommit(false); 

            String sqlOrder = "INSERT INTO orders (user_id, total_kg, total_amount, status, notes) VALUES (?, ?, ?, ?, ?)";
            psOrder = c.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            
            psOrder.setInt(1, o.getUserId());
            psOrder.setDouble(2, o.getTotalKg());
            psOrder.setDouble(3, 0); 
            psOrder.setString(4, "Pending");
            psOrder.setString(5, o.getNotes());
            
            psOrder.executeUpdate();

            int newOrderId = 0;
            rs = psOrder.getGeneratedKeys();
            if (rs.next()) {
                newOrderId = rs.getInt(1);
            } else {
                throw new SQLException("Gagal dapat ID Order");
            }

            String sqlService = "INSERT INTO order_services (order_id, service_id, kg, subtotal) VALUES (?, ?, ?, ?)";
            psService = c.prepareStatement(sqlService);
            
            psService.setInt(1, newOrderId);
            psService.setInt(2, o.getServiceId());
            psService.setDouble(3, o.getTotalKg());
            psService.setDouble(4, 0); 
            
            psService.executeUpdate();

            c.commit();
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
}