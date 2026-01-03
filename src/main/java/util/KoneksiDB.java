package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import model.User;

public class KoneksiDB {
    
    public static Connection getConnection() {
        try {
            Class.forName("org.postgresql.Driver");
            
            String url = "jdbc:postgresql://localhost:5432/laundry_db";
            
            String user = "postgres";
            String pass = "123";
             
            return DriverManager.getConnection(url, user, pass);
            
        } catch (Exception e) {
            System.err.println("Koneksi Gagal: " + e.getMessage());
            return null;
        }
    }
    
    public static void main(String[] args) {
        Connection c = getConnection();
        if (c != null) {
            System.out.println(">>> Koneksi Berhasil <<<");
        } else {
            System.out.println(">>> Koneksi Gagal <<<");
        }
    }
    
    public java.util.List<User> getAllUsers() {
        java.util.List<User> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY user_id DESC";
        
        try (Connection c = KoneksiDB.getConnection();
             Statement s = c.createStatement();
             ResultSet rs = s.executeQuery(sql)) {
            
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("user_id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone")); // Pastikan kolom database sesuai
                u.setRole(rs.getString("role"));
                u.setAddress(rs.getString("address")); // Pastikan kolom database sesuai
                
                list.add(u);
            }
        } catch (Exception e) {
            System.out.println("Error getAllUsers: " + e.getMessage());
        }
        return list;
    }
}
    
