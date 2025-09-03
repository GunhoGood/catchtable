package com.myproject.catchtable.mapper;

import com.myproject.catchtable.model.Reservation;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

public interface ReservationMapper {

	// 예약 조회
	Reservation findById(Integer reservationId);

	List<Reservation> findByUserId(Integer userId);

	List<Reservation> findByRestaurantId(Integer restaurantId);

	List<Reservation> findByDate(LocalDate reservationDate);

	List<Reservation> findByRestaurantAndDate(Integer restaurantId, LocalDate reservationDate);
	
	// 예약 등록/수정/삭제
	void insertReservation(Reservation reservation);

	void updateReservation(Reservation reservation);

	void deleteReservation(Integer reservationId);

	// 예약 상태 업데이트
	int confirmReservation(Integer reservationId);

	int cancelReservation(Integer reservationId);

	int completeReservation(Integer reservationId);

	// 예약 현황 조회
	List<Reservation> findPendingReservations();

	List<Reservation> findTodayReservations();

	List<Reservation> findUpcomingReservations(Integer userId);

	// 시간대별 예약 체크
	List<String> findBookedHours(@Param("restaurantId") Integer restaurantId, 
            @Param("reservationDate") LocalDate reservationDate);

	// 식당별 예약 목록 조회 (최신순)
	List<Reservation> findByRestaurantIdOrderByDateDesc(Integer restaurantId);

	// 통계
	int countByRestaurantId(Integer restaurantId);

	int countByUserId(Integer userId);
	// 사업자용 예약 조회
	List<Reservation> findByBusinessIdWithFilters(@Param("restaurantIds") List<Integer> restaurantIds, 
	                                              @Param("status") String status, 
	                                              @Param("restaurantId") String restaurantId, 
	                                              @Param("date") String date);

	// 통계용 메서드들
	int countReservationsByRestaurantIds(@Param("restaurantIds") List<Integer> restaurantIds);
	int countReservationsByStatusAndRestaurantIds(@Param("restaurantIds") List<Integer> restaurantIds, @Param("status") String status);
	int countTodayReservationsByRestaurantIds(@Param("restaurantIds") List<Integer> restaurantIds, @Param("today") LocalDate today);

	// 상태 변경 (사유 포함)
	int cancelReservationWithReason(@Param("reservationId") Integer reservationId, @Param("reason") String reason);
	// 단골 레스토랑 조회
    List<Map<String, Object>> findFavoriteRestaurants(@Param("userId") Integer userId, @Param("minVisits") int minVisits);
    
    public List<Map<String, Object>> debugUserReservations(Integer userId);
}