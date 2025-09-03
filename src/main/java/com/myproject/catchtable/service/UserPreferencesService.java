package com.myproject.catchtable.service;

import com.myproject.catchtable.mapper.UserPreferencesMapper;
import com.myproject.catchtable.model.UserPreferences;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class UserPreferencesService {
    
    @Autowired
    private UserPreferencesMapper userPreferencesMapper;
    
    // 사용자 선호도 조회
    public UserPreferences findByUserId(Integer userId) {
        return userPreferencesMapper.findByUserId(userId);
    }
    
    // 사용자 선호도 저장
    public void saveUserPreferences(UserPreferences userPreferences) {
        UserPreferences existing = userPreferencesMapper.findByUserId(userPreferences.getUserId());
        
        if (existing == null) {
            // 새로 등록
            userPreferencesMapper.insertUserPreferences(userPreferences);
        } else {
            // 기존 데이터 수정
            userPreferencesMapper.updateUserPreferences(userPreferences);
        }
    }
}