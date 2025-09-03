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
    private LocalDate endDate;        // ���� ���̺� �ִ� �ʵ�
    private Integer usageLimit;       // ���� ���̺� �ִ� �ʵ�
    
    // ������ ���� �߰� �ʵ��
    private String couponName;
    private String couponDescription;
    private Integer discountAmount;
    private Integer minOrderAmount;
    private LocalDate startDate;
    private LocalDate couponEndDate;
    
    // �⺻ ������
    public UserCoupon() {}
    
    // ������
    public UserCoupon(Integer userId, Integer couponId) {
        this.userId = userId;
        this.couponId = couponId;
        this.isUsed = false;
        this.createdAt = LocalDateTime.now();
    }
    
    // Getter & Setter �޼����
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
    
    // ���� �޼����
    
    /**
     * ������ ����Ǿ����� Ȯ��
     */
    public boolean isExpired() {
        if (endDate == null) {
            return false;
        }
        return endDate.isBefore(LocalDate.now());
    }
    
    /**
     * ���� ��� ���� ���� Ȯ��
     */
    public boolean isAvailable() {
        return !isUsed && !isExpired();
    }
    
    /**
     * ���� ���� ���ڿ� ��ȯ
     */
    public String getStatusText() {
        if (isUsed) {
            return "���Ϸ�";
        } else if (isExpired()) {
            return "�����";
        } else {
            return "��밡��";
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