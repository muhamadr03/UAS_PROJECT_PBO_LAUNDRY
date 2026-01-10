<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dao.ServiceDAO"%>
<%@page import="model.Service"%>

<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Clean Laundry | Solusi Cuci Premium</title>
        
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/style.css">
    </head>
    
    <body>

        <jsp:include page="includes/navbar.jsp" />
 
        <header class="hero-header text-center position-relative overflow-hidden">
            <div class="container position-relative z-2">
                <span class="badge bg-white text-primary px-3 py-2 rounded-pill mb-3 shadow-sm fw-bold">
                    <i class="fas fa-star me-1 text-warning"></i> Laundry #1 di Galaksi Bima Sakti 
                </span>
                <h1 class="display-3 fw-bold mb-3">Adalah pokoknya</h1>
                <p class="lead mb-4 opacity-75 mx-auto" style="max-width: 600px;">
                    Capek mikirin hidup? Jangan mikirin cucian juga. Serahin ke kami dijemput, dicuci, disikat, digosok enak dah terima beres
                </p>
                <div class="d-flex justify-content-center gap-3">
                    <a href="#services" class="btn btn-light btn-lg rounded-pill shadow fw-bold text-primary px-5">Pesan Sekarang</a>
                    <a href="#" class="btn btn-outline-light btn-lg rounded-pill px-4"><i class="fab fa-whatsapp"></i> Chat Admin</a>
                </div>
            </div>
        </header>

        <section id="services" class="container pb-5">
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                
                <%
                    ServiceDAO dao = new ServiceDAO();
                    List<Service> layanans = dao.getAllServices();
                    
                    for(Service s : layanans) {
                        String icon = "fa-tshirt";
                        if(s.getName().toLowerCase().contains("sepatu")) { icon = "fa-shoe-prints"; }
                        if(s.getName().toLowerCase().contains("setrika")) { icon = "fa-temperature-high"; }
                        if(s.getPrice() > 15000) icon = "fa-crown";
                %>
                
                <div class="col">
                    <div class="card service-card h-100 p-4 text-center">
                        <div class="icon-circle mx-auto">
                            <i class="fas <%= icon %>"></i>
                        </div>
                        
                        <h5 class="fw-bold mb-1"><%= s.getName() %></h5>
                        <p class="text-muted small mb-3">Estimasi <%= s.getDuration() %> Hari Kerja</p>
                        
                        <div class="price-text mb-4">
                            <small class="fs-6 text-muted fw-normal">Rp</small> 
                            <%= String.format("%,.0f", s.getPrice()) %>
                            
                            <small class="fs-6 text-muted fw-normal"> / <%= s.getUnit() %></small>
                        </div>
                        
                        <ul class="list-unstyled text-start small text-muted mb-4 ps-3 border-start border-3 border-primary bg-light p-2 rounded">
                            <li><i class="fas fa-check text-primary me-2"></i>Deterjen Anti Bakteri</li>
                            <li><i class="fas fa-check text-primary me-2"></i>Garansi Wangi 24 Jam</li>
                        </ul>
                        
                        <div class="mt-auto">
                            <a href="order-form.jsp?id=<%= s.getId() %>" class="btn btn-pesan w-100 fw-bold shadow-sm text-decoration-none d-block pt-2 pb-2">
                                Pilih Paket <i class="fas fa-arrow-right ms-2"></i>
                            </a>
                        </div>
                    </div>
                </div>
                
                <% } %>
                
            </div>
        </section>

        <section class="container py-5 text-center">
            <h6 class="text-primary fw-bold text-uppercase ls-2">Kenapa Kami?</h6>
            <h2 class="fw-bold mb-5">Keunggulan Clean Laundry</h2>
            <div class="row g-4">
                <div class="col-md-4">
                    <i class="fas fa-shipping-fast fa-3x text-info mb-3"></i>
                    <h5>Antar Jemput Gratis</h5>
                    <p class="text-muted">Gak perlu macet-macetan, kurir kami siap jemput cucianmu.</p>
                </div>
                <div class="col-md-4">
                    <i class="fas fa-stopwatch fa-3x text-warning mb-3"></i>
                    <h5>Tepat Waktu</h5>
                    <p class="text-muted">Kami menghargai waktumu. Selesai sesuai janji atau gratis.</p>
                </div>
                <div class="col-md-4">
                    <i class="fas fa-leaf fa-3x text-success mb-3"></i>
                    <h5>Ramah Lingkungan</h5>
                    <p class="text-muted">Menggunakan deterjen yang aman untuk kulit dan alam.</p>
                </div>
            </div>
        </section>

        <jsp:include page="includes/footer.jsp" />
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>