<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="dao.OrderDAO"%>
<%@page import="model.Order"%>
<%@page import="model.User"%>

<%
    // 1. CEK LOGIN (Wajib Login)
    User currentUser = (User) session.getAttribute("currentUser");
    if(currentUser == null) {
        response.sendRedirect("admin/login.jsp?error=need_login");
        return;
    }
    
    // 2. AMBIL DATA PESANAN
    OrderDAO dao = new OrderDAO();
    List<Order> myOrders = dao.getOrdersByUserId(currentUser.getId());
    
    // Format Rupiah
    Locale localeID = new Locale("id", "ID");
    NumberFormat formatRupiah = NumberFormat.getCurrencyInstance(localeID);
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Riwayat Pesanan | Clean Laundry</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css">
    
    <style>
        body { 
            background-color: #f8f9fa; 
            font-family: 'Poppins', sans-serif; /* Mengikuti style index.jsp */
        }
        
        .main-container {
            margin-top: 100px; /* Jarak agar tidak tertutup Navbar fixed */
            min-height: 60vh;
        }

        .card-order {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05); /* Shadow halus */
            overflow: hidden;
        }

        .table thead th {
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
            padding: 15px;
        }

        .table tbody td {
            padding: 15px;
            vertical-align: middle;
        }

        .status-badge {
            font-size: 0.8rem;
            padding: 8px 12px;
            border-radius: 30px;
            font-weight: 500;
        }
        
        .empty-state-icon {
            color: #dee2e6;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

    <jsp:include page="includes/navbar.jsp" />

    <div class="container main-container pb-5">
        
        <div class="text-center mb-5">
            <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill mb-2 fw-bold">
                <i class="fas fa-history me-1"></i> TRANSAKSI ANDA
            </span>
            <h2 class="fw-bold">Riwayat Cucian</h2>
            <p class="text-muted mx-auto" style="max-width: 500px;">
                Pantau proses pencucian baju kesayanganmu secara real-time di sini.
            </p>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-10">
                
                <div class="card card-order bg-white">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="bg-primary text-white">
                                    <tr>
                                        <th class="ps-4">No. Order</th>
                                        <th>Tanggal Masuk</th>
                                        <th>Layanan</th>
                                        <th>Berat/Jml</th>
                                        <th>Total Biaya</th>
                                        <th class="text-center">Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if(myOrders.isEmpty()) { %>
                                        <tr>
                                            <td colspan="6" class="text-center py-5">
                                                <i class="fas fa-clipboard-list fa-4x empty-state-icon"></i>
                                                <h5 class="fw-bold text-dark mt-3">Belum Ada Pesanan</h5>
                                                <p class="text-muted small mb-4">Yuk, mulai cuci bajumu sekarang!</p>
                                                <a href="index.jsp#services" class="btn btn-primary rounded-pill px-4 shadow-sm fw-bold">
                                                    Pesan Sekarang
                                                </a>
                                            </td>
                                        </tr>
                                    <% } else { 
                                        for(Order o : myOrders) {
                                            // Logika Warna Status agar Indah
                                            String badgeClass = "bg-secondary";
                                            String icon = "fa-circle";
                                            
                                            if(o.getStatus().equalsIgnoreCase("Pending")) {
                                                badgeClass = "bg-warning bg-opacity-25 text-warning border border-warning";
                                                icon = "fa-clock";
                                            } else if(o.getStatus().equalsIgnoreCase("Processing")) {
                                                badgeClass = "bg-info bg-opacity-25 text-info border border-info";
                                                icon = "fa-cog fa-spin";
                                            } else if(o.getStatus().equalsIgnoreCase("Completed") || o.getStatus().equalsIgnoreCase("Selesai")) {
                                                badgeClass = "bg-success bg-opacity-25 text-success border border-success";
                                                icon = "fa-check-circle";
                                            } else if(o.getStatus().equalsIgnoreCase("Cancelled")) {
                                                badgeClass = "bg-danger bg-opacity-25 text-danger border border-danger";
                                                icon = "fa-times";
                                            }
                                    %>
                                    <tr>
                                        <td class="ps-4">
                                            <span class="fw-bold text-primary">#<%= o.getOrderId() %></span>
                                        </td>
                                        
                                        <td>
                                            <div class="small fw-bold text-dark"><%= new java.text.SimpleDateFormat("dd MMM yyyy").format(o.getOrderDate()) %></div>
                                            <div class="small text-muted" style="font-size: 11px;">
                                                <%= new java.text.SimpleDateFormat("HH:mm").format(o.getOrderDate()) %> WIB
                                            </div>
                                        </td>
                                        
                                        <td>
                                            <span class="fw-bold text-dark"><%= o.getServiceName() %></span>
                                            <div class="small text-muted fst-italic"><%= o.getDeliveryType().toUpperCase() %></div>
                                        </td>
                                        
                                        <td>
                                            <span class="badge bg-light text-dark border">
                                                <%= o.getTotalKg() %>
                                            </span>
                                        </td>
                                        
                                        <td class="fw-bold text-dark">
                                            <%= formatRupiah.format(o.getTotalAmount()) %>
                                        </td>
                                        
                                        <td class="text-center">
                                            <span class="status-badge <%= badgeClass %> d-inline-flex align-items-center gap-2">
                                                <i class="fas <%= icon %>"></i> <%= o.getStatus() %>
                                            </span>
                                        </td>
                                    </tr>
                                    <%  } 
                                       } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="row mt-4 g-3">
                    <div class="col-md-6">
                        <div class="d-flex align-items-center gap-3 p-3 bg-white rounded-3 shadow-sm border-start border-4 border-warning">
                            <i class="fas fa-clock fa-2x text-warning opacity-50"></i>
                            <div>
                                <small class="text-muted d-block text-uppercase fw-bold" style="font-size: 10px;">Pending / Proses</small>
                                <span class="small">Pesanan sedang dikerjakan oleh tim kami.</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="d-flex align-items-center gap-3 p-3 bg-white rounded-3 shadow-sm border-start border-4 border-success">
                            <i class="fas fa-check-circle fa-2x text-success opacity-50"></i>
                            <div>
                                <small class="text-muted d-block text-uppercase fw-bold" style="font-size: 10px;">Selesai / Completed</small>
                                <span class="small">Cucian sudah bersih dan siap diambil/diantar.</span>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <jsp:include page="includes/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>