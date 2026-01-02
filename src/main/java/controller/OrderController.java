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
import dao.OrderDAO;

@WebServlet(name = "OrderController", urlPatterns = {"/OrderController"})
public class OrderController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            response.sendRedirect("admin/login.jsp");
            return;
        }

        int serviceId = Integer.parseInt(request.getParameter("service_id"));
        String deliveryType = request.getParameter("delivery_type");
        String noHp = request.getParameter("no_hp");
        String metode = request.getParameter("pembayaran");
        
        double berat = 0;
        String beratStr = request.getParameter("berat");
        if(beratStr != null && !beratStr.isEmpty()) {
            berat = Double.parseDouble(beratStr);
        }
        
        String alamatFinal;
        if ("dropoff".equals(deliveryType)) {
            alamatFinal = "-";
        } else {
            alamatFinal = request.getParameter("alamat");
        }

        Order o = new Order();
        o.setUserId(currentUser.getId());
        o.setServiceId(serviceId);
        o.setTotalKg(berat);
        o.setDeliveryType(deliveryType);
        o.setPickupAddress(alamatFinal);
        o.setPickupPhone(noHp);
        o.setNotes("Pembayaran: " + metode);

        OrderDAO dao = new OrderDAO();
        boolean berhasil = dao.insertOrder(o);

        if(berhasil) {
            response.sendRedirect("index.jsp?status=sukses");
        } else {
            response.sendRedirect("order-form.jsp?id=" + serviceId + "&status=gagal");
        }
    }
}