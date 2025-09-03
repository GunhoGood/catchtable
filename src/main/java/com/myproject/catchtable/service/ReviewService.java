package com.myproject.catchtable.service;

import com.myproject.catchtable.mapper.ReviewMapper;
import com.myproject.catchtable.mapper.ReservationMapper;
import com.myproject.catchtable.mapper.RestaurantMapper;
import com.myproject.catchtable.mapper.UserMapper;
import com.myproject.catchtable.model.Review;
import com.myproject.catchtable.model.Reservation;
import com.myproject.catchtable.model.Restaurant;
import com.myproject.catchtable.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class ReviewService {

	@Autowired
	private ReviewMapper reviewMapper;

	@Autowired
	private UserMapper userMapper;

	@Autowired
	private RestaurantMapper restaurantMapper;

	@Autowired
	private ReservationMapper reservationMapper;

	// 리뷰 조회
	public Review findById(Integer reviewId) {
		return reviewMapper.findById(reviewId);
	}

	public List<Review> findByUserId(Integer userId) {
		return reviewMapper.findByUserId(userId);
	}

	public List<Review> findByRestaurantId(Integer restaurantId) {
		return reviewMapper.findByRestaurantId(restaurantId);
	}

	// 리뷰 작성
	public void createReview(Review review) {
		// 사용자 존재 확인
		User user = userMapper.findById(review.getUserId());
		if (user == null) {
			throw new RuntimeException("존재하지 않는 사용자입니다.");
		}

		// 식당 존재 확인
		Restaurant restaurant = restaurantMapper.findById(review.getRestaurantId());
		if (restaurant == null) {
			throw new RuntimeException("존재하지 않는 식당입니다.");
		}

		// 예약 확인 (예약 ID가 있는 경우)
		if (review.getReservationId() != null) {
			Reservation reservation = reservationMapper.findById(review.getReservationId());
			if (reservation == null) {
				throw new RuntimeException("존재하지 않는 예약입니다.");
			}

			// 본인의 예약인지 확인
			if (!reservation.getUserId().equals(review.getUserId())) {
				throw new RuntimeException("본인의 예약에 대해서만 리뷰를 작성할 수 있습니다.");
			}

			// 완료된 예약인지 확인
			if (!reservation.getIsCompleted()) {
				throw new RuntimeException("완료된 예약에 대해서만 리뷰를 작성할 수 있습니다.");
			}

			// 이미 리뷰가 있는지 확인
			List<Review> existingReviews = reviewMapper.findByReservationId(review.getReservationId());
			if (!existingReviews.isEmpty()) {
				throw new RuntimeException("이미 리뷰가 작성된 예약입니다.");
			}
		}

		// 평점 유효성 검사
		if (review.getRating() < 1 || review.getRating() > 5) {
			throw new RuntimeException("평점은 1-5 사이의 값이어야 합니다.");
		}

		// 기본값 설정
		if (review.getIsRecommended() == null) {
			review.setIsRecommended(true);
		}

		reviewMapper.insertReview(review);
	}

	// 리뷰 수정
	public void updateReview(Review review, Integer userId) {
		Review existingReview = reviewMapper.findById(review.getReviewId());
		if (existingReview == null) {
			throw new RuntimeException("존재하지 않는 리뷰입니다.");
		}

		// 권한 확인 (본인 리뷰만 수정 가능)
		if (!existingReview.getUserId().equals(userId)) {
			throw new RuntimeException("본인의 리뷰만 수정할 수 있습니다.");
		}

		// 평점 유효성 검사
		if (review.getRating() < 1 || review.getRating() > 5) {
			throw new RuntimeException("평점은 1-5 사이의 값이어야 합니다.");
		}

		reviewMapper.updateReview(review);
	}

	// 리뷰 삭제
	public void deleteReview(Integer reviewId, Integer userId) {
		Review review = reviewMapper.findById(reviewId);
		if (review == null) {
			throw new RuntimeException("존재하지 않는 리뷰입니다.");
		}

		// 권한 확인
		if (!review.getUserId().equals(userId)) {
			throw new RuntimeException("본인의 리뷰만 삭제할 수 있습니다.");
		}

		reviewMapper.deleteReview(reviewId);
	}

	// 식당 평점 통계
	public Double getAverageRating(Integer restaurantId) {
		return reviewMapper.getAverageRatingByRestaurantId(restaurantId);
	}

	public int getReviewCount(Integer restaurantId) {
		return reviewMapper.countByRestaurantId(restaurantId);
	}

	public Double getOverallAverageRating() {
	    return reviewMapper.getOverallAverageRating();
	}
	
	// 정렬된 리뷰 목록
	public List<Review> getReviewsByRestaurantOrderByDate(Integer restaurantId) {
		return reviewMapper.findByRestaurantIdOrderByCreatedDesc(restaurantId);
	}

	public List<Review> getReviewsByRestaurantOrderByRating(Integer restaurantId) {
		return reviewMapper.findByRestaurantIdOrderByRatingDesc(restaurantId);
	}

	public List<Review> getRecommendedReviews(Integer restaurantId) {
		return reviewMapper.findRecommendedReviews(restaurantId);
	}

	// 최신 리뷰
	public List<Review> getRecentReviews(int limit) {
		return reviewMapper.findRecentReviews(limit);
	}

	// 높은 평점 리뷰
	public List<Review> getHighRatedReviews(Integer restaurantId) {
		return reviewMapper.findHighRatedReviews(restaurantId);
	}

	// 평점별 리뷰
	public List<Review> getReviewsByRating(Integer rating) {
		return reviewMapper.findByRating(rating);
	}
	public List<Review> findByRestaurantIdWithEmail(Integer restaurantId) {
	    return reviewMapper.findByRestaurantIdWithEmail(restaurantId);
	}
	
	public List<Map<String, Object>> findByUserIdWithRestaurant(Integer userId) {
	    return reviewMapper.findByUserIdWithRestaurant(userId);
	}


	public void updateReview(Review review) {
	    reviewMapper.updateReview(review);
	}
	
	/**
	 * 사용자가 특정 식당에 대해 이미 리뷰를 작성했는지 확인
	 */
	public boolean hasUserReviewedRestaurant(Integer userId, Integer restaurantId) {
	    if (userId == null || restaurantId == null) {
	        return false;
	    }
	    
	    List<Review> userReviews = reviewMapper.findByUserId(userId);
	    return userReviews.stream()
	        .anyMatch(review -> review.getRestaurantId().equals(restaurantId));
	}
	/**
	 * 특정 예약에 대한 리뷰가 작성되었는지 확인
	 */
	public boolean hasReviewForReservation(Integer reservationId) {
	    if (reservationId == null) {
	        return false;
	    }
	    
	    List<Review> reviews = reviewMapper.findByReservationId(reservationId);
	    return !reviews.isEmpty();
	}
	/**
	 * 식당별 리뷰 목록 조회 (관리자용)
	 */
	public List<Review> getReviewsByRestaurant(Integer restaurantId) {
	    // 식당 존재 확인
	    Restaurant restaurant = restaurantMapper.findById(restaurantId);
	    if (restaurant == null) {
	        throw new RuntimeException("존재하지 않는 식당입니다.");
	    }
	    
	    return reviewMapper.findByRestaurantIdWithUserInfo(restaurantId);
	}
}