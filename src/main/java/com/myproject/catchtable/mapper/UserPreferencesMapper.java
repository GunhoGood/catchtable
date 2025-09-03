package com.myproject.catchtable.mapper;

import com.myproject.catchtable.model.UserPreferences;

public interface UserPreferencesMapper {
    
    // ����� ��ȣ�� ��ȸ
    UserPreferences findByUserId(Integer userId);
    
    // ����� ��ȣ�� ���
    void insertUserPreferences(UserPreferences userPreferences);
    
    // ����� ��ȣ�� ����
    void updateUserPreferences(UserPreferences userPreferences);
    
    // ����� ��ȣ�� ����
    void deleteUserPreferences(Integer userId);
}