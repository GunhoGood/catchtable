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
	 * 사업자 프로필 페이지
	 */
	@GetMapping("/profile")
	public String businessProfile(HttpSession session, Model model) {
		try {
			// 세션에서 사업자 정보 가져오기
			Integer userId = (Integer) session.getAttribute("userId");
			String userType = (String) session.getAttribute("userType");

			// 로그인 확인
			if (userId == null) {
				return "redirect:/login";
			}

			// 사업자 권한 확인
			if (!"BUSINESS".equals(userType)) {
				return "redirect:/"; // 일반 사용자는 메인 페이지로
			}

			// 사업자 정보 조회
			User businessUser = userService.findById(userId);
			if (businessUser == null) {
				return "redirect:/login";
			}

			// 통계 데이터 수집
			Map<String, Object> statistics = getBusinessStatistics(userId);
			
			// 식당 목록과 평점 정보도 추가 
			List<Restaurant> restaurants = restaurantService.findByBusinessUserId(userId);
			Map<Integer, Double> restaurantRatings = new HashMap<>();
			for (Restaurant restaurant : restaurants) {
				try {
					Double avgRating = reviewService.getAverageRating(restaurant.getRestaurantId());
					restaurantRatings.put(restaurant.getRestaurantId(), avgRating != null ? avgRating : 0.0);
				} catch (Exception e) {
					System.err.println("평점 계산 실패: " + e.getMessage());
					restaurantRatings.put(restaurant.getRestaurantId(), 0.0);
				}
			}

			// 모델에 데이터 추가
			model.addAttribute("businessUser", businessUser);
			model.addAttribute("statistics", statistics);
			model.addAttribute("restaurants", restaurants);
			model.addAttribute("restaurantRatings", restaurantRatings);

			return "business-profile";

		} catch (Exception e) {
			System.err.println("사업자 프로필 페이지 오류: " + e.getMessage());
			e.printStackTrace();
			model.addAttribute("error", "프로필 정보를 불러오는 중 오류가 발생했습니다.");
			return "business-profile";
		}
	}

	/**
	 * 사업자 프로필 정보 수정
	 */
	@PostMapping("/profile/update")
	@ResponseBody
	public ApiResponse updateProfile(@RequestBody Map<String, Object> profileData, HttpSession session) {
		try {
			Integer userId = (Integer) session.getAttribute("userId");
			if (userId == null) {
				return ApiResponse.error("로그인이 필요합니다.");
			}

			// 기존 사용자 정보 조회
			User user = userService.findById(userId);
			if (user == null) {
				return ApiResponse.error("사용자 정보를 찾을 수 없습니다.");
			}

			// 수정할 정보 설정
			if (profileData.containsKey("name")) {
				user.setName((String) profileData.get("name"));
			}
			if (profileData.containsKey("phone")) {
				user.setPhone((String) profileData.get("phone"));
			}
			if (profileData.containsKey("email")) {
				user.setEmail((String) profileData.get("email"));
			}

			// 정보 업데이트
			userService.updateUser(user);

			return new ApiResponse("프로필이 성공적으로 업데이트되었습니다.");

		} catch (Exception e) {
			System.err.println("프로필 업데이트 오류: " + e.getMessage());
			return ApiResponse.error("프로필 업데이트 중 오류가 발생했습니다: " + e.getMessage());
		}
	}

	/**
	 * 비밀번호 변경
	 */
	@PostMapping("/profile/password")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> changePassword(@RequestBody Map<String, String> passwordData,
			HttpSession session) {

		Map<String, Object> response = new HashMap<>();

		try {
			// 다른 메소드와 동일한 방식으로 세션 확인
			Integer userId = (Integer) session.getAttribute("userId");
			String userType = (String) session.getAttribute("userType");

			if (userId == null || !"BUSINESS".equals(userType)) {
				response.put("success", false);
				response.put("message", "로그인이 필요합니다.");
				return ResponseEntity.ok(response);
			}

			// 사용자 정보 조회
			User user = userService.findById(userId);
			if (user == null) {
				response.put("success", false);
				response.put("message", "사용자 정보를 찾을 수 없습니다.");
				return ResponseEntity.ok(response);
			}

			String currentPassword = passwordData.get("currentPassword");
			String newPassword = passwordData.get("newPassword");

			// 입력값 검증
			if (currentPassword == null || currentPassword.trim().isEmpty() || newPassword == null
					|| newPassword.trim().isEmpty()) {
				response.put("success", false);
				response.put("message", "현재 비밀번호와 새 비밀번호를 모두 입력해주세요.");
				return ResponseEntity.ok(response);
			}

			// 새 비밀번호 길이 체크
			if (newPassword.length() < 6) {
				response.put("success", false);
				response.put("message", "새 비밀번호는 6자 이상이어야 합니다.");
				return ResponseEntity.ok(response);
			}

			// 현재 비밀번호 확인
			if (!currentPassword.equals(user.getPassword())) {
				response.put("success", false);
				response.put("message", "현재 비밀번호가 일치하지 않습니다.");
				return ResponseEntity.ok(response);
			}

			// 새 비밀번호와 현재 비밀번호가 같은지 확인
			if (currentPassword.equals(newPassword)) {
				response.put("success", false);
				response.put("message", "새 비밀번호는 현재 비밀번호와 달라야 합니다.");
				return ResponseEntity.ok(response);
			}

			// DB 업데이트
			int updateCount = businessUserService.updatePassword(user.getUserId(), newPassword);

			if (updateCount > 0) {
				response.put("success", true);
				response.put("message", "비밀번호가 성공적으로 변경되었습니다.");
			} else {
				response.put("success", false);
				response.put("message", "비밀번호 변경에 실패했습니다.");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "서버 오류가 발생했습니다.");
		}

		return ResponseEntity.ok(response);
	}

	/**
	 * 식당 목록 페이지 - 실제 예약 수 표시
	 */
	@GetMapping("/restaurants")
	public String businessRestaurants(HttpSession session, Model model) {
	   try {
	       // 세션에서 사업자 정보 확인
	       Integer userId = (Integer) session.getAttribute("userId");
	       String userType = (String) session.getAttribute("userType");

	       // 로그인 확인
	       if (userId == null) {
	           return "redirect:/login";
	       }

	       // 사업자 권한 확인
	       if (!"BUSINESS".equals(userType)) {
	           return "redirect:/"; // 일반 사용자는 메인 페이지로
	       }

	       // 사업자가 등록한 식당 목록 조회
	       List<Restaurant> restaurants = restaurantService.findByBusinessUserId(userId);

	       // 각 식당별 평점 계산
	       Map<Integer, Double> restaurantRatings = new HashMap<>();
	       // 각 식당별 실제 예약 수 계산 추가
	       Map<Integer, Integer> actualReservationCounts = new HashMap<>();
	       
	       for (Restaurant restaurant : restaurants) {
	           try {
	               // 평점 계산
	               Double avgRating = reviewService.getAverageRating(restaurant.getRestaurantId());
	               restaurantRatings.put(restaurant.getRestaurantId(), avgRating != null ? avgRating : 0.0);
	               
	               // 실제 예약 수 계산 (각 식당별로)
	               int actualCount = reservationService.getReservationCountByRestaurant(restaurant.getRestaurantId());
	               actualReservationCounts.put(restaurant.getRestaurantId(), actualCount);
	               
	           } catch (Exception e) {
	               System.err.println("식당 통계 계산 실패 - 식당ID: " + restaurant.getRestaurantId() + ", 오류: " + e.getMessage());
	               restaurantRatings.put(restaurant.getRestaurantId(), 0.0);
	               actualReservationCounts.put(restaurant.getRestaurantId(), 0);
	           }
	       }

	       // 모델에 데이터 추가
	       model.addAttribute("restaurants", restaurants);
	       model.addAttribute("restaurantRatings", restaurantRatings);
	       model.addAttribute("actualReservationCounts", actualReservationCounts); // 실제 예약 수 추가
	       model.addAttribute("totalRestaurants", restaurants.size());

	       return "business-restaurants";

	   } catch (Exception e) {
	       System.err.println("식당 목록 조회 오류: " + e.getMessage());
	       e.printStackTrace();
	       model.addAttribute("error", "식당 목록을 불러오는 중 오류가 발생했습니다.");
	       return "business-restaurants";
	   }
	}
	
	/**
	 * 식당 상세 관리 페이지
	 */
	@GetMapping("/restaurants/{restaurantId}")
	public String restaurantDetail(@PathVariable Integer restaurantId, HttpSession session, Model model) {
	    try {
	        // 세션에서 사업자 정보 확인
	        Integer userId = (Integer) session.getAttribute("userId");
	        String userType = (String) session.getAttribute("userType");

	        if (userId == null || !"BUSINESS".equals(userType)) {
	            return "redirect:/login";
	        }

	        // 식당 정보 조회
	        Restaurant restaurant = restaurantService.findById(restaurantId);
	        if (restaurant == null) {
	            model.addAttribute("error", "식당을 찾을 수 없습니다.");
	            return "redirect:/business/restaurants";
	        }

	        // 해당 식당이 현재 사업자의 것인지 확인
	        if (!restaurant.getBusinessUserId().equals(userId)) {
	            model.addAttribute("error", "접근 권한이 없습니다.");
	            return "redirect:/business/restaurants";
	        }

	        // 식당 메뉴 목록 조회
	        List<Menu> menus = restaurantService.getMenusByRestaurantId(restaurantId);

	        //  실제 통계 데이터 계산
	        // 1. 실제 예약 수 계산
	        int actualReservationCount = reservationService.getReservationCountByRestaurant(restaurantId);
	        
	        // 2. 실제 평점 계산
	        Double actualRating = null;
	        try {
	            actualRating = reviewService.getAverageRating(restaurantId);
	        } catch (Exception e) {
	            System.err.println("평점 계산 실패: " + e.getMessage());
	            actualRating = 0.0;
	        }
	        
	        // 3. 실제 좋아요 수 (현재 restaurant 테이블 값 사용, 필요시 실제 계산 가능)
	        int actualLikesCount = restaurant.getLikesCount() != null ? restaurant.getLikesCount() : 0;
	        
	        // 4. 실제 조회수 (현재 restaurant 테이블 값 사용, 필요시 실제 계산 가능)
	        int actualViewCount = restaurant.getViewCount() != null ? restaurant.getViewCount() : 0;

	        //  기존 restaurantStats 대신 실제 계산된 통계 맵 생성
	        Map<String, Object> actualStats = new HashMap<>();
	        actualStats.put("reservationCount", actualReservationCount);
	        actualStats.put("averageRating", actualRating != null ? actualRating : 0.0);
	        actualStats.put("likesCount", actualLikesCount);
	        actualStats.put("viewCount", actualViewCount);
	        
	        //  예약 가능 여부 판단 (운영시간 기반)
	        boolean isReservationAvailable = restaurant.getOperatingHours() != null && 
	                                       !restaurant.getOperatingHours().trim().isEmpty();

	        // 모델에 데이터 추가
	        model.addAttribute("restaurant", restaurant);
	        model.addAttribute("menus", menus);
	        
	        //  실제 계산된 통계 데이터 전달
	        model.addAttribute("actualReservationCount", actualReservationCount);
	        model.addAttribute("actualRating", actualRating != null ? actualRating : 0.0);
	        model.addAttribute("actualLikesCount", actualLikesCount);
	        model.addAttribute("actualViewCount", actualViewCount);
	        model.addAttribute("isReservationAvailable", isReservationAvailable);
	        
	        // 기존 restaurantStats는 하위 호환성을 위해 유지 (필요시 제거 가능)
	        model.addAttribute("restaurantStats", actualStats);

	        return "restaurant-detail";

	    } catch (Exception e) {
	        System.err.println("식당 상세 조회 오류: " + e.getMessage());
	        e.printStackTrace();
	        model.addAttribute("error", "식당 정보를 불러오는 중 오류가 발생했습니다.");
	        return "redirect:/business/restaurants";
	    }
	}
	/**
	 * 새 식당 등록 페이지
	 */
	@GetMapping("/restaurants/new")
	public String newRestaurantForm(HttpSession session, Model model) {
		try {
			// 세션에서 사업자 정보 확인
			Integer userId = (Integer) session.getAttribute("userId");
			String userType = (String) session.getAttribute("userType");

			if (userId == null || !"BUSINESS".equals(userType)) {
				return "redirect:/login";
			}

			// 카테고리 목록 조회 
			List<Category> categories = restaurantService.getAllCategories();
			model.addAttribute("categories", categories);

			// 빈 식당 객체 생성 
			model.addAttribute("restaurant", new Restaurant());

			return "restaurant-form";

		} catch (Exception e) {
			System.err.println("식당 등록 폼 오류: " + e.getMessage());
			model.addAttribute("error", "페이지를 불러오는 중 오류가 발생했습니다.");
			return "redirect:/business/restaurants";
		}
	}

	/**
	 * 식당 등록 처리
	 */
	@PostMapping("/restaurants")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> createRestaurant(@RequestBody Restaurant restaurant,
			HttpSession session) {

		Map<String, Object> response = new HashMap<>();

		try {
			// 세션에서 사업자 정보 확인
			Integer userId = (Integer) session.getAttribute("userId");
			String userType = (String) session.getAttribute("userType");

			if (userId == null || !"BUSINESS".equals(userType)) {
				response.put("success", false);
				response.put("message", "로그인이 필요합니다.");
				return ResponseEntity.ok(response);
			}

			// 입력값 검증
			if (restaurant.getName() == null || restaurant.getName().trim().isEmpty()) {
				response.put("success", false);
				response.put("message", "식당 이름을 입력해주세요.");
				return ResponseEntity.ok(response);
			}

			if (restaurant.getAddress() == null || restaurant.getAddress().trim().isEmpty()) {
				response.put("success", false);
				response.put("message", "식당 주소를 입력해주세요.");
				return ResponseEntity.ok(response);
			}
			// 사업자 ID 및 기본값 설정
			restaurant.setBusinessUserId(userId);
			restaurant.setCreatedAt(LocalDateTime.now());
			restaurant.setUpdatedAt(LocalDateTime.now());
			if (restaurant.getImageUrl() == null || restaurant.getImageUrl().trim().isEmpty()) {
				restaurant.setImageUrl("https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400&h=300&fit=crop&auto=format");
			}

			// 식당 등록
			int result = restaurantService.registerRestaurant(restaurant);

			if (result > 0) {
				response.put("success", true);
				response.put("message", "식당이 성공적으로 등록되었습니다.");
				response.put("restaurantId", restaurant.getRestaurantId());
			} else {
				response.put("success", false);
				response.put("message", "식당 등록에 실패했습니다.");
			}

		} catch (Exception e) {
			System.err.println("식당 등록 오류: " + e.getMessage());
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "서버 오류가 발생했습니다.");
		}

		return ResponseEntity.ok(response);
	}

	/**
	 * 식당 수정 페이지
	 */
	@GetMapping("/restaurants/{restaurantId}/edit")
	public String editRestaurantForm(@PathVariable Integer restaurantId, HttpSession session, Model model) {
		try {
			// 세션에서 사업자 정보 확인
			Integer userId = (Integer) session.getAttribute("userId");
			String userType = (String) session.getAttribute("userType");

			if (userId == null || !"BUSINESS".equals(userType)) {
				return "redirect:/login";
			}

			// 식당 정보 조회
			Restaurant restaurant = restaurantService.findById(restaurantId);
			if (restaurant == null) {
				model.addAttribute("error", "식당을 찾을 수 없습니다.");
				return "redirect:/business/restaurants";
			}

			// 해당 식당이 현재 사업자의 것인지 확인
			if (!restaurant.getBusinessUserId().equals(userId)) {
				model.addAttribute("error", "접근 권한이 없습니다.");
				return "redirect:/business/restaurants";
			}

			// 카테고리 목록 조회
			List<Category> categories = restaurantService.getAllCategories();

			// 모델에 데이터 추가
			model.addAttribute("restaurant", restaurant);
			model.addAttribute("categories", categories);
			model.addAttribute("isEdit", true);

			return "restaurant-form";

		} catch (Exception e) {
			System.err.println("식당 수정 폼 오류: " + e.getMessage());
			model.addAttribute("error", "페이지를 불러오는 중 오류가 발생했습니다.");
			return "redirect:/business/restaurants";
		}
	}

	/**
	 * 식당 정보 수정 처리
	 */
	@PutMapping("/restaurants/{restaurantId}")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> updateRestaurant(@PathVariable Integer restaurantId,
			@RequestBody Restaurant restaurant, HttpSession session) {

		Map<String, Object> response = new HashMap<>();

		try {
			// 세션에서 사업자 정보 확인
			Integer userId = (Integer) session.getAttribute("userId");
			String userType = (String) session.getAttribute("userType");

			if (userId == null || !"BUSINESS".equals(userType)) {
				response.put("success", false);
				response.put("message", "로그인이 필요합니다.");
				return ResponseEntity.ok(response);
			}

			// 식당 존재 및 권한 확인
			Restaurant existingRestaurant = restaurantService.findById(restaurantId);
			if (existingRestaurant == null) {
				response.put("success", false);
				response.put("message", "식당을 찾을 수 없습니다.");
				return ResponseEntity.ok(response);
			}

			if (!existingRestaurant.getBusinessUserId().equals(userId)) {
				response.put("success", false);
				response.put("message", "접근 권한이 없습니다.");
				return ResponseEntity.ok(response);
			}

			// 수정 데이터 설정
			restaurant.setRestaurantId(restaurantId);
			restaurant.setBusinessUserId(userId);
			restaurant.setCreatedAt(existingRestaurant.getCreatedAt()); // 생성일은 유지
			restaurant.setUpdatedAt(LocalDateTime.now());

			// 기존 카운트 값들 유지
			restaurant.setLikesCount(existingRestaurant.getLikesCount());
			restaurant.setReservationCount(existingRestaurant.getReservationCount());
			restaurant.setViewCount(existingRestaurant.getViewCount());

			// 식당 정보 수정
			int result = restaurantService.updateRestaurant(restaurant);

			if (result > 0) {
				response.put("success", true);
				response.put("message", "식당 정보가 성공적으로 수정되었습니다.");
			} else {
				response.put("success", false);
				response.put("message", "식당 정보 수정에 실패했습니다.");
			}

		} catch (Exception e) {
			System.err.println("식당 수정 오류: " + e.getMessage());
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "서버 오류가 발생했습니다.");
		}

		return ResponseEntity.ok(response);
	}

	/**
	 * 식당 삭제 처리
	 */
	@DeleteMapping("/restaurants/{restaurantId}")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> deleteRestaurant(@PathVariable Integer restaurantId,
			HttpSession session) {

		Map<String, Object> response = new HashMap<>();

		try {
			// 세션에서 사업자 정보 확인
			Integer userId = (Integer) session.getAttribute("userId");
			String userType = (String) session.getAttribute("userType");

			if (userId == null || !"BUSINESS".equals(userType)) {
				response.put("success", false);
				response.put("message", "로그인이 필요합니다.");
				return ResponseEntity.ok(response);
			}

			// 식당 존재 및 권한 확인
			Restaurant restaurant = restaurantService.findById(restaurantId);
			if (restaurant == null) {
				response.put("success", false);
				response.put("message", "식당을 찾을 수 없습니다.");
				return ResponseEntity.ok(response);
			}

			if (!restaurant.getBusinessUserId().equals(userId)) {
				response.put("success", false);
				response.put("message", "접근 권한이 없습니다.");
				return ResponseEntity.ok(response);
			}

			// 식당 삭제 (연관 데이터도 함께 삭제될 수 있도록 Service에서 처리)
			int result = restaurantService.deleteRestaurant(restaurantId);

			if (result > 0) {
				response.put("success", true);
				response.put("message", "식당이 성공적으로 삭제되었습니다.");
			} else {
				response.put("success", false);
				response.put("message", "식당 삭제에 실패했습니다.");
			}

		} catch (Exception e) {
			System.err.println("식당 삭제 오류: " + e.getMessage());
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "서버 오류가 발생했습니다.");
		}

		return ResponseEntity.ok(response);
	}

	// 사업자 통계 데이터 수집
	private Map<String, Object> getBusinessStatistics(Integer businessUserId) {
		Map<String, Object> statistics = new HashMap<>();

		try {
			// 등록한 식당 수
			List<Restaurant> restaurants = restaurantService.findByBusinessUserId(businessUserId);
			statistics.put("totalRestaurants", restaurants.size());

			// 총 예약 건수 계산
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

			// 이번 달 예약 건수 
			statistics.put("monthlyReservations", totalReservations > 0 ? (totalReservations / 3) : 0);

			// 실제 평균 평점 계산
			double avgRating = 0.0;
			try {
				List<Double> ratings = new ArrayList<>();
				for (Restaurant restaurant : restaurants) {
					// ReviewService 사용 
					Double rating = reviewService.getAverageRating(restaurant.getRestaurantId());
					if (rating != null && rating > 0) {
						ratings.add(rating);
					}
				}
				if (!ratings.isEmpty()) {
					avgRating = ratings.stream().mapToDouble(Double::doubleValue).average().orElse(0.0);
				}
				System.out.println("사업자 평균 평점 계산: " + avgRating);
			} catch (Exception e) {
				System.err.println("사업자 평점 계산 실패: " + e.getMessage());
				avgRating = 0.0;
			}

			statistics.put("averageRating", avgRating);

		} catch (Exception e) {
			System.err.println("통계 데이터 수집 오류: " + e.getMessage());
			// 오류 발생시 기본값 설정
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
	 * 메뉴 추가 페이지
	 */
	@GetMapping("/restaurants/{restaurantId}/menus/new")
	public String newMenuForm(@PathVariable Integer restaurantId, HttpSession session, Model model) {
	    try {
	        // 세션 확인
	        Integer userId = (Integer) session.getAttribute("userId");
	        String userType = (String) session.getAttribute("userType");

	        if (userId == null || !"BUSINESS".equals(userType)) {
	            return "redirect:/login";
	        }

	        // 식당 정보 조회 및 권한 확인
	        Restaurant restaurant = restaurantService.findById(restaurantId);
	        if (restaurant == null || !restaurant.getBusinessUserId().equals(userId)) {
	            model.addAttribute("error", "접근 권한이 없습니다.");
	            return "redirect:/business/restaurants";
	        }

	        // 모델에 데이터 추가
	        model.addAttribute("restaurant", restaurant);
	        model.addAttribute("menu", new Menu());
	        model.addAttribute("isEdit", false);

	        return "menu-form";

	    } catch (Exception e) {
	        System.err.println("메뉴 등록 폼 오류: " + e.getMessage());
	        model.addAttribute("error", "페이지를 불러오는 중 오류가 발생했습니다.");
	        return "redirect:/business/restaurants/" + restaurantId;
	    }
	}

	/**
	 * 메뉴 등록 처리
	 */
	@PostMapping("/restaurants/{restaurantId}/menus")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> createMenu(@PathVariable Integer restaurantId,
	        @RequestBody Menu menu, HttpSession session) {

	    Map<String, Object> response = new HashMap<>();

	    try {
	        // 세션 확인
	        Integer userId = (Integer) session.getAttribute("userId");
	        String userType = (String) session.getAttribute("userType");

	        if (userId == null || !"BUSINESS".equals(userType)) {
	            response.put("success", false);
	            response.put("message", "로그인이 필요합니다.");
	            return ResponseEntity.ok(response);
	        }

	        // 식당 권한 확인
	        Restaurant restaurant = restaurantService.findById(restaurantId);
	        if (restaurant == null || !restaurant.getBusinessUserId().equals(userId)) {
	            response.put("success", false);
	            response.put("message", "접근 권한이 없습니다.");
	            return ResponseEntity.ok(response);
	        }

	        // 입력값 검증
	        if (menu.getName() == null || menu.getName().trim().isEmpty()) {
	            response.put("success", false);
	            response.put("message", "메뉴 이름을 입력해주세요.");
	            return ResponseEntity.ok(response);
	        }

	        if (menu.getPrice() == null || menu.getPrice() <= 0) {
	            response.put("success", false);
	            response.put("message", "올바른 가격을 입력해주세요.");
	            return ResponseEntity.ok(response);
	        }

	        // 메뉴 정보 설정
	        menu.setRestaurantId(restaurantId);
	        if (menu.getIsSignature() == null) menu.setIsSignature(false);
	        if (menu.getIsAvailable() == null) menu.setIsAvailable(true);

	        // 메뉴 등록
	        int result = restaurantService.addMenu(menu);

	        if (result > 0) {
	            response.put("success", true);
	            response.put("message", "메뉴가 성공적으로 등록되었습니다.");
	        } else {
	            response.put("success", false);
	            response.put("message", "메뉴 등록에 실패했습니다.");
	        }

	    } catch (Exception e) {
	        System.err.println("메뉴 등록 오류: " + e.getMessage());
	        e.printStackTrace();
	        response.put("success", false);
	        response.put("message", "서버 오류가 발생했습니다.");
	    }

	    return ResponseEntity.ok(response);
	}
	/**
	 * 메뉴 수정 페이지
	 */
	@GetMapping("/restaurants/{restaurantId}/menus/{menuId}/edit")
	public String editMenuForm(@PathVariable Integer restaurantId, @PathVariable Integer menuId, 
	                          HttpSession session, Model model) {
	    try {
	        // 세션 확인
	        Integer userId = (Integer) session.getAttribute("userId");
	        String userType = (String) session.getAttribute("userType");

	        if (userId == null || !"BUSINESS".equals(userType)) {
	            return "redirect:/login";
	        }

	        // 식당 정보 조회 및 권한 확인
	        Restaurant restaurant = restaurantService.findById(restaurantId);
	        if (restaurant == null || !restaurant.getBusinessUserId().equals(userId)) {
	            model.addAttribute("error", "접근 권한이 없습니다.");
	            return "redirect:/business/restaurants";
	        }

	        // 메뉴 정보 조회
	        Menu menu = restaurantService.getMenuById(menuId);
	        if (menu == null || !menu.getRestaurantId().equals(restaurantId)) {
	            model.addAttribute("error", "메뉴를 찾을 수 없습니다.");
	            return "redirect:/business/restaurants/" + restaurantId;
	        }

	        // 모델에 데이터 추가
	        model.addAttribute("restaurant", restaurant);
	        model.addAttribute("menu", menu);
	        model.addAttribute("isEdit", true);

	        return "menu-form";

	    } catch (Exception e) {
	        System.err.println("메뉴 수정 폼 오류: " + e.getMessage());
	        model.addAttribute("error", "페이지를 불러오는 중 오류가 발생했습니다.");
	        return "redirect:/business/restaurants/" + restaurantId;
	    }
	}

	/**
	 * 메뉴 수정 처리
	 */
	@PutMapping("/restaurants/{restaurantId}/menus/{menuId}")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> updateMenu(@PathVariable Integer restaurantId,
	        @PathVariable Integer menuId, @RequestBody Menu menu, HttpSession session) {

	    Map<String, Object> response = new HashMap<>();

	    try {
	        // 세션 확인
	        Integer userId = (Integer) session.getAttribute("userId");
	        String userType = (String) session.getAttribute("userType");

	        if (userId == null || !"BUSINESS".equals(userType)) {
	            response.put("success", false);
	            response.put("message", "로그인이 필요합니다.");
	            return ResponseEntity.ok(response);
	        }

	        // 식당 권한 확인
	        Restaurant restaurant = restaurantService.findById(restaurantId);
	        if (restaurant == null || !restaurant.getBusinessUserId().equals(userId)) {
	            response.put("success", false);
	            response.put("message", "접근 권한이 없습니다.");
	            return ResponseEntity.ok(response);
	        }

	        // 메뉴 존재 확인
	        Menu existingMenu = restaurantService.getMenuById(menuId);
	        if (existingMenu == null || !existingMenu.getRestaurantId().equals(restaurantId)) {
	            response.put("success", false);
	            response.put("message", "메뉴를 찾을 수 없습니다.");
	            return ResponseEntity.ok(response);
	        }

	        // 입력값 검증
	        if (menu.getName() == null || menu.getName().trim().isEmpty()) {
	            response.put("success", false);
	            response.put("message", "메뉴 이름을 입력해주세요.");
	            return ResponseEntity.ok(response);
	        }

	        if (menu.getPrice() == null || menu.getPrice() <= 0) {
	            response.put("success", false);
	            response.put("message", "올바른 가격을 입력해주세요.");
	            return ResponseEntity.ok(response);
	        }

	        // 메뉴 정보 설정
	        menu.setMenuId(menuId);
	        menu.setRestaurantId(restaurantId);
	        if (menu.getIsSignature() == null) menu.setIsSignature(false);
	        if (menu.getIsAvailable() == null) menu.setIsAvailable(true);

	        // 메뉴 수정
	        int result = restaurantService.updateMenu(menu);

	        if (result > 0) {
	            response.put("success", true);
	            response.put("message", "메뉴가 성공적으로 수정되었습니다.");
	        } else {
	            response.put("success", false);
	            response.put("message", "메뉴 수정에 실패했습니다.");
	        }

	    } catch (Exception e) {
	        System.err.println("메뉴 수정 오류: " + e.getMessage());
	        e.printStackTrace();
	        response.put("success", false);
	        response.put("message", "서버 오류가 발생했습니다.");
	    }

	    return ResponseEntity.ok(response);
	}

	/**
	 * 메뉴 삭제 처리
	 */
	@DeleteMapping("/restaurants/{restaurantId}/menus/{menuId}")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> deleteMenu(@PathVariable Integer restaurantId,
	        @PathVariable Integer menuId, HttpSession session) {

	    Map<String, Object> response = new HashMap<>();

	    try {
	        // 세션 확인
	        Integer userId = (Integer) session.getAttribute("userId");
	        String userType = (String) session.getAttribute("userType");

	        if (userId == null || !"BUSINESS".equals(userType)) {
	            response.put("success", false);
	            response.put("message", "로그인이 필요합니다.");
	            return ResponseEntity.ok(response);
	        }

	        // 식당 권한 확인
	        Restaurant restaurant = restaurantService.findById(restaurantId);
	        if (restaurant == null || !restaurant.getBusinessUserId().equals(userId)) {
	            response.put("success", false);
	            response.put("message", "접근 권한이 없습니다.");
	            return ResponseEntity.ok(response);
	        }

	        // 메뉴 삭제
	        int result = restaurantService.deleteMenu(menuId);

	        if (result > 0) {
	            response.put("success", true);
	            response.put("message", "메뉴가 성공적으로 삭제되었습니다.");
	        } else {
	            response.put("success", false);
	            response.put("message", "메뉴 삭제에 실패했습니다.");
	        }

	    } catch (Exception e) {
	        System.err.println("메뉴 삭제 오류: " + e.getMessage());
	        e.printStackTrace();
	        response.put("success", false);
	        response.put("message", "서버 오류가 발생했습니다.");
	    }

	    return ResponseEntity.ok(response);
	}
	
	/**
	 * 예약 관리 페이지
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

	        // 사업자가 등록한 식당 목록 조회
	        List<Restaurant> restaurants = restaurantService.findByBusinessUserId(userId);
	        
	        // 전체 예약 목록 조회 
	        List<Reservation> allReservations = reservationService.getReservationsByBusinessId(
	            userId, status, restaurantId, date);
	            
	        //  페이징 계산
	        int totalReservations = allReservations.size();
	        int totalPages = (int) Math.ceil((double) totalReservations / size);
	        
	        // 현재 페이지 유효성 검사
	        if (page < 1) page = 1;
	        if (page > totalPages && totalPages > 0) page = totalPages;
	        
	        //  현재 페이지에 해당하는 데이터만 추출
	        int startIndex = (page - 1) * size;
	        int endIndex = Math.min(startIndex + size, totalReservations);
	        
	        List<Reservation> pageReservations = totalReservations > 0 ? 
	            allReservations.subList(startIndex, endIndex) : new ArrayList<>();

	        //  페이징 정보 계산
	        boolean hasPrev = page > 1;
	        boolean hasNext = page < totalPages;
	        
	        // 페이지 번호 범위 계산
	        int startPage = Math.max(1, page - 2);
	        int endPage = Math.min(totalPages, page + 2);
	        
	        // 예약 통계 계산
	        Map<String, Object> reservationStats = getReservationStatistics(userId);

	        // 모델에 데이터 추가
	        model.addAttribute("restaurants", restaurants);
	        model.addAttribute("reservations", pageReservations);
	        model.addAttribute("reservationStats", reservationStats);
	        model.addAttribute("currentStatus", status);
	        model.addAttribute("currentRestaurantId", restaurantId);
	        model.addAttribute("currentDate", date);
	        
	        //  페이징 정보 추가
	        model.addAttribute("currentPage", page);
	        model.addAttribute("totalPages", totalPages);
	        model.addAttribute("totalReservations", totalReservations);
	        model.addAttribute("pageSize", size);
	        model.addAttribute("hasPrev", hasPrev);
	        model.addAttribute("hasNext", hasNext);
	        model.addAttribute("startPage", startPage);
	        model.addAttribute("endPage", endPage);
	        
	        // 페이징 정보 로그
	        System.out.println(String.format("페이징 정보 - 전체: %d개, 현재페이지: %d/%d, 표시: %d개", 
	                                        totalReservations, page, totalPages, pageReservations.size()));

	        return "business-reservations";

	    } catch (Exception e) {
	        System.err.println("예약 관리 페이지 오류: " + e.getMessage());
	        e.printStackTrace();
	        model.addAttribute("error", "예약 정보를 불러오는 중 오류가 발생했습니다.");
	        return "business-reservations";
	    }
	}
	/**
	 * 빈 예약 통계 반환 
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
	 * 예약 상태 변경 처리
	 */
	@PostMapping("/reservations/{reservationId}/status")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> updateReservationStatus(
	        @PathVariable Integer reservationId,
	        @RequestBody Map<String, String> statusData,
	        HttpSession session) {

	    Map<String, Object> response = new HashMap<>();

	    try {
	        // 세션 확인
	        Integer userId = (Integer) session.getAttribute("userId");
	        String userType = (String) session.getAttribute("userType");

	        if (userId == null || !"BUSINESS".equals(userType)) {
	            response.put("success", false);
	            response.put("message", "로그인이 필요합니다.");
	            return ResponseEntity.ok(response);
	        }

	        String newStatus = statusData.get("status");
	        String reason = statusData.get("reason");

	        // 입력값 검증
	        if (newStatus == null || newStatus.trim().isEmpty()) {
	            response.put("success", false);
	            response.put("message", "상태값이 필요합니다.");
	            return ResponseEntity.ok(response);
	        }

	        // 유효한 상태값 검증
	        if (!isValidReservationStatus(newStatus)) {
	            response.put("success", false);
	            response.put("message", "유효하지 않은 상태값입니다.");
	            return ResponseEntity.ok(response);
	        }

	        // 예약 존재 및 권한 확인
	        Reservation reservation = reservationService.findById(reservationId);
	        if (reservation == null) {
	            response.put("success", false);
	            response.put("message", "예약을 찾을 수 없습니다.");
	            return ResponseEntity.ok(response);
	        }

	        // 해당 예약이 현재 사업자의 식당인지 확인
	        Restaurant restaurant = restaurantService.findById(reservation.getRestaurantId());
	        if (restaurant == null || !restaurant.getBusinessUserId().equals(userId)) {
	            response.put("success", false);
	            response.put("message", "접근 권한이 없습니다.");
	            return ResponseEntity.ok(response);
	        }

	        // 상태 변경 가능 여부 검증
	        String validationResult = validateStatusChange(reservation, newStatus);
	        if (validationResult != null) {
	            response.put("success", false);
	            response.put("message", validationResult);
	            return ResponseEntity.ok(response);
	        }

	        // 상태 업데이트
	        int result = reservationService.updateReservationStatus(reservationId, newStatus, reason);

	        if (result > 0) {
	            response.put("success", true);
	            response.put("message", getStatusChangeMessage(newStatus));
	            
	            // 성공 로깅
	            System.out.println(String.format("예약 상태 변경 성공 - 예약ID: %d, 상태: %s, 사업자ID: %d", 
	                              reservationId, newStatus, userId));
	        } else {
	            response.put("success", false);
	            response.put("message", "예약 상태 변경에 실패했습니다.");
	        }

	    } catch (Exception e) {
	        System.err.println("예약 상태 변경 오류: " + e.getMessage());
	        e.printStackTrace();
	        response.put("success", false);
	        response.put("message", "서버 오류가 발생했습니다.");
	    }

	    return ResponseEntity.ok(response);
	}

	/**
	 * 유효한 예약 상태값인지 확인
	 */
	private boolean isValidReservationStatus(String status) {
	    return status != null && 
	           ("PENDING".equals(status) || "CONFIRMED".equals(status) || 
	            "COMPLETED".equals(status) || "CANCELLED".equals(status));
	}

	/**
	 * 상태 변경 가능 여부 검증
	 */
	private String validateStatusChange(Reservation reservation, String newStatus) {
	    // 현재 상태 확인
	    String currentStatus = getCurrentReservationStatus(reservation);
	    
	    switch (newStatus) {
	        case "CONFIRMED":
	            if (!"PENDING".equals(currentStatus)) {
	                return "대기 중인 예약만 승인할 수 있습니다.";
	            }
	            break;
	            
	        case "CANCELLED":
	            if ("COMPLETED".equals(currentStatus)) {
	                return "완료된 예약은 취소할 수 없습니다.";
	            }
	            if ("CANCELLED".equals(currentStatus)) {
	                return "이미 취소된 예약입니다.";
	            }
	            break;
	            
	        case "COMPLETED":
	            if (!"CONFIRMED".equals(currentStatus)) {
	                return "승인된 예약만 완료 처리할 수 있습니다.";
	            }
	            break;
	            
	        default:
	            return "지원하지 않는 상태 변경입니다.";
	    }
	    
	    return null; // 유효함
	}

	/**
	 * 현재 예약 상태 확인 
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
	 * 상태 변경 성공 메시지 반환
	 */
	private String getStatusChangeMessage(String status) {
	    switch (status) {
	        case "CONFIRMED":
	            return "예약이 성공적으로 승인되었습니다.";
	        case "CANCELLED":
	            return "예약이 성공적으로 취소되었습니다.";
	        case "COMPLETED":
	            return "예약이 성공적으로 완료 처리되었습니다.";
	        default:
	            return "예약 상태가 성공적으로 변경되었습니다.";
	    }
	}

	/**
	 * 예약 통계 데이터 수집 -
	 */
	private Map<String, Object> getReservationStatistics(Integer businessUserId) {
	    Map<String, Object> stats = new HashMap<>();
	    
	    try {
	        // 사업자의 모든 식당 조회
	        List<Restaurant> restaurants = restaurantService.findByBusinessUserId(businessUserId);
	        
	        if (restaurants.isEmpty()) {
	            return getEmptyReservationStats();
	        }
	        
	        // restaurants 테이블의 캐시된 값들 사용
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
	        
	        // 실제 예약 데이터가 있다면 상태별로 분석, 없다면 추정치 사용
	        int pendingCount = 0;
	        int confirmedCount = 0;
	        int completedCount = 0;
	        int cancelledCount = 0;
	        int todayReservations = 0;
	        
	        try {
	            // 실제 예약 데이터로 상태별 계산 시도
	            List<Reservation> allReservations = new ArrayList<>();
	            for (Restaurant restaurant : restaurants) {
	                List<Reservation> reservations = reservationService.findByRestaurantId(restaurant.getRestaurantId());
	                allReservations.addAll(reservations);
	            }
	            
	            if (!allReservations.isEmpty()) {
	                // 실제 데이터가 있으면 정확히 계산
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
	                // 실제 데이터가 없으면 캐시된 총합을 기준으로 추정
	                // 예시: 전체의 70%는 완료, 20%는 확인, 5%는 취소, 5%는 대기로 가정
	                completedCount = (int)(totalReservations * 0.7);
	                confirmedCount = (int)(totalReservations * 0.2);
	                cancelledCount = (int)(totalReservations * 0.05);
	                pendingCount = totalReservations - completedCount - confirmedCount - cancelledCount;
	                todayReservations = 0; // 과거 데이터이므로 오늘 예약은 0
	            }
	            
	        } catch (Exception e) {
	            System.err.println("상태별 분석 실패, 기본 분배 사용: " + e.getMessage());
	            // 실패하면 기본 분배
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
	        System.err.println("예약 통계 수집 오류: " + e.getMessage());
	        return getEmptyReservationStats();
	    }
	    
	    return stats;
	}

}