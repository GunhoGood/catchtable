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

	// ���� ��ȸ
	public Review findById(Integer reviewId) {
		return reviewMapper.findById(reviewId);
	}

	public List<Review> findByUserId(Integer userId) {
		return reviewMapper.findByUserId(userId);
	}

	public List<Review> findByRestaurantId(Integer restaurantId) {
		return reviewMapper.findByRestaurantId(restaurantId);
	}

	// ���� �ۼ�
	public void createReview(Review review) {
		// ����� ���� Ȯ��
		User user = userMapper.findById(review.getUserId());
		if (user == null) {
			throw new RuntimeException("�������� �ʴ� ������Դϴ�.");
		}

		// �Ĵ� ���� Ȯ��
		Restaurant restaurant = restaurantMapper.findById(review.getRestaurantId());
		if (restaurant == null) {
			throw new RuntimeException("�������� �ʴ� �Ĵ��Դϴ�.");
		}

		// ���� Ȯ�� (���� ID�� �ִ� ���)
		if (review.getReservationId() != null) {
			Reservation reservation = reservationMapper.findById(review.getReservationId());
			if (reservation == null) {
				throw new RuntimeException("�������� �ʴ� �����Դϴ�.");
			}

			// ������ �������� Ȯ��
			if (!reservation.getUserId().equals(review.getUserId())) {
				throw new RuntimeException("������ ���࿡ ���ؼ��� ���並 �ۼ��� �� �ֽ��ϴ�.");
			}

			// �Ϸ�� �������� Ȯ��
			if (!reservation.getIsCompleted()) {
				throw new RuntimeException("�Ϸ�� ���࿡ ���ؼ��� ���並 �ۼ��� �� �ֽ��ϴ�.");
			}

			// �̹� ���䰡 �ִ��� Ȯ��
			List<Review> existingReviews = reviewMapper.findByReservationId(review.getReservationId());
			if (!existingReviews.isEmpty()) {
				throw new RuntimeException("�̹� ���䰡 �ۼ��� �����Դϴ�.");
			}
		}

		// ���� ��ȿ�� �˻�
		if (review.getRating() < 1 || review.getRating() > 5) {
			throw new RuntimeException("������ 1-5 ������ ���̾�� �մϴ�.");
		}

		// �⺻�� ����
		if (review.getIsRecommended() == null) {
			review.setIsRecommended(true);
		}

		reviewMapper.insertReview(review);
	}

	// ���� ����
	public void updateReview(Review review, Integer userId) {
		Review existingReview = reviewMapper.findById(review.getReviewId());
		if (existingReview == null) {
			throw new RuntimeException("�������� �ʴ� �����Դϴ�.");
		}

		// ���� Ȯ�� (���� ���丸 ���� ����)
		if (!existingReview.getUserId().equals(userId)) {
			throw new RuntimeException("������ ���丸 ������ �� �ֽ��ϴ�.");
		}

		// ���� ��ȿ�� �˻�
		if (review.getRating() < 1 || review.getRating() > 5) {
			throw new RuntimeException("������ 1-5 ������ ���̾�� �մϴ�.");
		}

		reviewMapper.updateReview(review);
	}

	// ���� ����
	public void deleteReview(Integer reviewId, Integer userId) {
		Review review = reviewMapper.findById(reviewId);
		if (review == null) {
			throw new RuntimeException("�������� �ʴ� �����Դϴ�.");
		}

		// ���� Ȯ��
		if (!review.getUserId().equals(userId)) {
			throw new RuntimeException("������ ���丸 ������ �� �ֽ��ϴ�.");
		}

		reviewMapper.deleteReview(reviewId);
	}

	// �Ĵ� ���� ���
	public Double getAverageRating(Integer restaurantId) {
		return reviewMapper.getAverageRatingByRestaurantId(restaurantId);
	}

	public int getReviewCount(Integer restaurantId) {
		return reviewMapper.countByRestaurantId(restaurantId);
	}

	public Double getOverallAverageRating() {
	    return reviewMapper.getOverallAverageRating();
	}
	
	// ���ĵ� ���� ���
	public List<Review> getReviewsByRestaurantOrderByDate(Integer restaurantId) {
		return reviewMapper.findByRestaurantIdOrderByCreatedDesc(restaurantId);
	}

	public List<Review> getReviewsByRestaurantOrderByRating(Integer restaurantId) {
		return reviewMapper.findByRestaurantIdOrderByRatingDesc(restaurantId);
	}

	public List<Review> getRecommendedReviews(Integer restaurantId) {
		return reviewMapper.findRecommendedReviews(restaurantId);
	}

	// �ֽ� ����
	public List<Review> getRecentReviews(int limit) {
		return reviewMapper.findRecentReviews(limit);
	}

	// ���� ���� ����
	public List<Review> getHighRatedReviews(Integer restaurantId) {
		return reviewMapper.findHighRatedReviews(restaurantId);
	}

	// ������ ����
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
	 * ����ڰ� Ư�� �Ĵ翡 ���� �̹� ���並 �ۼ��ߴ��� Ȯ��
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
	 * Ư�� ���࿡ ���� ���䰡 �ۼ��Ǿ����� Ȯ��
	 */
	public boolean hasReviewForReservation(Integer reservationId) {
	    if (reservationId == null) {
	        return false;
	    }
	    
	    List<Review> reviews = reviewMapper.findByReservationId(reservationId);
	    return !reviews.isEmpty();
	}
	/**
	 * �Ĵ纰 ���� ��� ��ȸ (�����ڿ�)
	 */
	public List<Review> getReviewsByRestaurant(Integer restaurantId) {
	    // �Ĵ� ���� Ȯ��
	    Restaurant restaurant = restaurantMapper.findById(restaurantId);
	    if (restaurant == null) {
	        throw new RuntimeException("�������� �ʴ� �Ĵ��Դϴ�.");
	    }
	    
	    return reviewMapper.findByRestaurantIdWithUserInfo(restaurantId);
	}
}