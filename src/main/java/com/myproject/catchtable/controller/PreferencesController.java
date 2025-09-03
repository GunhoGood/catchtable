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
    
    // ��ȣ�� ���� ������
    @GetMapping("/setup")
    public String preferencesSetupPage() {
        return "preferences";
    }
    
    // ��ȣ�� ����
    @PostMapping("/save")
    @ResponseBody
    public ApiResponse savePreferences(@RequestBody UserPreferences userPreferences, 
                                     HttpSession session) {
        try {
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId == null) {
                return ApiResponse.error("�α����� �ʿ��մϴ�.");
            }
            
            userPreferences.setUserId(userId);
            userPreferencesService.saveUserPreferences(userPreferences);
            
            return new ApiResponse("��ȣ���� ����Ǿ����ϴ�.");
            
        } catch (Exception e) {
            return ApiResponse.error("��ȣ�� ���� �� ������ �߻��߽��ϴ�: " + e.getMessage());
        }
    }
}