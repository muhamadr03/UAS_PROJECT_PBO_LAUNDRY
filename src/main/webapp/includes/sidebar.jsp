<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Logika untuk menentukan menu mana yang aktif (Biru)
    String uri = request.getRequestURI();
    String pDashboard = uri.contains("dashboard.jsp") ? "active" : "";
    String pOrders = uri.contains("orders.jsp") ? "active" : "";
    String pServices = uri.contains("services.jsp") ? "active" : ""; // Pastikan nama file services.jsp
    String pUsers = uri.contains("users.jsp") ? "active" : "";
    String contextPath = request.getContextPath();
%>

<style>
    /* Styling Sidebar agar konsisten */
    .sidebar {
        min-width: 250px;
        max-width: 250px;
        background-color: #212529; /* Dark Sidebar */
        color: white;
        min-height: 100vh;
        transition: margin 0.3s ease-out;
    }
    
    .sidebar .brand-logo {
        padding: 1.5rem 1.25rem;
        font-size: 1.2rem;
        font-weight: bold;
        text-align: center;
        border-bottom: 1px solid rgba(255,255,255,0.1);
        color: white;
    }

    .sidebar .nav-link {
        border: none;
        padding: 15px 25px;
        color: rgba(255,255,255,0.7);
        display: block;
    }

    .sidebar .nav-link:hover {
        background-color: rgba(255,255,255,0.1);
        color: white;
    }

    .sidebar .nav-link.active {
        background-color: #0d6efd; /* Warna Biru Active */
        color: white;
        font-weight: bold;
    }
    
    .sidebar .nav-link i {
        width: 25px;
        text-align: center;
        margin-right: 10px;
    }
</style>

<nav class="sidebar d-flex flex-column justify-content-between" id="sidebar-wrapper">
    
    <div>
        <div class="brand-logo mb-4">
            <i class="fas fa-soap me-2"></i> CLEAN ADMIN
        </div>
        
        <div class="nav flex-column">
            <small class="text-uppercase text-muted fw-bold mb-2 px-3" style="font-size: 11px;">Menu Utama</small>
            
            <a href="<%= contextPath %>/admin/dashboard.jsp" class="nav-link text-decoration-none <%= pDashboard %>">
                <i class="fas fa-th-large"></i> Dashboard
            </a>
            
            <a href="<%= contextPath %>/admin/orders.jsp" class="nav-link text-decoration-none <%= pOrders %>">
                <i class="fas fa-shopping-basket"></i> Kelola Pesanan
            </a>

            <a href="<%= contextPath %>/admin/services.jsp" class="nav-link text-decoration-none <%= pServices %>">
                <i class="fas fa-box-open"></i> Kelola Layanan
            </a>
            
            <a href="<%= contextPath %>/admin/users.jsp" class="nav-link text-decoration-none <%= pUsers %>">
                <i class="fas fa-users"></i> Kelola User
            </a>
            <a href="<%= contextPath %>/admin/gallery.jsp" class="nav-link text-decoration-none <%= uri.contains("gallery.jsp") ? "active" : "" %>">
                <i class="fas fa-images"></i> Kelola Galeri
            </a>
            <%
                String pReport = uri.contains("reports.jsp") ? "active" : "";
            %>

            <a href="<%= contextPath %>/admin/reports.jsp" class="nav-link text-decoration-none <%= pReport %>">
                <i class="fas fa-chart-line"></i> Laporan
            </a>
        </div>
    </div>

    <div class="mt-auto px-3 pb-4">
        <hr class="text-secondary opacity-25 mb-3"> 
        <a href="<%= contextPath %>/LogoutController" class="btn btn-light w-100 text-danger fw-bold shadow-sm d-flex align-items-center justify-content-center gap-2">
            <i class="fas fa-sign-out-alt"></i> <span>Logout</span>
        </a>
    </div>
            
    

</nav>