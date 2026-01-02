<%-- Lokasi: Web Pages/includes/navbar.jsp --%>
<%@page import="model.User"%>

<style>
    /* 1. NAVBAR GLASSMORPHISM */
    .navbar-glass {
        background: rgba(255, 255, 255, 0.98); /* Sedikit lebih solid biar tulisan jelas */
        backdrop-filter: blur(12px);
        -webkit-backdrop-filter: blur(12px);
        border-bottom: 1px solid rgba(0,0,0,0.08);
        padding-top: 12px;
        padding-bottom: 12px;
        transition: all 0.3s ease;
    }

    .brand-text {
        font-family: 'Poppins', sans-serif;
        font-weight: 800;
        letter-spacing: -0.5px;
        background: linear-gradient(45deg, #0d6efd, #00d2ff);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
    }

    /* 2. LINK MENU */
    .nav-link-custom {
        color: #555 !important;
        font-weight: 600;
        font-size: 0.95rem;
        margin: 0 8px;
        position: relative;
        transition: color 0.3s ease;
    }
    .nav-link-custom:hover { color: #0d6efd !important; }

    /* 3. TOMBOL LOGIN (Kondisi Belum Login) */
    .btn-login-modern {
        background: linear-gradient(135deg, #0d6efd 0%, #0099ff 100%);
        color: white !important;
        border: none;
        padding: 8px 24px;
        border-radius: 50px;
        font-weight: 600;
        font-size: 0.9rem;
        box-shadow: 0 4px 10px rgba(13, 110, 253, 0.2);
        transition: all 0.3s ease;
    }
    .btn-login-modern:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 15px rgba(13, 110, 253, 0.4);
    }

    /* 4. USER PROFILE (Kondisi Sudah Login) - INI YANG KITA PERBAIKI */
    .user-profile-link {
        padding: 4px 8px;
        border-radius: 50px;
        transition: background 0.3s;
    }
    .user-profile-link:hover {
        background-color: rgba(0,0,0,0.03); /* Efek hover halus di container */
    }
    
    .user-text-group {
        text-align: right;
        line-height: 1.2; /* Jarak antar baris nama & role dirapatkan */
        margin-right: 12px; /* Jarak antara teks ke avatar */
    }
    
    .user-name {
        font-size: 0.9rem;
        font-weight: 700;
        color: #333;
        display: block;
        margin-bottom: 2px;
    }
    
    .user-role {
        font-size: 0.7rem; /* Role lebih kecil */
        font-weight: 600;
        color: #0d6efd; /* Warna biru biar beda */
        background: rgba(13, 110, 253, 0.1); /* Badge background tipis */
        padding: 1px 6px;
        border-radius: 4px;
        letter-spacing: 0.5px;
        text-transform: uppercase;
        display: inline-block;
    }

    .user-avatar {
        width: 42px;      /* Ukuran fix */
        height: 42px;     /* Ukuran fix */
        background: linear-gradient(135deg, #0d6efd, #0dcaf0); /* Gradient background */
        color: white;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 700;
        font-size: 1.1rem;
        border: 3px solid rgba(255,255,255,0.8); /* Border putih biar misah dari background */
        box-shadow: 0 3px 6px rgba(0,0,0,0.1);
    }
    
    /* Hilangkan panah dropdown bawaan bootstrap */
    .user-dropdown .dropdown-toggle::after { display: none; }
</style>

<nav class="navbar navbar-expand-lg fixed-top navbar-glass">
    <div class="container">
        
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/index.jsp">
            <i class="fas fa-soap text-primary fs-3 me-2"></i>
            <span class="brand-text fs-4">CLEAN LAUNDRY</span>
        </a>
        
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item"><a class="nav-link nav-link-custom" href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link nav-link-custom" href="#services">Layanan</a></li>

                <%
                    User currentUser = (User) session.getAttribute("currentUser");

                    if (currentUser == null) { 
                %>
                
                <li class="nav-item ms-lg-4 mt-3 mt-lg-0">
                    <a class="btn btn-login-modern d-flex align-items-center gap-2 text-decoration-none" 
                       href="${pageContext.request.contextPath}/admin/login.jsp">
                        <i class="fas fa-sign-in-alt"></i> <span>Login</span>
                    </a>
                </li>

                <% } else { 
                        String nama = currentUser.getName();
                        String inisial = nama.substring(0, 1).toUpperCase();
                        if(nama.length() > 15) { nama = nama.substring(0, 15) + "..."; }
                %> 

                <li class="nav-item dropdown ms-lg-3 user-dropdown">
                    <a class="nav-link dropdown-toggle user-profile-link d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown">
                        
                        <div class="user-text-group d-none d-lg-block">
                            <span class="user-name"><%= nama %></span>
                            <span class="user-role"><%= currentUser.getRole() %></span>
                        </div>
                        
                        <div class="user-avatar">
                            <%= inisial %>
                        </div>
                    </a>

                    <ul class="dropdown-menu dropdown-menu-end border-0 shadow-lg p-2 rounded-4 mt-2" style="min-width: 200px;">
                        
                        <li class="d-lg-none px-3 py-2 text-center">
                            <div class="fw-bold"><%= currentUser.getName() %></div>
                            <small class="text-muted"><%= currentUser.getRole() %></small>
                            <hr class="dropdown-divider my-2">
                        </li>

                        <% if(currentUser.getRole().equalsIgnoreCase("admin") || currentUser.getRole().equalsIgnoreCase("superadmin")) { %>
                        <li>
                            <a class="dropdown-item rounded-3 py-2 fw-bold text-primary" href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                                <i class="fas fa-columns me-2 w-25"></i> Dashboard
                            </a>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <% } %>

                        <li>
                            <a class="dropdown-item rounded-3 py-2" href="#">
                                <i class="fas fa-user-cog me-2 w-25 text-muted"></i> Pengaturan
                            </a>
                        </li>
                        
                        <li>
                            <a class="dropdown-item rounded-3 py-2 text-danger fw-bold" href="${pageContext.request.contextPath}/LogoutController">
                                <i class="fas fa-sign-out-alt me-2 w-25"></i> Logout
                            </a>
                        </li>
                    </ul>
                </li>

                <% } %>

            </ul>
        </div>
    </div>
</nav>