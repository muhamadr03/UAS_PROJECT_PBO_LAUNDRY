<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="dao.OrderDAO"%>
<%@page import="model.Order"%>
<%@page import="model.User"%>

<%
    // --- 1. CEK LOGIN ADMIN ---
    // Logika ini tetap sama seperti kode Anda
    User admin = (User) session.getAttribute("currentUser");
    if(admin == null || (
       !"admin".equalsIgnoreCase(admin.getRole()) && 
       !"superadmin".equalsIgnoreCase(admin.getRole())
       )) {
        response.sendRedirect("../index.jsp");
        return;
    }

    // --- 2. LOGIKA HITUNG STATISTIK ---
    // Logika perhitungan tetap sama
    OrderDAO dao = new OrderDAO();
    List<Order> listOrders = dao.getAllOrders(); 

    int totalPesanan = 0;
    int pesananSelesai = 0;
    double totalPendapatan = 0;

    for(Order o : listOrders) {
        totalPesanan++;
        if("Completed".equalsIgnoreCase(o.getStatus()) || "Selesai".equalsIgnoreCase(o.getStatus())) {
            pesananSelesai++;
        }
        totalPendapatan += o.getTotalAmount();
    }

    Locale localeID = new Locale("id", "ID");
    NumberFormat formatRupiah = NumberFormat.getCurrencyInstance(localeID);
%>

<!DOCTYPE html>
<html lang="id">
<head>  
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin | Clean Laundry</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        body { font-family: 'Poppins', sans-serif; overflow-x: hidden; background-color: #f0f2f5; }
        
        /* --- LAYOUT SIDEBAR --- */
        #wrapper { display: flex; width: 100%; transition: all 0.3s; }
        
        #sidebar-wrapper {
            min-width: 250px;
            max-width: 250px;
            background-color: #212529; /* Warna Dark Sidebar */
            color: white;
            min-height: 100vh;
            transition: margin 0.3s ease-out;
        }
        
        /* Class ini dipakai JS untuk menyembunyikan sidebar */
        #wrapper.toggled #sidebar-wrapper { margin-left: -250px; }
        
        #page-content-wrapper { width: 100%; flex: 1; }
        
        .sidebar-heading { padding: 1.5rem 1.25rem; font-size: 1.2rem; font-weight: bold; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .list-group-item { border: none; padding: 15px 25px; background-color: transparent; color: rgba(255,255,255,0.7); }
        .list-group-item:hover { background-color: rgba(255,255,255,0.1); color: white; }
        .list-group-item.active { background-color: #0d6efd; color: white; font-weight: bold; }
        .list-group-item i { width: 25px; }

        /* --- DASHBOARD CARDS & TABLE --- */
        .stat-card { border-radius: 15px; color: white; transition: transform 0.3s; border:none; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .stat-card:hover { transform: translateY(-5px); }
        .bg-gradient-1 { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .bg-gradient-2 { background: linear-gradient(135deg, #2af598 0%, #009efd 100%); }
        .bg-gradient-3 { background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 99%, #fecfef 100%); color: #555; }
        .bg-gradient-3 .text-white { color: #555 !important; } /* Fix text color for light bg */
        
        .table-custom { background: white; border-radius: 15px; padding: 25px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); }

        @media (max-width: 768px) {
            #sidebar-wrapper { margin-left: -250px; }
            #wrapper.toggled #sidebar-wrapper { margin-left: 0; }
        }
    </style>
</head>
<body>

    <div class="d-flex" id="wrapper">

        <jsp:include page="../includes/sidebar.jsp" />

        <div id="page-content-wrapper">

            <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom shadow-sm px-3 py-3">
                <div class="container-fluid">
                    <button class="btn btn-outline-dark" id="menu-toggle">
                        <i class="fas fa-bars"></i>
                    </button>

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

            <div class="container-fluid px-4 py-4">
                
                <div class="row g-4 mb-5">
                    <div class="col-md-4">
                        <div class="stat-card bg-gradient-1 p-4">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <div class="fs-1"><i class="fas fa-receipt"></i></div>
                                <span class="badge bg-white text-primary bg-opacity-75">Semua</span>
                            </div>
                            <h5 class="mb-0 text-white-50">Total Pesanan</h5>
                            <h2 class="fw-bold display-6"><%= totalPesanan %> Order</h2>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="stat-card bg-gradient-2 p-4">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <div class="fs-1"><i class="fas fa-check-double"></i></div>
                                <span class="badge bg-white text-success bg-opacity-75">Selesai</span>
                            </div>
                            <h5 class="mb-0 text-white-50">Cucian Selesai</h5>
                            <h2 class="fw-bold display-6"><%= pesananSelesai %> Paket</h2>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="stat-card bg-gradient-3 p-4">
                            <div class="d-flex justify-content-between align-items-center mb-3 text-dark">
                                <div class="fs-1"><i class="fas fa-wallet"></i></div>
                                <span class="badge bg-white text-danger bg-opacity-75">Revenue</span>
                            </div>
                            <h5 class="mb-0 text-muted">Pendapatan</h5>
                            <h2 class="fw-bold display-6 text-dark"><%= formatRupiah.format(totalPendapatan).replace("Rp", "Rp ") %></h2>
                        </div>
                    </div>
                </div>

                <div class="table-custom">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 class="fw-bold mb-0">Pesanan Masuk Terbaru</h5>
                        <a href="orders.jsp" class="btn btn-sm btn-primary rounded-pill px-3">Lihat Semua</a>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Pelanggan</th>
                                    <th>Layanan</th>
                                    <th>Status</th>
                                    <th>Total</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    int count = 0;
                                    for(Order o : listOrders) {
                                        if(count >= 5) break; 
                                        count++;

                                        String badgeColor = "bg-secondary";
                                        if(o.getStatus().equalsIgnoreCase("Pending")) badgeColor = "bg-warning text-dark";
                                        if(o.getStatus().equalsIgnoreCase("Processing")) badgeColor = "bg-info text-dark";
                                        if(o.getStatus().equalsIgnoreCase("Completed")) badgeColor = "bg-success";
                                %>
                                <tr>
                                    <td><span class="fw-bold text-primary">#<%= o.getOrderId() %></span></td>
                                    <td>
                                        <div class="fw-bold"><%= o.getUserName() %></div>
                                        <div class="small text-muted"><%= o.getDeliveryType() %></div>
                                    </td>
                                    <td><%= o.getServiceName() %></td>
                                    <td><span class="badge <%= badgeColor %> rounded-pill px-3"><%= o.getStatus() %></span></td>
                                    <td class="fw-bold"><%= formatRupiah.format(o.getTotalAmount()) %></td>
                                    <td>
                                        <a href="orders.jsp" class="btn btn-sm btn-outline-primary rounded-circle"><i class="fas fa-edit"></i></a>
                                    </td>
                                </tr>
                                <% } %>
                                
                                <% if(listOrders.isEmpty()) { %>
                                    <tr><td colspan="6" class="text-center py-4">Data Kosong</td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div> </div> </div> <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        var el = document.getElementById("wrapper");
        var toggleButton = document.getElementById("menu-toggle");

        toggleButton.onclick = function () {
            el.classList.toggle("toggled");
        };
    </script>
    
</body>
</html>