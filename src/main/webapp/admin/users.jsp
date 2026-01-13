<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dao.UserDAO"%>
<%@page import="model.User"%>

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
    <title>Kelola Pengguna | Clean Laundry</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">
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
        
        /* CSS KHUSUS USER (TABLE CARD) */
        .table-custom { background: white; border-radius: 15px; padding: 25px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); }
        .btn-circle { width: 35px; height: 35px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; }
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
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold mb-1">Data Pengguna</h3>
                    <p class="text-muted">Kelola data pelanggan dan hak akses.</p>
                </div>
                <div>
                    <button class="btn btn-success rounded-pill shadow-sm me-2" data-bs-toggle="modal" data-bs-target="#addUserModal">
                        <i class="fas fa-plus me-2"></i> Tambah User
                    </button>
                    <button class="btn btn-primary rounded-pill shadow-sm" onclick="window.print()">
                        <i class="fas fa-print me-2"></i> Print
                    </button>
                </div>
            </div>

            <div class="table-custom">
                <table id="tableUser" class="table table-hover align-middle mb-0" style="width:100%">
                    <thead class="bg-primary text-white">
                        <tr>
                            <th class="ps-4">ID</th>
                            <th>Nama</th>
                            <th>Email & HP</th>
                            <th>Role</th>
                            <th>Alamat</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            UserDAO dao = new UserDAO();
                            List<User> users = dao.getAllUsers();
                            for(User u : users) {
                        %>
                        <tr>
                            <td class="ps-4 fw-bold">#<%= u.getId() %></td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="bg-light rounded-circle p-2 me-2 text-primary fw-bold border" style="width: 35px; height: 35px; text-align: center; display:flex; align-items:center; justify-content:center;">
                                        <%= u.getName().substring(0, 1).toUpperCase() %>
                                    </div>
                                    <span class="fw-bold text-dark"><%= u.getName() %></span>
                                </div>
                            </td>
                            <td>
                                <div class="small"><i class="fas fa-envelope text-muted me-1"></i><%= u.getEmail() %></div>
                                <div class="small text-muted"><i class="fas fa-phone text-muted me-1"></i><%= u.getPhone()!=null?u.getPhone():"-" %></div>
                            </td>
                            <td>
                                <span class="badge <%= "admin".equals(u.getRole())?"bg-danger":"bg-success" %> rounded-pill px-3"><%= u.getRole().toUpperCase() %></span>
                            </td>
                            <td class="small text-truncate" style="max-width: 150px;"><%= u.getAddress()!=null?u.getAddress():"-" %></td>
                            <td>
                                <button class="btn btn-warning btn-sm btn-circle text-white me-1"
                                    onclick="editUser('<%= u.getId() %>', '<%= u.getName() %>', '<%= u.getEmail() %>', '<%= u.getPhone() %>', '<%= u.getRole() %>', `<%= u.getAddress() %>`)"
                                    data-bs-toggle="modal" data-bs-target="#editUserModal">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <% if(!"superadmin".equalsIgnoreCase(u.getRole())) { %>
                                <form action="../UserController" method="POST" class="d-inline" onsubmit="return confirm('Hapus user ini?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%= u.getId() %>">
                                    <button class="btn btn-danger btn-sm btn-circle"><i class="fas fa-trash"></i></button>
                                </form>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="addUserModal" tabindex="-1"><div class="modal-dialog"><form action="../UserController" method="POST" class="modal-content"><input type="hidden" name="action" value="add"><div class="modal-header bg-success text-white"><h5 class="modal-title">Tambah User Baru</h5><button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button></div><div class="modal-body"><div class="mb-3"><label>Nama</label><input type="text" name="name" class="form-control" required></div><div class="mb-3"><label>Email</label><input type="email" name="email" class="form-control" required></div><div class="mb-3"><label>Password</label><input type="password" name="password" class="form-control" required></div><div class="row mb-3"><div class="col-6"><label>No HP</label><input type="text" name="phone" class="form-control"></div><div class="col-6"><label>Role</label><select name="role" class="form-select"><option value="customer">Customer</option><option value="admin">Admin</option></select></div></div><div class="mb-3"><label>Alamat</label><textarea name="address" class="form-control"></textarea></div></div><div class="modal-footer"><button type="button" class="btn btn-light" data-bs-dismiss="modal">Batal</button><button type="submit" class="btn btn-success">Simpan</button></div></form></div></div>
<div class="modal fade" id="editUserModal" tabindex="-1"><div class="modal-dialog"><form action="../UserController" method="POST" class="modal-content"><input type="hidden" name="action" value="update"><input type="hidden" name="id" id="user_id"><div class="modal-header bg-warning text-dark"><h5 class="modal-title">Edit Profil User</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div><div class="modal-body"><div class="mb-3"><label>Nama</label><input type="text" name="name" id="user_name" class="form-control" required></div><div class="mb-3"><label>Email</label><input type="email" name="email" id="user_email" class="form-control" required></div><div class="row mb-3"><div class="col-6"><label>No HP</label><input type="text" name="phone" id="user_phone" class="form-control"></div><div class="col-6"><label>Role</label><select name="role" id="user_role" class="form-select"><option value="customer">Customer</option><option value="admin">Admin</option></select></div></div><div class="mb-3"><label>Alamat</label><textarea name="address" id="user_address" class="form-control"></textarea></div></div><div class="modal-footer"><button type="button" class="btn btn-light" data-bs-dismiss="modal">Batal</button><button type="submit" class="btn btn-warning">Update Profil</button></div></form></div></div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>

<script>
    var el = document.getElementById("wrapper");
    var toggleButton = document.getElementById("menu-toggle");
    toggleButton.onclick = function () { el.classList.toggle("toggled"); };

    $(document).ready(function () { $('#tableUser').DataTable(); });

    function editUser(id, name, email, phone, role, address) {
        document.getElementById('user_id').value = id;
        document.getElementById('user_name').value = name;
        document.getElementById('user_email').value = email;
        document.getElementById('user_phone').value = (phone && phone !== 'null') ? phone : '';
        document.getElementById('user_address').value = (address && address !== 'null') ? address : '';
        document.getElementById('user_role').value = role.toLowerCase();
    }
</script>
</body>
</html>