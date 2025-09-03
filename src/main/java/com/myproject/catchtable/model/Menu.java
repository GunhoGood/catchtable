package com.myproject.catchtable.model;

public class Menu {
    private Integer menuId;
    private Integer restaurantId;
    private String name;
    private String description;
    private Integer price;
    private String category;
    private String imageUrl;
    private Boolean isSignature;
    private Boolean isAvailable;
    
    // 기본 생성자
    public Menu() {}
    
    // 필수 정보 생성자
    public Menu(Integer restaurantId, String name, Integer price) {
        this.restaurantId = restaurantId;
        this.name = name;
        this.price = price;
        this.isSignature = false;
        this.isAvailable = true;
    }
    
    // Getter 메서드들
    public Integer getMenuId() {
        return menuId;
    }
    
    public Integer getRestaurantId() {
        return restaurantId;
    }
    
    public String getName() {
        return name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public Integer getPrice() {
        return price;
    }
    
    public String getCategory() {
        return category;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public Boolean getIsSignature() {
        return isSignature;
    }
    
    public Boolean getIsAvailable() {
        return isAvailable;
    }
    
    // Setter 메서드들
    public void setMenuId(Integer menuId) {
        this.menuId = menuId;
    }
    
    public void setRestaurantId(Integer restaurantId) {
        this.restaurantId = restaurantId;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public void setPrice(Integer price) {
        this.price = price;
    }
    
    public void setCategory(String category) {
        this.category = category;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public void setIsSignature(Boolean isSignature) {
        this.isSignature = isSignature;
    }
    
    public void setIsAvailable(Boolean isAvailable) {
        this.isAvailable = isAvailable;
    }
    
    // 편의 메서드들
    public boolean hasImage() {
        return this.imageUrl != null && !this.imageUrl.trim().isEmpty();
    }
    
    public String getPriceFormatted() {
        return String.format("%,d원", this.price);
    }
    
    @Override
    public String toString() {
        return "Menu{" +
                "menuId=" + menuId +
                ", restaurantId=" + restaurantId +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", category='" + category + '\'' +
                ", isSignature=" + isSignature +
                ", isAvailable=" + isAvailable +
                '}';
    }
}