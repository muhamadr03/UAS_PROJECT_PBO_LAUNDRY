<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>

<nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold text-primary" href="${pageContext.request.contextPath}/index.jsp">
            <i class="fas fa-soap me-2"></i>Clean Laundry
        </a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center">
                
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Beranda</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp#services">Layanan</a>
                </li>

                <%-- 2. MENU KHUSUS LOGIN --%>
                <%
                    User navUser = (User) session.getAttribute("currentUser");
                    if (navUser != null) {
                %>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/my-orders.jsp">Riwayat Pesanan</a>
                    </li>

                    <li class="nav-item d-none d-lg-block mx-2 text-muted">|</li>

                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle fw-bold text-primary" href="#" role="button" data-bs-toggle="dropdown">
                            Hai, <%= navUser.getName().split(" ")[0] %> </a>
                        <ul class="dropdown-menu dropdown-menu-end border-0 shadow">
                            <li><span class="dropdown-header small text-muted">Akun Pelanggan</span></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/my-orders.jsp"><i class="fas fa-history me-2"></i>Riwayat Saya</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/LogoutController"><i class="fas fa-sign-out-alt me-2"></i>Keluar</a></li>
                        </ul>
                    </li>

                <% } else { %>
                    
                    <li class="nav-item ms-lg-3">
                        <a href="${pageContext.request.contextPath}/admin/login.jsp" class="btn btn-outline-primary rounded-pill px-4 btn-sm">Masuk</a>
                    </li>
                    <li class="nav-item ms-2">
                        <a href="${pageContext.request.contextPath}/admin/register.jsp" class="btn btn-primary rounded-pill px-4 btn-sm">Daftar</a>
                    </li>
                    
                <% } %>
                
            </ul>
        </div>
    </div>
</nav>