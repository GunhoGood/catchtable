package com.myproject.catchtable.model;

import java.time.LocalDateTime;

public class UserPreferences {
    private Integer userId;
    private String preferredCuisineTypes;  // ��ȣ ���� ����
    private String preferredPriceRange;    // ��ȣ ���ݴ�
    private String preferredArea;          // ��ȣ ����
    private LocalDateTime createdAt;
    
    // �⺻ ������
    public UserPreferences() {}
    
    // �ʼ� ���� ������
    public UserPreferences(Integer userId, String preferredCuisineTypes, 
                          String preferredPriceRange, String preferredArea) {
        this.userId = userId;
        this.preferredCuisineTypes = preferredCuisineTypes;
        this.preferredPriceRange = preferredPriceRange;
        this.preferredArea = preferredArea;
    }
    
    // Getter �޼����
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
    
    // Setter �޼����
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