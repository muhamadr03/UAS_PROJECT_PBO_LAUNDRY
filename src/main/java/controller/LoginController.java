package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; 
import model.User;
import dao.UserDAO;

@WebServlet(name = "LoginController", urlPatterns = {"/LoginController"})
public class LoginController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         
        String email = request.getParameter("email");
        String pass = request.getParameter("password");
        
        UserDAO dao = new UserDAO();
        User user = dao.authenticate(email, pass);
        
        if (user != null) {
            
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", user);
            
            String role = user.getRole().toLowerCase();

            if (role.equals("admin") || role.equals("superadmin")) {
                response.sendRedirect("admin/dashboard.jsp");
            } else {
                response.sendRedirect("index.jsp");
            }
            
        } else {
            response.sendRedirect("admin/login.jsp?error=invalid");
        }
    }
}