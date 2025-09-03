package com.myproject.catchtable.controller;

import com.myproject.catchtable.dto.ApiResponse;
import com.myproject.catchtable.model.User;
import com.myproject.catchtable.model.Restaurant;
import com.myproject.catchtable.model.Review;
import com.myproject.catchtable.model.Category;
import com.myproject.catchtable.model.Coupon;
import com.myproject.catchtable.model.Reservation;
import com.myproject.catchtable.model.UserPreferences;
import com.myproject.catchtable.service.UserService;
import com.myproject.catchtable.service.RestaurantService;
import com.myproject.catchtable.service.ReviewService;
import com.myproject.catchtable.service.CategoryService;
import com.myproject.catchtable.service.CouponService;
import com.myproject.catchtable.service.ReservationService;
import com.myproject.catchtable.service.UserPreferencesService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin")
public class AdminController {

	@Autowired
	private UserService userService;

	@Autowired
	private RestaurantService restaurantService;

	@Autowired
	private CategoryService categoryService;

	@Autowired
	private CouponService couponService;

	@Autowired
	private UserPreferencesService userPreferencesService;
	
	@Autowired
	private ReviewService reviewService;
	
	@Autowired
	private ReservationService reservationService;
	
	

	// 관리자 대시보드
	@GetMapping("/dashboard")
	public String dashboard(Model model) {
		try {
			// 기본 통계 데이터
			List<User> allUsers = userService.getAllUsers();
			List<User> pendingBusinessUsers = userService.getPendingBusinessUsers();
			List<Restaurant> allRestaurants = restaurantService.findAll();
			List<Category> allCategories = categoryService.findAll();

			// 통계 계산
			int totalUsers = 0;
			int totalBusinessUsers = 0;
			for (User user : allUsers) {
				if ("USER".equals(user.getUserType())) {
					totalUsers++;
				} else if ("BUSINESS".equals(user.getUserType())) {
					totalBusinessUsers++;
				}
			}

			int pendingApprovals = pendingBusinessUsers.size();
			int totalRestaurants = allRestaurants.size();
			int totalCategories = allCategories.size();

			// 최근 가입 사용자
			List<User> recentUsers = allUsers;
			if (recentUsers.size() > 5) {
				recentUsers = recentUsers.subList(0, 5);
			}

			// 모델에 데이터 추가
			model.addAttribute("totalUsers", totalUsers);
			model.addAttribute("totalBusinessUsers", totalBusinessUsers);
			model.addAttribute("pendingApprovals", pendingApprovals);
			model.addAttribute("totalRestaurants", totalRestaurants);
			model.addAttribute("totalCategories", totalCategories);
			model.addAttribute("recentUsers", recentUsers);
			model.addAttribute("pendingBusinessUsers", pendingBusinessUsers);

			return "admin";

		} catch (Exception e) {
			model.addAttribute("error", "대시보드 데이터 로딩 중 오류가 발생했습니다.");
			return "admin";
		}
	}

	// 사업자 승인 관리 페이지
	@GetMapping("/approve-business")
	public String approveBusinessPage(Model model) {
		List<User> pendingUsers = userService.getPendingBusinessUsers();
		model.addAttribute("pendingUsers", pendingUsers);
		model.addAttribute("pendingCount", pendingUsers.size());
		return "approve-business";
	}

	// 사업자 승인 처리
	@PostMapping("/approve-business/{userId}")
	@ResponseBody
	public ApiResponse approveBusiness(@PathVariable Integer userId) {
		try {
			userService.approveBusiness(userId);
			return new ApiResponse("사업자가 승인되었습니다.");

		} catch (Exception e) {
			return ApiResponse.error("승인 처리 중 오류가 발생했습니다: " + e.getMessage());
		}
	}

	// 사업자 거부 처리
	@PostMapping("/reject-business/{userId}")
	@ResponseBody
	public ApiResponse rejectBusiness(@PathVariable Integer userId, @RequestParam String rejectionReason) {
		try {
			if (rejectionReason == null || rejectionReason.trim().isEmpty()) {
				return ApiResponse.error("거부 사유는 필수입니다.");
			}

			userService.rejectBusiness(userId, rejectionReason);
			return new ApiResponse("사업자 신청이 거부되었습니다.");

		} catch (Exception e) {
			return ApiResponse.error("거부 처리 중 오류가 발생했습니다: " + e.getMessage());
		}
	}



	// 사용자 관리 페이지
	@GetMapping("/users")
	public String manageUsers(Model model) {
		try {
			// 기본 사용자 목록 조회
			List<User> normalUsers = userService.getUsersByType("USER");
			List<User> businessUsers = userService.getUsersByType("BUSINESS");

			// 각 사용자의 선호도 정보를 Map으로 준비
			Map<Integer, UserPreferences> preferencesMap = new HashMap<>();

			for (User user : normalUsers) {
				UserPreferences preferences = userPreferencesService.findByUserId(user.getUserId());
				if (preferences != null) {
					preferencesMap.put(user.getUserId(), preferences);
				}
			}

			model.addAttribute("normalUsers", normalUsers);
			model.addAttribute("businessUsers", businessUsers);
			model.addAttribute("preferencesMap", preferencesMap);

			return "admin-user";
		} catch (Exception e) {
			System.err.println("사용자 관리 페이지 로딩 실패: " + e.getMessage());
			e.printStackTrace();

			// 에러 발생시에도 빈 리스트로 처리
			model.addAttribute("normalUsers", new ArrayList<User>());
			model.addAttribute("businessUsers", new ArrayList<User>());
			model.addAttribute("preferencesMap", new HashMap<Integer, UserPreferences>());
			model.addAttribute("error", "사용자 정보 로딩 중 오류가 발생했습니다.");

			return "admin-user";
		}
	}

	// 사용자 선호도 조회 API
	@GetMapping("/users/{userId}/preferences")
	@ResponseBody
	public ApiResponse getUserPreferences(@PathVariable Integer userId) {
		try {
			User user = userService.findById(userId);
			if (user == null) {
				return ApiResponse.error("사용자를 찾을 수 없습니다.");
			}

			UserPreferences preferences = userPreferencesService.findByUserId(userId);

			Map<String, Object> result = new HashMap<>();
			result.put("userName", user.getName());
			result.put("preferences", preferences);

			return new ApiResponse("선호도 조회 성공", result);

		} catch (Exception e) {
			return ApiResponse.error("선호도 조회 실패: " + e.getMessage());
		}
	}

	// 사용자 삭제
	@DeleteMapping("/users/{userId}")
	@ResponseBody
	public ApiResponse deleteUser(@PathVariable Integer userId) {
		try {
			userService.deleteUser(userId);
			return new ApiResponse("사용자가 삭제되었습니다.");

		} catch (Exception e) {
			return ApiResponse.error("사용자 삭제 중 오류가 발생했습니다: " + e.getMessage());
		}
	}

	// 식당 관리 관련 메서드들

	// 식당 관리 페이지
	@GetMapping("/restaurants")
	public String manageRestaurants(Model model, 
	                               @RequestParam(required = false) String keyword,
	                               @RequestParam(required = false) Integer categoryId, 
	                               @RequestParam(required = false) String priceRange,
	                               @RequestParam(required = false, defaultValue = "newest") String sort) {
		
		
	    try {
	        // 기본 데이터 로드
	        List<Restaurant> allRestaurants = restaurantService.findAll();
	        List<Category> categories = categoryService.findAll();
	        
	        System.out.println("=== 디버깅 정보 ===");
	        System.out.println("전체 식당 수: " + (allRestaurants != null ? allRestaurants.size() : "null"));
	        System.out.println("카테고리 수: " + (categories != null ? categories.size() : "null"));
	        
	        // 검색 및 필터링
	        List<Restaurant> filteredRestaurants = allRestaurants;
	        
	        // 키워드 검색
	        if (keyword != null && !keyword.trim().isEmpty()) {
	            final String searchKeyword = keyword.toLowerCase();
	            filteredRestaurants = filteredRestaurants.stream()
	                .filter(r -> (r.getName() != null && r.getName().toLowerCase().contains(searchKeyword)) ||
	                           (r.getAddress() != null && r.getAddress().toLowerCase().contains(searchKeyword)))
	                .collect(Collectors.toList());
	            System.out.println("키워드 '" + keyword + "' 검색 결과: " + filteredRestaurants.size() + "개");
	        }
	        
	        // 카테고리 필터
	        if (categoryId != null) {
	            filteredRestaurants = filteredRestaurants.stream()
	                .filter(r -> r.getCategoryId() != null && r.getCategoryId().equals(categoryId))
	                .collect(Collectors.toList());
	            System.out.println("카테고리 " + categoryId + " 필터 결과: " + filteredRestaurants.size() + "개");
	        }
	        
	        // 가격대 필터
	        if (priceRange != null && !priceRange.isEmpty()) {
	            filteredRestaurants = filteredRestaurants.stream()
	                .filter(r -> priceRange.equals(r.getPriceRange()))
	                .collect(Collectors.toList());
	            System.out.println("가격대 " + priceRange + " 필터 결과: " + filteredRestaurants.size() + "개");
	        }
	        
	        // 정렬
	        switch (sort) {
	            case "popular":
	                filteredRestaurants.sort((a, b) -> {
	                    int scoreA = (a.getViewCount() != null ? a.getViewCount() : 0) + 
	                               (a.getLikesCount() != null ? a.getLikesCount() * 2 : 0) + 
	                               (a.getReservationCount() != null ? a.getReservationCount() * 3 : 0);
	                    int scoreB = (b.getViewCount() != null ? b.getViewCount() : 0) + 
	                               (b.getLikesCount() != null ? b.getLikesCount() * 2 : 0) + 
	                               (b.getReservationCount() != null ? b.getReservationCount() * 3 : 0);
	                    return Integer.compare(scoreB, scoreA);
	                });
	                break;
	            case "name":
	                filteredRestaurants.sort((a, b) -> {
	                    if (a.getName() == null && b.getName() == null) return 0;
	                    if (a.getName() == null) return 1;
	                    if (b.getName() == null) return -1;
	                    return a.getName().compareTo(b.getName());
	                });
	                break;
	            case "rating":
	                //  실제 평점 기준 정렬 구현
	                filteredRestaurants.sort((a, b) -> {
	                    Double ratingA = reviewService.getAverageRating(a.getRestaurantId());
	                    Double ratingB = reviewService.getAverageRating(b.getRestaurantId());
	                    if (ratingA == null) ratingA = 0.0;
	                    if (ratingB == null) ratingB = 0.0;
	                    return Double.compare(ratingB, ratingA);
	                });
	                break;
	            case "newest":
	            default:
	                filteredRestaurants.sort((a, b) -> {
	                    if (a.getCreatedAt() == null && b.getCreatedAt() == null) return 0;
	                    if (a.getCreatedAt() == null) return 1;
	                    if (b.getCreatedAt() == null) return -1;
	                    return b.getCreatedAt().compareTo(a.getCreatedAt());
	                });
	                break;
	        }
	        
	        // 통계 계산
	        int totalReservations = allRestaurants.stream()
	            .mapToInt(r -> r.getReservationCount() != null ? r.getReservationCount() : 0)
	            .sum();
	        
	        //  실제 평균 평점 계산
	        double avgRating = 0.0;
	        try {
	            List<Double> ratings = new ArrayList<>();
	            for (Restaurant restaurant : allRestaurants) {
	                Double rating = reviewService.getAverageRating(restaurant.getRestaurantId());
	                if (rating != null && rating > 0) {
	                    ratings.add(rating);
	                }
	            }
	            if (!ratings.isEmpty()) {
	                avgRating = ratings.stream().mapToDouble(Double::doubleValue).average().orElse(0.0);
	            }
	            System.out.println("계산된 평균 평점: " + avgRating);
	        } catch (Exception e) {
	            System.err.println("평점 계산 실패: " + e.getMessage());
	            avgRating = 0.0;
	        }
	        
	        System.out.println("최종 필터링된 식당 수: " + filteredRestaurants.size());
	        
	        // 모델에 데이터 추가
	        model.addAttribute("restaurants", filteredRestaurants);
	        model.addAttribute("categories", categories);
	        model.addAttribute("totalReservations", totalReservations);
	        model.addAttribute("avgRating", avgRating);
	        
	        // 검색 조건 유지를 위해 다시 전달
	        model.addAttribute("searchKeyword", keyword);
	        model.addAttribute("selectedCategoryId", categoryId);
	        model.addAttribute("selectedPriceRange", priceRange);
	        model.addAttribute("selectedSort", sort);
	        
	        return "admin-restaurant";
	        
	    } catch (Exception e) {
	        System.err.println("식당 관리 페이지 로딩 실패: " + e.getMessage());
	        e.printStackTrace();
	        
	        // 에러 발생시에도 빈 리스트로 처리
	        model.addAttribute("restaurants", new ArrayList<Restaurant>());
	        model.addAttribute("categories", new ArrayList<Category>());
	        model.addAttribute("totalReservations", 0);
	        model.addAttribute("avgRating", 0.0);
	        model.addAttribute("error", "식당 데이터 로딩 중 오류가 발생했습니다.");
	        
	        return "admin-restaurant";
	    }
	}

	//  식당 상세보기 API 추가 (상세보기 모달)
	@GetMapping("/restaurants/{restaurantId}/detail")
	@ResponseBody
	public ApiResponse getRestaurantDetail(@PathVariable Integer restaurantId) {
	    try {
	        // 식당 정보 조회
	        Restaurant restaurant = restaurantService.findById(restaurantId);
	        if (restaurant == null) {
	            return ApiResponse.error("존재하지 않는 식당입니다.");
	        }
	        
	        // 사업자 정보 조회
	        User businessUser = userService.findById(restaurant.getBusinessUserId());
	        
	        // 카테고리 정보 조회
	        Category category = null;
	        if (restaurant.getCategoryId() != null) {
	            category = categoryService.findById(restaurant.getCategoryId());
	        }
	        
	        // 응답 데이터 구성
	        Map<String, Object> responseData = new HashMap<>();
	        responseData.put("restaurant", restaurant);
	        responseData.put("businessUser", businessUser);
	        responseData.put("category", category);
	        
	        return new ApiResponse("식당 상세 정보 조회 성공", responseData);
	        
	    } catch (Exception e) {
	        System.err.println("식당 상세 정보 조회 실패: " + e.getMessage());
	        e.printStackTrace();
	        return ApiResponse.error("식당 상세 정보 조회 중 오류가 발생했습니다: " + e.getMessage());
	    }
	}

	//  식당 삭제 API 추가
	@DeleteMapping("/restaurants/{restaurantId}")
	@ResponseBody
	public ApiResponse deleteRestaurant(@PathVariable Integer restaurantId) {
	    try {
	        if (restaurantId == null) {
	            return ApiResponse.error("식당 ID가 누락되었습니다.");
	        }
	        
	        Restaurant restaurant = restaurantService.findById(restaurantId);
	        if (restaurant == null) {
	            return ApiResponse.error("존재하지 않는 식당입니다.");
	        }
	        
	        int result = restaurantService.deleteRestaurant(restaurantId);
	        
	        if (result > 0) {
	            return new ApiResponse("식당과 관련 데이터가 모두 삭제되었습니다.");
	        } else {
	            return ApiResponse.error("삭제에 실패했습니다.");
	        }
	        
	    } catch (Exception e) {
	 
	        e.printStackTrace();
	        return ApiResponse.error("삭제 중 오류가 발생했습니다: " + e.getMessage());
	    }
	}
	//  관리자 리뷰 삭제 기능 추가
	@DeleteMapping("/reviews/{reviewId}")
	@ResponseBody
	public ApiResponse deleteReviewAsAdmin(@PathVariable Integer reviewId) {
	    try {
	        Review review = reviewService.findById(reviewId);
	        if (review == null) {
	            return ApiResponse.error("존재하지 않는 리뷰입니다.");
	        }
	        
	        // 관리자는 모든 리뷰 삭제 가능 
	        reviewService.deleteReview(reviewId, review.getUserId());
	        
	        return new ApiResponse("리뷰가 삭제되었습니다.");
	        
	    } catch (Exception e) {
	        return ApiResponse.error("리뷰 삭제 중 오류가 발생했습니다: " + e.getMessage());
	    }
	}

	
	// 카테고리 관리 관련 메서드들

	// 카테고리 관리 페이지
	@GetMapping("/categories")
	public String manageCategories(Model model) {
		List<Category> categories = categoryService.findAll();
		model.addAttribute("categories", categories);
		return "categories";
	}

	// 카테고리 추가
	@PostMapping("/categories")
	@ResponseBody
	public ApiResponse createCategory(@RequestBody Category category) {
		try {
			if (category.getName() == null || category.getName().trim().isEmpty()) {
				return ApiResponse.error("카테고리명은 필수입니다.");
			}

			categoryService.createCategory(category);
			return new ApiResponse("카테고리가 추가되었습니다.");

		} catch (Exception e) {
			return ApiResponse.error("카테고리 추가 중 오류가 발생했습니다: " + e.getMessage());
		}
	}

	// 카테고리 수정
	@PutMapping("/categories/{categoryId}")
	@ResponseBody
	public ApiResponse updateCategory(@PathVariable Integer categoryId, @RequestBody Category category) {
		try {
			category.setCategoryId(categoryId);
			categoryService.updateCategory(category);
			return new ApiResponse("카테고리가 수정되었습니다.");

		} catch (Exception e) {
			return ApiResponse.error("카테고리 수정 중 오류가 발생했습니다: " + e.getMessage());
		}
	}

	// 카테고리 삭제
	@DeleteMapping("/categories/{categoryId}")
	@ResponseBody
	public ApiResponse deleteCategory(@PathVariable Integer categoryId) {
		try {
			categoryService.deleteCategory(categoryId);
			return new ApiResponse("카테고리가 삭제되었습니다.");

		} catch (Exception e) {
			return ApiResponse.error("카테고리 삭제 중 오류가 발생했습니다: " + e.getMessage());
		}
	}

	// 쿠폰 관리 관련 메서드들

	// 쿠폰 관리 페이지
	@GetMapping("/coupons")
	public String manageCoupons(Model model) {
		try {
			List<Coupon> coupons = couponService.findAll();
			List<User> allUsers = userService.getAllUsers();

			model.addAttribute("coupons", coupons);
			model.addAttribute("users", allUsers);

			return "coupons";
		} catch (Exception e) {
			model.addAttribute("error", "쿠폰 데이터 로딩 실패");
			return "coupons";
		}
	}

	// 쿠폰 생성
	@PostMapping("/coupons")
	@ResponseBody
	public ApiResponse createCoupon(@RequestBody Coupon coupon) {
		try {
			if (coupon.getName() == null || coupon.getName().trim().isEmpty()) {
				return ApiResponse.error("쿠폰명은 필수입니다.");
			}
			if (coupon.getDiscountAmount() == null || coupon.getDiscountAmount() <= 0) {
				return ApiResponse.error("할인 금액은 필수이며 0보다 커야 합니다.");
			}

			couponService.createCoupon(coupon);
			return new ApiResponse("쿠폰이 생성되었습니다.");

		} catch (Exception e) {
			return ApiResponse.error("쿠폰 생성 중 오류가 발생했습니다: " + e.getMessage());
		}
	}

	// 쿠폰 수정
	@PutMapping("/coupons/{couponId}")
	@ResponseBody
	public ApiResponse updateCoupon(@PathVariable Integer couponId, @RequestBody Coupon coupon) {
		try {
			Coupon existingCoupon = couponService.findById(couponId);
			if (existingCoupon == null) {
				return ApiResponse.error("존재하지 않는 쿠폰입니다.");
			}

			coupon.setCouponId(couponId);

			if (coupon.getDiscountAmount() == null) {
				coupon.setDiscountAmount(existingCoupon.getDiscountAmount());
			}
			if (coupon.getMinOrderAmount() == null) {
				coupon.setMinOrderAmount(existingCoupon.getMinOrderAmount());
			}
			if (coupon.getUsageLimit() == null) {
				coupon.setUsageLimit(existingCoupon.getUsageLimit());
			}
			if (coupon.getRequiredReservationCount() == null) {
				coupon.setRequiredReservationCount(existingCoupon.getRequiredReservationCount());
			}
			if (coupon.getStartDate() == null) {
				coupon.setStartDate(existingCoupon.getStartDate());
			}
			if (coupon.getEndDate() == null) {
				coupon.setEndDate(existingCoupon.getEndDate());
			}

			couponService.updateCoupon(coupon);
			return new ApiResponse("쿠폰이 수정되었습니다.");

		} catch (Exception e) {
			return ApiResponse.error("쿠폰 수정 중 오류가 발생했습니다: " + e.getMessage());
		}
	}

	// 쿠폰 삭제
	@DeleteMapping("/coupons/{couponId}")
	@ResponseBody
	public ApiResponse deleteCoupon(@PathVariable Integer couponId) {
		try {
			Coupon coupon = couponService.findById(couponId);
			if (coupon == null) {
				return ApiResponse.error("존재하지 않는 쿠폰입니다.");
			}

			int issuedCount = couponService.getCouponIssuedCount(couponId);
			int usedCount = couponService.getCouponUsedCount(couponId);

			couponService.forceDeleteCoupon(couponId);

			return new ApiResponse("쿠폰이 삭제되었습니다. (발급된 " + issuedCount + "개 쿠폰도 함께 삭제됨)");

		} catch (Exception e) {
			return ApiResponse.error("쿠폰 삭제 실패: " + e.getMessage());
		}
	}

	// 쿠폰 비활성화
	@PutMapping("/coupons/{couponId}/deactivate")
	@ResponseBody
	public ApiResponse deactivateCoupon(@PathVariable Integer couponId) {
		try {
			couponService.deactivateCoupon(couponId);
			return new ApiResponse("쿠폰이 비활성화되었습니다. 기존 보유자는 계속 사용할 수 있습니다.");

		} catch (Exception e) {
			return ApiResponse.error("쿠폰 비활성화 실패: " + e.getMessage());
		}
	}

	// 쿠폰 강제 삭제
	@DeleteMapping("/coupons/{couponId}/force")
	@ResponseBody
	public ApiResponse forceDeleteCoupon(@PathVariable Integer couponId) {
		try {
			couponService.forceDeleteCoupon(couponId);
			return new ApiResponse("쿠폰이 강제 삭제되었습니다.");

		} catch (Exception e) {
			return ApiResponse.error("강제 삭제 실패: " + e.getMessage());
		}
	}

	// 미사용 쿠폰 회수
	@DeleteMapping("/coupons/{couponId}/reclaim")
	@ResponseBody
	public ApiResponse reclaimUnusedCoupons(@PathVariable Integer couponId) {
		try {
			couponService.reclaimUnusedCoupons(couponId);
			return new ApiResponse("미사용 쿠폰이 회수되었습니다.");

		} catch (Exception e) {
			return ApiResponse.error("쿠폰 회수 실패: " + e.getMessage());
		}
	}

	// 쿠폰 통계 조회
	@GetMapping("/coupons/{couponId}/stats")
	@ResponseBody
	public ApiResponse getCouponStats(@PathVariable Integer couponId) {
		try {
			String stats = couponService.getCouponStatistics(couponId);
			return new ApiResponse(stats);

		} catch (Exception e) {
			return ApiResponse.error("통계 조회 실패: " + e.getMessage());
		}
	}

	// 이메일로 쿠폰 지급
	@PostMapping("/coupons/{couponId}/issue-by-email")
	@ResponseBody
	public ApiResponse issueCouponByEmail(@PathVariable Integer couponId, @RequestParam String email) {
		try {
			User user = userService.findByEmail(email);
			if (user == null) {
				return ApiResponse.error("해당 이메일의 사용자를 찾을 수 없습니다: " + email);
			}

			couponService.issueCouponToUser(user.getUserId(), couponId);
			return new ApiResponse(user.getName() + "님(" + email + ")에게 쿠폰이 지급되었습니다.");

		} catch (Exception e) {
			return ApiResponse.error("쿠폰 지급 실패: " + e.getMessage());
		}
	}

	// 일괄 지급
	@PostMapping("/coupons/{couponId}/issue-all")
	@ResponseBody
	public ApiResponse issueCouponToAllUsers(@PathVariable Integer couponId) {
		try {
			Coupon coupon = couponService.findById(couponId);
			if (coupon == null) {
				return ApiResponse.error("존재하지 않는 쿠폰입니다.");
			}

			List<User> allUsers = userService.getAllUsers();

			if (allUsers.isEmpty()) {
				return ApiResponse.error("등록된 사용자가 없습니다.");
			}

			List<Integer> targetUserIds = new ArrayList<>();
			for (User user : allUsers) {
				if ("USER".equals(user.getUserType()) && "APPROVED".equals(user.getApprovalStatus())) {
					targetUserIds.add(user.getUserId());
				}
			}

			if (targetUserIds.isEmpty()) {
				return ApiResponse.error("지급할 일반 사용자가 없습니다.");
			}

			int successCount = 0;
			int skipCount = 0;
			int errorCount = 0;

			for (Integer userId : targetUserIds) {
				try {
					couponService.issueCouponToUser(userId, couponId);
					successCount++;

				} catch (RuntimeException e) {
					if (e.getMessage().contains("이미 보유중인 쿠폰")) {
						skipCount++;
					} else {
						errorCount++;
					}
				} catch (Exception e) {
					errorCount++;
				}
			}

			StringBuilder resultDetails = new StringBuilder();
			resultDetails.append("일괄 지급 완료!\n");
			resultDetails.append("• 성공: ").append(successCount).append("명\n");
			if (skipCount > 0) {
				resultDetails.append("• 건너뜀: ").append(skipCount).append("명 (이미 보유)\n");
			}
			if (errorCount > 0) {
				resultDetails.append("• 실패: ").append(errorCount).append("명\n");
			}
			resultDetails.append("• 대상: ").append(targetUserIds.size()).append("명 중");

			return new ApiResponse(resultDetails.toString());

		} catch (Exception e) {
			return ApiResponse.error("일괄 지급 중 오류가 발생했습니다: " + e.getMessage());
		}
	}

	// 공통 통계 및 유틸리티 메서드들

	// 전체 통계 정보 조회
	@GetMapping("/stats")
	@ResponseBody
	public ApiResponse getStats() {
		try {
			List<User> allUsers = userService.getAllUsers();
			List<User> pendingBusiness = userService.getPendingBusinessUsers();
			List<Restaurant> allRestaurants = restaurantService.findAll();

			int totalUsers = allUsers.size();
			int pendingCount = pendingBusiness.size();
			int totalRestaurants = allRestaurants.size();

			String stats = String.format("총 사용자: %d명, 승인대기: %d명, 총 식당: %d개", totalUsers, pendingCount,
					totalRestaurants);

			return new ApiResponse("통계 조회 성공", stats);

		} catch (Exception e) {
			return ApiResponse.error("통계 조회 중 오류가 발생했습니다: " + e.getMessage());
		}
	}

	// 대시보드용 상세 통계 API

	// 대시보드 통계 데이터 API
	@GetMapping("/dashboard/stats")
	@ResponseBody
	public ApiResponse getDashboardStats() {
		try {
			List<User> allUsers = userService.getAllUsers();
			List<User> pendingBusinessUsers = userService.getPendingBusinessUsers();
			List<Restaurant> allRestaurants = restaurantService.findAll();
			List<Category> allCategories = categoryService.findAll();
			List<Coupon> allCoupons = couponService.findAll();

			// 사용자 타입별 통계
			int totalUsers = 0;
			int totalBusinessUsers = 0;
			int approvedBusinessUsers = 0;

			for (User user : allUsers) {
				if ("USER".equals(user.getUserType())) {
					totalUsers++;
				} else if ("BUSINESS".equals(user.getUserType())) {
					totalBusinessUsers++;
					if ("APPROVED".equals(user.getApprovalStatus())) {
						approvedBusinessUsers++;
					}
				}
			}

			// 식당 통계
			int totalReservations = allRestaurants.stream()
					.mapToInt(r -> r.getReservationCount() != null ? r.getReservationCount() : 0).sum();

			int totalViews = allRestaurants.stream().mapToInt(r -> r.getViewCount() != null ? r.getViewCount() : 0)
					.sum();

			int totalLikes = allRestaurants.stream().mapToInt(r -> r.getLikesCount() != null ? r.getLikesCount() : 0)
					.sum();

			// 응답 데이터 구성
			Map<String, Object> stats = new HashMap<>();

			// 기본 통계
			stats.put("totalUsers", totalUsers);
			stats.put("totalBusinessUsers", totalBusinessUsers);
			stats.put("approvedBusinessUsers", approvedBusinessUsers);
			stats.put("pendingApprovals", pendingBusinessUsers.size());
			stats.put("totalRestaurants", allRestaurants.size());
			stats.put("totalCategories", allCategories.size());
			stats.put("totalCoupons", allCoupons.size());

			// 활동 통계
			stats.put("totalReservations", totalReservations);
			stats.put("totalViews", totalViews);
			stats.put("totalLikes", totalLikes);
			stats.put("avgRating", 4.2); // TODO: 실제 평점 계산

			// 최근 활동 
			stats.put("recentUsers", allUsers.size() > 5 ? allUsers.subList(0, 5) : allUsers);
			stats.put("pendingBusinessUsers", pendingBusinessUsers);

			return new ApiResponse("대시보드 통계 조회 성공", stats);

		} catch (Exception e) {
			System.err.println("대시보드 통계 조회 실패: " + e.getMessage());
			return ApiResponse.error("대시보드 통계 조회 실패: " + e.getMessage());
		}
	}

	// 검색 및 필터링 공통 유틸리티

	// 전체 검색 API 
	@GetMapping("/search")
	@ResponseBody
	public ApiResponse globalSearch(@RequestParam String keyword) {
		try {
			if (keyword == null || keyword.trim().isEmpty()) {
				return ApiResponse.error("검색어를 입력해주세요.");
			}

			String searchKeyword = keyword.toLowerCase().trim();
			Map<String, Object> results = new HashMap<>();

			// 사용자 검색
			List<User> allUsers = userService.getAllUsers();
			List<User> matchedUsers = allUsers.stream()
					.filter(user -> (user.getName() != null && user.getName().toLowerCase().contains(searchKeyword))
							|| (user.getEmail() != null && user.getEmail().toLowerCase().contains(searchKeyword)))
					.collect(Collectors.toList());

			// 식당 검색
			List<Restaurant> allRestaurants = restaurantService.findAll();
			List<Restaurant> matchedRestaurants = allRestaurants.stream()
					.filter(restaurant -> (restaurant.getName() != null
							&& restaurant.getName().toLowerCase().contains(searchKeyword))
							|| (restaurant.getAddress() != null
									&& restaurant.getAddress().toLowerCase().contains(searchKeyword))
							|| (restaurant.getCuisineType() != null
									&& restaurant.getCuisineType().toLowerCase().contains(searchKeyword)))
					.collect(Collectors.toList());

			// 카테고리 검색
			List<Category> allCategories = categoryService.findAll();
			List<Category> matchedCategories = allCategories.stream().filter(
					category -> category.getName() != null && category.getName().toLowerCase().contains(searchKeyword))
					.collect(Collectors.toList());

			results.put("users", matchedUsers);
			results.put("restaurants", matchedRestaurants);
			results.put("categories", matchedCategories);
			results.put("totalResults", matchedUsers.size() + matchedRestaurants.size() + matchedCategories.size());

			return new ApiResponse("통합 검색 성공", results);

		} catch (Exception e) {
			return ApiResponse.error("통합 검색 실패: " + e.getMessage());
		}
	}



	// 예약 관리 관련 메서드들  

	// 식당별 예약 목록 조회
	@GetMapping("/restaurants/{restaurantId}/reservations")
	@ResponseBody
	public ApiResponse getRestaurantReservations(@PathVariable Integer restaurantId) {
	    try {
	        List<Reservation> reservations = reservationService.getReservationsByRestaurant(restaurantId);
	        
	        return new ApiResponse("예약 목록 조회 성공", reservations);
	        
	    } catch (Exception e) {
	        System.err.println("예약 목록 조회 실패: " + e.getMessage());
	        return ApiResponse.error("예약 목록 조회 중 오류가 발생했습니다: " + e.getMessage());
	    }
	}

	// 예약 상태 업데이트
	@PutMapping("/reservations/{reservationId}/status")
	@ResponseBody
	public ApiResponse updateReservationStatus(
	        @PathVariable Integer reservationId, 
	        @RequestBody Map<String, String> statusData) {
	    try {
	        String newStatus = statusData.get("status");
	        if (newStatus == null || newStatus.trim().isEmpty()) {
	            return ApiResponse.error("예약 상태는 필수입니다.");
	        }
	        
	        reservationService.updateReservationStatus(reservationId, newStatus);
	        
	        return new ApiResponse("예약 상태가 업데이트되었습니다.");
	        
	    } catch (Exception e) {
	        System.err.println("예약 상태 업데이트 실패: " + e.getMessage());
	        return ApiResponse.error("예약 상태 업데이트 중 오류가 발생했습니다: " + e.getMessage());
	    }
	}

	// 식당별 리뷰 목록 조회 
	@GetMapping("/restaurants/{restaurantId}/reviews")
	@ResponseBody
	public ApiResponse getRestaurantReviews(@PathVariable Integer restaurantId) {
	    try {
	        List<Review> reviews = reviewService.getReviewsByRestaurant(restaurantId);
	        
	        return new ApiResponse("리뷰 목록 조회 성공", reviews);
	        
	    } catch (Exception e) {
	        System.err.println("리뷰 목록 조회 실패: " + e.getMessage());
	        return ApiResponse.error("리뷰 목록 조회 중 오류가 발생했습니다: " + e.getMessage());
	    }
	}
}