package com.myproject.catchtable.service;

import com.myproject.catchtable.mapper.ReservationMapper;
import com.myproject.catchtable.mapper.RestaurantMapper;
import com.myproject.catchtable.mapper.UserMapper;
import com.myproject.catchtable.model.Reservation;
import com.myproject.catchtable.model.Restaurant;
import com.myproject.catchtable.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.ArrayList;
import java.util.Arrays;

@Service
@Transactional
public class ReservationService {

	@Autowired
	private ReservationMapper reservationMapper;

	@Autowired
	private UserMapper userMapper;

	@Autowired
	private RestaurantMapper restaurantMapper;

	@Autowired
	private CouponService couponService;

	// 예약 조회
	public Reservation findById(Integer reservationId) {
		return reservationMapper.findById(reservationId);
	}

	public List<Reservation> findByUserId(Integer userId) {
		return reservationMapper.findByUserId(userId);
	}

	public List<Reservation> findByRestaurantId(Integer restaurantId) {
		return reservationMapper.findByRestaurantId(restaurantId);
	}

	// 예약 생성
	public void createReservation(Reservation reservation) {
		// 사용자 존재 확인
		User user = userMapper.findById(reservation.getUserId());
		if (user == null) {
			throw new RuntimeException("존재하지 않는 사용자입니다.");
		}

		// 식당 존재 확인
		Restaurant restaurant = restaurantMapper.findById(reservation.getRestaurantId());
		if (restaurant == null) {
			throw new RuntimeException("존재하지 않는 식당입니다.");
		}

		// 시간 중복 체크
		List<String> bookedHours = reservationMapper.findBookedHours(reservation.getRestaurantId(),
				reservation.getReservationDate());

		if (bookedHours.contains(reservation.getReservationHour())) {
			throw new RuntimeException("이미 예약된 시간입니다.");
		}

		// 기본값 설정
		reservation.setIsConfirmed(false);
		reservation.setIsCancelled(false);
		reservation.setIsCompleted(false);

		reservationMapper.insertReservation(reservation);
	}

	// 예약 수정
	public void updateReservation(Reservation reservation, Integer userId) {
		Reservation existingReservation = reservationMapper.findById(reservation.getReservationId());
		if (existingReservation == null) {
			throw new RuntimeException("존재하지 않는 예약입니다.");
		}

		// 권한 확인 (본인 예약만 수정 가능)
		if (!existingReservation.getUserId().equals(userId)) {
			throw new RuntimeException("본인의 예약만 수정할 수 있습니다.");
		}

		// 취소되거나 완료된 예약은 수정 불가
		if (existingReservation.getIsCancelled() || existingReservation.getIsCompleted()) {
			throw new RuntimeException("취소되거나 완료된 예약은 수정할 수 없습니다.");
		}

		reservationMapper.updateReservation(reservation);
	}

	// 예약 확정 (사업자)
	public void confirmReservation(Integer reservationId, Integer businessUserId) {
		Reservation reservation = reservationMapper.findById(reservationId);
		if (reservation == null) {
			throw new RuntimeException("존재하지 않는 예약입니다.");
		}

		// 권한 확인 (해당 식당의 사업자만 확정 가능)
		Restaurant restaurant = restaurantMapper.findById(reservation.getRestaurantId());
		if (!restaurant.getBusinessUserId().equals(businessUserId)) {
			throw new RuntimeException("해당 식당의 사업자만 예약을 확정할 수 있습니다.");
		}

		reservationMapper.confirmReservation(reservationId);
	}

	// 예약 취소
	public void cancelReservation(Integer reservationId, Integer userId) {
		Reservation reservation = reservationMapper.findById(reservationId);
		if (reservation == null) {
			throw new RuntimeException("존재하지 않는 예약입니다.");
		}

		// 권한 확인
		if (!reservation.getUserId().equals(userId)) {
			throw new RuntimeException("본인의 예약만 취소할 수 있습니다.");
		}

		// 이미 취소되었거나 완료된 예약은 취소 불가
		if (reservation.getIsCancelled() || reservation.getIsCompleted()) {
			throw new RuntimeException("이미 취소되었거나 완료된 예약입니다.");
		}

		reservationMapper.cancelReservation(reservationId);
	}

	// 예약 완료 처리 - 자동 쿠폰 발급 로직 추가
	public void completeReservation(Integer reservationId, Integer businessUserId) {
		Reservation reservation = reservationMapper.findById(reservationId);
		if (reservation == null) {
			throw new RuntimeException("존재하지 않는 예약입니다.");
		}

		// 권한 확인
		Restaurant restaurant = restaurantMapper.findById(reservation.getRestaurantId());
		if (!restaurant.getBusinessUserId().equals(businessUserId)) {
			throw new RuntimeException("해당 식당의 사업자만 예약을 완료 처리할 수 있습니다.");
		}

		// 확정된 예약만 완료 처리 가능
		if (!reservation.getIsConfirmed()) {
			throw new RuntimeException("확정된 예약만 완료 처리할 수 있습니다.");
		}

		// 예약 완료 처리
		reservationMapper.completeReservation(reservationId);

		// 카운트 증가 (메서드가 존재한다면)
		try {
			userMapper.incrementReservationCount(reservation.getUserId());
			restaurantMapper.incrementReservationCount(reservation.getRestaurantId());
		} catch (Exception e) {
			System.out.println("카운트 증가 실패 (메서드가 없을 수 있음): " + e.getMessage());
		}

		// 자동 쿠폰 발급 시스템 실행
		try {
			issueAutoCoupons(reservation.getUserId());
		} catch (Exception e) {
			// 쿠폰 발급 실패해도 예약 완료는 유지 (로그만 남김)
			System.out.println("자동 쿠폰 발급 실패 - 사용자 ID: " + reservation.getUserId() + ", 사유: " + e.getMessage());
		}
	}

	// 자동 쿠폰 발급 메서드
	private void issueAutoCoupons(Integer userId) {
		// 사용자 정보 조회
		User user = userMapper.findById(userId);
		if (user == null)
			return;

		// reservation_count가 User 테이블에 있는지 확인 필요
		Integer currentReservationCount = 0;
		try {
			currentReservationCount = user.getReservationCount();
			if (currentReservationCount == null) {
				currentReservationCount = 0;
			}
		} catch (Exception e) {
			// reservation_count 필드가 없을 수 있음
			System.out.println("예약 횟수 조회 실패, 기본값 0 사용: " + e.getMessage());
		}

		System.out.println("자동 쿠폰 발급 체크 - 사용자: " + user.getName() + ", 현재 예약 횟수: " + currentReservationCount);

		// 발급 기준별 쿠폰 처리
		if (currentReservationCount == 1) {
			// 첫 방문 쿠폰
			couponService.issueWelcomeCoupon(userId);
			System.out.println("첫 방문 쿠폰 발급! - " + user.getName());

		} else if (currentReservationCount == 5) {
			// 5회 방문 쿠폰 (메서드가 있다면)
			try {
				couponService.issueVisitCountCoupon(userId, 5);
				System.out.println("5회 방문 쿠폰 발급! - " + user.getName());
			} catch (Exception e) {
				System.out.println("5회 방문 쿠폰 발급 실패: " + e.getMessage());
			}

		} else if (currentReservationCount == 10) {
			// 10회 방문 VIP 쿠폰
			try {
				couponService.issueVisitCountCoupon(userId, 10);
				System.out.println("10회 방문 VIP 쿠폰 발급! - " + user.getName());
			} catch (Exception e) {
				System.out.println("10회 방문 쿠폰 발급 실패: " + e.getMessage());
			}

		} else if (currentReservationCount == 20) {
			// 20회 방문 플래티넘 쿠폰
			try {
				couponService.issueVisitCountCoupon(userId, 20);
				System.out.println("20회 방문 플래티넘 쿠폰 발급! - " + user.getName());
			} catch (Exception e) {
				System.out.println("20회 방문 쿠폰 발급 실패: " + e.getMessage());
			}
		}

		// 특별 이벤트 쿠폰 (매 10회마다) - 메서드가 있다면
		if (currentReservationCount > 10 && currentReservationCount % 10 == 0) {
			try {
				couponService.issueSpecialEventCoupon(userId, currentReservationCount);
				System.out.println(currentReservationCount + "회 특별 이벤트 쿠폰 발급! - " + user.getName());
			} catch (Exception e) {
				System.out.println("특별 이벤트 쿠폰 발급 실패: " + e.getMessage());
			}
		}
	}

	// 예약 현황 조회
	public List<Reservation> getPendingReservations() {
		return reservationMapper.findPendingReservations();
	}

	public List<Reservation> getTodayReservations() {
		return reservationMapper.findTodayReservations();
	}

	public List<Reservation> getUpcomingReservations(Integer userId) {
		return reservationMapper.findUpcomingReservations(userId);
	}

	// 예약 가능 시간 조회
	public List<String> getAvailableHours(Integer restaurantId, LocalDate date) {
		List<String> bookedHours = reservationMapper.findBookedHours(restaurantId, date);
		List<String> allHours = Arrays.asList("17시", "18시", "19시", "20시", "21시");

		return allHours.stream().filter(hour -> !bookedHours.contains(hour)).collect(Collectors.toList());
	}

	// 사용자별 예약 통계 조회
	public ReservationStats getUserReservationStats(Integer userId) {
		User user = userMapper.findById(userId);
		if (user == null) {
			throw new RuntimeException("존재하지 않는 사용자입니다.");
		}

		List<Reservation> userReservations = reservationMapper.findByUserId(userId);

		// 통계 계산
		long totalReservations = userReservations.size();
		long completedReservations = userReservations.stream().filter(r -> r.getIsCompleted()).count();
		long cancelledReservations = userReservations.stream().filter(r -> r.getIsCancelled()).count();

		return new ReservationStats(totalReservations, completedReservations, cancelledReservations);
	}

	// 예약 통계 내부 클래스
	public static class ReservationStats {
		private long totalReservations;
		private long completedReservations;
		private long cancelledReservations;

		public ReservationStats(long total, long completed, long cancelled) {
			this.totalReservations = total;
			this.completedReservations = completed;
			this.cancelledReservations = cancelled;
		}

		// Getters
		public long getTotalReservations() {
			return totalReservations;
		}

		public long getCompletedReservations() {
			return completedReservations;
		}

		public long getCancelledReservations() {
			return cancelledReservations;
		}

		public double getCompletionRate() {
			return totalReservations > 0 ? (double) completedReservations / totalReservations * 100 : 0;
		}
	}

	// ======================================
	// 관리자용 추가 메서드들
	// ======================================

	/**
	 * 식당별 예약 목록 조회 (관리자용 - 최신순)
	 */
	public List<Reservation> getReservationsByRestaurant(Integer restaurantId) {
		// 식당 존재 확인
		Restaurant restaurant = restaurantMapper.findById(restaurantId);
		if (restaurant == null) {
			throw new RuntimeException("존재하지 않는 식당입니다.");
		}

		return reservationMapper.findByRestaurantIdOrderByDateDesc(restaurantId);
	}

	/**
	 * 예약 상태 업데이트 (관리자용)
	 */
	public void updateReservationStatus(Integer reservationId, String status) {
		// 예약 존재 확인
		Reservation reservation = reservationMapper.findById(reservationId);
		if (reservation == null) {
			throw new RuntimeException("존재하지 않는 예약입니다: " + reservationId);
		}

		// 상태 유효성 검사
		if (!isValidStatus(status)) {
			throw new RuntimeException("유효하지 않은 예약 상태입니다: " + status);
		}

		// 상태에 따른 처리
		switch (status) {
		case "CONFIRMED":
			reservationMapper.confirmReservation(reservationId);
			break;
		case "CANCELLED":
			reservationMapper.cancelReservation(reservationId);
			break;
		case "COMPLETED":
			reservationMapper.completeReservation(reservationId);

			// 완료 처리 시 카운트 증가 및 쿠폰 발급
			try {
				userMapper.incrementReservationCount(reservation.getUserId());
				restaurantMapper.incrementReservationCount(reservation.getRestaurantId());
				issueAutoCoupons(reservation.getUserId());
			} catch (Exception e) {
				System.out.println("완료 처리 후 부가 작업 실패: " + e.getMessage());
			}
			break;
		default:
			throw new RuntimeException("처리할 수 없는 상태입니다: " + status);
		}
	}

	/**
	 * 예약 상태 유효성 검사
	 */
	private boolean isValidStatus(String status) {
		return status != null && (status.equals("PENDING") || status.equals("CONFIRMED") || status.equals("CANCELLED")
				|| status.equals("COMPLETED"));
	}
	
	/**
	 * 사업자별 예약 목록 조회 (필터 적용)
	 */
	public List<Reservation> getReservationsByBusinessId(Integer businessUserId, String status, String restaurantId, String date) {
	    try {
	        // 사업자의 모든 식당 ID 조회
	        List<Restaurant> restaurants = restaurantMapper.findByBusinessUserId(businessUserId);
	        List<Integer> restaurantIds = restaurants.stream()
	            .map(Restaurant::getRestaurantId)
	            .collect(Collectors.toList());
	        
	        if (restaurantIds.isEmpty()) {
	            return new ArrayList<>();
	        }
	        
	        return reservationMapper.findByBusinessIdWithFilters(restaurantIds, status, restaurantId, date);
	        
	    } catch (Exception e) {
	        System.err.println("사업자 예약 조회 오류: " + e.getMessage());
	        return new ArrayList<>();
	    }
	}

	/**
	 * 예약 상태 변경 (사유 포함)
	 */
	public int updateReservationStatus(Integer reservationId, String status, String reason) {
	    try {
	        Reservation reservation = reservationMapper.findById(reservationId);
	        if (reservation == null) {
	            throw new RuntimeException("존재하지 않는 예약입니다.");
	        }
	        
	        // 상태별 처리
	        switch (status) {
	            case "CONFIRMED":
	                return reservationMapper.confirmReservation(reservationId);
	            case "CANCELLED":
	                return reservationMapper.cancelReservationWithReason(reservationId, reason);
	            case "COMPLETED":
	                int result = reservationMapper.completeReservation(reservationId);
	                if (result > 0) {
	                    // 완료 처리 후 추가 작업
	                    try {
	                        userMapper.incrementReservationCount(reservation.getUserId());
	                        restaurantMapper.incrementReservationCount(reservation.getRestaurantId());
	                        issueAutoCoupons(reservation.getUserId());
	                    } catch (Exception e) {
	                        System.out.println("완료 처리 후 부가 작업 실패: " + e.getMessage());
	                    }
	                }
	                return result;
	            default:
	                throw new RuntimeException("유효하지 않은 상태: " + status);
	        }
	        
	    } catch (Exception e) {
	        System.err.println("예약 상태 변경 오류: " + e.getMessage());
	        return 0;
	    }
	}

	/**
	 * 사업자별 총 예약 수
	 */
	public int getTotalReservationCount(Integer businessUserId) {
	    try {
	        List<Restaurant> restaurants = restaurantMapper.findByBusinessUserId(businessUserId);
	        List<Integer> restaurantIds = restaurants.stream()
	            .map(Restaurant::getRestaurantId)
	            .collect(Collectors.toList());
	        
	        if (restaurantIds.isEmpty()) {
	            return 0;
	        }
	        
	        return reservationMapper.countReservationsByRestaurantIds(restaurantIds);
	        
	    } catch (Exception e) {
	        System.err.println("총 예약 수 조회 오류: " + e.getMessage());
	        return 0;
	    }
	}

	/**
	 * 사업자별 상태별 예약 수
	 */
	public int getReservationCountByStatus(Integer businessUserId, String status) {
	    try {
	        List<Restaurant> restaurants = restaurantMapper.findByBusinessUserId(businessUserId);
	        List<Integer> restaurantIds = restaurants.stream()
	            .map(Restaurant::getRestaurantId)
	            .collect(Collectors.toList());
	        
	        if (restaurantIds.isEmpty()) {
	            return 0;
	        }
	        
	        return reservationMapper.countReservationsByStatusAndRestaurantIds(restaurantIds, status);
	        
	    } catch (Exception e) {
	        System.err.println("상태별 예약 수 조회 오류: " + e.getMessage());
	        return 0;
	    }
	}

	/**
	 * 사업자별 오늘 예약 수
	 */
	public int getTodayReservationCount(Integer businessUserId) {
	    try {
	        List<Restaurant> restaurants = restaurantMapper.findByBusinessUserId(businessUserId);
	        List<Integer> restaurantIds = restaurants.stream()
	            .map(Restaurant::getRestaurantId)
	            .collect(Collectors.toList());
	        
	        if (restaurantIds.isEmpty()) {
	            return 0;
	        }
	        
	        LocalDate today = LocalDate.now();
	        return reservationMapper.countTodayReservationsByRestaurantIds(restaurantIds, today);
	        
	    } catch (Exception e) {
	        System.err.println("오늘 예약 수 조회 오류: " + e.getMessage());
	        return 0;
	    }
	}
	
	/**
	 * 특정 식당의 총 예약 수 조회
	 */
	public int getReservationCountByRestaurant(Integer restaurantId) {
	    try {
	        return reservationMapper.countByRestaurantId(restaurantId);
	    } catch (Exception e) {
	        System.err.println("식당별 예약 수 조회 오류 - 식당ID: " + restaurantId + ", 오류: " + e.getMessage());
	        return 0;
	    }
	}
	/**
	 * 사용자의 단골 레스토랑 조회 (최소 방문 횟수 이상)
	 */
	public List<Map<String, Object>> getFavoriteRestaurants(Integer userId, int minVisits) {
	    if (userId == null) {
	        return new ArrayList<>();
	    }
	    return reservationMapper.findFavoriteRestaurants(userId, minVisits);
	}

	/**
	 * 디버깅용: 사용자의 모든 예약 상태 조회
	 */
	public List<Map<String, Object>> debugUserReservations(Integer userId) {
	    if (userId == null) {
	        return new ArrayList<>();
	    }
	    return reservationMapper.debugUserReservations(userId);
	}
}