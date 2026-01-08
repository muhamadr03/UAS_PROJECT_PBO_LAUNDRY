<%@page import="model.Service"%>
<%@page import="java.util.List"%>
<%@page import="dao.ServiceDAO"%>

<html>
    <head>
        <title>Daftar Layanan Laundry</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/style.css">
    </head>
    <body>
        <div class="container mt-4">
            <a href="index.jsp" class="text-decoration-none text-primary fw-bold">
                <i class="fas fa-arrow-left me-2"></i> Kembali ke Beranda
            </a>
        </div>
        <h2 class="mb-4 text-center">Daftar Harga Layanan Laundry</h2><br>
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
    </body>
</html>