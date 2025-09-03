package com.myproject.catchtable.model;

import java.time.LocalDateTime;

public class Like {
    private Integer likeId;
    private Integer userId;
    private Integer restaurantId;
    private LocalDateTime createdAt;
    
    // »ý¼ºÀÚ
    public Like() {}
    
    public Like(Integer userId, Integer restaurantId) {
        this.userId = userId;
        this.restaurantId = restaurantId;
        this.createdAt = LocalDateTime.now();
    }
    
    // Getter & Setter
    public Integer getLikeId() {
        return likeId;
    }
    
    public void setLikeId(Integer likeId) {
        this.likeId = likeId;
    }
    
    public Integer getUserId() {
        return userId;
    }
    
    public void setUserId(Integer userId) {
        this.userId = userId;
    }
    
    public Integer getRestaurantId() {
        return restaurantId;
    }
    
    public void setRestaurantId(Integer restaurantId) {
        this.restaurantId = restaurantId;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    @Override
    public String toString() {
        return "Like{" +
                "likeId=" + likeId +
                ", userId=" + userId +
                ", restaurantId=" + restaurantId +
                ", createdAt=" + createdAt +
                '}';
    }
}