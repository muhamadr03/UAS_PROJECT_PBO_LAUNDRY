/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.File;
import java.nio.file.Paths;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig; // WAJIB UNTUK UPLOAD
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.GalleryDAO;
import model.Gallery;


@WebServlet(name = "GalleryController", urlPatterns = {"/GalleryController"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class GalleryController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        GalleryDAO dao = new GalleryDAO();

        try {
            if ("upload".equals(action)) {
                String title = request.getParameter("title");
                Part filePart = request.getPart("file"); // Ambil file dari form
                
                // 1. Ambil Nama File
                String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
String fileName = System.currentTimeMillis() + "_" + originalName;
                
                // 2. Tentukan Lokasi Simpan (Folder 'uploads' di dalam web pages)
                // Note: Saat development, folder ini ada di build/web/uploads.
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir(); // Buat folder jika belum ada
                
                // 3. Simpan File Fisik ke Folder
                filePart.write(uploadPath + File.separator + fileName);
                
                // 4. Simpan Nama File ke Database
                Gallery g = new Gallery();
                g.setTitle(title);
                g.setImagePath(fileName);
                dao.insertPhoto(g);
                
                response.sendRedirect("admin/gallery.jsp?msg=sukses");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deletePhoto(id);
                // Note: Menghapus file fisik di folder agak kompleks, kita hapus di DB saja cukup untuk pemula.
                response.sendRedirect("admin/gallery.jsp?msg=deleted");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/gallery.jsp?msg=error");
        }
    }
    
}
