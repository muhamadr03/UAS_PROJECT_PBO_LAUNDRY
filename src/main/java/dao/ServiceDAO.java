package dao;

import java.sql.*;
import java.util.*;
import util.KoneksiDB;
import model.Service;

public class ServiceDAO {

    // 1. AMBIL SEMUA (READ)
    public List<Service> getAllServices() {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT * FROM services ORDER BY service_id ASC";
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while(rs.next()) {
                Service s = new Service();
                s.setId(rs.getInt("service_id"));
                s.setName(rs.getString("name"));
                s.setPrice(rs.getDouble("price"));
                s.setEstimatedDays(rs.getInt("estimated_days")); 
                s.setUnit(rs.getString("unit"));
                list.add(s);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 2. TAMBAH (CREATE)
    public boolean insertService(Service s) {
        String sql = "INSERT INTO services (name, price, estimated_days, unit) VALUES (?, ?, ?, ?)";
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setDouble(2, s.getPrice());
            ps.setInt(3, s.getEstimatedDays());
            ps.setString(4, s.getUnit());
            ps.executeUpdate();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 3. EDIT (UPDATE)
    public boolean updateService(Service s) {
        String sql = "UPDATE services SET name=?, price=?, estimated_days=?, unit=? WHERE service_id=?";
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setDouble(2, s.getPrice());
            ps.setInt(3, s.getEstimatedDays());
            ps.setString(4, s.getUnit());
            ps.setInt(5, s.getId());
            ps.executeUpdate();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 4. HAPUS (DELETE)
    public boolean deleteService(int id) {
        String sql = "DELETE FROM services WHERE service_id=?";
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
    
    // 5. GET BY ID (PENTING UNTUK ORDER)
    public Service getServiceById(int id) {
        Service s = null;
        String sql = "SELECT * FROM services WHERE service_id=?";
        try (Connection c = KoneksiDB.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if(rs.next()) {
                    s = new Service();
                    s.setId(rs.getInt("service_id"));
                    s.setName(rs.getString("name"));
                    s.setPrice(rs.getDouble("price"));
                    s.setEstimatedDays(rs.getInt("estimated_days"));
                    s.setUnit(rs.getString("unit"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return s;
    }
}