<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, dao.ServiceDAO, model.Service"%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Daftar Layanan | Clean Laundry</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root { --primary-color: #4361ee; --accent-color: #4cc9f0; }
        body { font-family: 'Poppins', sans-serif; background-color: #f8f9fa; }
        
        .header-bg { 
            background: linear-gradient(135deg, #4361ee 0%, #3f37c9 100%); 
            padding: 100px 0 60px; color: white; border-bottom-right-radius: 50px;
        }
        
        .service-card {
            border: none; border-radius: 20px; background: white;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05); transition: all 0.3s;
        }
        .service-card:hover { transform: translateY(-5px); box-shadow: 0 15px 30px rgba(67, 97, 238, 0.15); }
        .icon-box {
            width: 70px; height: 70px; background: #eef2ff; color: var(--primary-color);
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
            font-size: 1.8rem; margin: 0 auto 15px;
        }
    </style>
</head>
<body>

    <jsp:include page="includes/navbar.jsp" />

    <header class="header-bg text-center mb-5">
        <div class="container">
            <h1 class="fw-bold display-5">Semua Layanan</h1>
            <p class="lead opacity-75">Pilih paket terbaik untuk pakaian kesayangan Anda</p>
        </div>
    </header>

    <section class="container pb-5">
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
                    <div class="icon-box">
                        <i class="fas <%= icon %>"></i>
                    </div>
                    
                    <h5 class="fw-bold mb-1"><%= s.getName() %></h5>
                    <p class="text-muted small mb-3">Estimasi <%= s.getEstimatedDays() %> Hari</p>
                    
                    <h4 class="fw-bold text-primary mb-4">
                        <small class="fs-6 text-muted text-decoration-none">Rp</small> <%= String.format("%,.0f", s.getPrice()) %>
                        <small class="fs-6 text-muted fw-normal"> / <%= s.getUnit() %></small>
                    </h4>
                    
                    <div class="mt-auto">
                        <a href="order-form.jsp?id=<%= s.getId() %>" class="btn btn-primary w-100 rounded-pill fw-bold py-2 shadow-sm" 
                           style="background: #4361ee; border: none;">
                            Pesan Sekarang
                        </a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    </section>

    <jsp:include page="includes/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>