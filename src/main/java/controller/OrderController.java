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
import model.Service;     // Tambahan Import
import dao.OrderDAO;
import dao.ServiceDAO;   // Tambahan Import

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

        // 2. Ambil Data dari Form
        int serviceId = Integer.parseInt(request.getParameter("service_id"));
        String deliveryType = request.getParameter("delivery_type");
        String noHp = request.getParameter("no_hp");
        String metode = request.getParameter("pembayaran");
        
        double berat = 0;
        String beratStr = request.getParameter("berat");
        if(beratStr != null && !beratStr.isEmpty()) {
            berat = Double.parseDouble(beratStr);
        }
        
        // Cek Alamat
        String alamatFinal;
        if ("dropoff".equals(deliveryType)) {
            alamatFinal = "-"; // Kalau antar sendiri, alamat kosong strip
        } else {
            alamatFinal = request.getParameter("alamat");
        }

        // --- 3. HITUNG TOTAL HARGA (PERBAIKAN UTAMA) ---
        ServiceDAO svcDao = new ServiceDAO();
        Service svc = svcDao.getServiceById(serviceId);
        
        double totalHarga = 0;
        if(svc != null) {
            // Rumus: Berat * Harga per Kg (atau per Unit)
            totalHarga = berat * svc.getPrice();
        }

        // 4. Masukkan ke Object Order
        Order o = new Order();
        o.setUserId(currentUser.getId());
        o.setServiceId(serviceId);
        o.setTotalKg(berat);
        o.setTotalAmount(totalHarga); // Set Harga yang sudah dihitung
        o.setDeliveryType(deliveryType);
        o.setPickupAddress(alamatFinal);
        o.setPickupPhone(noHp);
        o.setNotes("Pembayaran: " + metode); // Catatan simpel

        // 5. Simpan ke Database
        OrderDAO dao = new OrderDAO();
        boolean berhasil = dao.insertOrder(o);

        if(berhasil) {
            // Redirect sukses
            response.sendRedirect("index.jsp?status=sukses");
        } else {
            // Redirect gagal
            response.sendRedirect("order-form.jsp?id=" + serviceId + "&status=gagal");
        }
    }
}