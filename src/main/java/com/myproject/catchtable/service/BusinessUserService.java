package com.myproject.catchtable.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.myproject.catchtable.mapper.UserMapper;

@Service
public class BusinessUserService {
    
    @Autowired
    private UserMapper userMapper;
    
    public int updatePassword(Integer userId, String newPassword) {
        
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("newPassword", newPassword);
        
        return userMapper.updatePassword(params);
    }
}