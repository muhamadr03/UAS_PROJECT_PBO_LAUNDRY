<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, dao.GalleryDAO, model.Gallery, model.User"%>
<%
    User admin = (User) session.getAttribute("currentUser");
    if(admin == null || (!"admin".equalsIgnoreCase(admin.getRole()) && !"superadmin".equalsIgnoreCase(admin.getRole()))) {
        response.sendRedirect("../index.jsp"); return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Kelola Galeri | Clean Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f0f2f5; }
        .gallery-img { width: 100%; height: 150px; object-fit: cover; border-radius: 10px; }
    </style>
</head>
<body>
<div class="d-flex" id="wrapper">
    <jsp:include page="../includes/sidebar.jsp" /> <div style="width: 100%;">
        <nav class="navbar navbar-light bg-white shadow-sm px-4 py-3 mb-4">
            <span class="navbar-brand fw-bold">Kelola Galeri Foto</span>
        </nav>

        <div class="container-fluid px-4">
            
            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body p-4">
                    <h5 class="fw-bold mb-3"><i class="fas fa-upload me-2"></i>Upload Foto Baru</h5>
                    <form action="../GalleryController" method="POST" enctype="multipart/form-data" class="row g-3 align-items-end">
                        <input type="hidden" name="action" value="upload">
                        <div class="col-md-5">
                            <label class="form-label">Judul / Caption</label>
                            <input type="text" name="title" class="form-control" placeholder="Contoh: Hasil Cuci Sepatu" required>
                        </div>
                        <div class="col-md-5">
                            <label class="form-label">Pilih Foto</label>
                            <input type="file" name="file" class="form-control" accept="image/*" required>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-primary w-100 fw-bold">Upload</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="row g-4">
                <%
                    GalleryDAO dao = new GalleryDAO();
                    List<Gallery> list = dao.getAllPhotos();
                    for(Gallery g : list) {
                %>
                <div class="col-md-3 col-6">
                    <div class="card border-0 shadow-sm h-100">
                        <img src="../uploads/<%= g.getImagePath() %>" class="gallery-img card-img-top" alt="Foto">
                        <div class="card-body p-3 text-center">
                            <h6 class="fw-bold mb-2 small"><%= g.getTitle() %></h6>
                            <form action="../GalleryController" method="POST" onsubmit="return confirm('Hapus foto ini?');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= g.getId() %>">
                                <button class="btn btn-sm btn-outline-danger w-100 rounded-pill"><i class="fas fa-trash"></i> Hapus</button>
                            </form>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>