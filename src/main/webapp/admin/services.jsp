<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, java.text.NumberFormat, java.util.Locale"%>
<%@page import="dao.ServiceDAO, model.Service, model.User"%>

<%
    User admin = (User) session.getAttribute("currentUser");
    if(admin == null || (!"admin".equalsIgnoreCase(admin.getRole()) && !"superadmin".equalsIgnoreCase(admin.getRole()))) {
        response.sendRedirect("../index.jsp"); return;
    }
    
    ServiceDAO dao = new ServiceDAO();
    List<Service> list = dao.getAllServices();
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Kelola Layanan | Clean Laundry</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        /* --- CSS DARI DASHBOARD (AGAR SAMA PERSIS) --- */
        body { font-family: 'Poppins', sans-serif; overflow-x: hidden; background-color: #f0f2f5; }
        
        #wrapper { display: flex; width: 100%; transition: all 0.3s; }
        
        #sidebar-wrapper {
            min-width: 250px;
            max-width: 250px;
            background-color: #212529; /* Dark Sidebar */
            color: white;
            min-height: 100vh;
            transition: margin 0.3s ease-out;
        }
        
        #wrapper.toggled #sidebar-wrapper { margin-left: -250px; }
        
        #page-content-wrapper { width: 100%; flex: 1; }
        
        .sidebar-heading { padding: 1.5rem 1.25rem; font-size: 1.2rem; font-weight: bold; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .list-group-item { border: none; padding: 15px 25px; background-color: transparent; color: rgba(255,255,255,0.7); }
        .list-group-item:hover { background-color: rgba(255,255,255,0.1); color: white; }
        .list-group-item.active { background-color: #0d6efd; color: white; font-weight: bold; }
        .list-group-item i { width: 25px; }

        @media (max-width: 768px) {
            #sidebar-wrapper { margin-left: -250px; }
            #wrapper.toggled #sidebar-wrapper { margin-left: 0; }
        }

        /* --- CSS KHUSUS SERVICES (GRID CARD) --- */
        .service-card {
            border: none; border-radius: 15px; transition: all 0.3s; background: white;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05); position: relative; overflow: hidden;
        }
        .service-card:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        .icon-circle {
            width: 60px; height: 60px; background: #eef2ff; color: #0d6efd;
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
            font-size: 1.5rem; margin-bottom: 15px;
        }
        .price-text { font-weight: 700; color: #212529; font-size: 1.3rem; }
    </style>
</head>
<body>

<div class="d-flex" id="wrapper">

    <jsp:include page="../includes/sidebar.jsp" />

    <div id="page-content-wrapper">
        
        <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom shadow-sm px-3 py-3">
            <div class="container-fluid">
                <button class="btn btn-outline-dark" id="menu-toggle"><i class="fas fa-bars"></i></button>
                <div class="collapse navbar-collapse">
                    <ul class="navbar-nav ms-auto mt-2 mt-lg-0 align-items-center">
                        <li class="nav-item"><span class="nav-link fw-bold text-dark">Hi, <%= admin.getName() %></span></li>
                        <li class="nav-item">
                            <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center fw-bold ms-2" style="width: 35px; height: 35px;">
                                <%= admin.getName().substring(0,1).toUpperCase() %>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container-fluid px-4 py-4">
            <div class="d-flex justify-content-between align-items-center mb-5">
                <div>
                    <h3 class="fw-bold mb-1">Daftar Paket & Layanan</h3>
                    <p class="text-muted">Kelola harga dan jenis layanan yang tampil di website.</p>
                </div>
                <button class="btn btn-primary rounded-pill shadow px-4" data-bs-toggle="modal" data-bs-target="#addModal">
                    <i class="fas fa-plus me-2"></i> Tambah Layanan
                </button>
            </div>

            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                <% for(Service s : list) { 
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
                        <p class="text-muted small mb-3">Estimasi <%= s.getEstimatedDays() %> Hari Kerja</p>
                        
                        <div class="price-text mb-3">
                            <small class="fs-6 text-muted fw-normal">Rp</small> 
                            <%= String.format("%,.0f", s.getPrice()) %>
                            <small class="fs-6 text-muted fw-normal"> / <%= s.getUnit() %></small>
                        </div>
                        
                        <div class="mt-auto d-flex gap-2 justify-content-center border-top pt-3">
                            <button class="btn btn-outline-warning btn-sm rounded-pill px-3 fw-bold"
                                    onclick="editService('<%= s.getId() %>', '<%= s.getName() %>', '<%= s.getPrice() %>', '<%= s.getUnit() %>', '<%= s.getEstimatedDays() %>')"
                                    data-bs-toggle="modal" data-bs-target="#editModal">
                                <i class="fas fa-edit me-1"></i> Edit
                            </button>
                            
                            <form action="../ServiceController" method="POST" onsubmit="return confirm('Hapus layanan ini?');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= s.getId() %>">
                                <button class="btn btn-outline-danger btn-sm rounded-pill px-3 fw-bold">
                                    <i class="fas fa-trash me-1"></i> Hapus
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="addModal" tabindex="-1"><div class="modal-dialog"><form action="../ServiceController" method="POST" class="modal-content"><input type="hidden" name="action" value="add"><div class="modal-header bg-primary text-white"><h5 class="modal-title">Tambah Layanan</h5><button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button></div><div class="modal-body"><div class="mb-3"><label>Nama Layanan</label><input type="text" name="name" class="form-control" required></div><div class="row"><div class="col-6 mb-3"><label>Harga (Rp)</label><input type="number" name="price" class="form-control" required></div><div class="col-6 mb-3"><label>Satuan</label><select name="unit" class="form-select"><option value="Kg">Kg</option><option value="Pcs">Pcs</option><option value="Meter">Meter</option><option value="Pasang">Pasang</option></select></div></div><div class="mb-3"><label>Estimasi (Hari)</label><input type="number" name="estimated_days" class="form-control" value="2" required></div></div><div class="modal-footer"><button type="button" class="btn btn-light" data-bs-dismiss="modal">Batal</button><button type="submit" class="btn btn-primary">Simpan</button></div></form></div></div>
<div class="modal fade" id="editModal" tabindex="-1"><div class="modal-dialog"><form action="../ServiceController" method="POST" class="modal-content"><input type="hidden" name="action" value="update"><input type="hidden" name="id" id="edit_id"> <div class="modal-header bg-warning text-dark"><h5 class="modal-title">Edit Layanan</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div><div class="modal-body"><div class="mb-3"><label>Nama Layanan</label><input type="text" name="name" id="edit_name" class="form-control" required></div><div class="row"><div class="col-6 mb-3"><label>Harga</label><input type="number" name="price" id="edit_price" class="form-control" required></div><div class="col-6 mb-3"><label>Satuan</label><select name="unit" id="edit_unit" class="form-select"><option value="Kg">Kg</option><option value="Pcs">Pcs</option><option value="Meter">Meter</option><option value="Pasang">Pasang</option></select></div></div><div class="mb-3"><label>Estimasi (Hari)</label><input type="number" name="estimated_days" id="edit_est" class="form-control" required></div></div><div class="modal-footer"><button type="button" class="btn btn-light" data-bs-dismiss="modal">Batal</button><button type="submit" class="btn btn-warning">Update</button></div></form></div></div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    var el = document.getElementById("wrapper");
    var toggleButton = document.getElementById("menu-toggle");
    toggleButton.onclick = function () { el.classList.toggle("toggled"); };

    function editService(id, name, price, unit, est) {
        document.getElementById('edit_id').value = id;
        document.getElementById('edit_name').value = name;
        document.getElementById('edit_price').value = price;
        document.getElementById('edit_unit').value = unit;
        document.getElementById('edit_est').value = est;
    }
</script>
</body>
</html>