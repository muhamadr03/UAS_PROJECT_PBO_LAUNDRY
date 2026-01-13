<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, dao.GalleryDAO, model.Gallery"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Galeri Kami | Clean Laundry</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f8f9fa; }
        .gallery-card {
            border-radius: 15px; overflow: hidden; position: relative; cursor: pointer;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1); transition: 0.3s; border: none;
        }
        .gallery-card:hover { transform: translateY(-5px); box-shadow: 0 15px 30px rgba(0,0,0,0.2); }
        .gallery-img { width: 100%; height: 250px; object-fit: cover; transition: 0.5s; }
        .gallery-card:hover .gallery-img { transform: scale(1.1); } /* Efek Zoom */
        .gallery-overlay {
            position: absolute; bottom: 0; left: 0; right: 0; background: linear-gradient(to top, rgba(0,0,0,0.8), transparent);
            padding: 20px; color: white; opacity: 0; transition: 0.3s;
        }
        .gallery-card:hover .gallery-overlay { opacity: 1; }
    </style>
</head>
<body>

    <jsp:include page="includes/navbar.jsp" />

    <header class="text-center py-5 bg-primary text-white mb-5" style="margin-top: 60px;">
        <h1 class="fw-bold">Galeri Aktivitas</h1>
        <p class="lead opacity-75">Bukti nyata kebersihan dan kerapihan layanan kami.</p>
    </header>

    <div class="container pb-5">
        <div class="row g-4">
            <%
                GalleryDAO dao = new GalleryDAO();
                List<Gallery> list = dao.getAllPhotos();
                for(Gallery g : list) {
            %>
            <div class="col-md-4 col-sm-6">
                <div class="card gallery-card">
                    <img src="uploads/<%= g.getImagePath() %>" class="gallery-img" alt="<%= g.getTitle() %>">
                    <div class="gallery-overlay">
                        <h5 class="fw-bold mb-0"><%= g.getTitle() %></h5>
                        <small><i class="fas fa-calendar-alt me-1"></i> Dokumentasi Clean Laundry</small>
                    </div>
                </div>
            </div>
            <% } %>
            
            <% if(list.isEmpty()) { %>
                <div class="col-12 text-center py-5">
                    <p class="text-muted">Belum ada foto yang diunggah.</p>
                </div>
            <% } %>
        </div>
    </div>

    <jsp:include page="includes/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>