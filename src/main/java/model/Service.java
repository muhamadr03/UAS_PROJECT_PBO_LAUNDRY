package model;

public class Service {
    private int id;
    private String name;
    private double price;
    private int estimatedDays; // <--- INI WAJIB ADA
    private String unit;
    private String description;

    // --- GETTER & SETTER ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    
    // --- INI METHOD YANG DICARI OLEH ERROR ANDA ---
    public int getEstimatedDays() { return estimatedDays; }
    public void setEstimatedDays(int estimatedDays) { this.estimatedDays = estimatedDays; }
    // ----------------------------------------------
    
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}