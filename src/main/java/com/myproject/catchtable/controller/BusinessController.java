package com.myproject.catchtable.controller;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.myproject.catchtable.dto.ApiResponse;
import com.myproject.catchtable.model.Category;
import com.myproject.catchtable.model.Menu;
import com.myproject.catchtable.model.Reservation;
import com.myproject.catchtable.model.Restaurant;
import com.myproject.catchtable.model.Review;
import com.myproject.catchtable.model.User;
import com.myproject.catchtable.service.BusinessUserService;
import com.myproject.catchtable.service.ReservationService;
import com.myproject.catchtable.service.RestaurantService;
import com.myproject.catchtable.service.ReviewService;
import com.myproject.catchtable.service.UserService;

@Controller
@RequestMapping("/business")
public class BusinessController {

	@Autowired
	private BusinessUserService businessUserService;

	@Autowired
	private UserService userService;

	@Autowired
	private RestaurantService restaurantService;

	@Autowired
	private ReservationService reservationService;

	@Autowired
	private ReviewService reviewService;

	/**
	 * ����� ������ ������
	 */
	@GetMapping("/profile")
	public String businessProfile(HttpSession session, Model model) {
		try {
			// ���ǿ��� ����� ���� ��������
			Integer userId = (Integer) session.getAttribute("userId");
			String userType = (String) session.getAttribute("userType");

			// �α��� Ȯ��
			if (userId == null) {
				return "redirect:/login";
			}

			// ����� ���� Ȯ��
			if (!"BUSINESS".equals(userType)) {
				return "redirect:/"; // �Ϲ� ����ڴ� ���� ��������
			}

			// ����� ���� ��ȸ
			User businessUser = userService.findById(userId);
			if (businessUser == null) {
				return "redirect:/login";
			}

			// ��� ������ ����
			Map<String, Object> statistics = getBusinessStatistics(userId);
			
			// �Ĵ� ��ϰ� ���� ������ �߰� 
			List<Restaurant> restaurants = restaurantService.findByBusinessUserId(userId);
			Map<Integer, Double> restaurantRatings = new HashMap<>();
			for (Restaurant restaurant : restaurants) {
				try {
					Double avgRating = reviewService.getAverageRating(restaurant.getRestaurantId());
					restaurantRatings.put(restaurant.getRestaurantId(), avgRating != null ? avgRating : 0.0);
				} catch (Exception e) {
					System.err.println("���� ��� ����: " + e.getMessage());
					restaurantRatings.put(restaurant.getRestaurantId(), 0.0);
				}
			}

			// �𵨿� ������ �߰�
			model.addAttribute("businessUser", businessUser);
			model.addAttribute("statistics", statistics);
			model.addAttribute("restaurants", restaurants);
			model.addAttribute("restaurantRatings", restaurantRatings);

			return "business-profile";

		} catch (Exception e) {
			System.err.println("����� ������ ������ ����: " + e.getMessage());
			e.printStackTrace();
			model.addAttribute("error", "������ ������ �ҷ����� �� ������ �߻��߽��ϴ�.");
			return "business-profile";
		}
	}

	/**
	 * ����� ������ ���� ����
	 */
	@PostMapping("/profile/update")
	@ResponseBody
	public ApiResponse updateProfile(@RequestBody Map<String, Object> profileData, HttpSession session) {
		try {
			Integer userId = (Integer) session.getAttribute("userId");
			if (userId == null) {
				return ApiResponse.error("�α����� �ʿ��մϴ�.");
			}

			// ���� ����� ���� ��ȸ
			User user = userService.findById(userId);
			if (user == null) {
				return ApiResponse.error("����� ������ ã�� �� �����ϴ�.");
			}

			// ������ ���� ����
			if (profileData.containsKey("name")) {
				user.setName((String) profileData.get("name"));
			}
			if (profileData.containsKey("phone")) {
				user.setPhone((String) profileData.get("phone"));
			}
			if (profileData.containsKey("email")) {
				user.setEmail((String) profileData.get("email"));
			}

			// ���� ������Ʈ
			userService.updateUser(user);

			return new ApiResponse("�������� ���������� ������Ʈ�Ǿ����ϴ�.");

		} catch (Exception e) {
			System.err.println("������ ������Ʈ ����: " + e.getMessage());
			return ApiResponse.error("������ ������Ʈ �� ������ �߻��߽��ϴ�: " + e.getMessage());
		}
	}

	/**
	 * ��й�ȣ ����
	 */
	@PostMapping("/profile/password")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> changePassword(@RequestBody Map<String, String> passwordData,
			HttpSession session) {

		Map<String, Object> response = new HashMap<>();

		try {
			// �ٸ� �޼ҵ�� ������ ������� ���� Ȯ��
			Integer userId = (Integer) session.getAttribute("userId");
			String userType = (String) session.getAttribute("userType");

			if (userId == null || !"BUSINESS".equals(userType)) {
				response.put("success", false);
				response.put("message", "�α����� �ʿ��մϴ�.");
				return ResponseEntity.ok(response);
			}

			// ����� ���� ��ȸ
			User user = userService.findById(userId);
			if (user == null) {
				response.put("success", false);
				response.put("message", "����� ������ ã�� �� �����ϴ�.");
				return ResponseEntity.ok(response);
			}

			String currentPassword = passwordData.get("currentPassword");
			String newPassword = passwordData.get("newPassword");

			// �Է°� ����
			if (currentPassword == null || currentPassword.trim().isEmpty() || newPassword == null
					|| newPassword.trim().isEmpty()) {
				response.put("success", false);
				response.put("message", "���� ��й�ȣ�� �� ��й�ȣ�� ��� �Է����ּ���.");
				return ResponseEntity.ok(response);
			}

			// �� ��й�ȣ ���� üũ
			if (newPassword.length() < 6) {
				response.put("success", false);
				response.put("message", "�� ��й�ȣ�� 6�� �̻��̾�� �մϴ�.");
				return ResponseEntity.ok(response);
			}

			// ���� ��й�ȣ Ȯ��
			if (!currentPassword.equals(user.getPassword())) {
				response.put("success", false);
				response.put("message", "���� ��й�ȣ�� ��ġ���� �ʽ��ϴ�.");
				return ResponseEntity.ok(response);
			}

			// �� ��й�ȣ�� ���� ��й�ȣ�� ������ Ȯ��
			if (currentPassword.equals(newPassword)) {
				response.put("success", false);
				response.put("message", "�� ��й�ȣ�� ���� ��й�ȣ�� �޶�� �մϴ�.");
				return ResponseEntity.ok(response);
			}

			// DB ������Ʈ
			int updateCount = businessUserService.updatePassword(user.getUserId(), newPassword);

			if (updateCount > 0) {
				response.put("success", true);
				response.put("message", "��й�ȣ�� ���������� ����Ǿ����ϴ�.");
			} else {
				response.put("success", false);
				response.put("message", "��й�ȣ ���濡 �����߽��ϴ�.");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "���� ������ �߻��߽��ϴ�.");
		}

		return ResponseEntity.ok(response);
	}

	/**
	 * �Ĵ� ��� ������ - ���� ���� �� ǥ��
	 */
	@GetMapping("/restaurants")
	public String businessRestaurants(HttpSession session, Model model) {
	   try {
	       // ���ǿ��� ����� ���� Ȯ��
	       Integer userId = (Integer) session.getAttribute("userId");
	       String userType = (String) session.getAttribute("userType");

	       // �α��� Ȯ��
	       if (userId == null) {
	           return "redirect:/login";
	       }

	       // ����� ���� Ȯ��
	       if (!"BUSINESS".equals(userType)) {
	           return "redirect:/"; // �Ϲ� ����ڴ� ���� ��������
	       }

	       // ����ڰ� ����� �Ĵ� ��� ��ȸ
	       List<Restaurant> restaurants = restaurantService.findByBusinessUserId(userId);

	       // �� �Ĵ纰 ���� ���
	       Map<Integer, Double> restaurantRatings = new HashMap<>();
	       // �� �Ĵ纰 ���� ���� �� ��� �߰�
	       Map<Integer, Integer> actualReservationCounts = new HashMap<>();
	       
	       for (Restaurant restaurant : restaurants) {
	           try {
	               // ���� ���
	               Double avgRating = reviewService.getAverageRating(restaurant.getRestaurantId());
	               restaurantRatings.put(restaurant.getRestaurantId(), avgRating != null ? avgRating : 0.0);
	               
	               // ���� ���� �� ��� (�� �Ĵ纰��)
	               int actualCount = reservationService.getReservationCountByRestaurant(restaurant.getRestaurantId());
	               actualReservationCounts.put(restaurant.getRestaurantId(), actualCount);
	               
	           } catch (Exception e) {
	               System.err.println("�Ĵ� ��� ��� ���� - �Ĵ�ID: " + restaurant.getRestaurantId() + ", ����: " + e.getMessage());
	               restaurantRatings.put(restaurant.getRestaurantId(), 0.0);
	               actualReservationCounts.put(restaurant.getRestaurantId(), 0);
	           }
	       }

	       // �𵨿� ������ �߰�
	       model.addAttribute("restaurants", restaurants);
	       model.addAttribute("restaurantRatings", restaurantRatings);
	       model.addAttribute("actualReservationCounts", actualReservationCounts); // ���� ���� �� �߰�
	       model.addAttribute("totalRestaurants", restaurants.size());

	       return "business-restaurants";

	   } catch (Exception e) {
	       System.err.println("�Ĵ� ��� ��ȸ ����: " + e.getMessage());
	       e.printStackTrace();
	       model.addAttribute("error", "�Ĵ� ����� �ҷ����� �� ������ �߻��߽��ϴ�.");
	       return "business-restaurants";
	   }
	}
	
	/**
	 * �Ĵ� �� ���� ������
	 */
	@GetMapping("/restaurants/{restaurantId}")
	public String restaurantDetail(@PathVariable Integer restaurantId, HttpSession session, Model model) {
	    try {
	        // ���ǿ��� ����� ���� Ȯ��
	        Integer userId = (Integer) session.getAttribute("userId");
	        String userType = (String) session.getAttribute("userType");

	        if (userId == null || !"BUSINESS".equals(userType)) {
	            return "redirect:/login";
	        }

	        // �Ĵ� ���� ��ȸ
	        Restaurant restaurant = restaurantService.findById(restaurantId);
	        if (restaurant == null) {
	            model.addAttribute("error", "�Ĵ��� ã�� �� �����ϴ�.");
	            return "redirect:/business/restaurants";
	        }

	        // �ش� �Ĵ��� ���� ������� ������ Ȯ��
	        if (!restaurant.getBusinessUserId().equals(userId)) {
	            model.addAttribute("error", "���� ������ �����ϴ�.");
	            return "redirect:/business/restaurants";
	        }

	        // �Ĵ� �޴� ��� ��ȸ
	        List<Menu> menus = restaurantService.getMenusByRestaurantId(restaurantId);

	        //  ���� ��� ������ ���
	        // 1. ���� ���� �� ���
	        int actualReservationCount = reservationService.getReservationCountByRestaurant(restaurantId);
	        
	        // 2. ���� ���� ���
	        Double actualRating = null;
	        try {
	            actualRating = reviewService.getAverageRating(restaurantId);
	        } catch (Exception e) {
	            System.err.println("���� ��� ����: " + e.getMessage());
	            actualRating = 0.0;
	        }
	        
	        // 3. ���� ���ƿ� �� (���� restaurant ���̺� �� ���, �ʿ�� ���� ��� ����)
	        int actualLikesCount = restaurant.getLikesCount() != null ? restaurant.getLikesCount() : 0;
	        
	        // 4. ���� ��ȸ�� (���� restaurant ���̺� �� ���, �ʿ�� ���� ��� ����)
	        int actualViewCount = restaurant.getViewCount() != null ? restaurant.getViewCount() : 0;

	        //  ���� restaurantStats ��� ���� ���� ��� �� ����
	        Map<String, Object> actualStats = new HashMap<>();
	        actualStats.put("reservationCount", actualReservationCount);
	        actualStats.put("averageRating", actualRating != null ? actualRating : 0.0);
	        actualStats.put("likesCount", actualLikesCount);
	        actualStats.put("viewCount", actualViewCount);
	        
	        //  ���� ���� ���� �Ǵ� (��ð� ���)
	        boolean isReservationAvailable = restaurant.getOperatingHours() != null && 
	                                       !restaurant.getOperatingHours().trim().isEmpty();

	        // �𵨿� ������ �߰�
	        model.addAttribute("restaurant", restaurant);
	        model.addAttribute("menus", menus);
	        
	        //  ���� ���� ��� ������ ����
	        model.addAttribute("actualReservationCount", actualReservationCount);
	        model.addAttribute("actualRating", actualRating != null ? actualRating : 0.0);
	        model.addAttribute("actualLikesCount", actualLikesCount);
	        model.addAttribute("actualViewCount", actualViewCount);
	        model.addAttribute("isReservationAvailable", isReservationAvailable);
	        
	        // ���� restaurantStats�� ���� ȣȯ���� ���� ���� (�ʿ�� ���� ����)
	        model.addAttribute("restaurantStats", actualStats);

	        return "restaurant-detail";

	    } catch (Exception e) {
	        System.err.println("�Ĵ� �� ��ȸ ����: " + e.getMessage());
	        e.printStackTrace();
	        model.addAttribute("error", "�Ĵ� ������ �ҷ����� �� ������ �߻��߽��ϴ�.");
	        return "redirect:/business/restaurants";
	    }
	}
	/**
	 * �� �Ĵ� ��� ������
	 */
	@GetMapping("/restaurants/new")
	public String newRestaurantForm(HttpSession session, Model model) {
		try {
			// ���ǿ��� ����� ���� Ȯ��
			Integer userId = (Integer) session.getAttribute("userId");
			String userType = (String) session.getAttribute("userType");

			if (userId == null || !"BUSINESS".equals(userType)) {
				return "redirect:/login";
			}

			// ī�װ� ��� ��ȸ 
			List<Category> categories = restaurantService.getAllCategories();
			model.addAttribute("categories", categories);

			// �� �Ĵ� ��ü ���� 
			model.addAttribute("restaurant", new Restaurant());

			return "restaurant-form";

		} catch (Exception e) {
			System.err.println("�Ĵ� ��� �� ����: " + e.getMessage());
			model.addAttribute("error", "�������� �ҷ����� �� ������ �߻��߽��ϴ�.");
			return "redirect:/business/restaurants";
		}
	}

	/**
	 * �Ĵ� ��� ó��
	 */
	@PostMapping("/restaurants")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> createRestaurant(@RequestBody Restaurant restaurant,
			HttpSession session) {

		Map<String, Object> response = new HashMap<>();

		try {
			// ���ǿ��� ����� ���� Ȯ��
			Integer userId = (Integer) session.getAttribute("userId");
			String userType = (String) session.getAttribute("userType");

			if (userId == null || !"BUSINESS".equals(userType)) {
				response.put("success", false);
				response.put("message", "�α����� �ʿ��մϴ�.");
				return ResponseEntity.ok(response);
			}

			// �Է°� ����
			if (restaurant.getName() == null || restaurant.getName().trim().isEmpty()) {
				response.put("success", false);
				response.put("message", "�Ĵ� �̸��� �Է����ּ���.");
				return ResponseEntity.ok(response);
			}

			if (restaurant.getAddress() == null || restaurant.getAddress().trim().isEmpty()) {
				response.put("success", false);
				response.put("message", "�Ĵ� �ּҸ� �Է����ּ���.");
				return ResponseEntity.ok(response);
			}
			// ����� ID �� �⺻�� ����
			restaurant.setBusinessUserId(userId);
			restaurant.setCreatedAt(LocalDateTime.now());
			restaurant.setUpdatedAt(LocalDateTime.now());
			if (restaurant.getImageUrl() == null || restaurant.getImageUrl().trim().isEmpty()) {
				restaurant.setImageUrl("https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400&h=300&fit=crop&auto=format");
			}

			// �Ĵ� ���
			int result = restaurantService.registerRestaurant(restaurant);

			if (result > 0) {
				response.put("success", true);
				response.put("message", "�Ĵ��� ���������� ��ϵǾ����ϴ�.");
				response.put("restaurantId", restaurant.getRestaurantId());
			} else {
				response.put("success", false);
				response.put("message", "�Ĵ� ��Ͽ� �����߽��ϴ�.");
			}

		} catch (Exception e) {
			System.err.println("�Ĵ� ��� ����: " + e.getMessage());
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "���� ������ �߻��߽��ϴ�.");
		}

		return ResponseEntity.ok(response);
	}

	/**
	 * �Ĵ� ���� ������
	 */
	@GetMapping("/restaurants/{restaurantId}/edit")
	public String editRestaurantForm(@PathVariable Integer restaurantId, HttpSession session, Model model) {
		try {
			// ���ǿ��� ����� ���� Ȯ��
			Integer userId = (Integer) session.getAttribute("userId");
			String userType = (String) session.getAttribute("userType");

			if (userId == null || !"BUSINESS".equals(userType)) {
				return "redirect:/login";
			}

			// �Ĵ� ���� ��ȸ
			Restaurant restaurant = restaurantService.findById(restaurantId);
			if (restaurant == null) {
				model.addAttribute("error", "�Ĵ��� ã�� �� �����ϴ�.");
				return "redirect:/business/restaurants";
			}

			// �ش� �Ĵ��� ���� ������� ������ Ȯ��
			if (!restaurant.getBusinessUserId().equals(userId)) {
				model.addAttribute("error", "���� ������ �����ϴ�.");
				return "redirect:/business/restaurants";
			}

			// ī�װ� ��� ��ȸ
			List<Category> categories = restaurantService.getAllCategories();

			// �𵨿� ������ �߰�
			model.addAttribute("restaurant", restaurant);
			model.addAttribute("categories", categories);
			model.addAttribute("isEdit", true);

			return "restaurant-form";

		} catch (Exception e) {
			System.err.println("�Ĵ� ���� �� ����: " + e.getMessage());
			model.addAttribute("error", "�������� �ҷ����� �� ������ �߻��߽��ϴ�.");
			return "redirect:/business/restaurants";
		}
	}

	/**
	 * �Ĵ� ���� ���� ó��
	 */
	@PutMapping("/restaurants/{restaurantId}")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> updateRestaurant(@PathVariable Integer restaurantId,
			@RequestBody Restaurant restaurant, HttpSession session) {

		Map<String, Object> response = new HashMap<>();

		try {
			// ���ǿ��� ����� ���� Ȯ��
			Integer userId = (Integer) session.getAttribute("userId");
			String userType = (String) session.getAttribute("userType");

			if (userId == null || !"BUSINESS".equals(userType)) {
				response.put("success", false);
				response.put("message", "�α����� �ʿ��մϴ�.");
				return ResponseEntity.ok(response);
			}

			// �Ĵ� ���� �� ���� Ȯ��
			Restaurant existingRestaurant = restaurantService.findById(restaurantId);
			if (existingRestaurant == null) {
				response.put("success", false);
				response.put("message", "�Ĵ��� ã�� �� �����ϴ�.");
				return ResponseEntity.ok(response);
			}

			if (!existingRestaurant.getBusinessUserId().equals(userId)) {
				response.put("success", false);
				response.put("message", "���� ������ �����ϴ�.");
				return ResponseEntity.ok(response);
			}

			// ���� ������ ����
			restaurant.setRestaurantId(restaurantId);
			restaurant.setBusinessUserId(userId);
			restaurant.setCreatedAt(existingRestaurant.getCreatedAt()); // �������� ����
			restaurant.setUpdatedAt(LocalDateTime.now());

			// ���� ī��Ʈ ���� ����
			restaurant.setLikesCount(existingRestaurant.getLikesCount());
			restaurant.setReservationCount(existingRestaurant.getReservationCount());
			restaurant.setViewCount(existingRestaurant.getViewCount());

			// �Ĵ� ���� ����
			int result = restaurantService.updateRestaurant(restaurant);

			if (result > 0) {
				response.put("success", true);
				response.put("message", "�Ĵ� ������ ���������� �����Ǿ����ϴ�.");
			} else {
				response.put("success", false);
				response.put("message", "�Ĵ� ���� ������ �����߽��ϴ�.");
			}

		} catch (Exception e) {
			System.err.println("�Ĵ� ���� ����: " + e.getMessage());
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "���� ������ �߻��߽��ϴ�.");
		}

		return ResponseEntity.ok(response);
	}

	/**
	 * �Ĵ� ���� ó��
	 */
	@DeleteMapping("/restaurants/{restaurantId}")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> deleteRestaurant(@PathVariable Integer restaurantId,
			HttpSession session) {

		Map<String, Object> response = new HashMap<>();

		try {
			// ���ǿ��� ����� ���� Ȯ��
			Integer userId = (Integer) session.getAttribute("userId");
			String userType = (String) session.getAttribute("userType");

			if (userId == null || !"BUSINESS".equals(userType)) {
				response.put("success", false);
				response.put("message", "�α����� �ʿ��մϴ�.");
				return ResponseEntity.ok(response);
			}

			// �Ĵ� ���� �� ���� Ȯ��
			Restaurant restaurant = restaurantService.findById(restaurantId);
			if (restaurant == null) {
				response.put("success", false);
				response.put("message", "�Ĵ��� ã�� �� �����ϴ�.");
				return ResponseEntity.ok(response);
			}

			if (!restaurant.getBusinessUserId().equals(userId)) {
				response.put("success", false);
				response.put("message", "���� ������ �����ϴ�.");
				return ResponseEntity.ok(response);
			}

			// �Ĵ� ���� (���� �����͵� �Բ� ������ �� �ֵ��� Service���� ó��)
			int result = restaurantService.deleteRestaurant(restaurantId);

			if (result > 0) {
				response.put("success", true);
				response.put("message", "�Ĵ��� ���������� �����Ǿ����ϴ�.");
			} else {
				response.put("success", false);
				response.put("message", "�Ĵ� ������ �����߽��ϴ�.");
			}

		} catch (Exception e) {
			System.err.println("�Ĵ� ���� ����: " + e.getMessage());
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "���� ������ �߻��߽��ϴ�.");
		}

		return ResponseEntity.ok(response);
	}

	// ����� ��� ������ ����
	private Map<String, Object> getBusinessStatistics(Integer businessUserId) {
		Map<String, Object> statistics = new HashMap<>();

		try {
			// ����� �Ĵ� ��
			List<Restaurant> restaurants = restaurantService.findByBusinessUserId(businessUserId);
			statistics.put("totalRestaurants", restaurants.size());

			// �� ���� �Ǽ� ���
			int totalReservations = 0;
			int totalViews = 0;
			int totalLikes = 0;

			for (Restaurant restaurant : restaurants) {
				if (restaurant.getReservationCount() != null) {
					totalReservations += restaurant.getReservationCount();
				}
				if (restaurant.getViewCount() != null) {
					totalViews += restaurant.getViewCount();
				}
				if (restaurant.getLikesCount() != null) {
					totalLikes += restaurant.getLikesCount();
				}
			}

			statistics.put("totalReservations", totalReservations);
			statistics.put("totalViews", totalViews);
			statistics.put("totalLikes", totalLikes);

			// �̹� �� ���� �Ǽ� 
			statistics.put("monthlyReservations", totalReservations > 0 ? (totalReservations / 3) : 0);

			// ���� ��� ���� ���
			double avgRating = 0.0;
			try {
				List<Double> ratings = new ArrayList<>();
				for (Restaurant restaurant : restaurants) {
					// ReviewService ��� 
					Double rating = reviewService.getAverageRating(restaurant.getRestaurantId());
					if (rating != null && rating > 0) {
						ratings.add(rating);
					}
				}
				if (!ratings.isEmpty()) {
					avgRating = ratings.stream().mapToDouble(Double::doubleValue).average().orElse(0.0);
				}
				System.out.println("����� ��� ���� ���: " + avgRating);
			} catch (Exception e) {
				System.err.println("����� ���� ��� ����: " + e.getMessage());
				avgRating = 0.0;
			}

			statistics.put("averageRating", avgRating);

		} catch (Exception e) {
			System.err.println("��� ������ ���� ����: " + e.getMessage());
			// ���� �߻��� �⺻�� ����
			statistics.put("totalRestaurants", 0);
			statistics.put("totalReservations", 0);
			statistics.put("totalViews", 0);
			statistics.put("totalLikes", 0);
			statistics.put("monthlyReservations", 0);
			statistics.put("averageRating", 0.0);
		}

		return statistics;
	}
	/**
	 * �޴� �߰� ������
	 */
	@GetMapping("/restaurants/{restaurantId}/menus/new")
	public String newMenuForm(@PathVariable Integer restaurantId, HttpSession session, Model model) {
	    try {
	        // ���� Ȯ��
	        Integer userId = (Integer) session.getAttribute("userId");
	        String userType = (String) session.getAttribute("userType");

	        if (userId == null || !"BUSINESS".equals(userType)) {
	            return "redirect:/login";
	        }

	        // �Ĵ� ���� ��ȸ �� ���� Ȯ��
	        Restaurant restaurant = restaurantService.findById(restaurantId);
	        if (restaurant == null || !restaurant.getBusinessUserId().equals(userId)) {
	            model.addAttribute("error", "���� ������ �����ϴ�.");
	            return "redirect:/business/restaurants";
	        }

	        // �𵨿� ������ �߰�
	        model.addAttribute("restaurant", restaurant);
	        model.addAttribute("menu", new Menu());
	        model.addAttribute("isEdit", false);

	        return "menu-form";

	    } catch (Exception e) {
	        System.err.println("�޴� ��� �� ����: " + e.getMessage());
	        model.addAttribute("error", "�������� �ҷ����� �� ������ �߻��߽��ϴ�.");
	        return "redirect:/business/restaurants/" + restaurantId;
	    }
	}

	/**
	 * �޴� ��� ó��
	 */
	@PostMapping("/restaurants/{restaurantId}/menus")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> createMenu(@PathVariable Integer restaurantId,
	        @RequestBody Menu menu, HttpSession session) {

	    Map<String, Object> response = new HashMap<>();

	    try {
	        // ���� Ȯ��
	        Integer userId = (Integer) session.getAttribute("userId");
	        String userType = (String) session.getAttribute("userType");

	        if (userId == null || !"BUSINESS".equals(userType)) {
	            response.put("success", false);
	            response.put("message", "�α����� �ʿ��մϴ�.");
	            return ResponseEntity.ok(response);
	        }

	        // �Ĵ� ���� Ȯ��
	        Restaurant restaurant = restaurantService.findById(restaurantId);
	        if (restaurant == null || !restaurant.getBusinessUserId().equals(userId)) {
	            response.put("success", false);
	            response.put("message", "���� ������ �����ϴ�.");
	            return ResponseEntity.ok(response);
	        }

	        // �Է°� ����
	        if (menu.getName() == null || menu.getName().trim().isEmpty()) {
	            response.put("success", false);
	            response.put("message", "�޴� �̸��� �Է����ּ���.");
	            return ResponseEntity.ok(response);
	        }

	        if (menu.getPrice() == null || menu.getPrice() <= 0) {
	            response.put("success", false);
	            response.put("message", "�ùٸ� ������ �Է����ּ���.");
	            return ResponseEntity.ok(response);
	        }

	        // �޴� ���� ����
	        menu.setRestaurantId(restaurantId);
	        if (menu.getIsSignature() == null) menu.setIsSignature(false);
	        if (menu.getIsAvailable() == null) menu.setIsAvailable(true);

	        // �޴� ���
	        int result = restaurantService.addMenu(menu);

	        if (result > 0) {
	            response.put("success", true);
	            response.put("message", "�޴��� ���������� ��ϵǾ����ϴ�.");
	        } else {
	            response.put("success", false);
	            response.put("message", "�޴� ��Ͽ� �����߽��ϴ�.");
	        }

	    } catch (Exception e) {
	        System.err.println("�޴� ��� ����: " + e.getMessage());
	        e.printStackTrace();
	        response.put("success", false);
	        response.put("message", "���� ������ �߻��߽��ϴ�.");
	    }

	    return ResponseEntity.ok(response);
	}
	/**
	 * �޴� ���� ������
	 */
	@GetMapping("/restaurants/{restaurantId}/menus/{menuId}/edit")
	public String editMenuForm(@PathVariable Integer restaurantId, @PathVariable Integer menuId, 
	                          HttpSession session, Model model) {
	    try {
	        // ���� Ȯ��
	        Integer userId = (Integer) session.getAttribute("userId");
	        String userType = (String) session.getAttribute("userType");

	        if (userId == null || !"BUSINESS".equals(userType)) {
	            return "redirect:/login";
	        }

	        // �Ĵ� ���� ��ȸ �� ���� Ȯ��
	        Restaurant restaurant = restaurantService.findById(restaurantId);
	        if (restaurant == null || !restaurant.getBusinessUserId().equals(userId)) {
	            model.addAttribute("error", "���� ������ �����ϴ�.");
	            return "redirect:/business/restaurants";
	        }

	        // �޴� ���� ��ȸ
	        Menu menu = restaurantService.getMenuById(menuId);
	        if (menu == null || !menu.getRestaurantId().equals(restaurantId)) {
	            model.addAttribute("error", "�޴��� ã�� �� �����ϴ�.");
	            return "redirect:/business/restaurants/" + restaurantId;
	        }

	        // �𵨿� ������ �߰�
	        model.addAttribute("restaurant", restaurant);
	        model.addAttribute("menu", menu);
	        model.addAttribute("isEdit", true);

	        return "menu-form";

	    } catch (Exception e) {
	        System.err.println("�޴� ���� �� ����: " + e.getMessage());
	        model.addAttribute("error", "�������� �ҷ����� �� ������ �߻��߽��ϴ�.");
	        return "redirect:/business/restaurants/" + restaurantId;
	    }
	}

	/**
	 * �޴� ���� ó��
	 */
	@PutMapping("/restaurants/{restaurantId}/menus/{menuId}")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> updateMenu(@PathVariable Integer restaurantId,
	        @PathVariable Integer menuId, @RequestBody Menu menu, HttpSession session) {

	    Map<String, Object> response = new HashMap<>();

	    try {
	        // ���� Ȯ��
	        Integer userId = (Integer) session.getAttribute("userId");
	        String userType = (String) session.getAttribute("userType");

	        if (userId == null || !"BUSINESS".equals(userType)) {
	            response.put("success", false);
	            response.put("message", "�α����� �ʿ��մϴ�.");
	            return ResponseEntity.ok(response);
	        }

	        // �Ĵ� ���� Ȯ��
	        Restaurant restaurant = restaurantService.findById(restaurantId);
	        if (restaurant == null || !restaurant.getBusinessUserId().equals(userId)) {
	            response.put("success", false);
	            response.put("message", "���� ������ �����ϴ�.");
	            return ResponseEntity.ok(response);
	        }

	        // �޴� ���� Ȯ��
	        Menu existingMenu = restaurantService.getMenuById(menuId);
	        if (existingMenu == null || !existingMenu.getRestaurantId().equals(restaurantId)) {
	            response.put("success", false);
	            response.put("message", "�޴��� ã�� �� �����ϴ�.");
	            return ResponseEntity.ok(response);
	        }

	        // �Է°� ����
	        if (menu.getName() == null || menu.getName().trim().isEmpty()) {
	            response.put("success", false);
	            response.put("message", "�޴� �̸��� �Է����ּ���.");
	            return ResponseEntity.ok(response);
	        }

	        if (menu.getPrice() == null || menu.getPrice() <= 0) {
	            response.put("success", false);
	            response.put("message", "�ùٸ� ������ �Է����ּ���.");
	            return ResponseEntity.ok(response);
	        }

	        // �޴� ���� ����
	        menu.setMenuId(menuId);
	        menu.setRestaurantId(restaurantId);
	        if (menu.getIsSignature() == null) menu.setIsSignature(false);
	        if (menu.getIsAvailable() == null) menu.setIsAvailable(true);

	        // �޴� ����
	        int result = restaurantService.updateMenu(menu);

	        if (result > 0) {
	            response.put("success", true);
	            response.put("message", "�޴��� ���������� �����Ǿ����ϴ�.");
	        } else {
	            response.put("success", false);
	            response.put("message", "�޴� ������ �����߽��ϴ�.");
	        }

	    } catch (Exception e) {
	        System.err.println("�޴� ���� ����: " + e.getMessage());
	        e.printStackTrace();
	        response.put("success", false);
	        response.put("message", "���� ������ �߻��߽��ϴ�.");
	    }

	    return ResponseEntity.ok(response);
	}

	/**
	 * �޴� ���� ó��
	 */
	@DeleteMapping("/restaurants/{restaurantId}/menus/{menuId}")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> deleteMenu(@PathVariable Integer restaurantId,
	        @PathVariable Integer menuId, HttpSession session) {

	    Map<String, Object> response = new HashMap<>();

	    try {
	        // ���� Ȯ��
	        Integer userId = (Integer) session.getAttribute("userId");
	        String userType = (String) session.getAttribute("userType");

	        if (userId == null || !"BUSINESS".equals(userType)) {
	            response.put("success", false);
	            response.put("message", "�α����� �ʿ��մϴ�.");
	            return ResponseEntity.ok(response);
	        }

	        // �Ĵ� ���� Ȯ��
	        Restaurant restaurant = restaurantService.findById(restaurantId);
	        if (restaurant == null || !restaurant.getBusinessUserId().equals(userId)) {
	            response.put("success", false);
	            response.put("message", "���� ������ �����ϴ�.");
	            return ResponseEntity.ok(response);
	        }

	        // �޴� ����
	        int result = restaurantService.deleteMenu(menuId);

	        if (result > 0) {
	            response.put("success", true);
	            response.put("message", "�޴��� ���������� �����Ǿ����ϴ�.");
	        } else {
	            response.put("success", false);
	            response.put("message", "�޴� ������ �����߽��ϴ�.");
	        }

	    } catch (Exception e) {
	        System.err.println("�޴� ���� ����: " + e.getMessage());
	        e.printStackTrace();
	        response.put("success", false);
	        response.put("message", "���� ������ �߻��߽��ϴ�.");
	    }

	    return ResponseEntity.ok(response);
	}
	
	/**
	 * ���� ���� ������
	 */
	@GetMapping("/reservations")
	public String businessReservations(HttpSession session, Model model, 
	        @RequestParam(defaultValue = "ALL") String status,
	        @RequestParam(required = false) String restaurantId,
	        @RequestParam(required = false) String date,
	        @RequestParam(defaultValue = "1") int page,
	        @RequestParam(defaultValue = "10") int size) {
	    try {
	        Integer userId = (Integer) session.getAttribute("userId");
	        String userType = (String) session.getAttribute("userType");

	        if (userId == null || !"BUSINESS".equals(userType)) {
	            return "redirect:/login";
	        }

	        // ����ڰ� ����� �Ĵ� ��� ��ȸ
	        List<Restaurant> restaurants = restaurantService.findByBusinessUserId(userId);
	        
	        // ��ü ���� ��� ��ȸ 
	        List<Reservation> allReservations = reservationService.getReservationsByBusinessId(
	            userId, status, restaurantId, date);
	            
	        //  ����¡ ���
	        int totalReservations = allReservations.size();
	        int totalPages = (int) Math.ceil((double) totalReservations / size);
	        
	        // ���� ������ ��ȿ�� �˻�
	        if (page < 1) page = 1;
	        if (page > totalPages && totalPages > 0) page = totalPages;
	        
	        //  ���� �������� �ش��ϴ� �����͸� ����
	        int startIndex = (page - 1) * size;
	        int endIndex = Math.min(startIndex + size, totalReservations);
	        
	        List<Reservation> pageReservations = totalReservations > 0 ? 
	            allReservations.subList(startIndex, endIndex) : new ArrayList<>();

	        //  ����¡ ���� ���
	        boolean hasPrev = page > 1;
	        boolean hasNext = page < totalPages;
	        
	        // ������ ��ȣ ���� ���
	        int startPage = Math.max(1, page - 2);
	        int endPage = Math.min(totalPages, page + 2);
	        
	        // ���� ��� ���
	        Map<String, Object> reservationStats = getReservationStatistics(userId);

	        // �𵨿� ������ �߰�
	        model.addAttribute("restaurants", restaurants);
	        model.addAttribute("reservations", pageReservations);
	        model.addAttribute("reservationStats", reservationStats);
	        model.addAttribute("currentStatus", status);
	        model.addAttribute("currentRestaurantId", restaurantId);
	        model.addAttribute("currentDate", date);
	        
	        //  ����¡ ���� �߰�
	        model.addAttribute("currentPage", page);
	        model.addAttribute("totalPages", totalPages);
	        model.addAttribute("totalReservations", totalReservations);
	        model.addAttribute("pageSize", size);
	        model.addAttribute("hasPrev", hasPrev);
	        model.addAttribute("hasNext", hasNext);
	        model.addAttribute("startPage", startPage);
	        model.addAttribute("endPage", endPage);
	        
	        // ����¡ ���� �α�
	        System.out.println(String.format("����¡ ���� - ��ü: %d��, ����������: %d/%d, ǥ��: %d��", 
	                                        totalReservations, page, totalPages, pageReservations.size()));

	        return "business-reservations";

	    } catch (Exception e) {
	        System.err.println("���� ���� ������ ����: " + e.getMessage());
	        e.printStackTrace();
	        model.addAttribute("error", "���� ������ �ҷ����� �� ������ �߻��߽��ϴ�.");
	        return "business-reservations";
	    }
	}
	/**
	 * �� ���� ��� ��ȯ 
	 */
	private Map<String, Object> getEmptyReservationStats() {
	    Map<String, Object> stats = new HashMap<>();
	    stats.put("totalReservations", 0);
	    stats.put("pendingCount", 0);
	    stats.put("confirmedCount", 0);
	    stats.put("completedCount", 0);
	    stats.put("cancelledCount", 0);
	    stats.put("todayReservations", 0);
	    return stats;
	}
	
	/**
	 * ���� ���� ���� ó��
	 */
	@PostMapping("/reservations/{reservationId}/status")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> updateReservationStatus(
	        @PathVariable Integer reservationId,
	        @RequestBody Map<String, String> statusData,
	        HttpSession session) {

	    Map<String, Object> response = new HashMap<>();

	    try {
	        // ���� Ȯ��
	        Integer userId = (Integer) session.getAttribute("userId");
	        String userType = (String) session.getAttribute("userType");

	        if (userId == null || !"BUSINESS".equals(userType)) {
	            response.put("success", false);
	            response.put("message", "�α����� �ʿ��մϴ�.");
	            return ResponseEntity.ok(response);
	        }

	        String newStatus = statusData.get("status");
	        String reason = statusData.get("reason");

	        // �Է°� ����
	        if (newStatus == null || newStatus.trim().isEmpty()) {
	            response.put("success", false);
	            response.put("message", "���°��� �ʿ��մϴ�.");
	            return ResponseEntity.ok(response);
	        }

	        // ��ȿ�� ���°� ����
	        if (!isValidReservationStatus(newStatus)) {
	            response.put("success", false);
	            response.put("message", "��ȿ���� ���� ���°��Դϴ�.");
	            return ResponseEntity.ok(response);
	        }

	        // ���� ���� �� ���� Ȯ��
	        Reservation reservation = reservationService.findById(reservationId);
	        if (reservation == null) {
	            response.put("success", false);
	            response.put("message", "������ ã�� �� �����ϴ�.");
	            return ResponseEntity.ok(response);
	        }

	        // �ش� ������ ���� ������� �Ĵ����� Ȯ��
	        Restaurant restaurant = restaurantService.findById(reservation.getRestaurantId());
	        if (restaurant == null || !restaurant.getBusinessUserId().equals(userId)) {
	            response.put("success", false);
	            response.put("message", "���� ������ �����ϴ�.");
	            return ResponseEntity.ok(response);
	        }

	        // ���� ���� ���� ���� ����
	        String validationResult = validateStatusChange(reservation, newStatus);
	        if (validationResult != null) {
	            response.put("success", false);
	            response.put("message", validationResult);
	            return ResponseEntity.ok(response);
	        }

	        // ���� ������Ʈ
	        int result = reservationService.updateReservationStatus(reservationId, newStatus, reason);

	        if (result > 0) {
	            response.put("success", true);
	            response.put("message", getStatusChangeMessage(newStatus));
	            
	            // ���� �α�
	            System.out.println(String.format("���� ���� ���� ���� - ����ID: %d, ����: %s, �����ID: %d", 
	                              reservationId, newStatus, userId));
	        } else {
	            response.put("success", false);
	            response.put("message", "���� ���� ���濡 �����߽��ϴ�.");
	        }

	    } catch (Exception e) {
	        System.err.println("���� ���� ���� ����: " + e.getMessage());
	        e.printStackTrace();
	        response.put("success", false);
	        response.put("message", "���� ������ �߻��߽��ϴ�.");
	    }

	    return ResponseEntity.ok(response);
	}

	/**
	 * ��ȿ�� ���� ���°����� Ȯ��
	 */
	private boolean isValidReservationStatus(String status) {
	    return status != null && 
	           ("PENDING".equals(status) || "CONFIRMED".equals(status) || 
	            "COMPLETED".equals(status) || "CANCELLED".equals(status));
	}

	/**
	 * ���� ���� ���� ���� ����
	 */
	private String validateStatusChange(Reservation reservation, String newStatus) {
	    // ���� ���� Ȯ��
	    String currentStatus = getCurrentReservationStatus(reservation);
	    
	    switch (newStatus) {
	        case "CONFIRMED":
	            if (!"PENDING".equals(currentStatus)) {
	                return "��� ���� ���ุ ������ �� �ֽ��ϴ�.";
	            }
	            break;
	            
	        case "CANCELLED":
	            if ("COMPLETED".equals(currentStatus)) {
	                return "�Ϸ�� ������ ����� �� �����ϴ�.";
	            }
	            if ("CANCELLED".equals(currentStatus)) {
	                return "�̹� ��ҵ� �����Դϴ�.";
	            }
	            break;
	            
	        case "COMPLETED":
	            if (!"CONFIRMED".equals(currentStatus)) {
	                return "���ε� ���ุ �Ϸ� ó���� �� �ֽ��ϴ�.";
	            }
	            break;
	            
	        default:
	            return "�������� �ʴ� ���� �����Դϴ�.";
	    }
	    
	    return null; // ��ȿ��
	}

	/**
	 * ���� ���� ���� Ȯ�� 
	 */
	private String getCurrentReservationStatus(Reservation reservation) {
	    if (reservation.getIsCompleted()) {
	        return "COMPLETED";
	    } else if (reservation.getIsCancelled()) {
	        return "CANCELLED";
	    } else if (reservation.getIsConfirmed()) {
	        return "CONFIRMED";
	    } else {
	        return "PENDING";
	    }
	}

	/**
	 * ���� ���� ���� �޽��� ��ȯ
	 */
	private String getStatusChangeMessage(String status) {
	    switch (status) {
	        case "CONFIRMED":
	            return "������ ���������� ���εǾ����ϴ�.";
	        case "CANCELLED":
	            return "������ ���������� ��ҵǾ����ϴ�.";
	        case "COMPLETED":
	            return "������ ���������� �Ϸ� ó���Ǿ����ϴ�.";
	        default:
	            return "���� ���°� ���������� ����Ǿ����ϴ�.";
	    }
	}

	/**
	 * ���� ��� ������ ���� -
	 */
	private Map<String, Object> getReservationStatistics(Integer businessUserId) {
	    Map<String, Object> stats = new HashMap<>();
	    
	    try {
	        // ������� ��� �Ĵ� ��ȸ
	        List<Restaurant> restaurants = restaurantService.findByBusinessUserId(businessUserId);
	        
	        if (restaurants.isEmpty()) {
	            return getEmptyReservationStats();
	        }
	        
	        // restaurants ���̺��� ĳ�õ� ���� ���
	        int totalReservations = 0;
	        int totalViews = 0;
	        int totalLikes = 0;
	        
	        for (Restaurant restaurant : restaurants) {
	            if (restaurant.getReservationCount() != null) {
	                totalReservations += restaurant.getReservationCount();
	            }
	            if (restaurant.getViewCount() != null) {
	                totalViews += restaurant.getViewCount();
	            }
	            if (restaurant.getLikesCount() != null) {
	                totalLikes += restaurant.getLikesCount();
	            }
	        }
	        
	        // ���� ���� �����Ͱ� �ִٸ� ���º��� �м�, ���ٸ� ����ġ ���
	        int pendingCount = 0;
	        int confirmedCount = 0;
	        int completedCount = 0;
	        int cancelledCount = 0;
	        int todayReservations = 0;
	        
	        try {
	            // ���� ���� �����ͷ� ���º� ��� �õ�
	            List<Reservation> allReservations = new ArrayList<>();
	            for (Restaurant restaurant : restaurants) {
	                List<Reservation> reservations = reservationService.findByRestaurantId(restaurant.getRestaurantId());
	                allReservations.addAll(reservations);
	            }
	            
	            if (!allReservations.isEmpty()) {
	                // ���� �����Ͱ� ������ ��Ȯ�� ���
	                LocalDate today = LocalDate.now();
	                for (Reservation reservation : allReservations) {
	                    if (Boolean.TRUE.equals(reservation.getIsCompleted())) {
	                        completedCount++;
	                    } else if (Boolean.TRUE.equals(reservation.getIsCancelled())) {
	                        cancelledCount++;
	                    } else if (Boolean.TRUE.equals(reservation.getIsConfirmed())) {
	                        confirmedCount++;
	                    } else {
	                        pendingCount++;
	                    }
	                    
	                    if (reservation.getReservationDate() != null && 
	                        reservation.getReservationDate().equals(today)) {
	                        todayReservations++;
	                    }
	                }
	            } else {
	                // ���� �����Ͱ� ������ ĳ�õ� ������ �������� ����
	                // ����: ��ü�� 70%�� �Ϸ�, 20%�� Ȯ��, 5%�� ���, 5%�� ���� ����
	                completedCount = (int)(totalReservations * 0.7);
	                confirmedCount = (int)(totalReservations * 0.2);
	                cancelledCount = (int)(totalReservations * 0.05);
	                pendingCount = totalReservations - completedCount - confirmedCount - cancelledCount;
	                todayReservations = 0; // ���� �������̹Ƿ� ���� ������ 0
	            }
	            
	        } catch (Exception e) {
	            System.err.println("���º� �м� ����, �⺻ �й� ���: " + e.getMessage());
	            // �����ϸ� �⺻ �й�
	            completedCount = (int)(totalReservations * 0.7);
	            confirmedCount = (int)(totalReservations * 0.2);
	            cancelledCount = (int)(totalReservations * 0.05);
	            pendingCount = totalReservations - completedCount - confirmedCount - cancelledCount;
	            todayReservations = 0;
	        }
	        
	        stats.put("totalReservations", totalReservations);
	        stats.put("pendingCount", pendingCount);
	        stats.put("confirmedCount", confirmedCount);
	        stats.put("completedCount", completedCount);
	        stats.put("cancelledCount", cancelledCount);
	        stats.put("todayReservations", todayReservations);
	        
	    } catch (Exception e) {
	        System.err.println("���� ��� ���� ����: " + e.getMessage());
	        return getEmptyReservationStats();
	    }
	    
	    return stats;
	}

}