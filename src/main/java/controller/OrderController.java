package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.User;
import model.Service;
import dao.OrderDAO;
import dao.ServiceDAO;

@WebServlet(name = "OrderController", urlPatterns = {"/OrderController"})
public class OrderController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
         
        // 1. Cek Login
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            response.sendRedirect("admin/login.jsp");
            return;
        }

        try {
            // 2. Ambil Data dari Form JSP
            int serviceId = Integer.parseInt(request.getParameter("service_id"));
            String deliveryType = request.getParameter("delivery_type");
            String noHp = request.getParameter("no_hp"); // Ambil No HP
            String metode = request.getParameter("pembayaran");
            String notes = request.getParameter("notes");
            String alamatInput = request.getParameter("alamat");
            
            double berat = 0;
            String beratStr = request.getParameter("berat");
            if(beratStr != null && !beratStr.isEmpty()) {
                berat = Double.parseDouble(beratStr);
            }
            
            // Logika Alamat
            String alamatFinal;
            if ("dropoff".equals(deliveryType)) {
                alamatFinal = "-"; // Kalau antar sendiri, alamat dikosongkan/strip
            } else {
                alamatFinal = alamatInput;
            }

            // 3. HITUNG TOTAL HARGA (Termasuk Ongkir)
            ServiceDAO svcDao = new ServiceDAO();
            Service svc = svcDao.getServiceById(serviceId);
            
            double totalHarga = 0;
            if(svc != null) {
                // Rumus Dasar: Berat * Harga Layanan
                totalHarga = berat * svc.getPrice();
                
                // Tambahan Ongkir jika Pickup (Antar Jemput)
                // Pastikan nilai ini SAMA dengan yang di JavaScript (10.000)
                if ("pickup".equalsIgnoreCase(deliveryType)) {
                    totalHarga += 10000; 
                }
            }

            // 4. Masukkan ke Object Order
            Order o = new Order();
            o.setUserId(currentUser.getId());
            o.setServiceId(serviceId);
            o.setTotalKg(berat);
            o.setTotalAmount(totalHarga); // Total sudah termasuk ongkir
            o.setDeliveryType(deliveryType);
            o.setPickupAddress(alamatFinal);
            o.setPickupPhone(noHp); // PENTING: Set No HP ke Object
            
            // Menggabungkan Metode Pembayaran ke dalam Notes agar admin tahu
            String catatanLengkap = "Pembayaran: " + metode;
            if(notes != null && !notes.isEmpty()) {
                catatanLengkap += " | Catatan: " + notes;
            }
            o.setNotes(catatanLengkap);

            // 5. Simpan ke Database
            OrderDAO dao = new OrderDAO();
            boolean berhasil = dao.insertOrder(o);

            if(berhasil) {
                // Redirect sukses ke halaman User (Riwayat Pesanan)
                response.sendRedirect("my-orders.jsp?status=sukses");
            } else {
                // Redirect gagal kembali ke form
                response.sendRedirect("order-form.jsp?id=" + serviceId + "&status=gagal");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?error=system");
        }
    }
}