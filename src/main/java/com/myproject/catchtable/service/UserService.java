package com.myproject.catchtable.service;

import com.myproject.catchtable.mapper.UserMapper;
import com.myproject.catchtable.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class UserService {

	@Autowired
	private UserMapper userMapper;

	// 사용자 조회
	public User findById(Integer userId) {
		return userMapper.findById(userId);
	}

	public User findByEmail(String email) {
		return userMapper.findByEmail(email);
	}

	// 사용자 등록
	public void registerUser(User user) {
		// 이메일 중복 체크
		if (userMapper.existsByEmail(user.getEmail())) {
			throw new RuntimeException("이미 존재하는 이메일입니다.");
		}

		// 기본값 설정
		if (user.getUserType() == null) {
			user.setUserType("USER");
		}
		if (user.getApprovalStatus() == null) {
			user.setApprovalStatus("APPROVED");
		}
		if (user.getReservationCount() == null) {
			user.setReservationCount(0);
		}

		userMapper.insertUser(user);
	}

	// 사업자 등록
	public void registerBusiness(User user) {
		// 이메일 중복 체크
		if (userMapper.existsByEmail(user.getEmail())) {
			throw new RuntimeException("이미 존재하는 이메일입니다.");
		}

		// 사업자 기본값 설정
		user.setUserType("BUSINESS");
		user.setApprovalStatus("PENDING"); // 승인 대기
		user.setReservationCount(0);

		userMapper.insertUser(user);
	}

	// 사용자 정보 수정
	public void updateUser(User user) {
		userMapper.updateUser(user);
	}

	public boolean updatePassword(Integer userId, String newPassword) {
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("userId", userId);
            params.put("newPassword", newPassword);
            
            int result = userMapper.updatePassword(params);
            return result > 0;
        } catch (Exception e) {
            System.err.println("비밀번호 업데이트 실패: " + e.getMessage());
            return false;
        }
	}
	// 사용자 삭제
	public void deleteUser(Integer userId) {
		userMapper.deleteUser(userId);
	}

	// 승인 대기 사업자 목록
	public List<User> getPendingBusinessUsers() {
		return userMapper.findPendingBusinessUsers();
	}

	// 사업자 승인
	public void approveBusiness(Integer userId) {
		userMapper.updateApprovalStatus(userId, "APPROVED", null);
	}

	// 사업자 거부
	public void rejectBusiness(Integer userId, String rejectionReason) {
		userMapper.updateApprovalStatus(userId, "REJECTED", rejectionReason);
	}

	// 예약 횟수 증가
	public void incrementReservationCount(Integer userId) {
		userMapper.incrementReservationCount(userId);
	}

	// 사용자 목록 조회
	public List<User> getAllUsers() {
		return userMapper.findAllUsers();
	}

	public List<User> getUsersByType(String userType) {
		return userMapper.findUsersByType(userType);
	}

	// 선호도 포함 사용자 목록 조회
	public List<User> getUsersByTypeWithPreferences(String userType) {
		return userMapper.findUsersByTypeWithPreferences(userType);
	}

	public List<User> getAllUsersWithPreferences() {
		return userMapper.findAllUsersWithPreferences();
	}

	// 중복 체크
	public boolean isEmailExists(String email) {
		return userMapper.existsByEmail(email);
	}

	public boolean isPhoneExists(String phone) {
		return userMapper.existsByPhone(phone);
	}
}