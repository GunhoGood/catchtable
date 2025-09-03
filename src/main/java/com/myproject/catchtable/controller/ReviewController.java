package com.myproject.catchtable.controller;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.myproject.catchtable.model.Review;
import com.myproject.catchtable.service.RestaurantService;
import com.myproject.catchtable.service.ReviewService;

@Controller
@RequestMapping("/review")
public class ReviewController {

    @Autowired
    private ReviewService reviewService;
    
    @Autowired
    private RestaurantService restaurantService;

    // 세션 검증 메서드
    private Integer validateUserSession(HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            return null;
        }
        return userId;
    }

    // 리뷰 폼 페이지 (작성/수정)
    @GetMapping("/form")
    public String reviewForm(@RequestParam(required = false) Integer reviewId,
                            @RequestParam(required = false) Integer restaurantId,
                            @RequestParam(required = false) Integer reservationId,
                            HttpSession session, Model model) {
        try {
            Integer userId = validateUserSession(session);
            if (userId == null) {
                return "redirect:/login";
            }

            if (reviewId != null) {
                // 수정 모드
                Review review = reviewService.findById(reviewId);
                if (review == null || !review.getUserId().equals(userId)) {
                    model.addAttribute("error", "리뷰를 찾을 수 없거나 수정 권한이 없습니다.");
                    return "redirect:/user/reviews";
                }
                
                // 레스토랑 이름 조회
                String restaurantName = restaurantService.getRestaurantName(review.getRestaurantId());
                
                model.addAttribute("review", review);
                model.addAttribute("restaurantName", restaurantName);
                model.addAttribute("mode", "edit");
            } else {
                // 작성 모드
                if (restaurantId == null || reservationId == null) {
                    return "redirect:/user/reservations";
                }
                
                // 레스토랑 이름 조회
                String restaurantName = restaurantService.getRestaurantName(restaurantId);
                
                model.addAttribute("restaurantId", restaurantId);
                model.addAttribute("reservationId", reservationId);
                model.addAttribute("restaurantName", restaurantName);
                model.addAttribute("mode", "create");
            }

            return "review-form";

        } catch (Exception e) {
            System.err.println("리뷰 폼 오류: " + e.getMessage());
            model.addAttribute("error", "페이지를 불러오는 중 오류가 발생했습니다.");
            return "redirect:/user/reviews";
        }
    }

    // 리뷰 작성
    @PostMapping("/create")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createReview(
            @RequestParam Integer restaurantId,
            @RequestParam Integer reservationId,
            @RequestParam Integer rating,
            @RequestParam String content,
            @RequestParam Boolean isRecommended,
            @RequestParam(required = false) MultipartFile imageFile,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            Integer userId = validateUserSession(session);
            if (userId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.ok(response);
            }

            // 리뷰 객체 생성
            Review review = new Review();
            review.setUserId(userId);
            review.setRestaurantId(restaurantId);
            review.setReservationId(reservationId);
            review.setRating(rating);
            review.setContent(content);
            review.setIsRecommended(isRecommended);

            // 이미지 업로드 처리 (있다면)
            if (imageFile != null && !imageFile.isEmpty()) {
                String imageUrl = uploadImage(imageFile);
                review.setImageUrl(imageUrl);
            }

            // 리뷰 저장
            reviewService.createReview(review);

            response.put("success", true);
            response.put("message", "리뷰가 성공적으로 작성되었습니다.");

        } catch (Exception e) {
            System.err.println("리뷰 작성 오류: " + e.getMessage());
            response.put("success", false);
            response.put("message", "리뷰 작성 중 오류가 발생했습니다.");
        }

        return ResponseEntity.ok(response);
    }

    // 리뷰 수정
    @PostMapping("/update")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateReview(
            @RequestParam Integer reviewId,
            @RequestParam Integer rating,
            @RequestParam String content,
            @RequestParam Boolean isRecommended,
            @RequestParam(required = false) MultipartFile imageFile,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            Integer userId = validateUserSession(session);
            if (userId == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return ResponseEntity.ok(response);
            }

            // 기존 리뷰 조회
            Review review = reviewService.findById(reviewId);
            if (review == null || !review.getUserId().equals(userId)) {
                response.put("success", false);
                response.put("message", "수정 권한이 없습니다.");
                return ResponseEntity.ok(response);
            }

            // 리뷰 정보 업데이트
            review.setRating(rating);
            review.setContent(content);
            review.setIsRecommended(isRecommended);

            // 이미지 업로드 처리 (있다면)
            if (imageFile != null && !imageFile.isEmpty()) {
                String imageUrl = uploadImage(imageFile);
                review.setImageUrl(imageUrl);
            }

            // 리뷰 수정
            reviewService.updateReview(review);

            response.put("success", true);
            response.put("message", "리뷰가 성공적으로 수정되었습니다.");

        } catch (Exception e) {
            System.err.println("리뷰 수정 오류: " + e.getMessage());
            response.put("success", false);
            response.put("message", "리뷰 수정 중 오류가 발생했습니다.");
        }

        return ResponseEntity.ok(response);
    }

    // 이미지 업로드 처리 
    private String uploadImage(MultipartFile imageFile) {
        try {
            // 업로드 디렉토리 설정 (프로젝트 내부)
            String uploadDir = System.getProperty("user.dir") + "/src/main/webapp/uploads/reviews/";
            File uploadDirFile = new File(uploadDir);
            
            // 디렉토리가 없으면 생성
            if (!uploadDirFile.exists()) {
                uploadDirFile.mkdirs();
                System.out.println("업로드 디렉토리 생성: " + uploadDir);
            }
            
            // 파일명 생성 (중복 방지)
            String fileName = System.currentTimeMillis() + "_" + imageFile.getOriginalFilename();
            String filePath = uploadDir + fileName;
            
            // 실제 파일 저장
            imageFile.transferTo(new File(filePath));
            System.out.println("파일 저장 완료: " + filePath);
            
            // 웹에서 접근 가능한 경로 반환
            return "/uploads/reviews/" + fileName;
            
        } catch (Exception e) {
            System.err.println("이미지 업로드 오류: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}