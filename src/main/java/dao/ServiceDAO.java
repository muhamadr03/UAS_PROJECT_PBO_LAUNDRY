package dao;

import java.sql.*;
import java.util.*;
import util.KoneksiDB;
import model.Service;

public class ServiceDAO {
     
    public List<Service> getAllServices() {
        List<Service> list = new ArrayList<>();
        
        String sql = "SELECT * FROM services ORDER BY service_id ASC";
        
        try (Connection c = KoneksiDB.getConnection();
             Statement s = c.createStatement();
             ResultSet r = s.executeQuery(sql)) {
            
            while (r.next()) {
                Service svc = new Service();
                
                svc.setId(r.getInt("service_id"));
                svc.setName(r.getString("name"));
                
                svc.setPrice(r.getDouble("price")); 
                
                svc.setDuration(r.getInt("estimated_days"));
                
                svc.setUnit(r.getString("unit")); 
                
                list.add(svc);
            }
        } catch (Exception e) {
            System.out.println("Error ambil data: " + e.getMessage());
        }
        return list;
    }
    
    public Service getServiceById(int id) {
        Service svc = null;
        String sql = "SELECT * FROM services WHERE service_id = ?";
        
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet r = ps.executeQuery();
            
            if (r.next()) {
                svc = new Service();
                svc.setId(r.getInt("service_id"));
                svc.setName(r.getString("name"));
                
                svc.setPrice(r.getDouble("price")); 
                svc.setDuration(r.getInt("estimated_days"));
                svc.setUnit(r.getString("unit"));
            }
        } catch (Exception e) {
            System.out.println("Error ambil detail service: " + e.getMessage());
        }
        return svc;
    }

    public static void main(String[] args) {
        ServiceDAO dao = new ServiceDAO();
        List<Service> data = dao.getAllServices();
        
        System.out.println("=== TES DATABASE SERVICES ===");
        for(Service s : data) {
            System.out.println(s.getName() + " | Rp " + (int)s.getPrice() + " / " + s.getUnit());
        }
    }
}