package com.myproject.catchtable.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.myproject.catchtable.model.Category;
import com.myproject.catchtable.model.Menu;
import com.myproject.catchtable.model.Reservation;
import com.myproject.catchtable.model.Restaurant;
import com.myproject.catchtable.model.Review;
import com.myproject.catchtable.model.User;
import com.myproject.catchtable.model.UserCoupon;
import com.myproject.catchtable.service.CategoryService;
import com.myproject.catchtable.service.CouponService;
import com.myproject.catchtable.service.LikeService;
import com.myproject.catchtable.service.ReservationService;
import com.myproject.catchtable.service.RestaurantService;
import com.myproject.catchtable.service.ReviewService;
import com.myproject.catchtable.service.UserService;

@Controller
@RequestMapping("/board")
public class BoardController {

    @Autowired
    private RestaurantService restaurantService;
    
    @Autowired
    private CouponService couponService;
    
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private CategoryService categoryService;
    
    @Autowired
    private LikeService likeService;
    
    @Autowired
    private ReviewService reviewService;
    
    
    @Autowired
    private ReservationService reservationService;
    /**
     * 레스토랑 게시판 메인 페이지
     */
    @GetMapping("/restaurants")
    public String restaurantBoard(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "latest") String sort,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String price,
            @RequestParam(required = false) String location,
            @RequestParam(required = false) String search,
            Model model) {
        
        try {
            // 카테고리 목록 조회
            List<Category> categories = categoryService.findAll();
            
            // 필터 조건 설정
            Map<String, Object> filters = new HashMap<>();
            filters.put("page", page);
            filters.put("sort", sort);
            filters.put("category", category);
            filters.put("price", price);
            filters.put("location", location);
            filters.put("search", search);
            
            // 레스토랑 목록 조회 
            List<Restaurant> restaurants = restaurantService.getFilteredRestaurants(filters);
            
            // 각 레스토랑에 평점 정보 추가
            for (Restaurant restaurant : restaurants) {
                try {
                    Map<String, Object> reviewStats = restaurantService.getRestaurantReviewStats(restaurant.getRestaurantId());
                    restaurant.setAverageRating((Double) reviewStats.get("averageRating"));
                    restaurant.setReviewCount((Integer) reviewStats.get("reviewCount"));
                } catch (Exception e) {
                    restaurant.setAverageRating(0.0);
                    restaurant.setReviewCount(0);
                }
            }
            
            // 총 개수 조회
            int totalCount = restaurantService.getFilteredRestaurantCount(filters);
            
            // 모델에 데이터 추가
            model.addAttribute("restaurants", restaurants);
            model.addAttribute("categories", categories);
            model.addAttribute("totalCount", totalCount);
            model.addAttribute("currentPage", page);
            model.addAttribute("currentSort", sort);
            model.addAttribute("selectedCategory", category);
            model.addAttribute("selectedPrice", price);
            model.addAttribute("selectedLocation", location);
            model.addAttribute("searchKeyword", search);
            
            return "board";
            
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "페이지를 불러오는 중 오류가 발생했습니다.");
            model.addAttribute("restaurants", new ArrayList<>());
            model.addAttribute("categories", new ArrayList<>());
            model.addAttribute("totalCount", 0);
            return "board";
        }
    }
    
    /**
     * AJAX - 필터링된 레스토랑 목록 조회
     */
    @GetMapping("/api/restaurants")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getRestaurants(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "latest") String sort,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String price,
            @RequestParam(required = false) String location,
            @RequestParam(required = false) String search,
            HttpSession session) {
        
        try {
            // 필터 조건 설정
            Map<String, Object> filters = new HashMap<>();
            filters.put("page", page);
            filters.put("sort", sort);
            filters.put("category", category);
            filters.put("price", price);
            filters.put("location", location);
            filters.put("search", search);
            filters.put("pageSize", 12); // 페이지당 12개씩
            
            // 레스토랑 목록 조회
            List<Restaurant> restaurants = restaurantService.getFilteredRestaurants(filters);
            
            // 총 개수 조회
            int totalCount = restaurantService.getFilteredRestaurantCount(filters);
            
            // 총 페이지 수 계산
            int totalPages = (int) Math.ceil((double) totalCount / 12);
            
            // 사용자 좋아요 정보 추가 (로그인한 경우)
            User currentUser = (User) session.getAttribute("user");
            if (currentUser != null) {
                for (Restaurant restaurant : restaurants) {
                    boolean isLiked = likeService.isUserLikedRestaurant(currentUser.getUserId(), restaurant.getRestaurantId());
                    restaurant.setLikedByCurrentUser(isLiked);
                }
            }
            
            // 각 레스토랑에 평점 정보 추가
            for (Restaurant restaurant : restaurants) {
                try {
                    Map<String, Object> reviewStats = restaurantService.getRestaurantReviewStats(restaurant.getRestaurantId());
                    restaurant.setAverageRating((Double) reviewStats.get("averageRating"));
                    restaurant.setReviewCount((Integer) reviewStats.get("reviewCount"));
                } catch (Exception e) {
                    restaurant.setAverageRating(0.0);
                    restaurant.setReviewCount(0);
                }
            }
            
            // 페이지네이션 정보
            Map<String, Object> pagination = new HashMap<>();
            pagination.put("currentPage", page);
            pagination.put("totalPages", totalPages);
            pagination.put("hasPrev", page > 1);
            pagination.put("hasNext", page < totalPages);
            
            // 응답 데이터 구성
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("restaurants", restaurants);
            response.put("totalCount", totalCount);
            response.put("pagination", pagination);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "레스토랑 목록을 불러오는 중 오류가 발생했습니다.");
            return ResponseEntity.status(500).body(errorResponse);
        }
    }
    
    /**
     * AJAX - 좋아요 추가/취소 통합
     */
    @PostMapping("/api/restaurants/{restaurantId}/like")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggleLike(
            @PathVariable Integer restaurantId,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            // 로그인 확인
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.badRequest().body(response);
            }
            
            // 좋아요 토글 (추가/취소)
            boolean isLiked = likeService.toggleLike(currentUser.getUserId(), restaurantId);
            
            // 업데이트된 좋아요 개수 조회
            int likesCount = likeService.getRestaurantLikesCount(restaurantId);
            
            response.put("success", true);
            response.put("isLiked", isLiked);
            response.put("message", isLiked ? "좋아요가 추가되었습니다." : "좋아요가 취소되었습니다.");
            response.put("likesCount", likesCount);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "좋아요 처리 중 오류가 발생했습니다.");
            return ResponseEntity.status(500).body(response);
        }
    }
    
    /**
     * 고객용 레스토랑 상세보기
     */
    @GetMapping("/restaurants/{restaurantId}")
    public String restaurantDetail(@PathVariable Integer restaurantId, Model model, HttpSession session) {
        try {
            // 레스토랑 정보 조회
            Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
            if (restaurant == null) {
                model.addAttribute("error", "레스토랑을 찾을 수 없습니다.");
                return "error/404";
            }
            //조회수 
            restaurantService.incrementViewCount(restaurantId);
            // 사용자 좋아요 여부 확인
            User currentUser = (User) session.getAttribute("user");
            if (currentUser != null) {
                boolean isLiked = likeService.isUserLikedRestaurant(currentUser.getUserId(), restaurantId);
                model.addAttribute("isLiked", isLiked);
            }
            
            // 카테고리 정보 조회
            Category category = categoryService.findById(restaurant.getCategoryId());
            
            // 리뷰 정보 조회
            Map<String, Object> reviewStats = restaurantService.getRestaurantReviewStats(restaurantId);
            
            // 메뉴 정보 조회
            List<Menu> menus = restaurantService.getMenusByRestaurantId(restaurantId);
            
            model.addAttribute("restaurant", restaurant);
            model.addAttribute("category", category);
            model.addAttribute("reviewStats", reviewStats);
            model.addAttribute("menus", menus);
            
            return "customer-detail";  
            
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "페이지를 불러오는 중 오류가 발생했습니다.");
            return "board";
        }
    }
    /**
     * 레스토랑 리뷰 페이지
     */
    @GetMapping("/restaurants/{restaurantId}/reviews")
    public String restaurantReviews(@PathVariable Integer restaurantId, Model model) {
        try {
            // 레스토랑 정보 조회
            Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
            if (restaurant == null) {
                model.addAttribute("error", "레스토랑을 찾을 수 없습니다.");
                return "error/404";
            }
            
            // 리뷰 목록 조회
            List<Review> reviews = reviewService.getReviewsByRestaurant(restaurantId);
         // 각 리뷰에 사용자 이메일 정보 추가
         for (Review review : reviews) {
             User user = userService.findById(review.getUserId()); // 또는 userMapper.findById()
             if (user != null) {
                 review.setEmail(user.getEmail());
             }
         }
            
            // 리뷰 통계 조회
            Map<String, Object> reviewStats = restaurantService.getRestaurantReviewStats(restaurantId);
            
            model.addAttribute("restaurant", restaurant);
            model.addAttribute("reviews", reviews);
            model.addAttribute("reviewStats", reviewStats);
            
            return "restaurant-reviews";
            
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "페이지를 불러오는 중 오류가 발생했습니다.");
            return "customer-detail";
        }
    }
    /**
     * 레스토랑 예약 페이지
     */
    @GetMapping("/restaurants/{restaurantId}/reservation")
    public String reservationPage(@PathVariable Integer restaurantId, Model model, HttpSession session) {
        try {
            // 로그인 확인
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                return "redirect:/auth/login";
            }
            
            // 레스토랑 정보 조회
            Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
            if (restaurant == null) {
                model.addAttribute("error", "레스토랑을 찾을 수 없습니다.");
                return "error/404";
            }
            
            // 조회수 증가
            restaurantService.incrementViewCount(restaurantId);
            
            // 사용 가능한 쿠폰 목록 추가
            List<UserCoupon> availableCoupons = couponService.findAvailableUserCoupons(currentUser.getUserId());
            
            model.addAttribute("restaurant", restaurant);
            model.addAttribute("user", currentUser);
            model.addAttribute("availableCoupons", availableCoupons); // 쿠폰 목록 추가
            
            return "reservation-form";
            
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "페이지를 불러오는 중 오류가 발생했습니다.");
            return "board";
        }
    }
    /**
     * 예약 처리 (POST)
     */
    @PostMapping("/restaurants/{restaurantId}/reservation")
    public String processReservation(
           @PathVariable Integer restaurantId,
           @RequestParam String reservationDate,
           @RequestParam String reservationHour,
           @RequestParam Integer partySize,
           @RequestParam(required = false) String specialRequest,
           @RequestParam(required = false) Integer selectedCouponId,
           Model model,
           HttpSession session) {
       
       try {
           // 로그인 확인
           User currentUser = (User) session.getAttribute("user");
           if (currentUser == null) {
               return "redirect:/auth/login";
           }
           
           // 레스토랑 정보 조회
           Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
           if (restaurant == null) {
               model.addAttribute("error", "레스토랑을 찾을 수 없습니다.");
               return "error/404";
           }
           
           // 예약 정보 생성
           Reservation reservation = new Reservation();
           reservation.setUserId(currentUser.getUserId());
           reservation.setRestaurantId(restaurantId);
           reservation.setReservationDate(LocalDate.parse(reservationDate));
           reservation.setReservationHour(reservationHour);
           reservation.setPartySize(partySize);
           reservation.setSpecialRequest(specialRequest);
           reservation.setIsConfirmed(false); 
           reservation.setIsCancelled(false);
           reservation.setIsCompleted(false);
           
           // 예약 저장
           reservationService.createReservation(reservation);
           
           // 쿠폰 사용 처리
           if (selectedCouponId != null) {
               try {
                   couponService.useCoupon(selectedCouponId, currentUser.getUserId());
               } catch (Exception e) {
                   System.err.println("쿠폰 사용 처리 오류: " + e.getMessage());
               }
           }
           
           // 날짜 포맷팅 
           DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy년 MM월 dd일");
           String formattedDate = reservation.getReservationDate().format(formatter);
           
           // 성공 메시지와 함께 성공 페이지로 이동
           model.addAttribute("reservation", reservation);
           model.addAttribute("restaurant", restaurant);
           model.addAttribute("user", currentUser);
           model.addAttribute("formattedDate", formattedDate);
           
           return "reservation-success";
           
       } catch (Exception e) {
           e.printStackTrace();
           model.addAttribute("error", "예약 처리 중 오류가 발생했습니다: " + e.getMessage());
           model.addAttribute("restaurant", restaurantService.getRestaurantById(restaurantId));
           return "reservation-form";
       }
    }
}