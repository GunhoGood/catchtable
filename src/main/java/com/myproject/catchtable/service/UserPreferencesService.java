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
    
    // ����� ��ȣ�� ��ȸ
    public UserPreferences findByUserId(Integer userId) {
        return userPreferencesMapper.findByUserId(userId);
    }
    
    // ����� ��ȣ�� ����
    public void saveUserPreferences(UserPreferences userPreferences) {
        UserPreferences existing = userPreferencesMapper.findByUserId(userPreferences.getUserId());
        
        if (existing == null) {
            // ���� ���
            userPreferencesMapper.insertUserPreferences(userPreferences);
        } else {
            // ���� ������ ����
            userPreferencesMapper.updateUserPreferences(userPreferences);
        }
    }
}