package com.myproject.catchtable.model;

import java.time.LocalDateTime;
import java.util.List;

public class Restaurant {
    private Integer restaurantId;
    private Integer businessUserId;
    private String name;
    private String description;
    private Integer categoryId;
    private String cuisineType;
    private String address;
    private String phone;
    private String operatingHours;
    private String priceRange; 
    private Integer likesCount;
    private Integer reservationCount;
    private Integer viewCount;
    private String imageUrl;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<Review> reviews;
    private Double averageRating;
    private Integer reviewCount;
    
    //  게시판용 추가 필드
    private Boolean likedByCurrentUser; // 현재 사용자가 좋아요했는지 여부
    
    // 기본 생성자
    public Restaurant() {}
    
    // 필수 정보 생성자
    public Restaurant(Integer businessUserId, String name, String address, 
                     Integer categoryId, String cuisineType, String priceRange) {
        this.businessUserId = businessUserId;
        this.name = name;
        this.address = address;
        this.categoryId = categoryId;
        this.cuisineType = cuisineType;
        this.priceRange = priceRange;
        this.likesCount = 0;
        this.reservationCount = 0;
        this.viewCount = 0;
        this.likedByCurrentUser = false; 
    }
    
    
    public Integer getRestaurantId() {
        return restaurantId;
    }
    
    public Integer getBusinessUserId() {
        return businessUserId;
    }
    
    public String getName() {
        return name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public Integer getCategoryId() {
        return categoryId;
    }
    
    public String getCuisineType() {
        return cuisineType;
    }
    
    public String getAddress() {
        return address;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public String getOperatingHours() {
        return operatingHours;
    }
    
    public String getPriceRange() {
        return priceRange;
    }
    
    public Integer getLikesCount() {
        return likesCount;
    }
    
    public Integer getReservationCount() {
        return reservationCount;
    }
    
    public Integer getViewCount() {
        return viewCount;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public List<Review> getReviews() {
        return reviews;
    }
    
    //  좋아요 여부 Getter
    public Boolean getLikedByCurrentUser() {
        return likedByCurrentUser;
    }
    
    public Boolean isLikedByCurrentUser() {
        return likedByCurrentUser != null ? likedByCurrentUser : false;
    }
    
   
    public void setRestaurantId(Integer restaurantId) {
        this.restaurantId = restaurantId;
    }
    
    public void setBusinessUserId(Integer businessUserId) {
        this.businessUserId = businessUserId;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }
    
    public void setCuisineType(String cuisineType) {
        this.cuisineType = cuisineType;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public void setOperatingHours(String operatingHours) {
        this.operatingHours = operatingHours;
    }
    
    public void setPriceRange(String priceRange) {
        this.priceRange = priceRange;
    }
    
    public void setLikesCount(Integer likesCount) {
        this.likesCount = likesCount;
    }
    
    public void setReservationCount(Integer reservationCount) {
        this.reservationCount = reservationCount;
    }
    
    public void setViewCount(Integer viewCount) {
        this.viewCount = viewCount;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public void setReviews(List<Review> reviews) {
        this.reviews = reviews;
    }
    
    // 좋아요 여부 Setter
    public void setLikedByCurrentUser(Boolean likedByCurrentUser) {
        this.likedByCurrentUser = likedByCurrentUser;
    }
    
    //  편의 메서드
    public boolean hasImage() {
        return this.imageUrl != null && !this.imageUrl.trim().isEmpty();
    }
    
    public boolean isPopular() {
        return this.likesCount > 10 || this.reservationCount > 20;
    }
    
    // 가격대 관련 편의 메서드
    public boolean isLowPriceRange() {
        if (priceRange == null) return false;
        String price = priceRange.toLowerCase();
        return price.contains("1만") || price.contains("만원 이하") || 
               (price.matches(".*[0-9]+,?[0-9]*원.*") && 
                price.matches(".*[1-9][0-9]{3}원.*")); // 1만원대
    }
    
    public boolean isHighPriceRange() {
        if (priceRange == null) return false;
        String price = priceRange.toLowerCase();
        return price.contains("5만") || price.contains("10만") || 
               price.contains("코스") || price.contains("고급");
    }
    
    public boolean isMediumPriceRange() {
        return !isLowPriceRange() && !isHighPriceRange();
    }
    
    // 조회수 증가 메서드
    public void incrementViewCount() {
        this.viewCount = (this.viewCount == null) ? 1 : this.viewCount + 1;
    }
    
    // 좋아요 수 증가/감소 메서드
    public void incrementLikesCount() {
        this.likesCount = (this.likesCount == null) ? 1 : this.likesCount + 1;
    }
    
    public void decrementLikesCount() {
        this.likesCount = (this.likesCount == null || this.likesCount <= 0) ? 0 : this.likesCount - 1;
    }
    
    // 예약 수 증가 메서드
    public void incrementReservationCount() {
        this.reservationCount = (this.reservationCount == null) ? 1 : this.reservationCount + 1;
    }
    
    // 리뷰 관련 편의 메서드
    public boolean hasReviews() {
        return this.reviews != null && !this.reviews.isEmpty();
    }
    
    public Integer getReviewCount() {
        // 설정된 reviewCount가 있으면 그것을 반환
        if (this.reviewCount != null) {
            return this.reviewCount;
        }
        // 없으면 reviews 배열 크기 반환
        return this.reviews != null ? this.reviews.size() : 0;
    }
    
    public Double getAverageRating() {
        // 설정된 averageRating이 있으면 그것을 반환 (캐시된 값)
        if (this.averageRating != null) {
            return this.averageRating;
        }
        
        // 없으면 reviews에서 실시간 계산
        if (this.reviews != null && !this.reviews.isEmpty()) {
            double sum = 0.0;
            int validReviews = 0;
            for (Review review : this.reviews) {
                if (review.getRating() != null) {
                    sum += review.getRating();
                    validReviews++;
                }
            }
            return validReviews > 0 ? sum / validReviews : 0.0;
        }
        
        return 0.0;
    }
    
    public void setAverageRating(Double averageRating) {
        this.averageRating = averageRating;
    }

    public void setReviewCount(Integer reviewCount) {
        this.reviewCount = reviewCount;
    }
    
    // toString 메서드
    @Override
    public String toString() {
        return "Restaurant{" +
                "restaurantId=" + restaurantId +
                ", businessUserId=" + businessUserId +
                ", name='" + name + '\'' +
                ", cuisineType='" + cuisineType + '\'' +
                ", address='" + address + '\'' +
                ", priceRange='" + priceRange + '\'' +
                ", likesCount=" + likesCount +
                ", reservationCount=" + reservationCount +
                ", viewCount=" + viewCount +
                ", reviewCount=" + getReviewCount() +
                ", likedByCurrentUser=" + likedByCurrentUser +
                ", createdAt=" + createdAt +
                '}';
    }
}