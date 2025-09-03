package com.myproject.catchtable.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.myproject.catchtable.dto.ApiResponse;
import com.myproject.catchtable.model.Category;
import com.myproject.catchtable.model.Restaurant;
import com.myproject.catchtable.model.User;
import com.myproject.catchtable.service.CategoryService;
import com.myproject.catchtable.service.RestaurantService;
import com.myproject.catchtable.service.ReviewService;

@Controller
@RequestMapping("/restaurant")
public class RestaurantController {
    
    private static final Logger logger = LoggerFactory.getLogger(RestaurantController.class);
    
    @Autowired
    private RestaurantService restaurantService;
    
    @Autowired
    private ReviewService reviewService;
    @Autowired
    private CategoryService categoryService;
    
    // 식당 목록 페이지
    @GetMapping("/list")
    public String restaurantList(Model model) {
        List<Restaurant> restaurants = restaurantService.findAll();
        List<Category> categories = categoryService.findAll();
        
        model.addAttribute("restaurants", restaurants);
        model.addAttribute("categories", categories);
        
        return "restaurant/list";
    }
    
    // 식당 상세 페이지
    @GetMapping("/detail/{restaurantId}")
    public String restaurantDetail(@PathVariable Integer restaurantId, 
                                  Model model, HttpSession session) {
        Restaurant restaurant = restaurantService.findById(restaurantId);
        if (restaurant == null) {
            return "redirect:/restaurant/list";
        }
        
        // 조회수 증가
        restaurantService.incrementViewCount(restaurantId);
        
        // 현재 사용자의 리뷰 작성 여부 확인
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId != null) {
            boolean hasReview = reviewService.hasUserReviewedRestaurant(userId, restaurantId);
            model.addAttribute("hasReviewForThisRestaurant", hasReview);
        }
        
        model.addAttribute("restaurant", restaurant);
        return "restaurant/detail";
    }
    
    // 식당 등록 페이지 (사업자만)
    @GetMapping("/register")
    public String restaurantRegisterPage(Model model, HttpSession session) {
        // 사업자 로그인 확인
        User user = (User) session.getAttribute("businessUser");
        if (user == null || !user.isBusiness()) {
            return "redirect:/auth/login";
        }
        
        List<Category> categories = categoryService.findAll();
        model.addAttribute("categories", categories);
        
        return "restaurant/register";
    }
    
    // 식당 등록 처리 
    @PostMapping("/register")
    @ResponseBody
    public ApiResponse registerRestaurant(@RequestBody Restaurant restaurant, HttpSession session) {
        try {
            // 세션에서 사업자 정보 가져오기
            User user = (User) session.getAttribute("businessUser");
            if (user == null) {
                return ApiResponse.error("로그인이 필요합니다.");
            }
            
            // 사업자 승인 상태 확인
            if (!restaurantService.isApprovedBusiness(user.getUserId())) {
                return ApiResponse.error("승인된 사업자만 식당을 등록할 수 있습니다.");
            }
            
            // 입력값 검증
            if (restaurant.getName() == null || restaurant.getName().trim().isEmpty()) {
                return ApiResponse.error("식당명은 필수입니다.");
            }
            if (restaurant.getAddress() == null || restaurant.getAddress().trim().isEmpty()) {
                return ApiResponse.error("주소는 필수입니다.");
            }
            if (restaurant.getCategoryId() == null) {
                return ApiResponse.error("카테고리는 필수입니다.");
            }
            
            // 사업자 ID 설정
            restaurant.setBusinessUserId(user.getUserId());
            
            // 식당 등록
            int result = restaurantService.registerRestaurant(restaurant);
            
            if (result > 0) {
                return new ApiResponse("식당이 성공적으로 등록되었습니다.");
            } else {
                return ApiResponse.error("식당 등록에 실패했습니다.");
            }
            
        } catch (Exception e) {
            logger.error("식당 등록 오류", e);
            return ApiResponse.error("식당 등록 중 오류가 발생했습니다: " + e.getMessage());
        }
    }
    
    // 식당 삭제 - 경로 수정
    @PostMapping("/delete/{id}")
    @ResponseBody
    public ResponseEntity<?> deleteRestaurant(@PathVariable Integer id, HttpSession session) {
        try {
            // 1. 세션 확인
            User user = (User) session.getAttribute("businessUser");
            if (user == null) {
                return ResponseEntity.status(401).body("로그인이 필요합니다");
            }
            
            // 2. 식당 존재 확인
            Restaurant restaurant = restaurantService.findById(id);
            if (restaurant == null) {
                return ResponseEntity.status(404).body("존재하지 않는 식당입니다");
            }
            
            // 3. 권한 확인 (본인 식당만 삭제 가능)
            if (!restaurantService.isOwner(id, user.getUserId())) {
                return ResponseEntity.status(403).body("삭제 권한이 없습니다");
            }
            
            // 4. 삭제 실행
            int result = restaurantService.deleteRestaurant(id);
            
            if (result > 0) {
                return ResponseEntity.ok("삭제가 완료되었습니다");
            } else {
                return ResponseEntity.badRequest().body("삭제에 실패했습니다");
            }
            
        } catch (Exception e) {
            logger.error("식당 삭제 오류", e);
            return ResponseEntity.status(500).body("서버 오류가 발생했습니다");
        }
    }
    
    // 식당 수정 페이지
    @GetMapping("/edit/{id}")
    public String editRestaurantPage(@PathVariable Integer id, Model model, HttpSession session) {
        // 세션 확인
        User user = (User) session.getAttribute("businessUser");
        if (user == null) {
            return "redirect:/auth/login";
        }
        
        // 권한 확인
        if (!restaurantService.isOwner(id, user.getUserId())) {
            return "redirect:/restaurant/list";
        }
        
        Restaurant restaurant = restaurantService.findById(id);
        List<Category> categories = categoryService.findAll();
        
        model.addAttribute("restaurant", restaurant);
        model.addAttribute("categories", categories);
        
        return "restaurant/edit";
    }
    
    // 식당 수정 처리
    @PostMapping("/edit/{id}")
    @ResponseBody
    public ApiResponse updateRestaurant(@PathVariable Integer id, 
                                       @RequestBody Restaurant restaurant, 
                                       HttpSession session) {
        try {
            // 세션 확인
            User user = (User) session.getAttribute("businessUser");
            if (user == null) {
                return ApiResponse.error("로그인이 필요합니다.");
            }
            
            // 권한 확인
            if (!restaurantService.isOwner(id, user.getUserId())) {
                return ApiResponse.error("수정 권한이 없습니다.");
            }
            
            // ID 설정
            restaurant.setRestaurantId(id);
            restaurant.setBusinessUserId(user.getUserId());
            
            // 수정 실행
            int result = restaurantService.updateRestaurant(restaurant);
            
            if (result > 0) {
                return new ApiResponse("식당 정보가 수정되었습니다.");
            } else {
                return ApiResponse.error("수정에 실패했습니다.");
            }
            
        } catch (Exception e) {
            logger.error("식당 수정 오류", e);
            return ApiResponse.error("수정 중 오류가 발생했습니다.");
        }
    }
    
    // 카테고리별 식당 조회
    @GetMapping("/category/{categoryId}")
    public String restaurantsByCategory(@PathVariable Integer categoryId, Model model) {
        List<Restaurant> restaurants = restaurantService.findByCategoryId(categoryId);
        Category category = categoryService.findById(categoryId);
        List<Category> allCategories = categoryService.findAll();
        
        model.addAttribute("restaurants", restaurants);
        model.addAttribute("currentCategory", category);
        model.addAttribute("categories", allCategories);
        
        return "restaurant/list";
    }
 // 리뷰 작성 페이지로 이동 
    @GetMapping("/{restaurantId}/review")
    public String createReview(@PathVariable Integer restaurantId,
                              @RequestParam Integer reservationId,
                              HttpSession session) {
        return "redirect:/review/form?restaurantId=" + restaurantId + "&reservationId=" + reservationId;
    }

    // 기존에 추가한 리뷰 수정 매핑
    @GetMapping("/{restaurantId}/review/edit")
    public String editReview(@PathVariable Integer restaurantId,
                            @RequestParam Integer reviewId,
                            HttpSession session) {
        return "redirect:/review/form?reviewId=" + reviewId;
    }
    // 식당 검색
    @GetMapping("/search")
    public String searchRestaurants(@RequestParam String keyword, Model model) {
        List<Restaurant> restaurants = restaurantService.searchByName(keyword);
        List<Category> categories = categoryService.findAll();
        
        model.addAttribute("restaurants", restaurants);
        model.addAttribute("categories", categories);
        model.addAttribute("keyword", keyword);
        
        return "restaurant/list";
    }
    
    // 인기 식당
    @GetMapping("/popular")
    public String popularRestaurants(Model model) {
        List<Restaurant> restaurants = restaurantService.getTopRestaurants(20);
        List<Category> categories = categoryService.findAll();
        
        model.addAttribute("restaurants", restaurants);
        model.addAttribute("categories", categories);
        
        return "restaurant/list";
    }
    
    // 좋아요 추가/제거 (AJAX)
    @PostMapping("/like/{restaurantId}")
    @ResponseBody
    public ApiResponse toggleLike(@PathVariable Integer restaurantId,
                                @RequestParam boolean isLike,
                                HttpSession session) {
        try {
            // 로그인 확인
            User user = (User) session.getAttribute("user");
            if (user == null) {
                return ApiResponse.error("로그인이 필요합니다.");
            }
            
            if (isLike) {
                restaurantService.incrementLikesCount(restaurantId);
            } else {
                restaurantService.decrementLikesCount(restaurantId);
            }
            
            return new ApiResponse("처리되었습니다.");
            
        } catch (Exception e) {
            logger.error("좋아요 처리 오류", e);
            return ApiResponse.error("오류가 발생했습니다.");
        }
    }
}