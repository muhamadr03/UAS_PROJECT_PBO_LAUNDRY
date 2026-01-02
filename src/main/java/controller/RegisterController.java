package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import dao.UserDAO;

@WebServlet(name = "RegisterController", urlPatterns = {"/RegisterController"})
public class RegisterController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         
        String nama = request.getParameter("nama");
        String email = request.getParameter("email");
        String pass = request.getParameter("password");
        
        User u = new User();
        u.setName(nama);
        u.setEmail(email);
        u.setPassword(pass);
        
        UserDAO dao = new UserDAO();
        boolean sukses = dao.registerUser(u);
        
        if(sukses) {
            response.sendRedirect("admin/login.jsp?status=registered");
        } else {
            response.sendRedirect("admin/register.jsp?error=gagal");
        }
    }
}