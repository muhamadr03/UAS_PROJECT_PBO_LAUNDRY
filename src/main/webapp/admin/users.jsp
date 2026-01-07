<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dao.UserDAO"%>
<%@page import="model.User"%>

<%
    User admin = (User) session.getAttribute("currentUser");
    if(admin == null || (
       !"admin".equalsIgnoreCase(admin.getRole()) && 
       !"superadmin".equalsIgnoreCase(admin.getRole())
       )) {
        response.sendRedirect("../index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Data Pelanggan | Clean Laundry</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    
    <style>
        body { font-family: 'Poppins', sans-serif; overflow-x: hidden; background-color: #f0f2f5; }
        
        /* --- LAYOUT SIDEBAR --- */
        #wrapper { display: flex; width: 100%; transition: all 0.3s; }
        #sidebar-wrapper {
            min-width: 250px; max-width: 250px;
            background-color: #212529; color: white;
            min-height: 100vh; transition: margin 0.3s ease-out;
        }
        #wrapper.toggled #sidebar-wrapper { margin-left: -250px; }
        #page-content-wrapper { width: 100%; flex: 1; }
        
        .sidebar-heading { padding: 1.5rem 1.25rem; font-size: 1.2rem; font-weight: bold; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .list-group-item { border: none; padding: 15px 25px; background-color: transparent; color: rgba(255,255,255,0.7); }
        .list-group-item:hover { background-color: rgba(255,255,255,0.1); color: white; }
        .list-group-item.active { background-color: #0d6efd; color: white; font-weight: bold; }

        .card-table { border-radius: 15px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }

        /* --- CUSTOM DATATABLES STYLE --- */
        
        /* 1. Kotak Pencarian (Search) */
        .dataTables_filter { text-align: right; }
        .dataTables_filter label { width: 100%; max-width: 300px; position: relative; display: inline-flex; align-items: center; }
        .dataTables_filter input {
            width: 100% !important; padding: 10px 20px; padding-left: 40px;
            border-radius: 50px; border: 1px solid #e0e0e0;
            background-color: #fff; box-shadow: 0 4px 10px rgba(0,0,0,0.03);
            transition: all 0.3s ease; margin-left: 0 !important; font-size: 0.9rem;
        }
        .dataTables_filter input:focus { border-color: #0d6efd; box-shadow: 0 4px 15px rgba(13, 110, 253, 0.15); outline: none; }
        .dataTables_filter label::before {
            content: "\f002"; font-family: "Font Awesome 6 Free"; font-weight: 900;
            position: absolute; left: 15px; color: #aaa; pointer-events: none; font-size: 0.9rem;
        }

        /* 2. Length Select (Tampilkan X data) - DIPERBAIKI */
        .dataTables_length { text-align: left; }
        .dataTables_length label { font-weight: normal; color: #6c757d; font-size: 0.9rem; }
        .dataTables_length select {
            border-radius: 50px; 
            padding: 8px 30px 8px 15px; 
            border: 1px solid #e0e0e0;
            background-color: #fff;
            margin: 0 5px;
            font-size: 0.9rem;
            cursor: pointer;
        }
        .dataTables_length select:focus { border-color: #0d6efd; outline: none; }

        /* 3. Pagination */
        .dataTables_paginate { margin-top: 20px; display: flex; justify-content: flex-end; gap: 5px; }
        .page-item .page-link {
            border: none; border-radius: 50%; width: 35px; height: 35px;
            display: flex; align-items: center; justify-content: center;
            color: #555; font-weight: 600; background: transparent; transition: all 0.2s;
        }
        .page-item.active .page-link { background-color: #0d6efd; color: white; box-shadow: 0 4px 10px rgba(13, 110, 253, 0.3); }
        .page-item:hover .page-link:not(.active) { background-color: #f0f2f5; color: #0d6efd; }

        @media (max-width: 768px) {
            #sidebar-wrapper { margin-left: -250px; }
            #wrapper.toggled #sidebar-wrapper { margin-left: 0; }
            .dataTables_filter, .dataTables_length { text-align: center; margin-bottom: 10px; }
        }
    </style>
</head>
<body>

    <div class="d-flex" id="wrapper">

        <div class="border-end" id="sidebar-wrapper">
            <div class="sidebar-heading border-bottom bg-dark text-white">
                <i class="fas fa-soap me-2"></i> Clean Admin
            </div>
            <div class="list-group list-group-flush mt-3">
                <a href="dashboard.jsp" class="list-group-item list-group-item-action">
                    <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                </a>
                <a href="orders.jsp" class="list-group-item list-group-item-action">
                    <i class="fas fa-shopping-basket me-2"></i> Kelola Pesanan
                </a>
                <a href="users.jsp" class="list-group-item list-group-item-action active">
                    <i class="fas fa-users me-2"></i> Data Pelanggan
                </a>
                <a href="../index.jsp" class="list-group-item list-group-item-action mt-5">
                    <i class="fas fa-home me-2"></i> Ke Website Utama
                </a>
                <a href="../LogoutController" class="list-group-item list-group-item-action text-danger">
                    <i class="fas fa-sign-out-alt me-2"></i> Logout
                </a>
            </div>
        </div>

        <div id="page-content-wrapper">

            <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom shadow-sm px-3 py-3">
                <div class="container-fluid">
                    <button class="btn btn-outline-dark" id="menu-toggle"><i class="fas fa-bars"></i></button>
                    
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent">
                        <span class="navbar-toggler-icon"></span>
                    </button>

                    <div class="collapse navbar-collapse" id="navbarSupportedContent">
                        <ul class="navbar-nav ms-auto mt-2 mt-lg-0 align-items-center">
                            <li class="nav-item">
                                <span class="nav-link fw-bold text-dark">Hi, <%= admin.getName() %></span>
                            </li>
                            <li class="nav-item">
                                <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center fw-bold ms-2" style="width: 35px; height: 35px;">
                                    <%= admin.getName().substring(0,1).toUpperCase() %>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>

            <div class="container-fluid px-4 py-4" id="main-content">
                
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h3 class="fw-bold mb-1">Data Pengguna</h3>
                        <p class="text-muted">Daftar semua akun yang terdaftar di sistem.</p>
                    </div>
                    <button class="btn btn-primary rounded-pill shadow-sm" onclick="window.print()">
                        <i class="fas fa-print me-2"></i> Cetak Laporan
                    </button>
                </div>

                <div class="card card-table overflow-hidden">
                    <div class="card-body p-4">
                        <div class="table-responsive">
                            
                            <table id="tableUser" class="table table-striped table-hover align-middle mb-0" style="width:100%">
                                <thead class="bg-primary text-white">
                                    <tr>
                                        <th class="ps-4 py-3">ID</th>
                                        <th>Nama Lengkap</th>
                                        <th>Kontak (Email & HP)</th>
                                        <th>Role</th>
                                        <th>Alamat Utama</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        UserDAO dao = new UserDAO();
                                        List<User> users = dao.getAllUsers();
                                        for(User u : users) {
                                    %>
                                    <tr>
                                        <td class="ps-4 fw-bold">#<%= u.getId() %></td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="bg-light rounded-circle p-2 me-2 text-primary fw-bold border" 
                                                     style="width: 40px; height: 40px; text-align: center;">
                                                    <%= u.getName().substring(0, 1).toUpperCase() %>
                                                </div>
                                                <span class="fw-bold text-dark"><%= u.getName() %></span>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="small"><i class="fas fa-envelope text-muted me-2"></i><%= u.getEmail() %></div>
                                            <div class="small text-muted"><i class="fas fa-phone text-muted me-2"></i><%= u.getPhone() != null ? u.getPhone() : "-" %></div>
                                        </td>
                                        <td>
                                            <% if("superadmin".equalsIgnoreCase(u.getRole())) { %>
                                                <span class="badge bg-dark rounded-pill px-3">SUPER ADMIN</span>
                                            <% } else if("admin".equalsIgnoreCase(u.getRole())) { %>
                                                <span class="badge bg-danger rounded-pill px-3">ADMIN</span>
                                            <% } else { %>
                                                <span class="badge bg-success rounded-pill px-3">CUSTOMER</span>
                                            <% } %>
                                        </td>
                                        <td class="small text-muted" style="max-width: 300px;">
                                            <%= u.getAddress() != null && !u.getAddress().isEmpty() ? u.getAddress() : "<span class='fst-italic'>Belum diisi</span>" %>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div> 
        </div> 
    </div> 

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
    
    <script>
        var el = document.getElementById("wrapper");
        var toggleButton = document.getElementById("menu-toggle");
        toggleButton.onclick = function () {
            el.classList.toggle("toggled");
        };

        $(document).ready(function () {
            $('#tableUser').DataTable({
                // Konfigurasi DOM untuk Tata Letak:
                // l = length (kiri), f = filtering (kanan) dalam satu baris flex
                // t = table
                // i = info (kiri), p = pagination (kanan) dalam satu baris flex
                "dom": '<"d-flex justify-content-between align-items-center mb-3"lf>t<"d-flex justify-content-between align-items-center mt-3"ip>',
                
                "language": {
                    "search": "", // Hapus label "Search:"
                    "searchPlaceholder": "Cari user...", 
                    "lengthMenu": "Tampilkan _MENU_ data", // Label untuk Length Select
                    "zeroRecords": "<div class='text-center py-4'><i class='fas fa-user-slash fa-3x text-muted mb-3'></i><p class='text-muted'>User tidak ditemukan.</p></div>",
                    "info": "Menampilkan _START_ - _END_ dari _TOTAL_ user",
                    "infoEmpty": "Belum ada data",
                    "infoFiltered": "(dari _MAX_ total user)",
                    "paginate": {
                        "first": "<<",
                        "last": ">>",
                        "next": "<i class='fas fa-chevron-right'></i>",
                        "previous": "<i class='fas fa-chevron-left'></i>"
                    }
                },
                "pageLength": 10 // Default tampil 10 data
            });
        });
    </script>
</body>
</html>