package model;

public class Service {
    private int id;
    private String name;
    private double price; 
    private int duration;
    
    private String unit; 

    public Service() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
}