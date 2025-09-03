package com.myproject.catchtable.mapper;

import com.myproject.catchtable.model.UserCoupon;
import java.util.List;

public interface UserCouponMapper {
    
    // ����� ���� ��ȸ
    UserCoupon findById(Integer userCouponId);
    UserCoupon findByUserIdAndCouponId(Integer userId, Integer couponId);
    List<UserCoupon> findByUserId(Integer userId);
    List<UserCoupon> findAvailableByUserId(Integer userId);
    
    // Ư�� ������ ��� ����� ���� ��ȸ
    List<UserCoupon> findAllByCouponId(Integer couponId);
    
    // ����� ���� ���/����/����
    void insertUserCoupon(UserCoupon userCoupon);
    void updateUserCoupon(UserCoupon userCoupon);
    void deleteUserCoupon(Integer userCouponId);
    
    // ���� ��� ó��
    void markAsUsed(Integer userCouponId);
    
    // Ư�� ���� ���� ����
    void deleteByCouponId(Integer couponId);
    void deleteUnusedByCouponId(Integer couponId);
    
    // ���
    int countByCouponId(Integer couponId);
    int countUsedByCouponId(Integer couponId);
    int countUnusedByCouponId(Integer couponId);
}