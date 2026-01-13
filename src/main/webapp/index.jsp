<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, dao.ServiceDAO, model.Service"%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clean Laundry | Solusi Cuci Premium</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        /* --- WARNA & FONT CUSTOM --- */
        :root {
            --primary-color: #4361ee;       /* Biru Modern */
            --secondary-color: #3f37c9;     /* Biru Gelap */
            --accent-color: #4cc9f0;        /* Biru Muda Segar */
            --bg-light: #f8f9fa;
            --text-dark: #2b2d42;
        }

        body { font-family: 'Poppins', sans-serif; color: var(--text-dark); background-color: #fff; }

        /* HERO SECTION */
        .hero-header { 
            padding: 160px 0 100px; 
            /* Gradasi Biru Langit Lembut */
            background: linear-gradient(135deg, #e3f2fd 0%, #f1f8ff 100%); 
            border-bottom-right-radius: 80px;
        }
        .hero-title { background: -webkit-linear-gradient(45deg, var(--primary-color), var(--accent-color)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }

        /* BUTTONS */
        .btn-primary-custom {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            border: none; color: white; transition: all 0.3s;
        }
        .btn-primary-custom:hover { transform: translateY(-3px); box-shadow: 0 10px 20px rgba(67, 97, 238, 0.3); color: white; }

        /* CARD SERVICES */
        .service-card {
            border: none; border-radius: 20px; background: white;
            box-shadow: 0 10px 30px rgba(0,0,0,0.03); transition: all 0.3s;
            border: 1px solid rgba(0,0,0,0.05);
        }
        .service-card:hover { transform: translateY(-10px); box-shadow: 0 20px 40px rgba(67, 97, 238, 0.15); border-color: var(--accent-color); }
        .icon-box {
            width: 80px; height: 80px; background: linear-gradient(135deg, #e0f2fe 0%, #bae6fd 100%);
            color: var(--primary-color); border-radius: 50%; display: flex; align-items: center; justify-content: center;
            font-size: 2rem; margin: 0 auto 20px; transition: 0.3s;
        }
        .service-card:hover .icon-box { background: var(--primary-color); color: white; }

        /* ABOUT SECTION */
        .about-img { border-radius: 30px; box-shadow: 20px 20px 0px var(--accent-color); }

        /* TEAM SECTION */
        .team-card { border: none; background: transparent; }
        .team-img { 
            width: 140px; height: 140px; object-fit: cover; border-radius: 50%; 
            border: 5px solid white; box-shadow: 0 10px 20px rgba(0,0,0,0.1); 
            transition: 0.3s;
        }
        .team-card:hover .team-img { transform: scale(1.1); border-color: var(--accent-color); }

        /* TESTIMONIAL */
        .testimonial-section { background-color: #1e1e2e; color: white; border-top-left-radius: 80px; }
        .testimonial-card {
            background: rgba(255,255,255,0.05); backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.1); border-radius: 20px; padding: 30px;
        }
        
        /* TEXT HIGHLIGHT */
        .text-gradient { color: var(--primary-color); font-weight: 700; }
    </style>
</head>

<body>

    <jsp:include page="includes/navbar.jsp" />

    <header class="hero-header text-center position-relative overflow-hidden">
        <div class="container position-relative z-2">
            <span class="badge bg-white text-primary px-3 py-2 rounded-pill mb-4 shadow-sm fw-bold border">
                <i class="fas fa-sparkles text-warning me-1"></i> Laundry Paling Wangi & Bersih
            </span>
            <h1 class="display-3 fw-bold mb-3 hero-title">Cucian Numpuk?<br>Kami Jemput Sekarang!</h1>
            <p class="lead mb-5 opacity-75 mx-auto text-secondary" style="max-width: 600px;">
                Hemat waktumu untuk hal yang lebih penting. Biarkan kami yang mencuci, menyetrika, dan melipat pakaianmu dengan penuh cinta.
            </p>
            <div class="d-flex justify-content-center gap-3">
                <a href="#services" class="btn btn-primary-custom btn-lg rounded-pill px-5 py-3 fw-bold shadow">
                    <i class="fas fa-paper-plane me-2"></i> Pesan Layanan
                </a>
                <a href="https://wa.me/628123456789" class="btn btn-outline-dark btn-lg rounded-pill px-4 py-3 fw-bold">
                    <i class="fab fa-whatsapp me-2"></i> Chat WA
                </a>
            </div>
        </div>
    </header>

    <section id="services" class="container py-5" style="margin-top: -50px; position: relative; z-index: 10;">
        <div class="row row-cols-1 row-cols-md-3 g-4">
            <%
                ServiceDAO dao = new ServiceDAO();
                List<Service> layanans = dao.getAllServices();
                int count = 0;
                for(Service s : layanans) {
                    if(count >= 3) break; 
                    count++;
                    String icon = "fa-tshirt";
                    if(s.getName().toLowerCase().contains("sepatu")) { icon = "fa-shoe-prints"; }
                    if(s.getName().toLowerCase().contains("setrika")) { icon = "fa-temperature-high"; }
                    if(s.getPrice() > 15000) icon = "fa-crown";
            %>
            <div class="col">
                <div class="card service-card h-100 p-4 text-center">
                    <div class="icon-box">
                        <i class="fas <%= icon %>"></i>
                    </div>
                    <h5 class="fw-bold mb-1"><%= s.getName() %></h5>
                    <p class="text-muted small mb-3">Estimasi <%= s.getEstimatedDays() %> Hari</p>
                    <h3 class="fw-bold text-gradient mb-4">
                        <small class="fs-6 text-muted">Rp</small> <%= String.format("%,.0f", s.getPrice()) %>
                    </h3>
                    <div class="mt-auto">
                        <a href="order-form.jsp?id=<%= s.getId() %>" class="btn btn-outline-primary w-100 rounded-pill fw-bold">Pilih Paket</a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>

        <div class="text-center mt-5">
            <a href="services.jsp" class="btn btn-link text-decoration-none fw-bold fs-5 text-dark">
                Lihat Seluruh Layanan <i class="fas fa-arrow-right ms-2 text-primary"></i>
            </a>
        </div>
    </section>

    <section id="about" class="py-5 position-relative bg-light">
        
        <div class="position-absolute start-0 top-0 w-100 h-100 opacity-25" 
             style="background-image: radial-gradient(#4361ee 0.5px, transparent 0.5px); background-size: 20px 20px;">
        </div>

        <div class="container py-5 position-relative z-1">
            
            <div class="text-center mx-auto mb-5" style="max-width: 800px;">
                <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill mb-3 fw-bold ls-1">
                    TENTANG KAMI
                </span>
                <h2 class="fw-bold display-5 mb-4 text-dark">
                    Laundry Modern untuk <br> Gaya Hidup Sibuk Anda
                </h2>
                <p class="text-muted lead" style="line-height: 1.8;">
                    Clean Laundry bukan sekadar tempat mencuci. Kami adalah partner kebersihan Anda. 
                    Dengan teknologi <span class="text-primary fw-bold">Eco-Wash</span>, kami memastikan pakaian bersih sempurna dan wangi tahan lama.
                </p>
            </div>

            <div class="row justify-content-center mb-5 g-4">
                <div class="col-6 col-md-3">
                    <div class="js-tilt-card bg-white p-4 rounded-4 shadow-sm text-center border-bottom border-4 border-primary h-100">
                        <h2 class="fw-bold text-primary display-6 mb-0">2024</h2>
                        <small class="text-muted fw-bold text-uppercase">Berdiri Sejak</small>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="js-tilt-card bg-white p-4 rounded-4 shadow-sm text-center border-bottom border-4 border-info h-100">
                        <h2 class="fw-bold text-info display-6 mb-0">5k+</h2>
                        <small class="text-muted fw-bold text-uppercase">Pelanggan Happy</small>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="js-tilt-card bg-white p-4 rounded-4 shadow-sm text-center border-bottom border-4 border-success h-100">
                        <h2 class="fw-bold text-success display-6 mb-0">100%</h2>
                        <small class="text-muted fw-bold text-uppercase">Jaminan Bersih</small>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-md-6 col-lg-3">
                    <div class="js-tilt-card card h-100 border-0 shadow-sm p-4 rounded-4 text-center">
                        <div class="mx-auto mb-3 bg-primary bg-opacity-10 text-primary rounded-circle d-flex align-items-center justify-content-center" style="width: 60px; height: 60px; font-size: 1.5rem;">
                            <i class="fas fa-shipping-fast"></i>
                        </div>
                        <h5 class="fw-bold">Antar Jemput</h5>
                        <p class="text-muted small mb-0">Kurir kami siap menjemput cucian kotor dan mengantarnya kembali.</p>
                    </div>
                </div>

                <div class="col-md-6 col-lg-3">
                    <div class="js-tilt-card card h-100 border-0 shadow-sm p-4 rounded-4 text-center">
                        <div class="mx-auto mb-3 bg-warning bg-opacity-10 text-warning rounded-circle d-flex align-items-center justify-content-center" style="width: 60px; height: 60px; font-size: 1.5rem;">
                            <i class="fas fa-stopwatch"></i>
                        </div>
                        <h5 class="fw-bold">Tepat Waktu</h5>
                        <p class="text-muted small mb-0">Jaminan selesai sesuai estimasi yang dijanjikan.</p>
                    </div>
                </div>

                <div class="col-md-6 col-lg-3">
                    <div class="js-tilt-card card h-100 border-0 shadow-sm p-4 rounded-4 text-center">
                        <div class="mx-auto mb-3 bg-success bg-opacity-10 text-success rounded-circle d-flex align-items-center justify-content-center" style="width: 60px; height: 60px; font-size: 1.5rem;">
                            <i class="fas fa-leaf"></i>
                        </div>
                        <h5 class="fw-bold">Ramah Lingkungan</h5>
                        <p class="text-muted small mb-0">Deterjen biodegradable aman untuk kulit dan alam.</p>
                    </div>
                </div>

                <div class="col-md-6 col-lg-3">
                    <div class="js-tilt-card card h-100 border-0 shadow-sm p-4 rounded-4 text-center">
                        <div class="mx-auto mb-3 bg-info bg-opacity-10 text-info rounded-circle d-flex align-items-center justify-content-center" style="width: 60px; height: 60px; font-size: 1.5rem;">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <h5 class="fw-bold">Garansi Cuci</h5>
                        <p class="text-muted small mb-0">Kurang bersih? Kami cuci ulang gratis tanpa syarat.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="container py-5">
        <div class="text-center mb-5">
            <h6 class="text-primary fw-bold text-uppercase">Tim Kami</h6>
            <h2 class="fw-bold">Wajah Di Balik Layar</h2>
        </div>

        <div class="row g-4 justify-content-center">
            <div class="col-6 col-md-3">
                <div class="team-card text-center">
                    <img src="https://ui-avatars.com/api/?name=Budi&background=4361ee&color=fff" class="team-img mb-3" alt="Foto">
                    <h5 class="fw-bold mb-0">Muhamad Rojali</h5>
                    <p class="text-muted small">NIM: 0110224033</p>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="team-card text-center">
                    <img src="https://ui-avatars.com/api/?name=Siti&background=3f37c9&color=fff" class="team-img mb-3" alt="Foto">
                    <h5 class="fw-bold mb-0">Nama Anggota 2</h5>
                    <p class="text-muted small">NIM: 123456</p>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="team-card text-center">
                    <img src="https://ui-avatars.com/api/?name=Agus&background=4cc9f0&color=fff" class="team-img mb-3" alt="Foto">
                    <h5 class="fw-bold mb-0">Nama Anggota 3</h5>
                    <p class="text-muted small">NIM: 123456</p>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="team-card text-center">
                    <img src="https://ui-avatars.com/api/?name=Dewi&background=f72585&color=fff" class="team-img mb-3" alt="Foto">
                    <h5 class="fw-bold mb-0">Nama Anggota 4</h5>
                    <p class="text-muted small">NIM: 123456</p>
                </div>
            </div>
        </div>
    </section>

    <section class="testimonial-section py-5 mt-5">
        <div class="container py-4">
            <div class="text-center mb-5">
                <h6 class="text-info fw-bold text-uppercase ls-2">Review Pelanggan</h6>
                <h2 class="fw-bold">Apa Kata Mereka?</h2>
            </div>
            
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="testimonial-card h-100">
                        <div class="text-warning mb-3"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i></div>
                        <p class="fst-italic opacity-75">"Cucian numpuk sebulan kelar dalam 2 hari. Wanginya enak banget, gak apek sama sekali."</p>
                        <h6 class="fw-bold mt-4 mb-0">Rizky, Mahasiswa</h6>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="testimonial-card h-100">
                        <div class="text-warning mb-3"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i></div>
                        <p class="fst-italic opacity-75">"Layanan antar jemputnya sangat membantu ibu rumah tangga seperti saya. Kurir ramah!"</p>
                        <h6 class="fw-bold mt-4 mb-0">Ibu Ani, IRT</h6>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="testimonial-card h-100">
                        <div class="text-warning mb-3"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i></div>
                        <p class="fst-italic opacity-75">"Harga bersahabat banget buat anak kos, tapi kualitasnya laundry hotel bintang 5."</p>
                        <h6 class="fw-bold mt-4 mb-0">Dinda, Karyawan</h6>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <jsp:include page="includes/footer.jsp" />   
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>