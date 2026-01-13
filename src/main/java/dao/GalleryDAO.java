package dao;
import java.sql.*;
import java.util.*;
import util.KoneksiDB;
import model.Gallery;

public class GalleryDAO {
    
    // AMBIL SEMUA FOTO
    public List<Gallery> getAllPhotos() {
        List<Gallery> list = new ArrayList<>();
        String sql = "SELECT * FROM gallery ORDER BY uploaded_at DESC";
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while(rs.next()) {
                Gallery g = new Gallery();
                g.setId(rs.getInt("id"));
                g.setTitle(rs.getString("title"));
                g.setImagePath(rs.getString("image_path"));
                g.setUploadedAt(rs.getTimestamp("uploaded_at"));
                list.add(g);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // UPLOAD FOTO (Simpan nama file ke DB)
    public boolean insertPhoto(Gallery g) {
        String sql = "INSERT INTO gallery (title, image_path) VALUES (?, ?)";
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, g.getTitle());
            ps.setString(2, g.getImagePath());
            ps.executeUpdate();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // HAPUS FOTO
    public boolean deletePhoto(int id) {
        String sql = "DELETE FROM gallery WHERE id=?";
        try (Connection c = KoneksiDB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
}