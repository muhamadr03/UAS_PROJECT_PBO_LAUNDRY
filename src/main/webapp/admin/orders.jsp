<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="dao.OrderDAO"%>
<%@page import="model.Order"%>
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

        /* Style khusus Pagination DataTables agar rapi */
        .dataTables_wrapper .dataTables_paginate .paginate_button { padding: 0 !important; margin: 0 5px !important; }
        .dataTables_wrapper .dataTables_length select { width: 60px !important; display: inline-block; }
        
        .dataTables_filter {
        margin-bottom: 20px;
        text-align: right;
    }
    
    .dataTables_filter label {
        width: 100%;
        max-width: 400px; /* Batasi lebar agar tidak terlalu panjang */
        position: relative;
        display: inline-flex;
        align-items: center;
    }

    /* Input Search yang Modern */
    .dataTables_filter input {
        width: 100% !important;
        padding: 12px 20px;
        padding-left: 45px; /* Ruang untuk ikon search */
        border-radius: 50px; /* Membuat bulat (Pill shape) */
        border: 1px solid #e0e0e0;
        background-color: #fff;
        box-shadow: 0 4px 10px rgba(0,0,0,0.03); /* Bayangan halus */
        transition: all 0.3s ease;
        margin-left: 0 !important;
        font-size: 0.95rem;
    }

    .dataTables_filter input:focus {
        border-color: #0d6efd;
        box-shadow: 0 4px 15px rgba(13, 110, 253, 0.15); /* Efek glow biru saat diklik */
        outline: none;
    }

    /* Menambahkan Ikon Kaca Pembesar (Pseudo-element) */
    .dataTables_filter label::before {
        content: "\f002"; /* Kode unik FontAwesome untuk kaca pembesar */
        font-family: "Font Awesome 6 Free";
        font-weight: 900;
        position: absolute;
        left: 20px;
        color: #aaa;
        pointer-events: none; /* Agar klik tembus ke input */
    }

    /* 2. Mempercantik Pagination (Tombol Halaman) */
    .dataTables_paginate {
        margin-top: 20px;
        display: flex;
        justify-content: flex-end;
        gap: 5px;
    }

    .page-item .page-link {
        border: none;
        border-radius: 50%; /* Tombol bulat */
        width: 35px;
        height: 35px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #555;
        font-weight: 600;
        background: transparent;
        transition: all 0.2s;
    }

    .page-item.active .page-link {
        background-color: #0d6efd; /* Warna Primary */
        color: white;
        box-shadow: 0 4px 10px rgba(13, 110, 253, 0.3);
    }
    
    .page-item.disabled .page-link {
        color: #ccc;
        background: transparent;
    }

    .page-item:hover .page-link:not(.active) {
        background-color: #f0f2f5;
        color: #0d6efd;
    }

    /* 3. Menyembunyikan Label "Show Entries" yang membosankan */
    .dataTables_length select {
        border-radius: 20px;
        padding: 5px 30px 5px 15px;
        border: 1px solid #e0e0e0;
        }
        
        
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
                            <i class="fas fa-check-circle me-1"></i> Update Berhasil!
                        </div>
                    <% } %>
                </div>

                <div class="card card-table overflow-hidden">
                    <div class="card-body p-4"> <div class="table-responsive">
                            
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
                                    <% for(Order o : listOrders) {
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
    <div class="d-flex gap-2"> <a href="invoice.jsp?id=<%= o.getOrderId() %>" target="_blank" class="btn btn-outline-dark btn-sm rounded-circle" title="Cetak Nota">
            <i class="fas fa-print"></i>
        </a>

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
    </div>
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
        // Toggle Sidebar
        var el = document.getElementById("wrapper");
        var toggleButton = document.getElementById("menu-toggle");
        toggleButton.onclick = function () {
            el.classList.toggle("toggled");
        };

        // Inisialisasi DataTables dengan Desain Baru
        $(document).ready(function () {
            $('#tablePesanan').DataTable({
                "dom": '<"d-flex justify-content-between align-items-center mb-3"f>t<"d-flex justify-content-between align-items-center mt-3"ip>', 
                // Penjelasan DOM: 
                // f = filtering (pencarian)
                // t = table (tabelnya)
                // i = info (menampilkan halaman 1 dari x)
                // p = pagination (tombol halaman)
                
                "language": {
                    "search": "", // Hapus teks label "Search:"
                    "searchPlaceholder": "Cari nama pelanggan, status, atau ID...", // Ganti jadi Placeholder
                    "zeroRecords": "<div class='text-center py-5'><i class='fas fa-search fa-3x text-muted mb-3'></i><p class='text-muted'>Ups, data pesanan tidak ditemukan.</p></div>",
                    "info": "Menampilkan _START_ - _END_ dari _TOTAL_ pesanan",
                    "infoEmpty": "Belum ada pesanan",
                    "infoFiltered": "(hasil filter dari _MAX_ total data)",
                    "paginate": {
                        "first": "<<",
                        "last": ">>",
                        "next": "<i class='fas fa-chevron-right'></i>",
                        "previous": "<i class='fas fa-chevron-left'></i>"
                    }
                },
                "order": [[ 0, "desc" ]], // Urutkan ID terbaru paling atas
                "pageLength": 10 // Jumlah data per halaman
            });
        });
    </script>
</body>
</html>