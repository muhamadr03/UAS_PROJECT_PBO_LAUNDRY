package dao;

import java.sql.*;
import util.KoneksiDB;
import model.User;

public class UserDAO {
    
    public User authenticate(String email, String password) {
        User u = null;
        String sql = "SELECT * FROM users WHERE email = ? AND password_hash = ?";
        
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, password);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                u = new User();
                u.setId(rs.getInt("user_id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                
                u.setPhone(rs.getString("phone"));
                u.setAddress(rs.getString("address"));
            }
            
        } catch (Exception e) {
            System.out.println("Error Login: " + e.getMessage());
        }
        return u; 
    }
    
    public boolean registerUser(User u) {
        String sql = "INSERT INTO users (name, email, password_hash, phone, role, address) VALUES (?, ?, ?, ?, 'customer', ?)";
        
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            
            ps.setString(1, u.getName());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());
            
            ps.setString(4, u.getPhone()); 
            ps.setString(5, u.getAddress());
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (Exception e) {
            System.out.println("Error Register: " + e.getMessage());
            return false;
        }
    }
}