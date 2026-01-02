package util;

import java.sql.Connection;
import java.sql.DriverManager;

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
}