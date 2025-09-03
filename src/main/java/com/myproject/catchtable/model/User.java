package com.myproject.catchtable.model;

import java.time.LocalDateTime;

public class User {
    private Integer userId;
    private String email;
    private String password;
    private String name;
    private String phone;
    private String birthDate;
    private String gender;
    private String userType;
    private String approvalStatus;
    private String businessLicenseNumber;
    private String businessLicenseImage;
    private String rejectionReason;
    private Integer reservationCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    

    // 기본 생성자
    public User() {}
    
    // 전체 생성자
    public User(String email, String password, String name, String phone, 
                String birthDate, String gender, String userType) {
        this.email = email;
        this.password = password;
        this.name = name;
        this.phone = phone;
        this.birthDate = birthDate;
        this.gender = gender;
        this.userType = userType;
        this.approvalStatus = "APPROVED"; // 기본값
        this.reservationCount = 0; // 기본값
    }
    
    // Getter 메서드들
    public Integer getUserId() {
        return userId;
    }
    
    public String getEmail() {
        return email;
    }
    
    public String getPassword() {
        return password;
    }
    
    public String getName() {
        return name;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public String getBirthDate() {
        return birthDate;
    }
    
    public String getGender() {
        return gender;
    }
    
    public String getUserType() {
        return userType;
    }
    
    public String getApprovalStatus() {
        return approvalStatus;
    }
    
    public String getBusinessLicenseNumber() {
        return businessLicenseNumber;
    }
    
    public String getBusinessLicenseImage() {
        return businessLicenseImage;
    }
    
    public String getRejectionReason() {
        return rejectionReason;
    }
    
    public Integer getReservationCount() {
        return reservationCount;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    // Setter 메서드들
    public void setUserId(Integer userId) {
        this.userId = userId;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public void setBirthDate(String birthDate) {
        this.birthDate = birthDate;
    }
    
    public void setGender(String gender) {
        this.gender = gender;
    }
    
    public void setUserType(String userType) {
        this.userType = userType;
    }
    
    public void setApprovalStatus(String approvalStatus) {
        this.approvalStatus = approvalStatus;
    }
    
    public void setBusinessLicenseNumber(String businessLicenseNumber) {
        this.businessLicenseNumber = businessLicenseNumber;
    }
    
    public void setBusinessLicenseImage(String businessLicenseImage) {
        this.businessLicenseImage = businessLicenseImage;
    }
    
    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }
    
    public void setReservationCount(Integer reservationCount) {
        this.reservationCount = reservationCount;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    // 편의 메서드들
    public boolean isAdmin() {
        return "ADMIN".equals(this.userType);
    }
    
    public boolean isBusiness() {
        return "BUSINESS".equals(this.userType);
    }
    
    public boolean isUser() {
        return "USER".equals(this.userType);
    }
    
    public boolean isApproved() {
        return "APPROVED".equals(this.approvalStatus);
    }
    
    public boolean isPending() {
        return "PENDING".equals(this.approvalStatus);
    }
    
    public boolean isRejected() {
        return "REJECTED".equals(this.approvalStatus);
    }
    
    // toString 메서드
    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", email='" + email + '\'' +
                ", name='" + name + '\'' +
                ", userType='" + userType + '\'' +
                ", approvalStatus='" + approvalStatus + '\'' +
                ", reservationCount=" + reservationCount +
                ", createdAt=" + createdAt +
                '}';
    }
}