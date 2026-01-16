package model;

import java.sql.Timestamp;

public class Order {
    private int orderId;
    private int userId;
    private Timestamp orderDate;
    private double weight;      // SEBELUMNYA 'totalKg', KITA UBAH JADI 'weight'
    private double totalAmount;
    private String status;
    private String notes;
    private String deliveryType;
    private String pickupAddress;
    private String pickupPhone; 
    
    // Join Fields (Variabel Bantuan untuk menampilkan Nama, bukan ID)
    private String userName;
    private int serviceId;
    private String serviceName;

    // ================= GETTERS & SETTERS =================

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Timestamp getOrderDate() { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }

    // --- BAGIAN INI YANG DIPERBAIKI (Weight) ---
    public double getWeight() { return weight; }
    public void setWeight(double weight) { this.weight = weight; }
    
    // (Opsional) Alias untuk jaga-jaga jika ada JSP lama yang panggil totalKg
    public double getTotalKg() { return weight; }
    public void setTotalKg(double weight) { this.weight = weight; }
    // -------------------------------------------

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    
    public String getDeliveryType() { return deliveryType; }
    public void setDeliveryType(String deliveryType) { this.deliveryType = deliveryType; }

    public String getPickupAddress() { return pickupAddress; }
    public void setPickupAddress(String pickupAddress) { this.pickupAddress = pickupAddress; }
    
    public String getPickupPhone() { return pickupPhone; }
    public void setPickupPhone(String pickupPhone) { this.pickupPhone = pickupPhone; }

    // --- Join Fields Getters Setters ---

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    
    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }
}