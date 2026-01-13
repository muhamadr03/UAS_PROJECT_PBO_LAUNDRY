package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.ServiceDAO;
import model.Service;

@WebServlet(name = "ServiceController", urlPatterns = {"/ServiceController"})
public class ServiceController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        ServiceDAO dao = new ServiceDAO();
        
        try {
            if ("add".equals(action)) {
                Service s = new Service();
                s.setName(request.getParameter("name"));
                s.setPrice(Double.parseDouble(request.getParameter("price")));
                // Handle Estimasi Hari (Default 1 jika kosong)
                String est = request.getParameter("estimated_days");
                s.setEstimatedDays(est != null && !est.isEmpty() ? Integer.parseInt(est) : 1);
                s.setUnit(request.getParameter("unit"));
                
                dao.insertService(s);
                
            } else if ("update".equals(action)) {
                Service s = new Service();
                s.setId(Integer.parseInt(request.getParameter("id")));
                s.setName(request.getParameter("name"));
                s.setPrice(Double.parseDouble(request.getParameter("price")));
                
                String est = request.getParameter("estimated_days");
                s.setEstimatedDays(est != null && !est.isEmpty() ? Integer.parseInt(est) : 1);
                s.setUnit(request.getParameter("unit"));
                
                dao.updateService(s);
                
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deleteService(id);
            }
            
            response.sendRedirect("admin/services.jsp?msg=sukses");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/services.jsp?msg=gagal");
        }
    }
}