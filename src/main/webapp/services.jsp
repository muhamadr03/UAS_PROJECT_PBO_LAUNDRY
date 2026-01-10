<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dao.ServiceDAO"%>
<%@page import="model.Service"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Daftar Layanan Laundry</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="container mt-5">
        
        <h2 class="mb-4 text-center">Daftar Harga Layanan Laundry</h2>
        
        <div class="card shadow">
            <div class="card-body">
                <table class="table table-striped table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Nama Layanan</th>
                            <th>Harga per KG</th>
                            <th>Estimasi Waktu</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            ServiceDAO dao = new ServiceDAO();
                            
                            List<Service> layanans = dao.getAllServices();
 
                            for(Service s : layanans) {
                        %>
                        <tr>
                            <td><%= s.getId() %></td>
                            <td><strong><%= s.getName() %></strong></td>
                            <td>Rp <%= String.format("%,.0f", s.getPrice()) %></td>
                            <td><%= s.getDuration() %> Hari</td>
                        </tr>
                        <% 
                            } 
                        %>
                    </tbody>
                </table>
            </div>
        </div>
            
        <div class="mt-3 text-center">
            <a href="index.html" class="btn btn-secondary">Kembali ke Menu Utama</a>
        </div>

    </body>
</html>