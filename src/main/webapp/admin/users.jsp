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

        /* --- TABLE STYLES --- */
        .card-table { border-radius: 15px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }

        @media (max-width: 768px) {
            #sidebar-wrapper { margin-left: -250px; }
            #wrapper.toggled #sidebar-wrapper { margin-left: 0; }
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
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover align-middle mb-0">
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
                                        
                                        if (users.isEmpty()) {
                                    %>
                                        <tr>
                                            <td colspan="5" class="text-center py-5 text-muted">Belum ada user terdaftar.</td>
                                        </tr>
                                    <%  } else {
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
                                    <% } } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="card-footer bg-white py-3">
                        <small class="text-muted">Total Pengguna Terdaftar: <strong><%= users.size() %></strong></small>
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
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // 1. Ambil semua link di sidebar
            const menuLinks = document.querySelectorAll('#sidebar-wrapper .list-group-item-action');
            const mainContent = document.getElementById('main-content');

            menuLinks.forEach(link => {
                link.addEventListener('click', function(e) {
                    const url = this.href;

                    // Jangan proses jika itu link Logout atau kembali ke Website utama
                    if (url.includes('LogoutController') || url.includes('index.jsp')) {
                        return; // Biarkan reload normal
                    }

                    e.preventDefault(); // Matikan reload bawaan browser

                    // Ubah tampilan link Aktif
                    menuLinks.forEach(l => l.classList.remove('active'));
                    this.classList.add('active');

                    // Tampilkan loading (opsional)
                    mainContent.style.opacity = '0.5';

                    // 2. Ambil data halaman tujuan
                    fetch(url)
                        .then(response => response.text())
                        .then(html => {
                            // 3. Ubah text HTML menjadi Dokumen agar bisa diambil sebagian
                            const parser = new DOMParser();
                            const doc = parser.parseFromString(html, 'text/html');
                            
                            // Ambil hanya bagian #main-content dari halaman tujuan
                            const newContent = doc.getElementById('main-content').innerHTML;

                            // 4. Masukkan ke halaman saat ini
                            mainContent.innerHTML = newContent;
                            mainContent.style.opacity = '1';

                            // 5. Ubah URL di browser (agar tombol back tetap jalan)
                            window.history.pushState({path: url}, '', url);
                            
                            // Re-init script khusus jika ada (misal tombol di tabel orders)
                            // Jika ada event listener khusus di dalam konten, harus dipanggil ulang di sini
                        })
                        .catch(err => {
                            console.warn('Gagal memuat halaman.', err);
                            window.location.href = url; // Fallback: load normal jika error
                        });
                });
            });

            // Handle tombol Back/Forward browser
            window.onpopstate = function(event) {
                location.reload(); // Reload saat user tekan back button browser
            };
        });
    </script>
</body>
</html>