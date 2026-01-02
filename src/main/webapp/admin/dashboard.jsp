<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>  
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin | Clean Laundry</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-style.css">
</head>
<body>

    <jsp:include page="../includes/sidebar.jsp" />

    <main class="main-content">
        
        <div class="d-flex justify-content-between align-items-center mb-5">
            <div>
                <h2 class="fw-bold text-dark">Dashboard Overview</h2>
                <p class="text-muted mb-0">Halo Admin, inilah performa laundry hari ini.</p>
            </div>
            <div class="d-flex align-items-center bg-white p-2 rounded-pill shadow-sm px-3">
                <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center fw-bold me-2" 
                     style="width: 40px; height: 40px; border: 2px solid #e0e0e0;">
                    SA
                </div>
                <div class="me-2 lh-1 text-end d-none d-md-block">
                    <span class="d-block fw-bold small">Super Admin</span>
                    <span class="d-block text-muted" style="font-size: 10px;">Online</span>
                </div>
            </div>
        </div>

        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <div class="stat-card bg-gradient-1 p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div class="fs-1"><i class="fas fa-receipt"></i></div>
                        <span class="badge bg-white text-primary bg-opacity-75">Hari Ini</span>
                    </div>
                    <h5 class="mb-0 opacity-75">Total Pesanan</h5>
                    <h2 class="fw-bold display-6">12 Order</h2>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="stat-card bg-gradient-2 p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div class="fs-1"><i class="fas fa-check-double"></i></div>
                        <span class="badge bg-white text-success bg-opacity-75">Completed</span>
                    </div>
                    <h5 class="mb-0 opacity-75">Cucian Selesai</h5>
                    <h2 class="fw-bold display-6">8 Paket</h2>
                </div>
            </div>

            <div class="col-md-4">
                <div class="stat-card bg-gradient-3 p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div class="fs-1"><i class="fas fa-wallet"></i></div>
                        <span class="badge bg-white text-danger bg-opacity-75">Profit</span>
                    </div>
                    <h5 class="mb-0 opacity-75">Pendapatan</h5>
                    <h2 class="fw-bold display-6">Rp 450k</h2>
                </div>
            </div>
        </div>

        <div class="table-custom">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="fw-bold mb-0">Pesanan Terbaru Masuk</h5>
                <button class="btn btn-sm btn-primary rounded-pill px-3">Lihat Semua</button>
            </div>
            
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr>
                            <th>ID Order</th>
                            <th>Pelanggan</th>
                            <th>Layanan</th>
                            <th>Status</th>
                            <th>Total</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><span class="fw-bold text-primary">#ORD-001</span></td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="bg-light rounded-circle p-2 me-2 text-primary fw-bold">BS</div>
                                    Budi Santoso
                                </div>
                            </td>
                            <td>Cuci Komplit</td>
                            <td><span class="badge bg-warning text-dark rounded-pill">Proses</span></td>
                            <td class="fw-bold">Rp 45.000</td>
                            <td>
                                <button class="btn btn-sm btn-outline-primary rounded-circle"><i class="fas fa-eye"></i></button>
                            </td>
                        </tr>
                        <tr>
                            <td><span class="fw-bold text-primary">#ORD-002</span></td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="bg-light rounded-circle p-2 me-2 text-primary fw-bold">SA</div>
                                    Siti Aminah
                                </div>
                            </td>
                            <td>Dry Clean Jas</td>
                            <td><span class="badge bg-success rounded-pill">Selesai</span></td>
                            <td class="fw-bold">Rp 60.000</td>
                            <td>
                                <button class="btn btn-sm btn-outline-primary rounded-circle"><i class="fas fa-eye"></i></button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>