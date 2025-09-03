package com.myproject.catchtable.mapper;

import com.myproject.catchtable.model.Category;
import com.myproject.catchtable.model.Menu;
import com.myproject.catchtable.model.Restaurant;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

public interface RestaurantMapper {

	// �Ĵ� ��ȸ
	Restaurant findById(Integer restaurantId);

	List<Restaurant> findAll();

	List<Restaurant> findByBusinessUserId(Integer businessUserId);

	List<Restaurant> findByCategoryId(Integer categoryId);

	List<Restaurant> findByPriceRange(String priceRange);

	List<Restaurant> findByCuisineType(String cuisineType);

	// �Ĵ� ���/����/����
	int insertRestaurant(Restaurant restaurant);

	int updateRestaurant(Restaurant restaurant);

	int deleteRestaurant(Integer restaurantId);

	// ī��Ʈ ������Ʈ
	void incrementViewCount(Integer restaurantId);

	void incrementLikesCount(Integer restaurantId);

	void decrementLikesCount(Integer restaurantId);

	void incrementReservationCount(Integer restaurantId);

	// �˻�
	List<Restaurant> searchByName(String name);

	List<Restaurant> searchByAddress(String address);

	// ����
	List<Restaurant> findAllOrderByLikesDesc();

	List<Restaurant> findAllOrderByReservationDesc();

	List<Restaurant> findAllOrderByViewDesc();

	// �α� �Ĵ�
	List<Restaurant> findTopRestaurants(int limit);

	//��縮�����
	void deleteReviewsByRestaurant(@Param("restaurantId") Integer restaurantId);
	//��翹����� 
	void deleteReservationsByRestaurant(@Param("restaurantId") Integer restaurantId);
	//���ƿ� ���� 
	void deleteFavoritesByRestaurant(@Param("restaurantId") Integer restaurantId);
	//ī�װ� ���� 
	List<Category> findAllCategories();
	// �޴� ����
	List<Menu> findMenusByRestaurantId(Integer restaurantId);
	int insertMenu(Menu menu);
	int deleteMenu(Integer menuId);
	/**
	 * �޴� ID�� ��ȸ
	 */
	Menu findMenuById(Integer menuId);

	/**
	 * �޴� ����
	 */
	int updateMenu(Menu menu);
	
	/**
	 * ���͸��� ������� ��� ��ȸ (�Խ��ǿ�)
	 */
	List<Restaurant> findFilteredRestaurants(Map<String, Object> filters);

	/**
	 * ���͸��� ������� �� ���� (�Խ��ǿ�)
	 */
	int countFilteredRestaurants(Map<String, Object> filters);

	/**
	 * ��õ ������� ��ȸ (���ƿ� + ���� ����)
	 */
	List<Restaurant> findFeaturedRestaurants(int limit);

	/**
	 * �ֽ� ������� ��ȸ
	 */
	List<Restaurant> findLatestRestaurants(int limit);
}