<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
    <head> 
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login Administrator | Clean Laundry</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">

        <style>
            body {
                font-family: 'Poppins', sans-serif;
                background-color: #f0f2f5;
                height: 100vh;
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
                background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
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
            .form-control:focus {
                background-color: #fff;
                box-shadow: none;
                border-color: #0d6efd;
            }
            .input-group-text {
                border-radius: 10px 0 0 10px;
                border: 1px solid #eee;
                background-color: #f8f9fa;
            }
            .btn-masuk {
                border-radius: 10px;
                padding: 12px;
                font-weight: 600;
                letter-spacing: 1px;
                transition: all 0.3s;
            }
            .btn-masuk:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(13, 110, 253, 0.3);
            }
        </style>
    </head>
    <body>

        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-5 col-lg-4">

                    <div class="card login-card bg-white">

                        <div class="login-header">
                            <i class="fas fa-soap fa-3x mb-2"></i>
                            <h4 class="fw-bold mb-0">Clean Admin</h4>
                            <p class="small opacity-75 mb-0">Silakan login untuk mengelola sistem</p>
                        </div>

                        <div class="card-body p-4 p-md-5">

                            <%
                                String errorCode = request.getParameter("error");
                                if (errorCode != null) {
                            %>

                            <% if (errorCode.equals("invalid")) { %>
                            <div class="alert alert-danger d-flex align-items-center small shadow-sm border-0 rounded-3 mb-4" role="alert">
                                <i class="fas fa-exclamation-circle me-2 fs-5"></i>
                                <div>
                                    <strong>Login Gagal!</strong><br>Email atau Password salah.
                                </div>
                            </div>

                            <% } else if (errorCode.equals("need_login")) { %>
                            <div class="alert alert-warning d-flex align-items-center small shadow-sm border-0 rounded-3 mb-4" role="alert">
                                <i class="fas fa-lock me-2 fs-5"></i>
                                <div>
                                    <strong>Akses Dibatasi</strong><br>Silakan login dulu untuk memesan.
                                </div>
                            </div>
                            <% } %>

                            <% }%>

                            <form action="${pageContext.request.contextPath}/LoginController" method="POST">

                                <div class="mb-3">
                                    <label class="form-label small fw-bold text-muted">EMAIL</label>
                                    <div class="input-group">
                                        <span class="input-group-text text-muted"><i class="fas fa-envelope"></i></span>
                                        <input type="email" name="email" class="form-control" placeholder="admin@laundry.com" required>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label small fw-bold text-muted">PASSWORD</label>
                                    <div class="input-group">
                                        <span class="input-group-text text-muted"><i class="fas fa-lock"></i></span>
                                        <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <div class="form-check">
                                        <input type="checkbox" class="form-check-input" id="remember">
                                        <label class="form-check-label small text-muted" for="remember">Ingat saya</label>
                                    </div>
                                    <a href="#" class="small text-decoration-none fw-bold">Lupa Password?</a>
                                </div>

                                <button type="submit" class="btn btn-primary w-100 btn-masuk">
                                    MASUK SEKARANG <i class="fas fa-arrow-right ms-2"></i>
                                </button>
                            </form>
                        </div>

                        <div class="card-footer bg-light text-center py-3 border-0">
                            <div class="mb-2">
                                <span class="small text-muted">Belum punya akun?</span>
                                <a href="register.jsp" class="small fw-bold text-decoration-none text-primary ms-1">Daftar Akun</a>
                            </div>
                            <a href="${pageContext.request.contextPath}/index.jsp" class="small text-decoration-none text-muted">
                                <i class="fas fa-arrow-left me-1"></i> Kembali ke Website
                            </a>
                        </div>
                    </div>

                </div>
            </div>
        </div>

    </body>
</html>