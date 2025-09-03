package com.myproject.catchtable.model;

public class Category {
    private Integer categoryId;
    private String name;
    private String iconUrl;
    
    // 기본 생성자
    public Category() {}
    
    // 필수 정보 생성자
    public Category(String name, String iconUrl) {
        this.name = name;
        this.iconUrl = iconUrl;
    }
    
    // Getter 메서드들
    public Integer getCategoryId() {
        return categoryId;
    }
    
    public String getName() {
        return name;
    }
    
    public String getIconUrl() {
        return iconUrl;
    }
    
    // Setter 메서드들
    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public void setIconUrl(String iconUrl) {
        this.iconUrl = iconUrl;
    }
    
    // 편의 메서드들
    public boolean hasIcon() {
        return this.iconUrl != null && !this.iconUrl.trim().isEmpty();
    }
    
    @Override
    public String toString() {
        return "Category{" +
                "categoryId=" + categoryId +
                ", name='" + name + '\'' +
                ", iconUrl='" + iconUrl + '\'' +
                '}';
    }
}