<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="dao.OrderDAO"%>
<%@page import="model.Order"%>
<%@page import="model.User"%>

<%
    // 1. CEK LOGIN ADMIN
    User admin = (User) session.getAttribute("currentUser");
    if(admin == null || (!"admin".equalsIgnoreCase(admin.getRole()) && !"superadmin".equalsIgnoreCase(admin.getRole()))) {
        response.sendRedirect("../index.jsp");
        return;
    }

    // 2. AMBIL ID DARI URL
    String idStr = request.getParameter("id");
    if(idStr == null || idStr.isEmpty()) {
        out.println("<div class='alert alert-danger'>ID Pesanan tidak ditemukan.</div>");
        return;
    }

    // 3. AMBIL DATA DARI DAO
    OrderDAO dao = new OrderDAO();
    Order o = dao.getOrderById(Integer.parseInt(idStr));

    if(o == null) {
        out.println("<div class='alert alert-danger'>Data pesanan tidak ditemukan di database.</div>");
        return;
    }

    // 4. LOGIKA HITUNG ONGKIR & SUBTOTAL
    double ongkir = 0;
    if ("pickup".equalsIgnoreCase(o.getDeliveryType())) {
        ongkir = 10000; 
    }
    double subtotal = o.getTotalAmount() - ongkir;

    // 5. FORMATTER
    Locale localeID = new Locale("id", "ID");
    NumberFormat formatRupiah = NumberFormat.getCurrencyInstance(localeID);
    SimpleDateFormat sdfDate = new SimpleDateFormat("dd MMMM yyyy");
    SimpleDateFormat sdfTime = new SimpleDateFormat("HH:mm");
    
    // Warna Status
    String statusColor = "#6c757d"; 
    String statusBorder = "#6c757d";
    if(o.getStatus().equalsIgnoreCase("Completed") || o.getStatus().equalsIgnoreCase("Selesai")) {
        statusColor = "#198754"; 
        statusBorder = "#198754";
    } else if(o.getStatus().equalsIgnoreCase("Pending")) {
        statusColor = "#ffc107"; 
        statusBorder = "#ffc107";
    } else if(o.getStatus().equalsIgnoreCase("Cancelled")) {
        statusColor = "#dc3545"; 
        statusBorder = "#dc3545";
    }
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Invoice #<%= o.getOrderId() %> - Clean Laundry</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    
    <style>
        body {
            background-color: #525659;
            font-family: 'Inter', sans-serif;
            -webkit-print-color-adjust: exact;
        }

        .invoice-paper {
            background-color: white;
            width: 210mm;
            min-height: 297mm;
            margin: 30px auto;
            padding: 40px 50px;
            box-shadow: 0 0 20px rgba(0,0,0,0.5);
            position: relative;
        }

        /* HEADER */
        .brand-name { font-size: 24px; font-weight: 800; letter-spacing: -0.5px; color: #0d6efd; }
        .invoice-title { font-size: 32px; font-weight: 300; color: #ccc; letter-spacing: 2px; text-align: right; }

        /* INFO SECTION */
        .info-label { font-size: 11px; text-transform: uppercase; color: #888; font-weight: 600; margin-bottom: 3px; }
        .info-value { font-size: 14px; color: #222; font-weight: 500; }

        /* TABLE UTAMA */
        .table-invoice th {
            background-color: #f8f9fa !important; border-bottom: 2px solid #eee;
            color: #555; font-size: 12px; text-transform: uppercase; padding: 12px 15px;
        }
        .table-invoice td { padding: 15px; vertical-align: middle; border-bottom: 1px solid #f2f2f2; }
        .table-invoice tr:last-child td { border-bottom: none; }

        /* BAGIAN TOTAL (DIPERBAIKI AGAR RAPI) */
        .total-section {
            background-color: #fcfcfc;
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 15px 20px;
        }
        
        /* Tabel kecil khusus total agar rata kanan sempurna */
        .table-total {
            width: 100%;
            margin-bottom: 0;
        }
        .table-total td {
            padding: 5px 0;
            text-align: right;
            border: none;
        }
        .table-total .label-text {
            color: #6c757d;
            padding-right: 20px; /* Jarak antara teks dan angka */
        }
        .table-total .value-text {
            font-weight: 600;
            color: #212529;
            width: 140px; /* Lebar tetap untuk angka agar lurus */
        }
        .table-total .grand-total td {
            border-top: 2px dashed #ccc !important;
            padding-top: 15px;
            margin-top: 10px;
            font-size: 1.2rem;
            font-weight: 800;
            color: #0d6efd;
        }

        /* STAMP STATUS */
        .status-stamp {
            position: absolute; top: 150px; right: 50px;
            font-size: 2rem; font-weight: 700; color: <%= statusColor %>;
            border: 3px solid <%= statusBorder %>; padding: 5px 20px;
            text-transform: uppercase; opacity: 0.2; transform: rotate(-15deg);
            pointer-events: none;
        }

        .invoice-footer { margin-top: 50px; padding-top: 20px; border-top: 1px dashed #ddd; font-size: 12px; color: #666; text-align: center; }
        .action-bar { position: fixed; top: 20px; right: 20px; z-index: 999; display: flex; gap: 10px; }

        @media print {
            body { background-color: white; margin: 0; }
            .invoice-paper { width: 100%; margin: 0; box-shadow: none; padding: 20px; min-height: auto; }
            .action-bar { display: none !important; }
            .status-stamp { opacity: 0.4; }
        }
    </style>
</head>
<body>

    <div class="action-bar">
        <a href="orders.jsp" class="btn btn-light shadow-sm fw-bold border">
            <i class="fas fa-arrow-left"></i> Kembali
        </a>
        <button onclick="window.print()" class="btn btn-primary shadow-sm fw-bold">
            <i class="fas fa-print"></i> Cetak / PDF
        </button>
    </div>

    <div class="invoice-paper">
        
        <div class="status-stamp"><%= o.getStatus() %></div>

        <div class="row align-items-center mb-5">
            <div class="col-6">
                <div class="brand-name"><i class="fas fa-soap"></i> Clean Laundry</div>
                <div class="text-muted small mt-1">
                    Jl. Kebersihan No. 10, Jakarta Selatan<br>
                    WhatsApp: 0812-3456-7890
                </div>
            </div>
            <div class="col-6 text-end">
                <div class="invoice-title">INVOICE</div>
                <div class="text-muted">#INV-<%= String.format("%05d", o.getOrderId()) %></div>
            </div>
        </div>

        <div class="row mb-5">
            <div class="col-6">
                <div class="info-label">DITAGIHKAN KEPADA:</div>
                <div class="info-value fs-5"><%= o.getUserName() %></div>
                <div class="text-muted small">
                    <i class="fas fa-phone-alt me-1"></i> <%= o.getPickupPhone() != null ? o.getPickupPhone() : "-" %><br>
                    <% if("pickup".equals(o.getDeliveryType()) && o.getPickupAddress() != null) { %>
                        <div class="mt-1">
                            <i class="fas fa-map-marker-alt text-danger me-1"></i> <%= o.getPickupAddress() %>
                        </div>
                    <% } else { %>
                        <span class="badge bg-light text-dark border mt-1">Antar Sendiri ke Toko</span>
                    <% } %>
                </div>
            </div>
            <div class="col-6 text-end">
                <div class="info-label">TANGGAL</div>
                <div class="info-value"><%= sdfDate.format(o.getOrderDate()) %></div>
                <div class="mt-2">
                    <div class="info-label">METODE</div>
                    <div class="info-value text-uppercase"><%= o.getDeliveryType() %></div>
                </div>
            </div>
        </div>

        <table class="table table-invoice mb-4">
            <thead>
                <tr>
                    <th style="width: 50%;">Deskripsi Layanan</th>
                    <th class="text-center">Berat (Kg)</th>
                    <th class="text-end">Biaya Jasa</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <span class="fw-bold text-dark"><%= o.getServiceName() %></span>
                        <div class="small text-muted fst-italic">Status: <%= o.getStatus() %></div>
                        <% if(o.getNotes() != null && !o.getNotes().isEmpty()) { %>
                            <div class="small text-danger mt-1"><i class="fas fa-info-circle"></i> <%= o.getNotes() %></div>
                        <% } %>
                    </td>
                    <td class="text-center"><%= o.getTotalKg() %></td>
                    <td class="text-end fw-bold"><%= formatRupiah.format(subtotal) %></td>
                </tr>
                <tr style="height: 50px;"><td></td><td></td><td></td></tr>
            </tbody>
        </table>

        <div class="row justify-content-end">
            <div class="col-md-5 col-sm-7">
                <div class="total-section">
                    <table class="table-total">
                        <tr>
                            <td class="label-text">Subtotal Jasa</td>
                            <td class="value-text"><%= formatRupiah.format(subtotal) %></td>
                        </tr>
                        <tr>
                            <td class="label-text">Biaya Antar Jemput</td>
                            <td class="value-text <%= ongkir > 0 ? "text-success" : "" %>">
                                <%= formatRupiah.format(ongkir) %>
                            </td>
                        </tr>
                        <tr class="grand-total">
                            <td class="label-text text-dark">TOTAL TAGIHAN</td>
                            <td class="value-text text-primary"><%= formatRupiah.format(o.getTotalAmount()) %></td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>

        <div class="invoice-footer">
            <p class="fw-bold mb-1">TERIMA KASIH TELAH MENGGUNAKAN JASA KAMI</p>
            <p>Bukti ini sah sebagai tanda terima pembayaran.</p>
        </div>

    </div>
</body>
</html>