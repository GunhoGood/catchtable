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
				response.put("message", "�α����� �ʿ��մϴ�.");
				return ResponseEntity.ok(response);
			}

			User user = userService.findById(userId);
			if (user == null) {
				response.put("success", false);
				response.put("message", "����� ������ ã�� �� �����ϴ�.");
				return ResponseEntity.ok(response);
			}

			// �⺻ ����� ���� ������Ʈ
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

			// ��ȣ�� ���� ������Ʈ
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
			response.put("message", "�������� ���������� ������Ʈ�Ǿ����ϴ�.");

		} catch (Exception e) {
			System.err.println("������ ������Ʈ ����: " + e.getMessage());
			response.put("success", false);
			response.put("message", "������ ������Ʈ �� ������ �߻��߽��ϴ�.");
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

			// ����� ��ȣ�� ������ �Բ� ��ȸ
			UserPreferences preferences = userPreferencesService.findByUserId(userId);

			model.addAttribute("user", user);
			model.addAttribute("preferences", preferences);
			return "user-profile";

		} catch (Exception e) {
			System.err.println("����� ������ ����: " + e.getMessage());
			model.addAttribute("error", "�������� �ҷ����� �� ������ �߻��߽��ϴ�.");
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
	            response.put("message", "�α����� �ʿ��մϴ�.");
	            return ResponseEntity.ok(response);
	        }
	        User user = userService.findById(userId);
	        if (user == null) {
	            response.put("success", false);
	            response.put("message", "����� ������ ã�� �� �����ϴ�.");
	            return ResponseEntity.ok(response);
	        }
	        String currentPassword = passwordData.get("currentPassword");
	        String newPassword = passwordData.get("newPassword");
	        
	        
	        
	        if (!currentPassword.equals(user.getPassword())) {
	            response.put("success", false);
	            response.put("message", "���� ��й�ȣ�� ��ġ���� �ʽ��ϴ�.");
	            return ResponseEntity.ok(response);
	        }
	        if (currentPassword.equals(newPassword)) {
	            response.put("success", false);
	            response.put("message", "�� ��й�ȣ�� ���� ��й�ȣ�� �޶�� �մϴ�.");
	            return ResponseEntity.ok(response);
	        }
	        boolean updateResult = userService.updatePassword(userId, newPassword);
	        
	        if (updateResult) {
	            response.put("success", true);
	            response.put("message", "��й�ȣ�� ���������� ����Ǿ����ϴ�.");
	        } else {
	            response.put("success", false);
	            response.put("message", "��й�ȣ ���濡 �����߽��ϴ�.");
	        }
	        
	    } catch (Exception e) {
	        System.err.println("��й�ȣ ���� ����: " + e.getMessage());
	        response.put("success", false);
	        response.put("message", "���� ������ �߻��߽��ϴ�.");
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

	        // �� ���࿡ ���� ���� �ۼ� ���� Ȯ��
	        Map<Integer, Boolean> reviewStatusMap = new HashMap<>();
	        for (Reservation reservation : allReservations) {
	            boolean hasReview = reviewService.hasReviewForReservation(reservation.getReservationId());
	            reviewStatusMap.put(reservation.getReservationId(), hasReview);
	        }

	        // ����¡ ó�� (���� �ڵ� �״��)
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
	        model.addAttribute("reviewStatusMap", reviewStatusMap); // �߰�
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
	        System.err.println("����� ���� ��� ����: " + e.getMessage());
	        model.addAttribute("error", "���� ����� �ҷ����� �� ������ �߻��߽��ϴ�.");
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
				response.put("message", "�α����� �ʿ��մϴ�.");
				return ResponseEntity.ok(response);
			}

			reservationService.cancelReservation(reservationId, userId);

			response.put("success", true);
			response.put("message", "������ ���������� ��ҵǾ����ϴ�.");

		} catch (Exception e) {
			System.err.println("���� ��� ����: " + e.getMessage());
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

	        // ����¡ ó��
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

	        // ���� ��� ���
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

	        // ReviewStats ��ü ����
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
	        System.err.println("����� ���� ��� ����: " + e.getMessage());
	        model.addAttribute("error", "���� ����� �ҷ����� �� ������ �߻��߽��ϴ�.");
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
				response.put("message", "�α����� �ʿ��մϴ�.");
				return ResponseEntity.ok(response);
			}

			
			reviewService.deleteReview(reviewId, userId);

			response.put("success", true);
			response.put("message", "���䰡 ���������� �����Ǿ����ϴ�.");

		} catch (Exception e) {
			System.err.println("���� ���� ����: " + e.getMessage());
			response.put("success", false);
			response.put("message", e.getMessage());
		}

		return ResponseEntity.ok(response);
	}
	/**
     * ����� ���� ��� ������
     */
    @GetMapping("/coupons")
    public String userCoupons(HttpSession session, Model model) {
        try {
            // �α��� Ȯ��
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                return "redirect:/auth/login";
            }

            // ������� ��� ���� ��ȸ (���� ���� ����)
            List<UserCoupon> userCoupons = couponService.findUserCoupons(currentUser.getUserId());
            
            // �� ������ ���� ���� �߰�
            for (UserCoupon userCoupon : userCoupons) {
                // ���� ���� Ȯ��
                boolean isExpired = userCoupon.getEndDate() != null && 
                                  userCoupon.getEndDate().isBefore(LocalDate.now());
                
                // �� ���� ���� Ȯ�� (7�� �̳�)
                boolean isExpiringSoon = userCoupon.getEndDate() != null && 
                                       !isExpired &&
                                       userCoupon.getEndDate().isBefore(LocalDate.now().plusDays(7));
                
                // ���� ����
                String couponStatus;
                if (userCoupon.getIsUsed()) {
                    couponStatus = "used";
                } else if (isExpired) {
                    couponStatus = "expired";
                } else {
                    couponStatus = "available";
                }
                
                // �ӽ÷� UserCoupon�� ���� ���� �߰� (�ʿ�� UserCoupon �𵨿� �ʵ� �߰�)
                // ���⼭�� description�� ���� ������ �ӽ÷� ��� JSP���� ���
                userCoupon.setCouponDescription(userCoupon.getCouponDescription() + "|STATUS:" + couponStatus);
                
                // ���� ���� ������ �߰�
                if (isExpiringSoon) {
                    userCoupon.setCouponDescription(userCoupon.getCouponDescription() + "|EXPIRING_SOON:true");
                }
                if (isExpired) {
                    userCoupon.setCouponDescription(userCoupon.getCouponDescription() + "|EXPIRED:true");
                }
            }

            // ���� ��� ���
            Map<String, Integer> couponStats = calculateCouponStats(userCoupons);

            // �𵨿� ������ �߰�
            model.addAttribute("userCoupons", userCoupons);
            model.addAttribute("couponStats", couponStats);
            model.addAttribute("user", currentUser);

            return "user-coupons";

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "���� ����� �ҷ����� �� ������ �߻��߽��ϴ�.");
            return "user-coupons";
        }
    }

    /**
     * ���� ��� ���
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
     * ����� �ܰ� ������� ��� (3ȸ �̻� �湮)
     */
    @GetMapping("/favorites")
    public String userFavorites(HttpSession session, Model model) {
        try {
            Integer userId = validateUserSession(session);
            if (userId == null) {
                return "redirect:/login";
            }

            // 3ȸ �̻� �湮�� ������� ��ȸ
            List<Map<String, Object>> favoriteRestaurants = reservationService.getFavoriteRestaurants(userId, 3);
            
            // �� ��������� �߰� ���� ����
            for (Map<String, Object> restaurant : favoriteRestaurants) {
                Integer restaurantId = (Integer) restaurant.get("restaurantId");
                
                // ���� ���� �߰�
                Map<String, Object> reviewStats = restaurantService.getRestaurantReviewStats(restaurantId);
                restaurant.put("averageRating", reviewStats.get("averageRating"));
                restaurant.put("reviewCount", reviewStats.get("reviewCount"));
            }

            // ��� ���
            Map<String, Object> favoriteStats = calculateFavoriteStats(favoriteRestaurants);

            model.addAttribute("favoriteRestaurants", favoriteRestaurants);
            model.addAttribute("favoriteStats", favoriteStats);

            return "user-favorites";

        } catch (Exception e) {
            System.err.println("�ܰ� ������� ��� ����: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "�ܰ� ������� ����� �ҷ����� �� ������ �߻��߽��ϴ�.");
            return "user-favorites";
        }
    }

    /**
     * �ܰ� ������� ��� ���
     */
    private Map<String, Object> calculateFavoriteStats(List<Map<String, Object>> favoriteRestaurants) {
        Map<String, Object> stats = new HashMap<>();
        
        int totalFavorites = favoriteRestaurants.size();
        int totalVisits = 0;
        double averageVisits = 0.0;
        
        for (Map<String, Object> restaurant : favoriteRestaurants) {
            Object visitCountObj = restaurant.get("visitCount");
            int visitCount = 0;
            
            // Long�� Integer�� �����ϰ� ��ȯ
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