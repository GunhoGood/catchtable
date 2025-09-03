package com.myproject.catchtable.model;

import java.time.LocalDateTime;
import java.time.LocalDate;

public class UserCoupon {
    
    private Integer userCouponId;
    private Integer userId;
    private Integer couponId;
    private Boolean isUsed;
    private LocalDateTime usedAt;
    private LocalDateTime createdAt;
    private LocalDate endDate;        // 기존 테이블에 있는 필드
    private Integer usageLimit;       // 기존 테이블에 있는 필드
    
    // 조인을 위한 추가 필드들
    private String couponName;
    private String couponDescription;
    private Integer discountAmount;
    private Integer minOrderAmount;
    private LocalDate startDate;
    private LocalDate couponEndDate;
    
    // 기본 생성자
    public UserCoupon() {}
    
    // 생성자
    public UserCoupon(Integer userId, Integer couponId) {
        this.userId = userId;
        this.couponId = couponId;
        this.isUsed = false;
        this.createdAt = LocalDateTime.now();
    }
    
    // Getter & Setter 메서드들
    public Integer getUserCouponId() {
        return userCouponId;
    }
    
    public void setUserCouponId(Integer userCouponId) {
        this.userCouponId = userCouponId;
    }
    
    public Integer getUserId() {
        return userId;
    }
    
    public void setUserId(Integer userId) {
        this.userId = userId;
    }
    
    public Integer getCouponId() {
        return couponId;
    }
    
    public void setCouponId(Integer couponId) {
        this.couponId = couponId;
    }
    
    public Boolean getIsUsed() {
        return isUsed;
    }
    
    public void setIsUsed(Boolean isUsed) {
        this.isUsed = isUsed;
    }
    
    public LocalDateTime getUsedAt() {
        return usedAt;
    }
    
    public void setUsedAt(LocalDateTime usedAt) {
        this.usedAt = usedAt;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDate getEndDate() {
        return endDate;
    }
    
    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }
    
    public Integer getUsageLimit() {
        return usageLimit;
    }
    
    public void setUsageLimit(Integer usageLimit) {
        this.usageLimit = usageLimit;
    }
    
    public String getCouponName() {
        return couponName;
    }
    
    public void setCouponName(String couponName) {
        this.couponName = couponName;
    }
    
    public String getCouponDescription() {
        return couponDescription;
    }
    
    public void setCouponDescription(String couponDescription) {
        this.couponDescription = couponDescription;
    }
    
    public Integer getDiscountAmount() {
        return discountAmount;
    }
    
    public void setDiscountAmount(Integer discountAmount) {
        this.discountAmount = discountAmount;
    }
    
    public Integer getMinOrderAmount() {
        return minOrderAmount;
    }
    
    public void setMinOrderAmount(Integer minOrderAmount) {
        this.minOrderAmount = minOrderAmount;
    }
    
    public LocalDate getStartDate() {
        return startDate;
    }
    
    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }
    
    public LocalDate getCouponEndDate() {
        return couponEndDate;
    }
    
    public void setCouponEndDate(LocalDate couponEndDate) {
        this.couponEndDate = couponEndDate;
    }
    
    // 편의 메서드들
    
    /**
     * 쿠폰이 만료되었는지 확인
     */
    public boolean isExpired() {
        if (endDate == null) {
            return false;
        }
        return endDate.isBefore(LocalDate.now());
    }
    
    /**
     * 쿠폰 사용 가능 여부 확인
     */
    public boolean isAvailable() {
        return !isUsed && !isExpired();
    }
    
    /**
     * 쿠폰 상태 문자열 반환
     */
    public String getStatusText() {
        if (isUsed) {
            return "사용완료";
        } else if (isExpired()) {
            return "만료됨";
        } else {
            return "사용가능";
        }
    }
    
    @Override
    public String toString() {
        return "UserCoupon{" +
                "userCouponId=" + userCouponId +
                ", userId=" + userId +
                ", couponId=" + couponId +
                ", couponName='" + couponName + '\'' +
                ", isUsed=" + isUsed +
                ", createdAt=" + createdAt +
                ", endDate=" + endDate +
                ", status='" + getStatusText() + '\'' +
                '}';
    }
}