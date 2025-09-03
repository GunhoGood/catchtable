package com.myproject.catchtable.model;

import java.time.LocalDateTime;

public class UserPreferences {
    private Integer userId;
    private String preferredCuisineTypes;  // 선호 음식 종류
    private String preferredPriceRange;    // 선호 가격대
    private String preferredArea;          // 선호 지역
    private LocalDateTime createdAt;
    
    // 기본 생성자
    public UserPreferences() {}
    
    // 필수 정보 생성자
    public UserPreferences(Integer userId, String preferredCuisineTypes, 
                          String preferredPriceRange, String preferredArea) {
        this.userId = userId;
        this.preferredCuisineTypes = preferredCuisineTypes;
        this.preferredPriceRange = preferredPriceRange;
        this.preferredArea = preferredArea;
    }
    
    // Getter 메서드들
    public Integer getUserId() {
        return userId;
    }
    
    public String getPreferredCuisineTypes() {
        return preferredCuisineTypes;
    }
    
    public String getPreferredPriceRange() {
        return preferredPriceRange;
    }
    
    public String getPreferredArea() {
        return preferredArea;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    // Setter 메서드들
    public void setUserId(Integer userId) {
        this.userId = userId;
    }
    
    public void setPreferredCuisineTypes(String preferredCuisineTypes) {
        this.preferredCuisineTypes = preferredCuisineTypes;
    }
    
    public void setPreferredPriceRange(String preferredPriceRange) {
        this.preferredPriceRange = preferredPriceRange;
    }
    
    public void setPreferredArea(String preferredArea) {
        this.preferredArea = preferredArea;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    @Override
    public String toString() {
        return "UserPreferences{" +
                "userId=" + userId +
                ", preferredCuisineTypes='" + preferredCuisineTypes + '\'' +
                ", preferredPriceRange='" + preferredPriceRange + '\'' +
                ", preferredArea='" + preferredArea + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}