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

	// ����� ��ȸ
	public User findById(Integer userId) {
		return userMapper.findById(userId);
	}

	public User findByEmail(String email) {
		return userMapper.findByEmail(email);
	}

	// ����� ���
	public void registerUser(User user) {
		// �̸��� �ߺ� üũ
		if (userMapper.existsByEmail(user.getEmail())) {
			throw new RuntimeException("�̹� �����ϴ� �̸����Դϴ�.");
		}

		// �⺻�� ����
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

	// ����� ���
	public void registerBusiness(User user) {
		// �̸��� �ߺ� üũ
		if (userMapper.existsByEmail(user.getEmail())) {
			throw new RuntimeException("�̹� �����ϴ� �̸����Դϴ�.");
		}

		// ����� �⺻�� ����
		user.setUserType("BUSINESS");
		user.setApprovalStatus("PENDING"); // ���� ���
		user.setReservationCount(0);

		userMapper.insertUser(user);
	}

	// ����� ���� ����
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
            System.err.println("��й�ȣ ������Ʈ ����: " + e.getMessage());
            return false;
        }
	}
	// ����� ����
	public void deleteUser(Integer userId) {
		userMapper.deleteUser(userId);
	}

	// ���� ��� ����� ���
	public List<User> getPendingBusinessUsers() {
		return userMapper.findPendingBusinessUsers();
	}

	// ����� ����
	public void approveBusiness(Integer userId) {
		userMapper.updateApprovalStatus(userId, "APPROVED", null);
	}

	// ����� �ź�
	public void rejectBusiness(Integer userId, String rejectionReason) {
		userMapper.updateApprovalStatus(userId, "REJECTED", rejectionReason);
	}

	// ���� Ƚ�� ����
	public void incrementReservationCount(Integer userId) {
		userMapper.incrementReservationCount(userId);
	}

	// ����� ��� ��ȸ
	public List<User> getAllUsers() {
		return userMapper.findAllUsers();
	}

	public List<User> getUsersByType(String userType) {
		return userMapper.findUsersByType(userType);
	}

	// ��ȣ�� ���� ����� ��� ��ȸ
	public List<User> getUsersByTypeWithPreferences(String userType) {
		return userMapper.findUsersByTypeWithPreferences(userType);
	}

	public List<User> getAllUsersWithPreferences() {
		return userMapper.findAllUsersWithPreferences();
	}

	// �ߺ� üũ
	public boolean isEmailExists(String email) {
		return userMapper.existsByEmail(email);
	}

	public boolean isPhoneExists(String phone) {
		return userMapper.existsByPhone(phone);
	}
}