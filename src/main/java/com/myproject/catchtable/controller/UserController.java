package com.myproject.catchtable.controller;

import java.time.LocalDate;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.myproject.catchtable.model.Reservation;
import com.myproject.catchtable.model.Review;
import com.myproject.catchtable.model.User;
import com.myproject.catchtable.model.UserCoupon;
import com.myproject.catchtable.model.UserPreferences;
import com.myproject.catchtable.service.CouponService;
import com.myproject.catchtable.service.ReservationService;
import com.myproject.catchtable.service.RestaurantService;
import com.myproject.catchtable.service.ReviewService;
import com.myproject.catchtable.service.UserPreferencesService;
import com.myproject.catchtable.service.UserService;

@Controller
@RequestMapping("/user")
public class UserController {

	@Autowired
	private UserService userService;

	@Autowired
	private CouponService couponService;
	
	@Autowired
	private ReservationService reservationService;

	@Autowired
	private ReviewService reviewService;

	@Autowired
	private UserPreferencesService userPreferencesService;

	@Autowired
	private RestaurantService restaurantService;
	
	private Integer validateUserSession(HttpSession session) {
		Integer userId = (Integer) session.getAttribute("userId");
		String userType = (String) session.getAttribute("userType");

		if (userId == null) {
			return null;
		}

		if ("BUSINESS".equals(userType)) {
			return null;
		}

		return userId;
	}

	@PostMapping("/profile/update")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> updateProfile(@RequestBody Map<String, Object> profileData,
			HttpSession session) {
		Map<String, Object> response = new HashMap<>();

		try {
			Integer userId = validateUserSession(session);
			if (userId == null) {
				response.put("success", false);
				response.put("message", "로그인이 필요합니다.");
				return ResponseEntity.ok(response);
			}

			User user = userService.findById(userId);
			if (user == null) {
				response.put("success", false);
				response.put("message", "사용자 정보를 찾을 수 없습니다.");
				return ResponseEntity.ok(response);
			}

			// 기본 사용자 정보 업데이트
			boolean userInfoUpdated = false;
			if (profileData.containsKey("name")) {
				user.setName((String) profileData.get("name"));
				userInfoUpdated = true;
			}
			if (profileData.containsKey("phone")) {
				user.setPhone((String) profileData.get("phone"));
				userInfoUpdated = true;
			}
			if (profileData.containsKey("email")) {
				user.setEmail((String) profileData.get("email"));
				userInfoUpdated = true;
			}

			if (userInfoUpdated) {
				userService.updateUser(user);
			}

			// 선호도 정보 업데이트
			if (profileData.containsKey("preferredCuisineTypes") || profileData.containsKey("preferredPriceRange")
					|| profileData.containsKey("preferredArea")) {

				UserPreferences preferences = new UserPreferences();
				preferences.setUserId(userId);

				if (profileData.containsKey("preferredCuisineTypes")) {
					preferences.setPreferredCuisineTypes((String) profileData.get("preferredCuisineTypes"));
				}
				if (profileData.containsKey("preferredPriceRange")) {
					preferences.setPreferredPriceRange((String) profileData.get("preferredPriceRange"));
				}
				if (profileData.containsKey("preferredArea")) {
					preferences.setPreferredArea((String) profileData.get("preferredArea"));
				}

				userPreferencesService.saveUserPreferences(preferences);
			}

			response.put("success", true);
			response.put("message", "프로필이 성공적으로 업데이트되었습니다.");

		} catch (Exception e) {
			System.err.println("프로필 업데이트 오류: " + e.getMessage());
			response.put("success", false);
			response.put("message", "프로필 업데이트 중 오류가 발생했습니다.");
		}

		return ResponseEntity.ok(response);
	}

	@GetMapping("/profile")
	public String userProfile(HttpSession session, Model model) {
		try {
			Integer userId = validateUserSession(session);
			if (userId == null) {
				return "redirect:/login";
			}

			User user = userService.findById(userId);
			if (user == null) {
				return "redirect:/login";
			}

			// 사용자 선호도 정보도 함께 조회
			UserPreferences preferences = userPreferencesService.findByUserId(userId);

			model.addAttribute("user", user);
			model.addAttribute("preferences", preferences);
			return "user-profile";

		} catch (Exception e) {
			System.err.println("사용자 프로필 오류: " + e.getMessage());
			model.addAttribute("error", "프로필을 불러오는 중 오류가 발생했습니다.");
			return "user-profile";
		}
	}

	@PostMapping("/profile/password")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> changePassword(@RequestBody Map<String, String> passwordData,
	        HttpSession session) {
	    Map<String, Object> response = new HashMap<>();
	    try {
	        Integer userId = validateUserSession(session);
	        if (userId == null) {
	            response.put("success", false);
	            response.put("message", "로그인이 필요합니다.");
	            return ResponseEntity.ok(response);
	        }
	        User user = userService.findById(userId);
	        if (user == null) {
	            response.put("success", false);
	            response.put("message", "사용자 정보를 찾을 수 없습니다.");
	            return ResponseEntity.ok(response);
	        }
	        String currentPassword = passwordData.get("currentPassword");
	        String newPassword = passwordData.get("newPassword");
	        
	        
	        
	        if (!currentPassword.equals(user.getPassword())) {
	            response.put("success", false);
	            response.put("message", "현재 비밀번호가 일치하지 않습니다.");
	            return ResponseEntity.ok(response);
	        }
	        if (currentPassword.equals(newPassword)) {
	            response.put("success", false);
	            response.put("message", "새 비밀번호는 현재 비밀번호와 달라야 합니다.");
	            return ResponseEntity.ok(response);
	        }
	        boolean updateResult = userService.updatePassword(userId, newPassword);
	        
	        if (updateResult) {
	            response.put("success", true);
	            response.put("message", "비밀번호가 성공적으로 변경되었습니다.");
	        } else {
	            response.put("success", false);
	            response.put("message", "비밀번호 변경에 실패했습니다.");
	        }
	        
	    } catch (Exception e) {
	        System.err.println("비밀번호 변경 오류: " + e.getMessage());
	        response.put("success", false);
	        response.put("message", "서버 오류가 발생했습니다.");
	    }
	    return ResponseEntity.ok(response);
	}

	@GetMapping("/reservations")
	public String myReservations(HttpSession session, Model model, 
	                           @RequestParam(defaultValue = "1") int page,
	                           @RequestParam(defaultValue = "10") int size) {
	    try {
	        Integer userId = validateUserSession(session);
	        if (userId == null) {
	            return "redirect:/login";
	        }

	        List<Reservation> allReservations = reservationService.findByUserId(userId);
	        Map<Integer, String> restaurantNameMap = new HashMap<>();
	        for (Reservation reservation : allReservations) {
	            String restaurantName = restaurantService.getRestaurantName(reservation.getRestaurantId());
	            restaurantNameMap.put(reservation.getReservationId(), restaurantName);
	        }

	        // 각 예약에 대해 리뷰 작성 여부 확인
	        Map<Integer, Boolean> reviewStatusMap = new HashMap<>();
	        for (Reservation reservation : allReservations) {
	            boolean hasReview = reviewService.hasReviewForReservation(reservation.getReservationId());
	            reviewStatusMap.put(reservation.getReservationId(), hasReview);
	        }

	        // 페이징 처리 (기존 코드 그대로)
	        int totalReservations = allReservations.size();
	        int totalPages = (int) Math.ceil((double) totalReservations / size);

	        if (page < 1) page = 1;
	        if (page > totalPages && totalPages > 0) page = totalPages;

	        int startIndex = (page - 1) * size;
	        int endIndex = Math.min(startIndex + size, totalReservations);

	        List<Reservation> pageReservations = totalReservations > 0 ? 
	            allReservations.subList(startIndex, endIndex) : allReservations;

	        boolean hasPrev = page > 1;
	        boolean hasNext = page < totalPages;

	        int startPage = Math.max(1, page - 2);
	        int endPage = Math.min(totalPages, page + 2);

	        ReservationService.ReservationStats stats = reservationService.getUserReservationStats(userId);

	        model.addAttribute("reservations", pageReservations);
	        model.addAttribute("reviewStatusMap", reviewStatusMap); // 추가
	        model.addAttribute("reservationStats", stats);
	        model.addAttribute("currentPage", page);
	        model.addAttribute("totalPages", totalPages);
	        model.addAttribute("totalReservations", totalReservations);
	        model.addAttribute("pageSize", size);
	        model.addAttribute("hasPrev", hasPrev);
	        model.addAttribute("hasNext", hasNext);
	        model.addAttribute("startPage", startPage);
	        model.addAttribute("endPage", endPage);
	        model.addAttribute("restaurantNameMap", restaurantNameMap);

	        return "user-reservations";

	    } catch (Exception e) {
	        System.err.println("사용자 예약 목록 오류: " + e.getMessage());
	        model.addAttribute("error", "예약 목록을 불러오는 중 오류가 발생했습니다.");
	        return "user-reservations";
	    }
	}
	@PostMapping("/reservations/{reservationId}/cancel")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> cancelReservation(@PathVariable Integer reservationId,
			HttpSession session) {
		Map<String, Object> response = new HashMap<>();

		try {
			Integer userId = validateUserSession(session);
			if (userId == null) {
				response.put("success", false);
				response.put("message", "로그인이 필요합니다.");
				return ResponseEntity.ok(response);
			}

			reservationService.cancelReservation(reservationId, userId);

			response.put("success", true);
			response.put("message", "예약이 성공적으로 취소되었습니다.");

		} catch (Exception e) {
			System.err.println("예약 취소 오류: " + e.getMessage());
			response.put("success", false);
			response.put("message", e.getMessage());
		}

		return ResponseEntity.ok(response);
	}

	@GetMapping("/reviews")
	public String myReviews(HttpSession session, Model model, 
	                       @RequestParam(defaultValue = "1") int page,
	                       @RequestParam(defaultValue = "10") int size) {
	    try {
	        Integer userId = validateUserSession(session);
	        if (userId == null) {
	            return "redirect:/login";
	        }

	        
	        List<Map<String, Object>> allReviews = reviewService.findByUserIdWithRestaurant(userId);

	        // 페이징 처리
	        int totalReviews = allReviews.size();
	        int totalPages = (int) Math.ceil((double) totalReviews / size);

	        if (page < 1) page = 1;
	        if (page > totalPages && totalPages > 0) page = totalPages;

	        int startIndex = (page - 1) * size;
	        int endIndex = Math.min(startIndex + size, totalReviews);

	        
	        List<Map<String, Object>> pageReviews = totalReviews > 0 ? 
	            allReviews.subList(startIndex, endIndex) : allReviews;

	        boolean hasPrev = page > 1;
	        boolean hasNext = page < totalPages;

	        int startPage = Math.max(1, page - 2);
	        int endPage = Math.min(totalPages, page + 2);

	        // 리뷰 통계 계산
	        double averageRating = 0.0;
	        double recommendationRate = 0.0;
	        
	        if (!allReviews.isEmpty()) {
	            averageRating = allReviews.stream()
	                .mapToDouble(review -> (Integer) review.get("rating"))
	                .average()
	                .orElse(0.0);
	                
	            long recommendedCount = allReviews.stream()
	                .filter(review -> (Boolean) review.get("isRecommended"))
	                .count();
	            recommendationRate = (recommendedCount * 100.0) / totalReviews;
	        }

	        // ReviewStats 객체 생성
	        Map<String, Object> reviewStats = new HashMap<>();
	        reviewStats.put("totalReviews", totalReviews);
	        reviewStats.put("averageRating", averageRating);
	        reviewStats.put("recommendationRate", recommendationRate);

	        model.addAttribute("reviews", pageReviews);  
	        model.addAttribute("reviewStats", reviewStats);
	        model.addAttribute("totalReviews", totalReviews);
	        model.addAttribute("currentPage", page);
	        model.addAttribute("totalPages", totalPages);
	        model.addAttribute("pageSize", size);
	        model.addAttribute("hasPrev", hasPrev);
	        model.addAttribute("hasNext", hasNext);
	        model.addAttribute("startPage", startPage);
	        model.addAttribute("endPage", endPage);

	        return "user-reviews";

	    } catch (Exception e) {
	        System.err.println("사용자 리뷰 목록 오류: " + e.getMessage());
	        model.addAttribute("error", "리뷰 목록을 불러오는 중 오류가 발생했습니다.");
	        return "user-reviews";
	    }
	}

	@PostMapping("/reviews/{reviewId}/delete")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> deleteReview(@PathVariable Integer reviewId, HttpSession session) {
		Map<String, Object> response = new HashMap<>();

		try {
			Integer userId = validateUserSession(session);
			if (userId == null) {
				response.put("success", false);
				response.put("message", "로그인이 필요합니다.");
				return ResponseEntity.ok(response);
			}

			
			reviewService.deleteReview(reviewId, userId);

			response.put("success", true);
			response.put("message", "리뷰가 성공적으로 삭제되었습니다.");

		} catch (Exception e) {
			System.err.println("리뷰 삭제 오류: " + e.getMessage());
			response.put("success", false);
			response.put("message", e.getMessage());
		}

		return ResponseEntity.ok(response);
	}
	/**
     * 사용자 쿠폰 목록 페이지
     */
    @GetMapping("/coupons")
    public String userCoupons(HttpSession session, Model model) {
        try {
            // 로그인 확인
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                return "redirect:/auth/login";
            }

            // 사용자의 모든 쿠폰 조회 (쿠폰 정보 포함)
            List<UserCoupon> userCoupons = couponService.findUserCoupons(currentUser.getUserId());
            
            // 각 쿠폰에 상태 정보 추가
            for (UserCoupon userCoupon : userCoupons) {
                // 만료 여부 확인
                boolean isExpired = userCoupon.getEndDate() != null && 
                                  userCoupon.getEndDate().isBefore(LocalDate.now());
                
                // 곧 만료 여부 확인 (7일 이내)
                boolean isExpiringSoon = userCoupon.getEndDate() != null && 
                                       !isExpired &&
                                       userCoupon.getEndDate().isBefore(LocalDate.now().plusDays(7));
                
                // 상태 설정
                String couponStatus;
                if (userCoupon.getIsUsed()) {
                    couponStatus = "used";
                } else if (isExpired) {
                    couponStatus = "expired";
                } else {
                    couponStatus = "available";
                }
                
                // 임시로 UserCoupon에 상태 정보 추가 (필요시 UserCoupon 모델에 필드 추가)
                // 여기서는 description에 상태 정보를 임시로 담아 JSP에서 사용
                userCoupon.setCouponDescription(userCoupon.getCouponDescription() + "|STATUS:" + couponStatus);
                
                // 만료 관련 정보도 추가
                if (isExpiringSoon) {
                    userCoupon.setCouponDescription(userCoupon.getCouponDescription() + "|EXPIRING_SOON:true");
                }
                if (isExpired) {
                    userCoupon.setCouponDescription(userCoupon.getCouponDescription() + "|EXPIRED:true");
                }
            }

            // 쿠폰 통계 계산
            Map<String, Integer> couponStats = calculateCouponStats(userCoupons);

            // 모델에 데이터 추가
            model.addAttribute("userCoupons", userCoupons);
            model.addAttribute("couponStats", couponStats);
            model.addAttribute("user", currentUser);

            return "user-coupons";

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "쿠폰 목록을 불러오는 중 오류가 발생했습니다.");
            return "user-coupons";
        }
    }

    /**
     * 쿠폰 통계 계산
     */
    private Map<String, Integer> calculateCouponStats(List<UserCoupon> userCoupons) {
        Map<String, Integer> stats = new HashMap<>();
        
        int totalCoupons = userCoupons.size();
        int usedCoupons = 0;
        int availableCoupons = 0;
        int expiredCoupons = 0;
        
        LocalDate now = LocalDate.now();
        
        for (UserCoupon userCoupon : userCoupons) {
            if (userCoupon.getIsUsed()) {
                usedCoupons++;
            } else if (userCoupon.getEndDate() != null && userCoupon.getEndDate().isBefore(now)) {
                expiredCoupons++;
            } else {
                availableCoupons++;
            }
        }
        
        stats.put("totalCoupons", totalCoupons);
        stats.put("usedCoupons", usedCoupons);
        stats.put("availableCoupons", availableCoupons);
        stats.put("expiredCoupons", expiredCoupons);
        
        return stats;
    }
    /**
     * 사용자 단골 레스토랑 목록 (3회 이상 방문)
     */
    @GetMapping("/favorites")
    public String userFavorites(HttpSession session, Model model) {
        try {
            Integer userId = validateUserSession(session);
            if (userId == null) {
                return "redirect:/login";
            }

            // 3회 이상 방문한 레스토랑 조회
            List<Map<String, Object>> favoriteRestaurants = reservationService.getFavoriteRestaurants(userId, 3);
            
            // 각 레스토랑에 추가 정보 설정
            for (Map<String, Object> restaurant : favoriteRestaurants) {
                Integer restaurantId = (Integer) restaurant.get("restaurantId");
                
                // 평점 정보 추가
                Map<String, Object> reviewStats = restaurantService.getRestaurantReviewStats(restaurantId);
                restaurant.put("averageRating", reviewStats.get("averageRating"));
                restaurant.put("reviewCount", reviewStats.get("reviewCount"));
            }

            // 통계 계산
            Map<String, Object> favoriteStats = calculateFavoriteStats(favoriteRestaurants);

            model.addAttribute("favoriteRestaurants", favoriteRestaurants);
            model.addAttribute("favoriteStats", favoriteStats);

            return "user-favorites";

        } catch (Exception e) {
            System.err.println("단골 레스토랑 목록 오류: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "단골 레스토랑 목록을 불러오는 중 오류가 발생했습니다.");
            return "user-favorites";
        }
    }

    /**
     * 단골 레스토랑 통계 계산
     */
    private Map<String, Object> calculateFavoriteStats(List<Map<String, Object>> favoriteRestaurants) {
        Map<String, Object> stats = new HashMap<>();
        
        int totalFavorites = favoriteRestaurants.size();
        int totalVisits = 0;
        double averageVisits = 0.0;
        
        for (Map<String, Object> restaurant : favoriteRestaurants) {
            Object visitCountObj = restaurant.get("visitCount");
            int visitCount = 0;
            
            // Long을 Integer로 안전하게 변환
            if (visitCountObj instanceof Long) {
                visitCount = ((Long) visitCountObj).intValue();
            } else if (visitCountObj instanceof Integer) {
                visitCount = (Integer) visitCountObj;
            }
            
            totalVisits += visitCount;
        }
        
        if (totalFavorites > 0) {
            averageVisits = Math.round((double) totalVisits / totalFavorites * 10.0) / 10.0;
        }
        
        stats.put("totalFavorites", totalFavorites);
        stats.put("totalVisits", totalVisits);
        stats.put("averageVisits", averageVisits);
        
        return stats;
    }
}