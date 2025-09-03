package com.myproject.catchtable.service;

import com.myproject.catchtable.mapper.LikeMapper;
import com.myproject.catchtable.mapper.RestaurantMapper;
import com.myproject.catchtable.model.Like;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class LikeService {
    
    @Autowired
    private LikeMapper likeMapper;
    
    @Autowired
    private RestaurantMapper restaurantMapper;
    
    /**
     * 사용자가 특정 레스토랑을 좋아요했는지 확인
     */
    public boolean isUserLikedRestaurant(Integer userId, Integer restaurantId) {
        // Map으로 파라미터 전달
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("restaurantId", restaurantId);
        
        Like like = likeMapper.findByUserAndRestaurant(params);
        return like != null;
    }
    /**
     * 좋아요 추가
     */
    public void addLike(Integer userId, Integer restaurantId) {
        // 이미 좋아요한 경우 중복 방지
        if (isUserLikedRestaurant(userId, restaurantId)) {
            throw new RuntimeException("이미 좋아요한 레스토랑입니다.");
        }
        
        // 좋아요 정보 저장
        Like like = new Like();
        like.setUserId(userId);
        like.setRestaurantId(restaurantId);
        
        likeMapper.insertLike(like);
        
        // 레스토랑의 좋아요 개수 증가
        restaurantMapper.incrementLikesCount(restaurantId);
    }
    
    /**
     * 좋아요 취소
     */
    public void removeLike(Integer userId, Integer restaurantId) {
        // 좋아요하지 않은 경우 예외 처리
        if (!isUserLikedRestaurant(userId, restaurantId)) {
            throw new RuntimeException("좋아요하지 않은 레스토랑입니다.");
        }
        
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("restaurantId", restaurantId);
        
        // 좋아요 정보 삭제
        likeMapper.deleteLike(params);
        
        // 레스토랑의 좋아요 개수 감소
        restaurantMapper.decrementLikesCount(restaurantId);
    }
    
    /**
     * 좋아요 토글 (추가/취소)
     */
    public boolean toggleLike(Integer userId, Integer restaurantId) {
        if (isUserLikedRestaurant(userId, restaurantId)) {
            removeLike(userId, restaurantId);
            return false; // 좋아요 취소됨
        } else {
            addLike(userId, restaurantId);
            return true; // 좋아요 추가됨
        }
    }
    
    /**
     * 레스토랑의 총 좋아요 개수 조회
     */
    public int getRestaurantLikesCount(Integer restaurantId) {
        return likeMapper.countLikesByRestaurant(restaurantId);
    }
    
    /**
     * 사용자가 좋아요한 레스토랑 목록 조회
     */
    public List<Integer> getUserLikedRestaurantIds(Integer userId) {
        return likeMapper.findRestaurantIdsByUser(userId);
    }
    
    /**
     * 사용자가 좋아요한 레스토랑 개수 조회
     */
    public int getUserLikesCount(Integer userId) {
        return likeMapper.countLikesByUser(userId);
    }
    
    /**
     * 레스토랑을 좋아요한 사용자 목록 조회
     */
    public List<Integer> getRestaurantLikedUserIds(Integer restaurantId) {
        return likeMapper.findUserIdsByRestaurant(restaurantId);
    }
    
    /**
     * 인기 레스토랑 순위 조회 (좋아요 기준)
     */
    public List<Map<String, Object>> getPopularRestaurantsByLikes(int limit) {
        return likeMapper.findPopularRestaurantsByLikes(limit);
    }
    
    /**
     * 특정 기간 동안의 좋아요 통계
     */
    public Map<String, Object> getLikeStatistics(Integer restaurantId, String period) {
        Map<String, Object> params = new HashMap<>();
        params.put("restaurantId", restaurantId);
        params.put("period", period); // 'day', 'week', 'month'
        
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalLikes", getRestaurantLikesCount(restaurantId));
        stats.put("periodLikes", likeMapper.countLikesByPeriod(params));
        
        return stats;
    }
    
    /**
     * 좋아요 일괄 삭제 (레스토랑 삭제시 사용)
     */
    public void deleteAllLikesByRestaurant(Integer restaurantId) {
        likeMapper.deleteAllLikesByRestaurant(restaurantId);
    }
    
    /**
     * 좋아요 일괄 삭제 (사용자 탈퇴시 사용)
     */
    public void deleteAllLikesByUser(Integer userId) {
        likeMapper.deleteAllLikesByUser(userId);
    }
}