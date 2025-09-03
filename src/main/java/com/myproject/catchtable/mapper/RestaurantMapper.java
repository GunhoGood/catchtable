package com.myproject.catchtable.mapper;

import com.myproject.catchtable.model.Category;
import com.myproject.catchtable.model.Menu;
import com.myproject.catchtable.model.Restaurant;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

public interface RestaurantMapper {

	// 식당 조회
	Restaurant findById(Integer restaurantId);

	List<Restaurant> findAll();

	List<Restaurant> findByBusinessUserId(Integer businessUserId);

	List<Restaurant> findByCategoryId(Integer categoryId);

	List<Restaurant> findByPriceRange(String priceRange);

	List<Restaurant> findByCuisineType(String cuisineType);

	// 식당 등록/수정/삭제
	int insertRestaurant(Restaurant restaurant);

	int updateRestaurant(Restaurant restaurant);

	int deleteRestaurant(Integer restaurantId);

	// 카운트 업데이트
	void incrementViewCount(Integer restaurantId);

	void incrementLikesCount(Integer restaurantId);

	void decrementLikesCount(Integer restaurantId);

	void incrementReservationCount(Integer restaurantId);

	// 검색
	List<Restaurant> searchByName(String name);

	List<Restaurant> searchByAddress(String address);

	// 정렬
	List<Restaurant> findAllOrderByLikesDesc();

	List<Restaurant> findAllOrderByReservationDesc();

	List<Restaurant> findAllOrderByViewDesc();

	// 인기 식당
	List<Restaurant> findTopRestaurants(int limit);

	//모든리뷰삭제
	void deleteReviewsByRestaurant(@Param("restaurantId") Integer restaurantId);
	//모든예약삭제 
	void deleteReservationsByRestaurant(@Param("restaurantId") Integer restaurantId);
	//좋아요 삭제 
	void deleteFavoritesByRestaurant(@Param("restaurantId") Integer restaurantId);
	//카테고리 관련 
	List<Category> findAllCategories();
	// 메뉴 관련
	List<Menu> findMenusByRestaurantId(Integer restaurantId);
	int insertMenu(Menu menu);
	int deleteMenu(Integer menuId);
	/**
	 * 메뉴 ID로 조회
	 */
	Menu findMenuById(Integer menuId);

	/**
	 * 메뉴 수정
	 */
	int updateMenu(Menu menu);
	
	/**
	 * 필터링된 레스토랑 목록 조회 (게시판용)
	 */
	List<Restaurant> findFilteredRestaurants(Map<String, Object> filters);

	/**
	 * 필터링된 레스토랑 총 개수 (게시판용)
	 */
	int countFilteredRestaurants(Map<String, Object> filters);

	/**
	 * 추천 레스토랑 조회 (좋아요 + 평점 기준)
	 */
	List<Restaurant> findFeaturedRestaurants(int limit);

	/**
	 * 최신 레스토랑 조회
	 */
	List<Restaurant> findLatestRestaurants(int limit);
}