<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, java.util.ArrayList, dao.OrderDAO, model.Order, java.text.NumberFormat, java.util.Locale"%>

<%
    // Cek Login
    if(session.getAttribute("currentUser") == null) {
        response.sendRedirect("../index.jsp"); return;
    }

    // Inisialisasi
    List<Order> reportList = new ArrayList<>();
    double grandTotal = 0;
    String tglAwal = request.getParameter("tgl_awal");
    String tglAkhir = request.getParameter("tgl_akhir");
    
    // Jika tombol filter diklik
    if(tglAwal != null && tglAkhir != null) {
        OrderDAO dao = new OrderDAO();
        reportList = dao.getReportByDate(tglAwal, tglAkhir);
        
        // Hitung Grand Total
        for(Order o : reportList) {
            grandTotal += o.getTotalAmount();
        }
    }

    Locale localeID = new Locale("id", "ID");
    NumberFormat formatRupiah = NumberFormat.getCurrencyInstance(localeID);
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Laporan Keuangan | Clean Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f0f2f5; }
        @media print {
            .no-print { display: none !important; }
            .card { border: none !important; shadow: none !important; }
        }
    </style>
</head>
<body>

<div class="d-flex" id="wrapper">
    <div class="no-print">
        <jsp:include page="../includes/sidebar.jsp" />
    </div>

    <div style="width: 100%;">
        <div class="container-fluid px-4 py-4">
            
            <h3 class="fw-bold mb-4"><i class="fas fa-chart-line me-2"></i>Laporan Pendapatan</h3>

            <div class="card border-0 shadow-sm mb-4 no-print">
                <div class="card-body">
                    <form method="GET" class="row g-3 align-items-end">
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Dari Tanggal</label>
                            <input type="date" name="tgl_awal" class="form-control" value="<%= (tglAwal!=null)?tglAwal:"" %>" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Sampai Tanggal</label>
                            <input type="date" name="tgl_akhir" class="form-control" value="<%= (tglAkhir!=null)?tglAkhir:"" %>" required>
                        </div>
                        <div class="col-md-4">
                            <button type="submit" class="btn btn-primary fw-bold text-white w-100">
                                <i class="fas fa-filter me-2"></i> Tampilkan Laporan
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <% if(tglAwal != null && tglAkhir != null) { %>
            <div class="card border-0 shadow-sm">
                <div class="card-body p-4">
                    
                    <div class="text-center mb-4">
                        <h4 class="fw-bold">LAPORAN PEMASUKAN CLEAN LAUNDRY</h4>
                        <p class="text-muted mb-0">Periode: <%= tglAwal %> s/d <%= tglAkhir %></p>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-bordered table-striped align-middle">
                            <thead class="table-dark text-center">
                                <tr>
                                    <th>No</th>
                                    <th>Tanggal</th>
                                    <th>Pelanggan</th>
                                    <th>Layanan</th>
                                    <th>Status</th>
                                    <th>Total (Rp)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    int no = 1;
                                    for(Order o : reportList) { 
                                %>
                                <tr>
                                    <td class="text-center"><%= no++ %></td>
                                    <td><%= o.getOrderDate() %></td>
                                    <td><%= o.getUserName() %></td>
                                    <td><%= o.getServiceName() %> (<%= o.getWeight() %>)</td>
                                    <td class="text-center">
                                        <% if(o.getStatus().equalsIgnoreCase("Completed")) { %>
                                            <span class="badge bg-success">Selesai</span>
                                        <% } else { %>
                                            <span class="badge bg-secondary"><%= o.getStatus() %></span>
                                        <% } %>
                                    </td>
                                    <td class="text-end fw-bold"><%= formatRupiah.format(o.getTotalAmount()).replace("Rp", "") %></td>
                                </tr>
                                <% } %>
                                
                                <% if(reportList.isEmpty()) { %>
                                    <tr><td colspan="6" class="text-center py-3">Tidak ada data transaksi pada periode ini.</td></tr>
                                <% } %>
                            </tbody>
                            <tfoot class="table-light">
                                <tr>
                                    <td colspan="5" class="text-end fw-bold fs-5">TOTAL PENDAPATAN</td>
                                    <td class="text-end fw-bold fs-5 text-primary">
                                        <%= formatRupiah.format(grandTotal) %>
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                    
                    <div class="mt-4 no-print text-end">
                        <button onclick="window.print()" class="btn btn-success fw-bold">
                            <i class="fas fa-print me-2"></i> Cetak Laporan
                        </button>
                    </div>

                </div>
            </div>
            <% } %>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>