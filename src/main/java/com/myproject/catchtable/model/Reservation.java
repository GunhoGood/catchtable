package com.myproject.catchtable.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Reservation {
    private Integer reservationId;
    private Integer userId;
    private Integer restaurantId;
    private LocalDate reservationDate;
    private String reservationHour;
    private Integer partySize;
    private String specialRequest;
    private Boolean isConfirmed;
    private Boolean isCancelled;
    private Boolean isCompleted;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String restaurantName;    
    private String userName;          
    private String userPhone;         
    private String userEmail;         
    
    // 기본 생성자
    public Reservation() {}
    
    // 필수 정보 생성자
    public Reservation(Integer userId, Integer restaurantId, LocalDate reservationDate, 
                      String reservationHour, Integer partySize) {
        this.userId = userId;
        this.restaurantId = restaurantId;
        this.reservationDate = reservationDate;
        this.reservationHour = reservationHour;
        this.partySize = partySize;
        this.isConfirmed = false;
        this.isCancelled = false;
        this.isCompleted = false;
    }
    
    public Integer getReservationId() {
        return reservationId;
    }
    
    public Integer getUserId() {
        return userId;
    }
    
    public Integer getRestaurantId() {
        return restaurantId;
    }
    
    public LocalDate getReservationDate() {
        return reservationDate;
    }
    
    public String getReservationHour() {
        return reservationHour;
    }
    
    public Integer getPartySize() {
        return partySize;
    }
    
    public String getSpecialRequest() {
        return specialRequest;
    }
    
    public Boolean getIsConfirmed() {
        return isConfirmed;
    }
    
    public Boolean getIsCancelled() {
        return isCancelled;
    }
    
    public Boolean getIsCompleted() {
        return isCompleted;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public String getRestaurantName() {
        return restaurantName;
    }
    
    public String getUserName() {
        return userName;
    }
    
    public String getUserPhone() {
        return userPhone;
    }
    
    public String getUserEmail() {
        return userEmail;
    }
    
    public void setReservationId(Integer reservationId) {
        this.reservationId = reservationId;
    }
    
    public void setUserId(Integer userId) {
        this.userId = userId;
    }
    
    public void setRestaurantId(Integer restaurantId) {
        this.restaurantId = restaurantId;
    }
    
    public void setReservationDate(LocalDate reservationDate) {
        this.reservationDate = reservationDate;
    }
    
    public void setReservationHour(String reservationHour) {
        this.reservationHour = reservationHour;
    }
    
    public void setPartySize(Integer partySize) {
        this.partySize = partySize;
    }
    
    public void setSpecialRequest(String specialRequest) {
        this.specialRequest = specialRequest;
    }
    
    public void setIsConfirmed(Boolean isConfirmed) {
        this.isConfirmed = isConfirmed;
    }
    
    public void setIsCancelled(Boolean isCancelled) {
        this.isCancelled = isCancelled;
    }
    
    public void setIsCompleted(Boolean isCompleted) {
        this.isCompleted = isCompleted;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    
    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
    
    public void setUserPhone(String userPhone) {
        this.userPhone = userPhone;
    }
    
    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }
    
    
    public boolean isPending() {
        return !isConfirmed && !isCancelled;
    }
    
    public boolean canCancel() {
        return !isCancelled && !isCompleted;
    }
    
    public boolean canComplete() {
        return isConfirmed && !isCancelled && !isCompleted;
    }
    
    public String getStatus() {
        if (isCancelled) return "취소됨";
        if (isCompleted) return "방문완료";
        if (isConfirmed) return "예약확정";
        return "승인대기";
    }
    
    //  상세 상태 정보 메서드 (CSS 클래스용)
    public String getStatusClass() {
        if (isCancelled) return "cancelled";
        if (isCompleted) return "completed";
        if (isConfirmed) return "confirmed";
        return "pending";
    }
    
    //  예약자 정보 표시용 메서드
    public String getCustomerInfo() {
        if (userName != null && userPhone != null) {
            return userName + " (" + userPhone + ")";
        } else if (userName != null) {
            return userName;
        } else if (userPhone != null) {
            return userPhone;
        }
        return "정보 없음";
    }
    
    @Override
    public String toString() {
        return "Reservation{" +
                "reservationId=" + reservationId +
                ", userId=" + userId +
                ", restaurantId=" + restaurantId +
                ", restaurantName='" + restaurantName + '\'' +
                ", userName='" + userName + '\'' +
                ", reservationDate=" + reservationDate +
                ", reservationHour='" + reservationHour + '\'' +
                ", partySize=" + partySize +
                ", status='" + getStatus() + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}