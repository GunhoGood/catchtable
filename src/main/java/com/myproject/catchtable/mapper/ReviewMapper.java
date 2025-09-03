package com.myproject.catchtable.mapper;

import com.myproject.catchtable.model.Review;
import java.util.List;
import java.util.Map;

public interface ReviewMapper {

	// ���� ��ȸ
	Review findById(Integer reviewId);

	List<Review> findByUserId(Integer userId);

	List<Review> findByRestaurantId(Integer restaurantId);

	List<Review> findByReservationId(Integer reservationId);

	// ���� ���/����/����
	void insertReview(Review review);

	void updateReview(Review review);

	void deleteReview(Integer reviewId);

	List<Review> findByRestaurantIdWithEmail(Integer restaurantId);

	// ���� ���
	Double getAverageRatingByRestaurantId(Integer restaurantId);

	int countByRestaurantId(Integer restaurantId);

	// ���� ��� (����)
	List<Review> findByRestaurantIdOrderByCreatedDesc(Integer restaurantId);

	List<Review> findByRestaurantIdOrderByRatingDesc(Integer restaurantId);

	List<Review> findRecommendedReviews(Integer restaurantId);

	// �ֽ� ����
	List<Review> findRecentReviews(int limit);

	// �Ĵ纰 ���� ��� ��ȸ (����� ���� ����)
	List<Review> findByRestaurantIdWithUserInfo(Integer restaurantId);
	
	// ���� ��ȸ  
	List<Map<String, Object>> findByUserIdWithRestaurant(Integer userId);
	
	// ������ ��ȸ
	List<Review> findByRating(Integer rating);

	List<Review> findHighRatedReviews(Integer restaurantId);

	public Double getOverallAverageRating();

}