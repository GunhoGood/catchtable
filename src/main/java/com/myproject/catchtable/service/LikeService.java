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
     * ����ڰ� Ư�� ��������� ���ƿ��ߴ��� Ȯ��
     */
    public boolean isUserLikedRestaurant(Integer userId, Integer restaurantId) {
        // Map���� �Ķ���� ����
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("restaurantId", restaurantId);
        
        Like like = likeMapper.findByUserAndRestaurant(params);
        return like != null;
    }
    /**
     * ���ƿ� �߰�
     */
    public void addLike(Integer userId, Integer restaurantId) {
        // �̹� ���ƿ��� ��� �ߺ� ����
        if (isUserLikedRestaurant(userId, restaurantId)) {
            throw new RuntimeException("�̹� ���ƿ��� ��������Դϴ�.");
        }
        
        // ���ƿ� ���� ����
        Like like = new Like();
        like.setUserId(userId);
        like.setRestaurantId(restaurantId);
        
        likeMapper.insertLike(like);
        
        // ��������� ���ƿ� ���� ����
        restaurantMapper.incrementLikesCount(restaurantId);
    }
    
    /**
     * ���ƿ� ���
     */
    public void removeLike(Integer userId, Integer restaurantId) {
        // ���ƿ����� ���� ��� ���� ó��
        if (!isUserLikedRestaurant(userId, restaurantId)) {
            throw new RuntimeException("���ƿ����� ���� ��������Դϴ�.");
        }
        
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("restaurantId", restaurantId);
        
        // ���ƿ� ���� ����
        likeMapper.deleteLike(params);
        
        // ��������� ���ƿ� ���� ����
        restaurantMapper.decrementLikesCount(restaurantId);
    }
    
    /**
     * ���ƿ� ��� (�߰�/���)
     */
    public boolean toggleLike(Integer userId, Integer restaurantId) {
        if (isUserLikedRestaurant(userId, restaurantId)) {
            removeLike(userId, restaurantId);
            return false; // ���ƿ� ��ҵ�
        } else {
            addLike(userId, restaurantId);
            return true; // ���ƿ� �߰���
        }
    }
    
    /**
     * ��������� �� ���ƿ� ���� ��ȸ
     */
    public int getRestaurantLikesCount(Integer restaurantId) {
        return likeMapper.countLikesByRestaurant(restaurantId);
    }
    
    /**
     * ����ڰ� ���ƿ��� ������� ��� ��ȸ
     */
    public List<Integer> getUserLikedRestaurantIds(Integer userId) {
        return likeMapper.findRestaurantIdsByUser(userId);
    }
    
    /**
     * ����ڰ� ���ƿ��� ������� ���� ��ȸ
     */
    public int getUserLikesCount(Integer userId) {
        return likeMapper.countLikesByUser(userId);
    }
    
    /**
     * ��������� ���ƿ��� ����� ��� ��ȸ
     */
    public List<Integer> getRestaurantLikedUserIds(Integer restaurantId) {
        return likeMapper.findUserIdsByRestaurant(restaurantId);
    }
    
    /**
     * �α� ������� ���� ��ȸ (���ƿ� ����)
     */
    public List<Map<String, Object>> getPopularRestaurantsByLikes(int limit) {
        return likeMapper.findPopularRestaurantsByLikes(limit);
    }
    
    /**
     * Ư�� �Ⱓ ������ ���ƿ� ���
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
     * ���ƿ� �ϰ� ���� (������� ������ ���)
     */
    public void deleteAllLikesByRestaurant(Integer restaurantId) {
        likeMapper.deleteAllLikesByRestaurant(restaurantId);
    }
    
    /**
     * ���ƿ� �ϰ� ���� (����� Ż��� ���)
     */
    public void deleteAllLikesByUser(Integer userId) {
        likeMapper.deleteAllLikesByUser(userId);
    }
}