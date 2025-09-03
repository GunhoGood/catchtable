package com.myproject.catchtable.mapper;

import com.myproject.catchtable.model.User;
import org.apache.ibatis.annotations.Param; 
import java.util.List;
import java.util.Map;

public interface UserMapper {
    
    // 사용자 조회
    User findById(Integer userId);
    User findByEmail(String email);
    
    // 사용자 등록/수정
    void insertUser(User user);
    void updateUser(User user);
    void deleteUser(Integer userId);
    int updatePassword(Map<String, Object> params);

    // 사업자 승인 관리 
    List<User> findPendingBusinessUsers();
    void updateApprovalStatus(@Param("userId") Integer userId, 
                             @Param("approvalStatus") String approvalStatus, 
                             @Param("rejectionReason") String rejectionReason);
    
    // 예약 횟수 업데이트
    void incrementReservationCount(Integer userId);
    
    // 사용자 목록 조회
    List<User> findAllUsers();
    List<User> findUsersByType(String userType);
    
    //선호도와 함께 사용자 조회
    List<User> findUsersByTypeWithPreferences(String userType);
    List<User> findAllUsersWithPreferences();
    //비밀번호변경
    int updatePassword(@Param("userId") Integer userId, @Param("newPassword") String newPassword);
    // 중복 체크
    boolean existsByEmail(String email);
    boolean existsByPhone(String phone);
}