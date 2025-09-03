package com.myproject.catchtable.service;

import com.myproject.catchtable.mapper.RestaurantMapper;
import com.myproject.catchtable.mapper.UserMapper;
import com.myproject.catchtable.model.Restaurant;
import com.myproject.catchtable.model.Review;
import com.myproject.catchtable.model.User;
import com.myproject.catchtable.model.Category;
import com.myproject.catchtable.model.Menu;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class RestaurantService {
    
    @Autowired
    private RestaurantMapper restaurantMapper;
    @Autowired
    private ReviewService reviewService;
    
    @Autowired
    private UserMapper userMapper;
    
    // 기존 메서드들은 그대로 유지...
    
    // 조회 메서드들
    public Restaurant findById(Integer restaurantId) {
        return restaurantMapper.findById(restaurantId);
    }
    
    public List<Restaurant> findAll() {
        return restaurantMapper.findAll();
    }
    
    public List<Restaurant> findByBusinessUserId(Integer businessUserId) {
        return restaurantMapper.findByBusinessUserId(businessUserId);
    }
    
    public List<Restaurant> findByCategoryId(Integer categoryId) {
        return restaurantMapper.findByCategoryId(categoryId);
    }
    
    // 식당 등록
    public int registerRestaurant(Restaurant restaurant) {
        // 기본값 설정
        if (restaurant.getLikesCount() == null) restaurant.setLikesCount(0);
        if (restaurant.getReservationCount() == null) restaurant.setReservationCount(0);
        if (restaurant.getViewCount() == null) restaurant.setViewCount(0);
        
        return restaurantMapper.insertRestaurant(restaurant);
    }
    
    // 식당 정보 수정
    public int updateRestaurant(Restaurant restaurant) {
        return restaurantMapper.updateRestaurant(restaurant);
    }
    
    // 식당 삭제
    public int deleteRestaurant(Integer restaurantId) {
        return restaurantMapper.deleteRestaurant(restaurantId);
    }
    
    // 카운트 관련 메서드들
    public void incrementViewCount(Integer restaurantId) {
        restaurantMapper.incrementViewCount(restaurantId);
    }
    
    public void incrementLikesCount(Integer restaurantId) {
        restaurantMapper.incrementLikesCount(restaurantId);
    }
    
    public void decrementLikesCount(Integer restaurantId) {
        restaurantMapper.decrementLikesCount(restaurantId);
    }
    
    public void incrementReservationCount(Integer restaurantId) {
        restaurantMapper.incrementReservationCount(restaurantId);
    }
    
    // 검색 메서드들
    public List<Restaurant> searchByName(String name) {
        return restaurantMapper.searchByName(name);
    }
    
    public List<Restaurant> searchByAddress(String address) {
        return restaurantMapper.searchByAddress(address);
    }
    
    public List<Restaurant> findByPriceRange(String priceRange) {
        return restaurantMapper.findByPriceRange(priceRange);
    }
    
    public List<Restaurant> findByCuisineType(String cuisineType) {
        return restaurantMapper.findByCuisineType(cuisineType);
    }
    
    // 정렬된 목록들
    public List<Restaurant> getPopularRestaurants() {
        return restaurantMapper.findAllOrderByLikesDesc();
    }
    
    public List<Restaurant> getTopReservedRestaurants() {
        return restaurantMapper.findAllOrderByReservationDesc();
    }
    
    public List<Restaurant> getMostViewedRestaurants() {
        return restaurantMapper.findAllOrderByViewDesc();
    }
    
    public List<Restaurant> getTopRestaurants(int limit) {
        return restaurantMapper.findTopRestaurants(limit);
    }
    
    // 권한 확인 메서드 
    public boolean isOwner(Integer restaurantId, Integer businessUserId) {
        Restaurant restaurant = findById(restaurantId);
        return restaurant != null && restaurant.getBusinessUserId().equals(businessUserId);
    }
    
    // 사업자 승인 상태 확인 
    public boolean isApprovedBusiness(Integer businessUserId) {
        User user = userMapper.findById(businessUserId);
        return user != null && user.isBusiness() && user.isApproved();
    }
    
    /**
     * 카테고리 목록 조회 (드롭다운용) - CategoryService로 위임
     */
    public List<Category> getAllCategories() {
        return restaurantMapper.findAllCategories();
    }
    
    /**
     * 메뉴 목록 조회
     */
    public List<Menu> getMenusByRestaurantId(Integer restaurantId) {
        return restaurantMapper.findMenusByRestaurantId(restaurantId);
    }
    
    /**
     * 식당 통계 조회
     */
    public Map<String, Object> getRestaurantStatistics(Integer restaurantId) {
        Map<String, Object> stats = new HashMap<>();
        
        Restaurant restaurant = findById(restaurantId);
        if (restaurant != null) {
            stats.put("viewCount", restaurant.getViewCount());
            stats.put("likesCount", restaurant.getLikesCount());
            stats.put("reservationCount", restaurant.getReservationCount());
            stats.put("monthlyReservations", restaurant.getReservationCount() != null ? restaurant.getReservationCount() / 3 : 0);
            
            //  ReviewService로 평점 계산
            try {
                Double avgRating = reviewService.getAverageRating(restaurantId);
                stats.put("averageRating", avgRating != null ? avgRating : 0.0);
            } catch (Exception e) {
                stats.put("averageRating", 0.0);
            }
        }
        
        return stats;
    }
    
    /**
     * 메뉴 추가
     */
    public int addMenu(Menu menu) {
        
        if (menu.getImageUrl() == null || menu.getImageUrl().trim().isEmpty()) {
            menu.setImageUrl("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpPcv7OgCDdn3lSB8nPFeRqybLtlIoM5HXkA&s");
        }
        
        // 기본값 설정
        if (menu.getIsSignature() == null) menu.setIsSignature(false);
        if (menu.getIsAvailable() == null) menu.setIsAvailable(true);
        
        return restaurantMapper.insertMenu(menu);
    }
    
    /**
     * 메뉴 ID로 조회
     */
    public Menu getMenuById(Integer menuId) {
        return restaurantMapper.findMenuById(menuId);
    }

    /**
     * 메뉴 수정
     */
    public int updateMenu(Menu menu) {
        // 이미지 URL이 비어있으면 기본 이미지 설정
        if (menu.getImageUrl() == null || menu.getImageUrl().trim().isEmpty()) {
            menu.setImageUrl("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpPcv7OgCDdn3lSB8nPFeRqybLtlIoM5HXkA&s");
        }
        
        // 기본값 설정
        if (menu.getIsSignature() == null) menu.setIsSignature(false);
        if (menu.getIsAvailable() == null) menu.setIsAvailable(true);
        
        return restaurantMapper.updateMenu(menu);
    }
    
    /**
     * 메뉴 삭제
     */
    public int deleteMenu(Integer menuId) {
        return restaurantMapper.deleteMenu(menuId);
    }
    
    public String getRestaurantName(Integer restaurantId) {
        Restaurant restaurant = restaurantMapper.findById(restaurantId);
        return restaurant != null ? restaurant.getName() : "알 수 없는 레스토랑";
    }
    
    // ================================
    // 🆕 게시판용 추가 메서드들
    // ================================
    
    /**
     * 필터링된 레스토랑 목록 조회 (게시판용)
     */
    public List<Restaurant> getFilteredRestaurants(Map<String, Object> filters) {
        // 페이징 설정
        int page = (Integer) filters.getOrDefault("page", 1);
        int pageSize = (Integer) filters.getOrDefault("pageSize", 12);
        int offset = (page - 1) * pageSize;
        
        filters.put("offset", offset);
        filters.put("limit", pageSize);
        
        return restaurantMapper.findFilteredRestaurants(filters);
    }
    
    /**
     * 필터링된 레스토랑 총 개수 (게시판용)
     */
    public int getFilteredRestaurantCount(Map<String, Object> filters) {
        return restaurantMapper.countFilteredRestaurants(filters);
    }
    
    /**
     * 레스토랑별 리뷰 통계 조회 (게시판용)
     */
    public Map<String, Object> getRestaurantReviewStats(Integer restaurantId) {
        Map<String, Object> stats = new HashMap<>();
        
        try {
            // 평균 평점
            Double avgRating = reviewService.getAverageRating(restaurantId);
            stats.put("averageRating", avgRating != null ? avgRating : 0.0);
            
            // 리뷰 개수
            int reviewCount = reviewService.getReviewCount(restaurantId);
            stats.put("reviewCount", reviewCount);
            
            // 추천 비율 계산 (추천 리뷰 / 전체 리뷰 * 100)
            if (reviewCount > 0) {
                List<Review> recommendedReviews = reviewService.getRecommendedReviews(restaurantId);
                double recommendationRate = (double) recommendedReviews.size() / reviewCount * 100.0;
                stats.put("recommendationRate", Math.round(recommendationRate * 10.0) / 10.0); // 소수점 1자리
            } else {
                stats.put("recommendationRate", 0.0);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            stats.put("averageRating", 0.0);
            stats.put("reviewCount", 0);
            stats.put("recommendationRate", 0.0);
        }
        
        return stats;
    }
    
    /**
     * ID로 레스토랑 조회 (게시판용 - 별칭)
     */
    public Restaurant getRestaurantById(Integer restaurantId) {
        return findById(restaurantId);
    }
    
    /**
     * 인기 레스토랑 조회 (게시판 메인용)
     */
    public List<Restaurant> getFeaturedRestaurants(int limit) {
        return restaurantMapper.findFeaturedRestaurants(limit);
    }
    
    /**
     * 최신 레스토랑 조회 (게시판 메인용)
     */
    public List<Restaurant> getLatestRestaurants(int limit) {
        return restaurantMapper.findLatestRestaurants(limit);
    }
    
    /**
     * 조회수 증가 (게시판 상세보기용)
     */
    public void increaseViewCount(Integer restaurantId) {
        incrementViewCount(restaurantId);
    }
}