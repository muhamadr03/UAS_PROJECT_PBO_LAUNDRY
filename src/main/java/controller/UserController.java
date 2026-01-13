package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.UserDAO;
import model.User;

@WebServlet(name = "UserController", urlPatterns = {"/UserController"})
public class UserController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        UserDAO dao = new UserDAO();

        try {
            if ("add".equals(action)) {
                User u = new User();
                u.setName(request.getParameter("name"));
                u.setEmail(request.getParameter("email"));
                u.setPassword(request.getParameter("password")); // Password text biasa
                u.setPhone(request.getParameter("phone"));
                u.setAddress(request.getParameter("address"));
                u.setRole(request.getParameter("role"));
                
                dao.insertUser(u);

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                User u = new User();
                u.setId(id);
                u.setName(request.getParameter("name"));
                u.setEmail(request.getParameter("email"));
                u.setPhone(request.getParameter("phone"));
                u.setAddress(request.getParameter("address"));
                u.setRole(request.getParameter("role"));
                
                dao.updateUser(u);

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deleteUser(id);
            }
            response.sendRedirect("admin/users.jsp?msg=sukses");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/users.jsp?msg=gagal");
        }
    }
}