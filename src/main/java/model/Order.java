package model;

import java.sql.Timestamp;

public class Order {
    // --- FIELD UTAMA (Sesuai Tabel Database) ---
    private int orderId;
    private int userId;
    private int serviceId; 
    private double totalKg;
    private double totalAmount;
    private String status;
    private String notes;
    private Timestamp orderDate;
    private String pickupAddress;
    private String pickupPhone;
    private String deliveryType;

    // --- FIELD TAMBAHAN (PENTING UNTUK ADMIN) ---
    // Variabel ini tidak disimpan di tabel 'orders', tapi diisi
    // lewat query JOIN di OrderDAO agar bisa tampil di Dashboard.
    private String userName;     // Untuk menyimpan nama user (dari tabel users)
    private String serviceName;  // Untuk menyimpan nama layanan (dari tabel services)

    public Order() {} 

    // --- GETTER & SETTER LAMA ---
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public double getTotalKg() { return totalKg; }
    public void setTotalKg(double totalKg) { this.totalKg = totalKg; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Timestamp getOrderDate() { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }
    
    public String getDeliveryType() { return deliveryType; }
    public void setDeliveryType(String deliveryType) { this.deliveryType = deliveryType; }
    
    public String getPickupAddress() { return pickupAddress; }
    public void setPickupAddress(String pickupAddress) { this.pickupAddress = pickupAddress; }

    public String getPickupPhone() { return pickupPhone; }
    public void setPickupPhone(String pickupPhone) { this.pickupPhone = pickupPhone; }

    // --- GETTER & SETTER BARU (WAJIB DITAMBAHKAN) ---
    
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }
}