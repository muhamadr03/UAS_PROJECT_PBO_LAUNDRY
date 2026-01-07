<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="dao.OrderDAO"%>
<%@page import="model.Order"%>
<%@page import="model.User"%>

<%
    // --- 1. KEAMANAN ---
    User admin = (User) session.getAttribute("currentUser");
    if(admin == null || (
       !"admin".equalsIgnoreCase(admin.getRole()) && 
       !"superadmin".equalsIgnoreCase(admin.getRole())
       )) {
        response.sendRedirect("../index.jsp");
        return;
    }

    // --- 2. LOGIKA UPDATE STATUS ---
    String action = request.getParameter("action");
    String msg = "";
    OrderDAO dao = new OrderDAO();

    if("update_status".equals(action)) {
        try {
            int orderId = Integer.parseInt(request.getParameter("order_id"));
            String newStatus = request.getParameter("status");
            dao.updateStatus(orderId, newStatus);
            msg = "sukses";
        } catch(Exception e) {
            e.printStackTrace();
            msg = "gagal";
        }
    }

    // --- 3. AMBIL DATA ---
    List<Order> listOrders = dao.getAllOrders();
    Locale localeID = new Locale("id", "ID");
    NumberFormat formatRupiah = NumberFormat.getCurrencyInstance(localeID);
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Pesanan | Clean Laundry</title>
    
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
        .status-select { border-radius: 20px; font-size: 0.85rem; padding: 5px 10px; border: 1px solid #dee2e6; }
        .btn-update { border-radius: 20px; padding: 5px 15px; font-size: 0.85rem; }

        /* --- CUSTOM DATATABLES STYLE (Sama persis dengan Users.jsp) --- */
        
        /* 1. Kotak Pencarian */
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

        /* 2. Length Select */
        .dataTables_length { text-align: left; }
        .dataTables_length label { font-weight: normal; color: #6c757d; font-size: 0.9rem; }
        .dataTables_length select {
            border-radius: 50px; padding: 8px 30px 8px 15px; 
            border: 1px solid #e0e0e0; background-color: #fff;
            margin: 0 5px; font-size: 0.9rem; cursor: pointer;
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
                <a href="orders.jsp" class="list-group-item list-group-item-action active">
                    <i class="fas fa-shopping-basket me-2"></i> Kelola Pesanan
                </a>
                <a href="users.jsp" class="list-group-item list-group-item-action">
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
                        <h3 class="fw-bold mb-1">Daftar Semua Pesanan</h3>
                        <p class="text-muted">Kelola status pesanan pelanggan di sini.</p>
                    </div>
                    
                    <% if("sukses".equals(msg)) { %>
                        <div class="alert alert-success py-2 px-4 rounded-pill shadow-sm mb-0 fade show">
                            <i class="fas fa-check-circle me-1"></i> Status berhasil diperbarui!
                        </div>
                    <% } %>
                </div>

                <div class="card card-table overflow-hidden">
                    <div class="card-body p-4">
                        <div class="table-responsive">
                            
                            <table id="tablePesanan" class="table table-hover align-middle mb-0" style="width:100%">
                                <thead class="bg-light text-secondary">
                                    <tr>
                                        <th class="ps-4">ID</th>
                                        <th>Tgl Order</th>
                                        <th>Pelanggan</th>
                                        <th>Detail Layanan</th>
                                        <th>Total Biaya</th>
                                        <th class="text-center">Status</th>
                                        <th>Aksi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (listOrders.isEmpty()) { %>
                                        <% } else {
                                        for(Order o : listOrders) {
                                            String badgeClass = "bg-secondary";
                                            if(o.getStatus().equalsIgnoreCase("Pending")) badgeClass = "bg-warning text-dark";
                                            else if(o.getStatus().equalsIgnoreCase("Processing")) badgeClass = "bg-info text-dark";
                                            else if(o.getStatus().equalsIgnoreCase("Completed")) badgeClass = "bg-success";
                                            else if(o.getStatus().equalsIgnoreCase("Cancelled")) badgeClass = "bg-danger";
                                    %>
                                    <tr>
                                        <td class="ps-4 fw-bold text-primary">#<%= o.getOrderId() %></td>
                                        
                                        <td class="small text-muted">
                                            <span style="display:none;"><%= o.getOrderDate().getTime() %></span>
                                            <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(o.getOrderDate()) %><br>
                                            <%= new java.text.SimpleDateFormat("HH:mm").format(o.getOrderDate()) %>
                                        </td>
                                        
                                        <td>
                                            <div class="fw-bold"><%= o.getUserName() %></div>
                                            <div class="small text-muted">
                                                <i class="<%= o.getDeliveryType() != null && o.getDeliveryType().equals("pickup") ? "fas fa-truck" : "fas fa-store" %> me-1"></i>
                                                <%= o.getDeliveryType() != null ? o.getDeliveryType().toUpperCase() : "-" %>
                                            </div>
                                            <% if(o.getDeliveryType() != null && o.getDeliveryType().equals("pickup")) { %>
                                                <div class="small text-muted fst-italic" style="font-size: 11px; max-width: 150px;">
                                                    <%= o.getPickupAddress() %>
                                                </div>
                                            <% } %>
                                        </td>
                                        
                                        <td>
                                            <span class="badge bg-light text-dark border"><%= o.getServiceName() %></span>
                                            <div class="small mt-1 text-muted">Berat: <strong><%= o.getTotalKg() %> Kg</strong></div>
                                        </td>
                                        
                                        <td class="fw-bold text-success">
                                            <%= formatRupiah.format(o.getTotalAmount()) %>
                                        </td>
                                        
                                        <td class="text-center">
                                            <span class="badge <%= badgeClass %> rounded-pill px-3"><%= o.getStatus() %></span>
                                        </td>
                                        
                                        <td>
                                            <form action="orders.jsp" method="POST" class="d-flex align-items-center gap-2">
                                                <input type="hidden" name="action" value="update_status">
                                                <input type="hidden" name="order_id" value="<%= o.getOrderId() %>">
                                                
                                                <select name="status" class="form-select form-select-sm status-select" style="width: 110px;">
                                                    <option value="Pending" <%= o.getStatus().equalsIgnoreCase("Pending") ? "selected" : "" %>>Pending</option>
                                                    <option value="Processing" <%= o.getStatus().equalsIgnoreCase("Processing") ? "selected" : "" %>>Proses</option>
                                                    <option value="Completed" <%= o.getStatus().equalsIgnoreCase("Completed") ? "selected" : "" %>>Selesai</option>
                                                    <option value="Cancelled" <%= o.getStatus().equalsIgnoreCase("Cancelled") ? "selected" : "" %>>Batal</option>
                                                </select>
                                                
                                                <button type="submit" class="btn btn-primary btn-sm btn-update" title="Simpan">
                                                    <i class="fas fa-save"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                    <% } } %>
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
            $('#tablePesanan').DataTable({
                // Konfigurasi DOM sama dengan users.jsp
                "dom": '<"d-flex justify-content-between align-items-center mb-3"lf>t<"d-flex justify-content-between align-items-center mt-3"ip>',
                
                "language": {
                    "search": "", 
                    "searchPlaceholder": "Cari pesanan...", 
                    "lengthMenu": "Tampilkan _MENU_ data",
                    "zeroRecords": "<div class='text-center py-4'><i class='fas fa-box-open fa-3x text-muted mb-3'></i><p class='text-muted'>Pesanan tidak ditemukan.</p></div>",
                    "info": "Menampilkan _START_ - _END_ dari _TOTAL_ pesanan",
                    "infoEmpty": "Belum ada data",
                    "infoFiltered": "(dari _MAX_ total data)",
                    "paginate": {
                        "first": "<<",
                        "last": ">>",
                        "next": "<i class='fas fa-chevron-right'></i>",
                        "previous": "<i class='fas fa-chevron-left'></i>"
                    }
                },
                "order": [[ 0, "desc" ]], // Urutkan ID Terbaru di atas
                "pageLength": 10
            });
        });
    </script>
</body>
</html>