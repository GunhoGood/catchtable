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
    
    // �Ĵ� ��� ������
    @GetMapping("/list")
    public String restaurantList(Model model) {
        List<Restaurant> restaurants = restaurantService.findAll();
        List<Category> categories = categoryService.findAll();
        
        model.addAttribute("restaurants", restaurants);
        model.addAttribute("categories", categories);
        
        return "restaurant/list";
    }
    
    // �Ĵ� �� ������
    @GetMapping("/detail/{restaurantId}")
    public String restaurantDetail(@PathVariable Integer restaurantId, 
                                  Model model, HttpSession session) {
        Restaurant restaurant = restaurantService.findById(restaurantId);
        if (restaurant == null) {
            return "redirect:/restaurant/list";
        }
        
        // ��ȸ�� ����
        restaurantService.incrementViewCount(restaurantId);
        
        // ���� ������� ���� �ۼ� ���� Ȯ��
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId != null) {
            boolean hasReview = reviewService.hasUserReviewedRestaurant(userId, restaurantId);
            model.addAttribute("hasReviewForThisRestaurant", hasReview);
        }
        
        model.addAttribute("restaurant", restaurant);
        return "restaurant/detail";
    }
    
    // �Ĵ� ��� ������ (����ڸ�)
    @GetMapping("/register")
    public String restaurantRegisterPage(Model model, HttpSession session) {
        // ����� �α��� Ȯ��
        User user = (User) session.getAttribute("businessUser");
        if (user == null || !user.isBusiness()) {
            return "redirect:/auth/login";
        }
        
        List<Category> categories = categoryService.findAll();
        model.addAttribute("categories", categories);
        
        return "restaurant/register";
    }
    
    // �Ĵ� ��� ó�� 
    @PostMapping("/register")
    @ResponseBody
    public ApiResponse registerRestaurant(@RequestBody Restaurant restaurant, HttpSession session) {
        try {
            // ���ǿ��� ����� ���� ��������
            User user = (User) session.getAttribute("businessUser");
            if (user == null) {
                return ApiResponse.error("�α����� �ʿ��մϴ�.");
            }
            
            // ����� ���� ���� Ȯ��
            if (!restaurantService.isApprovedBusiness(user.getUserId())) {
                return ApiResponse.error("���ε� ����ڸ� �Ĵ��� ����� �� �ֽ��ϴ�.");
            }
            
            // �Է°� ����
            if (restaurant.getName() == null || restaurant.getName().trim().isEmpty()) {
                return ApiResponse.error("�Ĵ���� �ʼ��Դϴ�.");
            }
            if (restaurant.getAddress() == null || restaurant.getAddress().trim().isEmpty()) {
                return ApiResponse.error("�ּҴ� �ʼ��Դϴ�.");
            }
            if (restaurant.getCategoryId() == null) {
                return ApiResponse.error("ī�װ��� �ʼ��Դϴ�.");
            }
            
            // ����� ID ����
            restaurant.setBusinessUserId(user.getUserId());
            
            // �Ĵ� ���
            int result = restaurantService.registerRestaurant(restaurant);
            
            if (result > 0) {
                return new ApiResponse("�Ĵ��� ���������� ��ϵǾ����ϴ�.");
            } else {
                return ApiResponse.error("�Ĵ� ��Ͽ� �����߽��ϴ�.");
            }
            
        } catch (Exception e) {
            logger.error("�Ĵ� ��� ����", e);
            return ApiResponse.error("�Ĵ� ��� �� ������ �߻��߽��ϴ�: " + e.getMessage());
        }
    }
    
    // �Ĵ� ���� - ��� ����
    @PostMapping("/delete/{id}")
    @ResponseBody
    public ResponseEntity<?> deleteRestaurant(@PathVariable Integer id, HttpSession session) {
        try {
            // 1. ���� Ȯ��
            User user = (User) session.getAttribute("businessUser");
            if (user == null) {
                return ResponseEntity.status(401).body("�α����� �ʿ��մϴ�");
            }
            
            // 2. �Ĵ� ���� Ȯ��
            Restaurant restaurant = restaurantService.findById(id);
            if (restaurant == null) {
                return ResponseEntity.status(404).body("�������� �ʴ� �Ĵ��Դϴ�");
            }
            
            // 3. ���� Ȯ�� (���� �Ĵ縸 ���� ����)
            if (!restaurantService.isOwner(id, user.getUserId())) {
                return ResponseEntity.status(403).body("���� ������ �����ϴ�");
            }
            
            // 4. ���� ����
            int result = restaurantService.deleteRestaurant(id);
            
            if (result > 0) {
                return ResponseEntity.ok("������ �Ϸ�Ǿ����ϴ�");
            } else {
                return ResponseEntity.badRequest().body("������ �����߽��ϴ�");
            }
            
        } catch (Exception e) {
            logger.error("�Ĵ� ���� ����", e);
            return ResponseEntity.status(500).body("���� ������ �߻��߽��ϴ�");
        }
    }
    
    // �Ĵ� ���� ������
    @GetMapping("/edit/{id}")
    public String editRestaurantPage(@PathVariable Integer id, Model model, HttpSession session) {
        // ���� Ȯ��
        User user = (User) session.getAttribute("businessUser");
        if (user == null) {
            return "redirect:/auth/login";
        }
        
        // ���� Ȯ��
        if (!restaurantService.isOwner(id, user.getUserId())) {
            return "redirect:/restaurant/list";
        }
        
        Restaurant restaurant = restaurantService.findById(id);
        List<Category> categories = categoryService.findAll();
        
        model.addAttribute("restaurant", restaurant);
        model.addAttribute("categories", categories);
        
        return "restaurant/edit";
    }
    
    // �Ĵ� ���� ó��
    @PostMapping("/edit/{id}")
    @ResponseBody
    public ApiResponse updateRestaurant(@PathVariable Integer id, 
                                       @RequestBody Restaurant restaurant, 
                                       HttpSession session) {
        try {
            // ���� Ȯ��
            User user = (User) session.getAttribute("businessUser");
            if (user == null) {
                return ApiResponse.error("�α����� �ʿ��մϴ�.");
            }
            
            // ���� Ȯ��
            if (!restaurantService.isOwner(id, user.getUserId())) {
                return ApiResponse.error("���� ������ �����ϴ�.");
            }
            
            // ID ����
            restaurant.setRestaurantId(id);
            restaurant.setBusinessUserId(user.getUserId());
            
            // ���� ����
            int result = restaurantService.updateRestaurant(restaurant);
            
            if (result > 0) {
                return new ApiResponse("�Ĵ� ������ �����Ǿ����ϴ�.");
            } else {
                return ApiResponse.error("������ �����߽��ϴ�.");
            }
            
        } catch (Exception e) {
            logger.error("�Ĵ� ���� ����", e);
            return ApiResponse.error("���� �� ������ �߻��߽��ϴ�.");
        }
    }
    
    // ī�װ��� �Ĵ� ��ȸ
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
 // ���� �ۼ� �������� �̵� 
    @GetMapping("/{restaurantId}/review")
    public String createReview(@PathVariable Integer restaurantId,
                              @RequestParam Integer reservationId,
                              HttpSession session) {
        return "redirect:/review/form?restaurantId=" + restaurantId + "&reservationId=" + reservationId;
    }

    // ������ �߰��� ���� ���� ����
    @GetMapping("/{restaurantId}/review/edit")
    public String editReview(@PathVariable Integer restaurantId,
                            @RequestParam Integer reviewId,
                            HttpSession session) {
        return "redirect:/review/form?reviewId=" + reviewId;
    }
    // �Ĵ� �˻�
    @GetMapping("/search")
    public String searchRestaurants(@RequestParam String keyword, Model model) {
        List<Restaurant> restaurants = restaurantService.searchByName(keyword);
        List<Category> categories = categoryService.findAll();
        
        model.addAttribute("restaurants", restaurants);
        model.addAttribute("categories", categories);
        model.addAttribute("keyword", keyword);
        
        return "restaurant/list";
    }
    
    // �α� �Ĵ�
    @GetMapping("/popular")
    public String popularRestaurants(Model model) {
        List<Restaurant> restaurants = restaurantService.getTopRestaurants(20);
        List<Category> categories = categoryService.findAll();
        
        model.addAttribute("restaurants", restaurants);
        model.addAttribute("categories", categories);
        
        return "restaurant/list";
    }
    
    // ���ƿ� �߰�/���� (AJAX)
    @PostMapping("/like/{restaurantId}")
    @ResponseBody
    public ApiResponse toggleLike(@PathVariable Integer restaurantId,
                                @RequestParam boolean isLike,
                                HttpSession session) {
        try {
            // �α��� Ȯ��
            User user = (User) session.getAttribute("user");
            if (user == null) {
                return ApiResponse.error("�α����� �ʿ��մϴ�.");
            }
            
            if (isLike) {
                restaurantService.incrementLikesCount(restaurantId);
            } else {
                restaurantService.decrementLikesCount(restaurantId);
            }
            
            return new ApiResponse("ó���Ǿ����ϴ�.");
            
        } catch (Exception e) {
            logger.error("���ƿ� ó�� ����", e);
            return ApiResponse.error("������ �߻��߽��ϴ�.");
        }
    }
}