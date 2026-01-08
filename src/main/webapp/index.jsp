<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dao.ServiceDAO"%>
<%@page import="model.Service"%>

<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Clean Laundry | Solusi Cuci Premium</title>
        
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/style.css">
    </head>
    
    <body>

        <jsp:include page="includes/navbar.jsp" />
 
        <header class="hero-header text-center position-relative overflow-hidden">
            <div class="container position-relative z-2">
                <span class="badge bg-white text-primary px-3 py-2 rounded-pill mb-3 shadow-sm fw-bold">
                    <i class="fas fa-star me-1 text-warning"></i> Laundry #1 di Galaksi Bima Sakti 
                </span>
                <h1 class="display-3 fw-bold mb-3">Adalah pokoknya</h1>
                <p class="lead mb-4 opacity-75 mx-auto" style="max-width: 600px;">
                    Capek mikirin hidup? Jangan mikirin cucian juga. Serahin ke kami dijemput, dicuci, disikat, digosok enak dah terima beres
                </p>
                <div class="d-flex justify-content-center gap-3">
                    <a href="${pageContext.request.contextPath}/services.jsp" class="btn btn-light btn-lg rounded-pill shadow fw-bold text-primary px-5">Pesan Sekarang</a>
                    <a href="https://wa.me/6287894603748" class="btn btn-outline-light btn-lg rounded-pill px-4" target="_blank">
                        <i class="fab fa-whatsapp"></i> Chat Admin
</a>
                </div>
            </div>
        </header>
        <br><br>
        <section id="services" class="container py-5">
            <div class="text-center mb-5">
                <h2 class="fw-bold">Layanan Unggulan Kami</h2>
                <p class="text-muted">Pilih paket yang sesuai dengan kebutuhan laundry Anda</p>
            </div>

            <div class="row row-cols-1 row-cols-md-3 g-4">
                <%
                    ServiceDAO dao = new ServiceDAO();
                    List<Service> layanans = dao.getAllServices();

                    // Mengambil maksimal 3 layanan saja untuk preview
                    int limit = Math.min(layanans.size(), 3);
                    for (int i = 0; i < limit; i++) {
                        Service s = layanans.get(i);

                        // Logika Ikon
                        String icon = "fa-tshirt";
                        if (s.getName().toLowerCase().contains("sepatu")) {
                            icon = "fa-shoe-prints";
                        }
                        if (s.getName().toLowerCase().contains("setrika")) {
                            icon = "fa-temperature-high";
                        }
                        if (s.getPrice() > 15000)
                            icon = "fa-crown";
                %>

                <div class="col">
                    <div class="card service-card h-100 p-4 text-center border-0 shadow-sm" style="border-radius: 20px;">
                        <div class="icon-circle mx-auto mb-3">
                            <i class="fas <%= icon%>"></i>
                        </div>

                        <h5 class="fw-bold mb-1"><%= s.getName()%></h5>
                        <p class="text-muted small mb-3">Estimasi <%= s.getDuration()%> Hari Kerja</p>

                        <div class="price-text mb-4">
                            <span class="fs-6 text-muted fw-normal">Rp</span> 
                            <%= String.format("%,.0f", s.getPrice())%>
                            <span class="fs-6 text-muted fw-normal"> / <%= s.getUnit()%></span>
                        </div>

                        <div class="mt-auto">
                            <a href="order-form.jsp?id=<%= s.getId()%>" class="btn btn-pesan w-100 fw-bold py-2 shadow-sm text-decoration-none d-block">
                                Pilih Paket <i class="fas fa-arrow-right ms-2"></i>
                            </a>
                        </div>
                    </div>
                </div>

                <% }%>
            </div>

            <!-- Tombol Lihat Semua Layanan -->
                <div class="text-center mt-5 pt-3">
                    <a href="services.jsp" class="btn btn-outline-primary rounded-pill px-4 fw-bold">
                        Lihat Semua Layanan >
                    </a>
                    <p class="text-muted small mt-2">
                        <i class="fas fa-info-circle me-1"></i> Tersedia 7 paket layanan laundry premium
                    </p>
                </div>
        </section>
        <!-- TESTIMONI SECTION - GANTI DI index.jsp -->
        <section id="testimonials" class="py-5 bg-light">
            <div class="container">
                <div class="text-center mb-5">
                    <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill mb-2 fw-bold">
                        <i class="fas fa-heart me-1 text-danger"></i> TESTIMONI PELANGGAN
                    </span>
                    <h2 class="fw-bold">Apa Kata Mereka?</h2>
                    <p class="text-muted mx-auto" style="max-width: 600px;">
                        Ribuan pelanggan sudah membuktikan kualitas layanan kami.
                    </p>
                </div>

                <div class="row row-cols-1 row-cols-md-3 g-4">
                    <!-- Testimoni 1 -->
                    <div class="col">
                        <div class="card h-100 border-0 shadow-sm hover-shadow">
                            <div class="card-body p-4">
                                <!-- Rating Bintang -->
                                <div class="mb-3">
                                    <div class="text-warning">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <span class="text-dark ms-2 fw-bold">5.0</span>
                                    </div>
                                </div>

                                <!-- Komentar -->
                                <p class="card-text text-muted mb-4">
                                    <i class="fas fa-quote-left text-primary opacity-25 me-2"></i>
                                    Cucian saya yang kotor banget jadi kinclong! Pelayanan antar-jemput gratis sangat membantu saya yang sibuk kerja.
                                    <i class="fas fa-quote-right text-primary opacity-25 ms-2"></i>
                                </p>

                                <!-- Profile -->
                                <div class="d-flex align-items-center">
                                    <div class="flex-shrink-0">
                                        <div class="rounded-circle bg-primary bg-opacity-10 p-3">
                                            <i class="fas fa-user text-primary"></i>
                                        </div>
                                    </div>
                                    <div class="flex-grow-1 ms-3">
                                        <h6 class="fw-bold mb-0">Budi Santoso</h6>
                                        <small class="text-muted">Jakarta Selatan</small>
                                    </div>
                                </div>

                                <!-- Service Badge -->
                                <div class="mt-3">
                                    <span class="badge bg-light text-dark border">
                                        <i class="fas fa-tshirt me-1 text-primary"></i> Cuci Kiloan Regular
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Testimoni 2 -->
                    <div class="col">
                        <div class="card h-100 border-0 shadow-sm hover-shadow">
                            <div class="card-body p-4">
                                <!-- Rating Bintang -->
                                <div class="mb-3">
                                    <div class="text-warning">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star-half-alt"></i>
                                        <span class="text-dark ms-2 fw-bold">4.5</span>
                                    </div>
                                </div>

                                <!-- Komentar -->
                                <p class="card-text text-muted mb-4">
                                    <i class="fas fa-quote-left text-success opacity-25 me-2"></i>
                                    Bedcover ukuran king selesai tepat waktu dan wanginya tahan lama sampai 3 hari! Recommended banget buat keluarga.
                                    <i class="fas fa-quote-right text-success opacity-25 ms-2"></i>
                                </p>

                                <!-- Profile -->
                                <div class="d-flex align-items-center">
                                    <div class="flex-shrink-0">
                                        <div class="rounded-circle bg-success bg-opacity-10 p-3">
                                            <i class="fas fa-user-tie text-success"></i>
                                        </div>
                                    </div>
                                    <div class="flex-grow-1 ms-3">
                                        <h6 class="fw-bold mb-0">Siti Aminah</h6>
                                        <small class="text-muted">Bandung</small>
                                    </div>
                                </div>

                                <!-- Service Badge -->
                                <div class="mt-3">
                                    <span class="badge bg-light text-dark border">
                                        <i class="fas fa-bed me-1 text-success"></i> Cuci Bedcover Besar
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Testimoni 3 -->
                    <div class="col">
                        <div class="card h-100 border-0 shadow-sm hover-shadow">
                            <div class="card-body p-4">
                                <!-- Rating Bintang -->
                                <div class="mb-3">
                                    <div class="text-warning">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <span class="text-dark ms-2 fw-bold">5.0</span>
                                    </div>
                                </div>

                                <!-- Komentar -->
                                <p class="card-text text-muted mb-4">
                                    <i class="fas fa-quote-left text-warning opacity-25 me-2"></i>
                                    Jas Armani saya yang mahal ditangani dengan sangat profesional. Dry clean-nya beneran bersih, nggak ada bekas noda.
                                    <i class="fas fa-quote-right text-warning opacity-25 ms-2"></i>
                                </p>

                                <!-- Profile -->
                                <div class="d-flex align-items-center">
                                    <div class="flex-shrink-0">
                                        <div class="rounded-circle bg-warning bg-opacity-10 p-3">
                                            <i class="fas fa-user-graduate text-warning"></i>
                                        </div>
                                    </div>
                                    <div class="flex-grow-1 ms-3">
                                        <h6 class="fw-bold mb-0">Andi Pratama</h6>
                                        <small class="text-muted">Jakarta Pusat</small>
                                    </div>
                                </div>

                                <!-- Service Badge -->
                                <div class="mt-3">
                                    <span class="badge bg-light text-dark border">
                                        <i class="fas fa-vest me-1 text-warning"></i> Dry Clean Jas
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Stats -->
                <div class="row mt-5 pt-4 border-top">
                    <div class="col-md-3 col-6 text-center">
                        <h3 class="fw-bold text-primary">500+</h3>
                        <p class="text-muted small">Pelanggan Setia</p>
                    </div>
                    <div class="col-md-3 col-6 text-center">
                        <h3 class="fw-bold text-success">4.8</h3>
                        <p class="text-muted small">Rating Rata-rata</p>
                    </div>
                    <div class="col-md-3 col-6 text-center">
                        <h3 class="fw-bold text-warning">2,500+</h3>
                        <p class="text-muted small">Cucian Selesai</p>
                    </div>
                    <div class="col-md-3 col-6 text-center">
                        <h3 class="fw-bold text-info">98%</h3>
                        <p class="text-muted small">Kepuasan Pelanggan</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- TAMBAH CSS HOVER -->
        <style>
            .hover-shadow {
                transition: all 0.3s ease;
                border-radius: 15px;
            }
            .hover-shadow:hover {
                transform: translateY(-8px);
                box-shadow: 0 10px 25px rgba(0,0,0,0.1) !important;
            }
        </style>

        <section class="container py-5 text-center">
            <h6 class="text-primary fw-bold text-uppercase ls-2">Kenapa Kami?</h6>
            <h2 class="fw-bold mb-5">Keunggulan Clean Laundry</h2>
            <div class="row g-4">
                <div class="col-md-4">
                    <i class="fas fa-shipping-fast fa-3x text-info mb-3"></i>
                    <h5>Antar Jemput Gratis</h5>
                    <p class="text-muted">Gak perlu macet-macetan, kurir kami siap jemput cucianmu.</p>
                </div>
                <div class="col-md-4">
                    <i class="fas fa-stopwatch fa-3x text-warning mb-3"></i>
                    <h5>Tepat Waktu</h5>
                    <p class="text-muted">Kami menghargai waktumu. Selesai sesuai janji atau gratis.</p>
                </div>
                <div class="col-md-4">
                    <i class="fas fa-leaf fa-3x text-success mb-3"></i>
                    <h5>Ramah Lingkungan</h5>
                    <p class="text-muted">Menggunakan deterjen yang aman untuk kulit dan alam.</p>
                </div>
            </div>
        </section>

        <jsp:include page="includes/footer.jsp" />
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>