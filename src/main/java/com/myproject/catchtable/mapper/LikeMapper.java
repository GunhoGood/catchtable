package com.myproject.catchtable.mapper;

import com.myproject.catchtable.model.Like;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

public interface LikeMapper {

	/**
	 * ���ƿ� �߰�
	 */
	int insertLike(Like like);

	/**
	 * ����ڿ� ����������� ���ƿ� ���� ��ȸ (���� �Ķ����)
	 */
	Like findByUserAndRestaurant(Map<String, Object> params);

	/**
	 * ���ƿ� ����
	 */
	int deleteLike(Map<String, Object> params);

	/**
	 * ��������� ���ƿ� ���� ��ȸ
	 */
	int countLikesByRestaurant(Integer restaurantId);

	/**
	 * ����ڰ� ���ƿ��� ������� ID ��� ��ȸ
	 */
	List<Integer> findRestaurantIdsByUser(Integer userId);

	/**
	 * ������� ���ƿ� ���� ��ȸ
	 */
	int countLikesByUser(Integer userId);

	/**
	 * ��������� ���ƿ��� ����� ID ��� ��ȸ
	 */
	List<Integer> findUserIdsByRestaurant(Integer restaurantId);

	/**
	 * �α� ������� ���� ��ȸ (���ƿ� ����)
	 */
	List<Map<String, Object>> findPopularRestaurantsByLikes(int limit);

	/**
	 * Ư�� �Ⱓ�� ���ƿ� ���� ��ȸ
	 */
	int countLikesByPeriod(Map<String, Object> params);

	/**
	 * ��������� ��� ���ƿ� ����
	 */
	int deleteAllLikesByRestaurant(Integer restaurantId);

	/**
	 * ������� ��� ���ƿ� ����
	 */
	int deleteAllLikesByUser(Integer userId);
}