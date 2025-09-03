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
	 * 좋아요 추가
	 */
	int insertLike(Like like);

	/**
	 * 사용자와 레스토랑으로 좋아요 정보 조회 (개별 파라미터)
	 */
	Like findByUserAndRestaurant(Map<String, Object> params);

	/**
	 * 좋아요 삭제
	 */
	int deleteLike(Map<String, Object> params);

	/**
	 * 레스토랑의 좋아요 개수 조회
	 */
	int countLikesByRestaurant(Integer restaurantId);

	/**
	 * 사용자가 좋아요한 레스토랑 ID 목록 조회
	 */
	List<Integer> findRestaurantIdsByUser(Integer userId);

	/**
	 * 사용자의 좋아요 개수 조회
	 */
	int countLikesByUser(Integer userId);

	/**
	 * 레스토랑을 좋아요한 사용자 ID 목록 조회
	 */
	List<Integer> findUserIdsByRestaurant(Integer restaurantId);

	/**
	 * 인기 레스토랑 순위 조회 (좋아요 기준)
	 */
	List<Map<String, Object>> findPopularRestaurantsByLikes(int limit);

	/**
	 * 특정 기간의 좋아요 개수 조회
	 */
	int countLikesByPeriod(Map<String, Object> params);

	/**
	 * 레스토랑의 모든 좋아요 삭제
	 */
	int deleteAllLikesByRestaurant(Integer restaurantId);

	/**
	 * 사용자의 모든 좋아요 삭제
	 */
	int deleteAllLikesByUser(Integer userId);
}