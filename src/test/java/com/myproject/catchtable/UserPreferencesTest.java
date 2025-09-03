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
		System.out.println("DB 연결 성공");
	}
	
	@Test
	public void insertTest() throws Exception {
		// 테스트용 사용자 생성
		String testEmail = "preferencestest1@example.com";
		User existingUser = userMapper.findByEmail(testEmail);
		if(existingUser != null) {
			userMapper.deleteUser(existingUser.getUserId());
		}
		
		User testUser = new User();
		testUser.setEmail(testEmail);
		testUser.setPassword("password123");
		testUser.setName("선호도테스트1");
		testUser.setPhone("010-1111-0001");
		testUser.setBirthDate("1990-01-01");
		testUser.setGender("M");
		testUser.setUserType("USER");
		testUser.setApprovalStatus("APPROVED");
		testUser.setReservationCount(0);
		
		userMapper.insertUser(testUser);
		
		// 생성된 사용자 ID로 선호도 테스트
		User createdUser = userMapper.findByEmail(testEmail);
		Integer userId = createdUser.getUserId();
		
		// 기존 선호도 데이터가 있으면 삭제
		UserPreferences existingPreferences = userPreferencesMapper.findByUserId(userId);
		if(existingPreferences != null) {
			userPreferencesMapper.deleteUserPreferences(userId);
		}
		
		UserPreferences preferences = new UserPreferences();
		preferences.setUserId(userId);
		preferences.setPreferredCuisineTypes("한식,중식");
		preferences.setPreferredPriceRange("MEDIUM");
		preferences.setPreferredArea("강남구");
		
		userPreferencesMapper.insertUserPreferences(preferences);
		
		UserPreferences insertedPreferences = userPreferencesMapper.findByUserId(userId);
		assertTrue(insertedPreferences != null);
		assertTrue(insertedPreferences.getUserId().equals(userId));
		assertTrue(insertedPreferences.getPreferredCuisineTypes().equals("한식,중식"));
		System.out.println("Insert 성공: " + insertedPreferences);
		
		// 삭제
		userPreferencesMapper.deleteUserPreferences(userId);
		userMapper.deleteUser(userId);
	}
	
	@Test
	public void findByUserIdTest() throws Exception {
		// 테스트용 사용자 생성
		String testEmail = "preferencestest2@example.com";
		User existingUser = userMapper.findByEmail(testEmail);
		if(existingUser != null) {
			userMapper.deleteUser(existingUser.getUserId());
		}
		
		User testUser = new User();
		testUser.setEmail(testEmail);
		testUser.setPassword("password123");
		testUser.setName("선호도테스트2");
		testUser.setPhone("010-2222-0002");
		testUser.setBirthDate("1985-05-15");
		testUser.setGender("F");
		testUser.setUserType("USER");
		testUser.setApprovalStatus("APPROVED");
		testUser.setReservationCount(0);
		
		userMapper.insertUser(testUser);
		
		//생성된 사용자 ID로 선호도 테스트
		User createdUser = userMapper.findByEmail(testEmail);
		Integer userId = createdUser.getUserId();
		
		UserPreferences preferences = new UserPreferences();
		preferences.setUserId(userId);
		preferences.setPreferredCuisineTypes("일식,양식");
		preferences.setPreferredPriceRange("HIGH");
		preferences.setPreferredArea("서초구");
		
		userPreferencesMapper.insertUserPreferences(preferences);
		
		UserPreferences foundPreferences = userPreferencesMapper.findByUserId(userId);
		assertTrue(foundPreferences != null);
		assertTrue(foundPreferences.getUserId().equals(userId));
		assertTrue(foundPreferences.getPreferredCuisineTypes().equals("일식,양식"));
		assertTrue(foundPreferences.getPreferredPriceRange().equals("HIGH"));
		assertTrue(foundPreferences.getPreferredArea().equals("서초구"));
		System.out.println("FindByUserId 성공: " + foundPreferences);
		
		// 삭제
		userPreferencesMapper.deleteUserPreferences(userId);
		userMapper.deleteUser(userId);
	}
	
	@Test
	public void updateTest() throws Exception {
		// 테스트용 사용자 생성
		String testEmail = "preferencestest3@example.com";
		User existingUser = userMapper.findByEmail(testEmail);
		if(existingUser != null) {
			userMapper.deleteUser(existingUser.getUserId());
		}
		
		User testUser = new User();
		testUser.setEmail(testEmail);
		testUser.setPassword("password123");
		testUser.setName("선호도테스트3");
		testUser.setPhone("010-3333-0003");
		testUser.setBirthDate("1988-03-10");
		testUser.setGender("M");
		testUser.setUserType("USER");
		testUser.setApprovalStatus("APPROVED");
		testUser.setReservationCount(0);
		
		userMapper.insertUser(testUser);
		
		// 생성된 사용자 ID로 선호도 테스트
		User createdUser = userMapper.findByEmail(testEmail);
		Integer userId = createdUser.getUserId();
		
		// 초기 데이터 삽입
		UserPreferences preferences = new UserPreferences();
		preferences.setUserId(userId);
		preferences.setPreferredCuisineTypes("한식");
		preferences.setPreferredPriceRange("LOW");
		preferences.setPreferredArea("마포구");
		
		userPreferencesMapper.insertUserPreferences(preferences);
		
		// 수정할 데이터 준비
		UserPreferences updatePreferences = new UserPreferences();
		updatePreferences.setUserId(userId);
		updatePreferences.setPreferredCuisineTypes("한식,일식,중식");
		updatePreferences.setPreferredPriceRange("MEDIUM");
		updatePreferences.setPreferredArea("용산구");
		
		userPreferencesMapper.updateUserPreferences(updatePreferences);
		
		UserPreferences result = userPreferencesMapper.findByUserId(userId);
		assertTrue(result.getPreferredCuisineTypes().equals("한식,일식,중식"));
		assertTrue(result.getPreferredPriceRange().equals("MEDIUM"));
		assertTrue(result.getPreferredArea().equals("용산구"));
		System.out.println("Update 성공: " + result);
		
		// 테스트용 사용자 삭제 
		userPreferencesMapper.deleteUserPreferences(userId);
		userMapper.deleteUser(userId);
	}
	
	@Test
	public void deleteTest() throws Exception {
		//테스트용 사용자 생성
		String testEmail = "preferencestest4@example.com";
		User existingUser = userMapper.findByEmail(testEmail);
		if(existingUser != null) {
			userMapper.deleteUser(existingUser.getUserId());
		}
		
		User testUser = new User();
		testUser.setEmail(testEmail);
		testUser.setPassword("password123");
		testUser.setName("선호도테스트4");
		testUser.setPhone("010-4444-0004");
		testUser.setBirthDate("1995-07-20");
		testUser.setGender("F");
		testUser.setUserType("USER");
		testUser.setApprovalStatus("APPROVED");
		testUser.setReservationCount(0);
		
		userMapper.insertUser(testUser);
		
		//생성된 사용자 ID로 선호도 테스트
		User createdUser = userMapper.findByEmail(testEmail);
		Integer userId = createdUser.getUserId();
		
		UserPreferences preferences = new UserPreferences();
		preferences.setUserId(userId);
		preferences.setPreferredCuisineTypes("양식");
		preferences.setPreferredPriceRange("HIGH");
		preferences.setPreferredArea("종로구");
		
		userPreferencesMapper.insertUserPreferences(preferences);
		
		UserPreferences insertedPreferences = userPreferencesMapper.findByUserId(userId);
		assertTrue(insertedPreferences != null);
		
		userPreferencesMapper.deleteUserPreferences(userId);
		
		UserPreferences deletedPreferences = userPreferencesMapper.findByUserId(userId);
		assertTrue(deletedPreferences == null);
		System.out.println("Delete 성공: 사용자 ID " + userId + "의 선호도 삭제됨");
		
		// 테스트용 사용자 삭제 
		userMapper.deleteUser(userId);
	}
}