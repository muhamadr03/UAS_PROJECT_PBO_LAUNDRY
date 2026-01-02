<nav class="sidebar d-flex flex-column justify-content-between">
    
    <div>
        <div class="brand-logo mb-4">
            <i class="fas fa-soap me-2"></i> CLEAN ADMIN
        </div>
        
        <div class="nav flex-column">
            <small class="text-uppercase text-muted fw-bold mb-2 px-3" style="font-size: 11px;">Menu Utama</small>
            
            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="nav-link text-decoration-none">
                <i class="fas fa-th-large"></i> Dashboard
            </a>
            
            <a href="${pageContext.request.contextPath}/admin/list-layanan.jsp" class="nav-link text-decoration-none">
                <i class="fas fa-box-open"></i> Kelola Layanan
            </a>

            </div>
    </div>

    <div class="mt-auto px-3 pb-4">
        <hr class="text-secondary opacity-25 mb-3"> <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-light w-100 text-danger fw-bold shadow-sm d-flex align-items-center justify-content-center gap-2">
            <i class="fas fa-sign-out-alt"></i> <span>Logout</span>
        </a>
    </div>

</nav>