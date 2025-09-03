package com.myproject.catchtable.controller;

import com.myproject.catchtable.dto.ApiResponse;
import com.myproject.catchtable.model.UserPreferences;
import com.myproject.catchtable.service.UserPreferencesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/preferences")
public class PreferencesController {
    
    @Autowired
    private UserPreferencesService userPreferencesService;
    
    // 선호도 설정 페이지
    @GetMapping("/setup")
    public String preferencesSetupPage() {
        return "preferences";
    }
    
    // 선호도 저장
    @PostMapping("/save")
    @ResponseBody
    public ApiResponse savePreferences(@RequestBody UserPreferences userPreferences, 
                                     HttpSession session) {
        try {
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId == null) {
                return ApiResponse.error("로그인이 필요합니다.");
            }
            
            userPreferences.setUserId(userId);
            userPreferencesService.saveUserPreferences(userPreferences);
            
            return new ApiResponse("선호도가 저장되었습니다.");
            
        } catch (Exception e) {
            return ApiResponse.error("선호도 저장 중 오류가 발생했습니다: " + e.getMessage());
        }
    }
}