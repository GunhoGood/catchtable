package com.myproject.catchtable.mapper;

import com.myproject.catchtable.model.Reservation;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

public interface ReservationMapper {

	// ���� ��ȸ
	Reservation findById(Integer reservationId);

	List<Reservation> findByUserId(Integer userId);

	List<Reservation> findByRestaurantId(Integer restaurantId);

	List<Reservation> findByDate(LocalDate reservationDate);

	List<Reservation> findByRestaurantAndDate(Integer restaurantId, LocalDate reservationDate);
	
	// ���� ���/����/����
	void insertReservation(Reservation reservation);

	void updateReservation(Reservation reservation);

	void deleteReservation(Integer reservationId);

	// ���� ���� ������Ʈ
	int confirmReservation(Integer reservationId);

	int cancelReservation(Integer reservationId);

	int completeReservation(Integer reservationId);

	// ���� ��Ȳ ��ȸ
	List<Reservation> findPendingReservations();

	List<Reservation> findTodayReservations();

	List<Reservation> findUpcomingReservations(Integer userId);

	// �ð��뺰 ���� üũ
	List<String> findBookedHours(@Param("restaurantId") Integer restaurantId, 
            @Param("reservationDate") LocalDate reservationDate);

	// �Ĵ纰 ���� ��� ��ȸ (�ֽż�)
	List<Reservation> findByRestaurantIdOrderByDateDesc(Integer restaurantId);

	// ���
	int countByRestaurantId(Integer restaurantId);

	int countByUserId(Integer userId);
	// ����ڿ� ���� ��ȸ
	List<Reservation> findByBusinessIdWithFilters(@Param("restaurantIds") List<Integer> restaurantIds, 
	                                              @Param("status") String status, 
	                                              @Param("restaurantId") String restaurantId, 
	                                              @Param("date") String date);

	// ���� �޼����
	int countReservationsByRestaurantIds(@Param("restaurantIds") List<Integer> restaurantIds);
	int countReservationsByStatusAndRestaurantIds(@Param("restaurantIds") List<Integer> restaurantIds, @Param("status") String status);
	int countTodayReservationsByRestaurantIds(@Param("restaurantIds") List<Integer> restaurantIds, @Param("today") LocalDate today);

	// ���� ���� (���� ����)
	int cancelReservationWithReason(@Param("reservationId") Integer reservationId, @Param("reason") String reason);
	// �ܰ� ������� ��ȸ
    List<Map<String, Object>> findFavoriteRestaurants(@Param("userId") Integer userId, @Param("minVisits") int minVisits);
    
    public List<Map<String, Object>> debugUserReservations(Integer userId);
}