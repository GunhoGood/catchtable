package com.myproject.catchtable.mapper;

import com.myproject.catchtable.model.UserPreferences;

public interface UserPreferencesMapper {
    
    // 사용자 선호도 조회
    UserPreferences findByUserId(Integer userId);
    
    // 사용자 선호도 등록
    void insertUserPreferences(UserPreferences userPreferences);
    
    // 사용자 선호도 수정
    void updateUserPreferences(UserPreferences userPreferences);
    
    // 사용자 선호도 삭제
    void deleteUserPreferences(Integer userId);
}