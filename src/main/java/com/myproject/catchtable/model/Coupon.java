package com.myproject.catchtable.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Coupon {
    private Integer couponId;
    private String name;
    private String description;
    private Integer discountAmount;
    private Integer minOrderAmount;
    private Integer requiredReservationCount;
    private LocalDate startDate;
    private LocalDate endDate;
    private Integer usageLimit;
    private LocalDateTime createdAt;
    
    // 기본 생성자
    public Coupon() {}
    
    // 필수 정보 생성자
    public Coupon(String name, Integer discountAmount, LocalDate startDate, LocalDate endDate) {
        this.name = name;
        this.discountAmount = discountAmount;
        this.startDate = startDate;
        this.endDate = endDate;
        this.minOrderAmount = 0;
        this.requiredReservationCount = 0;
    }
    
    // Getter 메서드들
    public Integer getCouponId() {
        return couponId;
    }
    
    public String getName() {
        return name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public Integer getDiscountAmount() {
        return discountAmount;
    }
    
    public Integer getMinOrderAmount() {
        return minOrderAmount;
    }
    
    public Integer getRequiredReservationCount() {
        return requiredReservationCount;
    }
    
    public LocalDate getStartDate() {
        return startDate;
    }
    
    public LocalDate getEndDate() {
        return endDate;
    }
    
    public Integer getUsageLimit() {
        return usageLimit;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    // Setter 메서드들
    public void setCouponId(Integer couponId) {
        this.couponId = couponId;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public void setDiscountAmount(Integer discountAmount) {
        this.discountAmount = discountAmount;
    }
    
    public void setMinOrderAmount(Integer minOrderAmount) {
        this.minOrderAmount = minOrderAmount;
    }
    
    public void setRequiredReservationCount(Integer requiredReservationCount) {
        this.requiredReservationCount = requiredReservationCount;
    }
    
    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }
    
    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }
    
    public void setUsageLimit(Integer usageLimit) {
        this.usageLimit = usageLimit;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    // 편의 메서드들
    public boolean isActive() {
        LocalDate now = LocalDate.now();
        return (startDate == null || !now.isBefore(startDate)) && 
               (endDate == null || !now.isAfter(endDate));
    }
    
    public String getDiscountFormatted() {
        return String.format("%,d원 할인", this.discountAmount);
    }
    
    @Override
    public String toString() {
        return "Coupon{" +
                "couponId=" + couponId +
                ", name='" + name + '\'' +
                ", discountAmount=" + discountAmount +
                ", requiredReservationCount=" + requiredReservationCount +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                '}';
    }
}