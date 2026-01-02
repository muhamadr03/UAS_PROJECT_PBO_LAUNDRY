<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar Akun Baru | Clean Laundry</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
     
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f0f2f5;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08);
            overflow: hidden;
        }
        .login-header {
            background: linear-gradient(135deg, #198754 0%, #20c997 100%); /* Warna Hijau biar beda dikit */
            padding: 30px;
            text-align: center;
            color: white;
        }
        .form-control {
            border-radius: 10px;
            padding: 12px 15px;
            background-color: #f8f9fa;
            border: 1px solid #eee;
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5 col-lg-4">
                
                <div class="card login-card bg-white">
                    <div class="login-header">
                        <i class="fas fa-user-plus fa-3x mb-2"></i>
                        <h4 class="fw-bold mb-0">Buat Akun</h4>
                        <p class="small opacity-75 mb-0">Isi data diri Anda untuk memulai</p>
                    </div>

                    <div class="card-body p-4">
                        
                        <% if(request.getParameter("error") != null) { %>
                            <div class="alert alert-danger small text-center">Gagal Mendaftar! Email mungkin sudah dipakai.</div>
                        <% } %>

                        <form action="${pageContext.request.contextPath}/RegisterController" method="POST">
                            
                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">NAMA LENGKAP</label>
                                <input type="text" name="nama" class="form-control" placeholder="Contoh: Budi Santoso" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">EMAIL</label>
                                <input type="email" name="email" class="form-control" placeholder="nama@email.com" required>
                            </div>

                            <div class="mb-4">
                                <label class="form-label small fw-bold text-muted">PASSWORD</label>
                                <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                            </div>

                            <button type="submit" class="btn btn-success w-100 py-3 rounded-3 fw-bold shadow-sm">
                                DAFTAR SEKARANG
                            </button>
                        </form>
                    </div>
                    
                    <div class="card-footer bg-light text-center py-3 border-0">
                        <span class="small text-muted">Sudah punya akun?</span>
                        <a href="login.jsp" class="small fw-bold text-decoration-none text-success ms-1">Masuk disini</a>
                    </div>
                </div>

            </div>
        </div>
    </div>

</body>
</html>