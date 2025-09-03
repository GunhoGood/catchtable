package com.myproject.catchtable.mapper;

import com.myproject.catchtable.model.Review;
import java.util.List;
import java.util.Map;

public interface ReviewMapper {

	// 리뷰 조회
	Review findById(Integer reviewId);

	List<Review> findByUserId(Integer userId);

	List<Review> findByRestaurantId(Integer restaurantId);

	List<Review> findByReservationId(Integer reservationId);

	// 리뷰 등록/수정/삭제
	void insertReview(Review review);

	void updateReview(Review review);

	void deleteReview(Integer reviewId);

	List<Review> findByRestaurantIdWithEmail(Integer restaurantId);

	// 리뷰 통계
	Double getAverageRatingByRestaurantId(Integer restaurantId);

	int countByRestaurantId(Integer restaurantId);

	// 리뷰 목록 (정렬)
	List<Review> findByRestaurantIdOrderByCreatedDesc(Integer restaurantId);

	List<Review> findByRestaurantIdOrderByRatingDesc(Integer restaurantId);

	List<Review> findRecommendedReviews(Integer restaurantId);

	// 최신 리뷰
	List<Review> findRecentReviews(int limit);

	// 식당별 리뷰 목록 조회 (사용자 정보 포함)
	List<Review> findByRestaurantIdWithUserInfo(Integer restaurantId);
	
	// 리뷰 조회  
	List<Map<String, Object>> findByUserIdWithRestaurant(Integer userId);
	
	// 평점별 조회
	List<Review> findByRating(Integer rating);

	List<Review> findHighRatedReviews(Integer restaurantId);

	public Double getOverallAverageRating();

}