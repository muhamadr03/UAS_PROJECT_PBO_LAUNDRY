<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dao.ServiceDAO"%>
<%@page import="model.Service"%>
<%@page import="model.User"%>

<%
    // --- 1. CEK LOGIN ---
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("admin/login.jsp?error=need_login");
        return;
    }

    // --- 2. AMBIL DATA LAYANAN ---
    String idStr = request.getParameter("id");
    if(idStr == null || idStr.isEmpty()) {
        response.sendRedirect("index.jsp");
        return;
    }

    int id = Integer.parseInt(idStr);
    ServiceDAO dao = new ServiceDAO();
    Service s = dao.getServiceById(id);
    if(s == null) {
        out.println("<h2>Layanan tidak ditemukan!</h2>");
        return;
    }
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Form Pemesanan | Clean Laundry</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body class="bg-light">

    <jsp:include page="includes/navbar.jsp" />

    <div class="container" style="margin-top: 120px; margin-bottom: 50px;">
        <div class="row g-5">
            
            <div class="col-md-7 col-lg-8">
                <h4 class="mb-3 fw-bold text-primary"><i class="fas fa-clipboard-list me-2"></i>Detail Pesanan</h4>
                
                <form action="${pageContext.request.contextPath}/OrderController" method="POST" class="card shadow-sm border-0 rounded-4 p-4">
                    <input type="hidden" name="action" value="create_order_customer">
                    <input type="hidden" name="service_id" value="<%= s.getId() %>"><input type="hidden" name="service_id" value="<%= s.getId() %>">
                    
                    <div class="row g-3">
                        
                        <div class="col-12 mb-2">
                            <label class="form-label fw-bold small text-muted">Opsi Pengiriman</label>
                            <div class="d-flex gap-3">
                                <div class="form-check card p-3 border shadow-sm w-50" style="cursor: pointer;">
                                    <input class="form-check-input" type="radio" name="delivery_type" id="pickup" value="pickup" checked>
                                    <label class="form-check-label fw-bold" for="pickup">
                                        <i class="fas fa-truck text-primary me-2"></i> Antar Jemput
                                    </label>
                                </div>
                                <div class="form-check card p-3 border shadow-sm w-50" style="cursor: pointer;">
                                    <input class="form-check-input" type="radio" name="delivery_type" id="dropoff" value="dropoff">
                                    <label class="form-check-label fw-bold" for="dropoff">
                                        <i class="fas fa-store text-success me-2"></i> Datang Sendiri
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-bold small text-muted">Nama Lengkap</label>
                            <input type="text" class="form-control bg-light" value="<%= currentUser.getName() %>" readonly>
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-bold small text-muted">Nomor WhatsApp</label>
                            <input type="text" class="form-control bg-light" name="no_hp" 
                                   value="<%= (currentUser.getPhone() != null) ? currentUser.getPhone() : "" %>" required>
                        </div>

                        <div class="col-12" id="box-alamat">
                            <label class="form-label fw-bold small text-muted">Alamat Penjemputan</label>
                            <textarea class="form-control bg-light" name="alamat" id="input-alamat" rows="3" 
                                      placeholder="Jalan, Nomor Rumah..."><%= (currentUser.getAddress() != null) ? currentUser.getAddress() : "" %></textarea>
                        </div>
                        
                        <div class="col-12 d-none" id="box-toko">
                            <div class="alert alert-success border-0 small">
                                <i class="fas fa-map-marker-alt me-2"></i> <strong>Alamat Toko Kami:</strong><br>
                                Jl. Kebersihan No. 10, Jakarta Selatan<br>
                                <span class="text-muted" style="font-size: 0.9em;">(Buka setiap hari: 08.00 - 20.00)</span>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-muted">
                                Perkiraan <%= s.getUnit().equalsIgnoreCase("Kg") ? "Berat" : "Jumlah" %> (<%= s.getUnit() %>)
                            </label>
                            
                            <input type="number" 
                                   id="input-berat"
                                   step="<%= s.getUnit().equalsIgnoreCase("Kg") ? "0.1" : "1" %>" 
                                   min="1"
                                   class="form-control bg-light" name="berat" required placeholder="Min. 1">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold small text-muted">Pembayaran</label>
                            <select class="form-select bg-light" name="pembayaran">
                                <option value="COD">Bayar di Tempat (COD)</option>
                                <option value="Transfer">Transfer Bank</option>
                            </select>
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-bold small text-muted">Catatan Tambahan (Opsional)</label>
                            <textarea class="form-control bg-light" name="notes" rows="2" 
                                      placeholder="Contoh: Jangan disetrika, pisahkan warna putih..."></textarea>
                        </div>

                    </div>

                    <hr class="my-4 opacity-10">
                    
                    <button class="btn btn-primary btn-lg w-100 rounded-pill fw-bold py-3 shadow-sm" type="submit">
                        <i class="fas fa-paper-plane me-2"></i> Kirim Pesanan
                    </button>
                </form>
            </div>

            <div class="col-md-5 col-lg-4">
                <div class="card border-0 shadow rounded-4 overflow-hidden position-sticky" style="top: 100px;">
                    <div class="card-header bg-primary text-white p-4 text-center border-0">
                        <h5 class="mb-0 small text-uppercase ls-1">Paket Pilihan</h5>
                        <h3 class="fw-bold mt-2"><%= s.getName() %></h3>
                    </div>
                    
                    <div class="card-body p-4 bg-white">
                        <ul class="list-group list-group-flush mb-3">
                            <li class="list-group-item d-flex justify-content-between border-0 px-0">
                                <span class="text-muted">Harga per <%= s.getUnit() %></span>
                                <span class="fw-bold" id="harga-satuan" data-price="<%= s.getPrice() %>">
                                    Rp <%= String.format("%,.0f", s.getPrice()) %>
                                </span>
                            </li>
                            
                            <li class="list-group-item d-flex justify-content-between border-0 px-0">
                                <span class="text-muted">Biaya Antar Jemput</span>
                                <span class="fw-bold text-success" id="display-ongkir">Rp 0</span>
                            </li>
                            
                            <li class="list-group-item d-flex justify-content-between border-0 px-0 pt-3 border-top">
                                <span class="fw-bold text-dark">Estimasi Total</span>
                                <span class="fw-bold text-primary fs-5" id="total-bayar">Rp 0</span>
                            </li>
                        </ul>
                        
                        <div class="alert alert-light border small text-muted fst-italic">
                            <i class="fas fa-calculator me-1"></i> Total biaya sudah termasuk estimasi berat & ongkir (jika ada).
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script> 
        // 1. KONFIGURASI BIAYA ONGKIR (Misal 10.000)
        const BIAYA_ONGKIR = 10000;

        // 2. REFERENSI ELEMENT
        const inputBerat = document.getElementById('input-berat');
        const displayTotal = document.getElementById('total-bayar');
        const displayOngkir = document.getElementById('display-ongkir');
        const elemHarga = document.getElementById('harga-satuan');
        const radioPickup = document.getElementById('pickup');
        const radioDropoff = document.getElementById('dropoff');
        
        const hargaPerUnit = parseFloat(elemHarga.getAttribute('data-price'));

        // Helper Format Rupiah
        const formatRupiah = (angka) => {
            return new Intl.NumberFormat('id-ID', {
                style: 'currency',
                currency: 'IDR',
                minimumFractionDigits: 0
            }).format(angka);
        };

        // 3. FUNGSI HITUNG TOTAL
        function hitungTotal() {
            // Ambil Berat
            let jumlah = parseFloat(inputBerat.value);
            if (isNaN(jumlah) || jumlah < 0) { jumlah = 0; }

            // Cek Ongkir
            let isPickup = radioPickup.checked;
            let ongkir = isPickup ? BIAYA_ONGKIR : 0;

            // Hitung
            let subtotal = jumlah * hargaPerUnit;
            let totalAkhir = subtotal + ongkir;

            // Update UI
            displayOngkir.innerText = isPickup ? formatRupiah(ongkir) : "Rp 0";
            displayTotal.innerText = formatRupiah(totalAkhir);

            // Toggle Tampilan Alamat
            toggleAlamatUI(isPickup);
        }

        function toggleAlamatUI(isPickup) {
            const boxAlamat = document.getElementById('box-alamat');
            const boxToko = document.getElementById('box-toko');
            const inputAlamat = document.getElementById('input-alamat');

            if (isPickup) {
                boxAlamat.classList.remove('d-none');
                boxToko.classList.add('d-none');
                inputAlamat.setAttribute('required', 'required');
            } else {
                boxAlamat.classList.add('d-none');
                boxToko.classList.remove('d-none');
                inputAlamat.removeAttribute('required');
            }
        }

        // 4. EVENT LISTENERS
        inputBerat.addEventListener('input', hitungTotal);
        radioPickup.addEventListener('change', hitungTotal);
        radioDropoff.addEventListener('change', hitungTotal);

        // Jalankan saat load awal
        document.addEventListener("DOMContentLoaded", function() {
            hitungTotal();
        });
    </script>
    
    <jsp:include page="includes/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>