package com.myproject.catchtable.model;

import java.time.LocalDateTime;

public class Review {
	private Integer reviewId;
	private Integer userId;
	private Integer restaurantId;
	private Integer reservationId;
	private Integer rating;
	private String content;
	private String imageUrl;
	private Boolean isRecommended;
	private LocalDateTime createdAt;
	private LocalDateTime updatedAt;
	private String email;

	// 기본 생성자
	public Review() {
	}

	// 필수 정보 생성자
	public Review(Integer userId, Integer restaurantId, Integer rating, String content) {
		this.userId = userId;
		this.restaurantId = restaurantId;
		this.rating = rating;
		this.content = content;
		this.isRecommended = true; // 기본값
	}

	// Getter 메서드들

	public String getEmail() {
		return email;
	}
	
	public void setEmail(String email) {
		this.email = email;
	}
	public Integer getReviewId() {
		return reviewId;
	}


	public Integer getUserId() {
		return userId;
	}

	public Integer getRestaurantId() {
		return restaurantId;
	}

	public Integer getReservationId() {
		return reservationId;
	}

	public Integer getRating() {
		return rating;
	}

	public String getContent() {
		return content;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public Boolean getIsRecommended() {
		return isRecommended;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public LocalDateTime getUpdatedAt() {
		return updatedAt;
	}

	// Setter 메서드들
	public void setReviewId(Integer reviewId) {
		this.reviewId = reviewId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
	}

	public void setRestaurantId(Integer restaurantId) {
		this.restaurantId = restaurantId;
	}

	public void setReservationId(Integer reservationId) {
		this.reservationId = reservationId;
	}

	public void setRating(Integer rating) {
		if (rating >= 1 && rating <= 5) {
			this.rating = rating;
		} else {
			throw new IllegalArgumentException("평점은 1-5 사이의 값이어야 합니다.");
		}
	}

	public void setContent(String content) {
		this.content = content;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public void setIsRecommended(Boolean isRecommended) {
		this.isRecommended = isRecommended;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	public void setUpdatedAt(LocalDateTime updatedAt) {
		this.updatedAt = updatedAt;
	}

	// 편의 메서드들
	public boolean hasImage() {
		return this.imageUrl != null && !this.imageUrl.trim().isEmpty();
	}

	public boolean isHighRating() {
		return this.rating != null && this.rating >= 4;
	}

	public boolean isLowRating() {
		return this.rating != null && this.rating <= 2;
	}

	public String getRatingStars() {
		if (rating == null)
			return "☆☆☆☆☆";

		StringBuilder stars = new StringBuilder();
		for (int i = 1; i <= 5; i++) {
			stars.append(i <= rating ? "★" : "☆");
		}
		return stars.toString();
	}

	@Override
	public String toString() {
		return "Review{" + "reviewId=" + reviewId + ", userId=" + userId + ", restaurantId=" + restaurantId
				+ ", rating=" + rating + ", content='" + content + '\'' + ", isRecommended=" + isRecommended
				+ ", createdAt=" + createdAt + '}';
	}
}