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

    // ���� ���� �޼���
    private Integer validateUserSession(HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            return null;
        }
        return userId;
    }

    // ���� �� ������ (�ۼ�/����)
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
                // ���� ���
                Review review = reviewService.findById(reviewId);
                if (review == null || !review.getUserId().equals(userId)) {
                    model.addAttribute("error", "���並 ã�� �� ���ų� ���� ������ �����ϴ�.");
                    return "redirect:/user/reviews";
                }
                
                // ������� �̸� ��ȸ
                String restaurantName = restaurantService.getRestaurantName(review.getRestaurantId());
                
                model.addAttribute("review", review);
                model.addAttribute("restaurantName", restaurantName);
                model.addAttribute("mode", "edit");
            } else {
                // �ۼ� ���
                if (restaurantId == null || reservationId == null) {
                    return "redirect:/user/reservations";
                }
                
                // ������� �̸� ��ȸ
                String restaurantName = restaurantService.getRestaurantName(restaurantId);
                
                model.addAttribute("restaurantId", restaurantId);
                model.addAttribute("reservationId", reservationId);
                model.addAttribute("restaurantName", restaurantName);
                model.addAttribute("mode", "create");
            }

            return "review-form";

        } catch (Exception e) {
            System.err.println("���� �� ����: " + e.getMessage());
            model.addAttribute("error", "�������� �ҷ����� �� ������ �߻��߽��ϴ�.");
            return "redirect:/user/reviews";
        }
    }

    // ���� �ۼ�
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
                response.put("message", "�α����� �ʿ��մϴ�.");
                return ResponseEntity.ok(response);
            }

            // ���� ��ü ����
            Review review = new Review();
            review.setUserId(userId);
            review.setRestaurantId(restaurantId);
            review.setReservationId(reservationId);
            review.setRating(rating);
            review.setContent(content);
            review.setIsRecommended(isRecommended);

            // �̹��� ���ε� ó�� (�ִٸ�)
            if (imageFile != null && !imageFile.isEmpty()) {
                String imageUrl = uploadImage(imageFile);
                review.setImageUrl(imageUrl);
            }

            // ���� ����
            reviewService.createReview(review);

            response.put("success", true);
            response.put("message", "���䰡 ���������� �ۼ��Ǿ����ϴ�.");

        } catch (Exception e) {
            System.err.println("���� �ۼ� ����: " + e.getMessage());
            response.put("success", false);
            response.put("message", "���� �ۼ� �� ������ �߻��߽��ϴ�.");
        }

        return ResponseEntity.ok(response);
    }

    // ���� ����
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
                response.put("message", "�α����� �ʿ��մϴ�.");
                return ResponseEntity.ok(response);
            }

            // ���� ���� ��ȸ
            Review review = reviewService.findById(reviewId);
            if (review == null || !review.getUserId().equals(userId)) {
                response.put("success", false);
                response.put("message", "���� ������ �����ϴ�.");
                return ResponseEntity.ok(response);
            }

            // ���� ���� ������Ʈ
            review.setRating(rating);
            review.setContent(content);
            review.setIsRecommended(isRecommended);

            // �̹��� ���ε� ó�� (�ִٸ�)
            if (imageFile != null && !imageFile.isEmpty()) {
                String imageUrl = uploadImage(imageFile);
                review.setImageUrl(imageUrl);
            }

            // ���� ����
            reviewService.updateReview(review);

            response.put("success", true);
            response.put("message", "���䰡 ���������� �����Ǿ����ϴ�.");

        } catch (Exception e) {
            System.err.println("���� ���� ����: " + e.getMessage());
            response.put("success", false);
            response.put("message", "���� ���� �� ������ �߻��߽��ϴ�.");
        }

        return ResponseEntity.ok(response);
    }

    // �̹��� ���ε� ó�� 
    private String uploadImage(MultipartFile imageFile) {
        try {
            // ���ε� ���丮 ���� (������Ʈ ����)
            String uploadDir = System.getProperty("user.dir") + "/src/main/webapp/uploads/reviews/";
            File uploadDirFile = new File(uploadDir);
            
            // ���丮�� ������ ����
            if (!uploadDirFile.exists()) {
                uploadDirFile.mkdirs();
                System.out.println("���ε� ���丮 ����: " + uploadDir);
            }
            
            // ���ϸ� ���� (�ߺ� ����)
            String fileName = System.currentTimeMillis() + "_" + imageFile.getOriginalFilename();
            String filePath = uploadDir + fileName;
            
            // ���� ���� ����
            imageFile.transferTo(new File(filePath));
            System.out.println("���� ���� �Ϸ�: " + filePath);
            
            // ������ ���� ������ ��� ��ȯ
            return "/uploads/reviews/" + fileName;
            
        } catch (Exception e) {
            System.err.println("�̹��� ���ε� ����: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}