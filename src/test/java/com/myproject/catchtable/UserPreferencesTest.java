package com.myproject.catchtable;
import static org.junit.Assert.*;
import java.sql.SQLException;

import javax.sql.DataSource;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import com.myproject.catchtable.mapper.UserPreferencesMapper;
import com.myproject.catchtable.mapper.UserMapper;
import com.myproject.catchtable.model.UserPreferences;
import com.myproject.catchtable.model.User;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/main/webapp/WEB-INF/spring/**/root-context.xml" })
public class UserPreferencesTest {
	
	@Autowired
    UserPreferencesMapper userPreferencesMapper;
	
	@Autowired
    UserMapper userMapper;
	
	@Autowired
	DataSource ds;
	
	@Test
	public void connectionTest() throws SQLException {
		assertTrue(ds.getConnection()!=null);
		System.out.println("DB ���� ����");
	}
	
	@Test
	public void insertTest() throws Exception {
		// �׽�Ʈ�� ����� ����
		String testEmail = "preferencestest1@example.com";
		User existingUser = userMapper.findByEmail(testEmail);
		if(existingUser != null) {
			userMapper.deleteUser(existingUser.getUserId());
		}
		
		User testUser = new User();
		testUser.setEmail(testEmail);
		testUser.setPassword("password123");
		testUser.setName("��ȣ���׽�Ʈ1");
		testUser.setPhone("010-1111-0001");
		testUser.setBirthDate("1990-01-01");
		testUser.setGender("M");
		testUser.setUserType("USER");
		testUser.setApprovalStatus("APPROVED");
		testUser.setReservationCount(0);
		
		userMapper.insertUser(testUser);
		
		// ������ ����� ID�� ��ȣ�� �׽�Ʈ
		User createdUser = userMapper.findByEmail(testEmail);
		Integer userId = createdUser.getUserId();
		
		// ���� ��ȣ�� �����Ͱ� ������ ����
		UserPreferences existingPreferences = userPreferencesMapper.findByUserId(userId);
		if(existingPreferences != null) {
			userPreferencesMapper.deleteUserPreferences(userId);
		}
		
		UserPreferences preferences = new UserPreferences();
		preferences.setUserId(userId);
		preferences.setPreferredCuisineTypes("�ѽ�,�߽�");
		preferences.setPreferredPriceRange("MEDIUM");
		preferences.setPreferredArea("������");
		
		userPreferencesMapper.insertUserPreferences(preferences);
		
		UserPreferences insertedPreferences = userPreferencesMapper.findByUserId(userId);
		assertTrue(insertedPreferences != null);
		assertTrue(insertedPreferences.getUserId().equals(userId));
		assertTrue(insertedPreferences.getPreferredCuisineTypes().equals("�ѽ�,�߽�"));
		System.out.println("Insert ����: " + insertedPreferences);
		
		// ����
		userPreferencesMapper.deleteUserPreferences(userId);
		userMapper.deleteUser(userId);
	}
	
	@Test
	public void findByUserIdTest() throws Exception {
		// �׽�Ʈ�� ����� ����
		String testEmail = "preferencestest2@example.com";
		User existingUser = userMapper.findByEmail(testEmail);
		if(existingUser != null) {
			userMapper.deleteUser(existingUser.getUserId());
		}
		
		User testUser = new User();
		testUser.setEmail(testEmail);
		testUser.setPassword("password123");
		testUser.setName("��ȣ���׽�Ʈ2");
		testUser.setPhone("010-2222-0002");
		testUser.setBirthDate("1985-05-15");
		testUser.setGender("F");
		testUser.setUserType("USER");
		testUser.setApprovalStatus("APPROVED");
		testUser.setReservationCount(0);
		
		userMapper.insertUser(testUser);
		
		//������ ����� ID�� ��ȣ�� �׽�Ʈ
		User createdUser = userMapper.findByEmail(testEmail);
		Integer userId = createdUser.getUserId();
		
		UserPreferences preferences = new UserPreferences();
		preferences.setUserId(userId);
		preferences.setPreferredCuisineTypes("�Ͻ�,���");
		preferences.setPreferredPriceRange("HIGH");
		preferences.setPreferredArea("���ʱ�");
		
		userPreferencesMapper.insertUserPreferences(preferences);
		
		UserPreferences foundPreferences = userPreferencesMapper.findByUserId(userId);
		assertTrue(foundPreferences != null);
		assertTrue(foundPreferences.getUserId().equals(userId));
		assertTrue(foundPreferences.getPreferredCuisineTypes().equals("�Ͻ�,���"));
		assertTrue(foundPreferences.getPreferredPriceRange().equals("HIGH"));
		assertTrue(foundPreferences.getPreferredArea().equals("���ʱ�"));
		System.out.println("FindByUserId ����: " + foundPreferences);
		
		// ����
		userPreferencesMapper.deleteUserPreferences(userId);
		userMapper.deleteUser(userId);
	}
	
	@Test
	public void updateTest() throws Exception {
		// �׽�Ʈ�� ����� ����
		String testEmail = "preferencestest3@example.com";
		User existingUser = userMapper.findByEmail(testEmail);
		if(existingUser != null) {
			userMapper.deleteUser(existingUser.getUserId());
		}
		
		User testUser = new User();
		testUser.setEmail(testEmail);
		testUser.setPassword("password123");
		testUser.setName("��ȣ���׽�Ʈ3");
		testUser.setPhone("010-3333-0003");
		testUser.setBirthDate("1988-03-10");
		testUser.setGender("M");
		testUser.setUserType("USER");
		testUser.setApprovalStatus("APPROVED");
		testUser.setReservationCount(0);
		
		userMapper.insertUser(testUser);
		
		// ������ ����� ID�� ��ȣ�� �׽�Ʈ
		User createdUser = userMapper.findByEmail(testEmail);
		Integer userId = createdUser.getUserId();
		
		// �ʱ� ������ ����
		UserPreferences preferences = new UserPreferences();
		preferences.setUserId(userId);
		preferences.setPreferredCuisineTypes("�ѽ�");
		preferences.setPreferredPriceRange("LOW");
		preferences.setPreferredArea("������");
		
		userPreferencesMapper.insertUserPreferences(preferences);
		
		// ������ ������ �غ�
		UserPreferences updatePreferences = new UserPreferences();
		updatePreferences.setUserId(userId);
		updatePreferences.setPreferredCuisineTypes("�ѽ�,�Ͻ�,�߽�");
		updatePreferences.setPreferredPriceRange("MEDIUM");
		updatePreferences.setPreferredArea("��걸");
		
		userPreferencesMapper.updateUserPreferences(updatePreferences);
		
		UserPreferences result = userPreferencesMapper.findByUserId(userId);
		assertTrue(result.getPreferredCuisineTypes().equals("�ѽ�,�Ͻ�,�߽�"));
		assertTrue(result.getPreferredPriceRange().equals("MEDIUM"));
		assertTrue(result.getPreferredArea().equals("��걸"));
		System.out.println("Update ����: " + result);
		
		// �׽�Ʈ�� ����� ���� 
		userPreferencesMapper.deleteUserPreferences(userId);
		userMapper.deleteUser(userId);
	}
	
	@Test
	public void deleteTest() throws Exception {
		//�׽�Ʈ�� ����� ����
		String testEmail = "preferencestest4@example.com";
		User existingUser = userMapper.findByEmail(testEmail);
		if(existingUser != null) {
			userMapper.deleteUser(existingUser.getUserId());
		}
		
		User testUser = new User();
		testUser.setEmail(testEmail);
		testUser.setPassword("password123");
		testUser.setName("��ȣ���׽�Ʈ4");
		testUser.setPhone("010-4444-0004");
		testUser.setBirthDate("1995-07-20");
		testUser.setGender("F");
		testUser.setUserType("USER");
		testUser.setApprovalStatus("APPROVED");
		testUser.setReservationCount(0);
		
		userMapper.insertUser(testUser);
		
		//������ ����� ID�� ��ȣ�� �׽�Ʈ
		User createdUser = userMapper.findByEmail(testEmail);
		Integer userId = createdUser.getUserId();
		
		UserPreferences preferences = new UserPreferences();
		preferences.setUserId(userId);
		preferences.setPreferredCuisineTypes("���");
		preferences.setPreferredPriceRange("HIGH");
		preferences.setPreferredArea("���α�");
		
		userPreferencesMapper.insertUserPreferences(preferences);
		
		UserPreferences insertedPreferences = userPreferencesMapper.findByUserId(userId);
		assertTrue(insertedPreferences != null);
		
		userPreferencesMapper.deleteUserPreferences(userId);
		
		UserPreferences deletedPreferences = userPreferencesMapper.findByUserId(userId);
		assertTrue(deletedPreferences == null);
		System.out.println("Delete ����: ����� ID " + userId + "�� ��ȣ�� ������");
		
		// �׽�Ʈ�� ����� ���� 
		userMapper.deleteUser(userId);
	}
}