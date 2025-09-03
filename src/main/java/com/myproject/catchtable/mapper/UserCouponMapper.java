package com.myproject.catchtable.mapper;

import com.myproject.catchtable.model.UserCoupon;
import java.util.List;

public interface UserCouponMapper {
    
    // 사용자 쿠폰 조회
    UserCoupon findById(Integer userCouponId);
    UserCoupon findByUserIdAndCouponId(Integer userId, Integer couponId);
    List<UserCoupon> findByUserId(Integer userId);
    List<UserCoupon> findAvailableByUserId(Integer userId);
    
    // 특정 쿠폰의 모든 사용자 쿠폰 조회
    List<UserCoupon> findAllByCouponId(Integer couponId);
    
    // 사용자 쿠폰 등록/수정/삭제
    void insertUserCoupon(UserCoupon userCoupon);
    void updateUserCoupon(UserCoupon userCoupon);
    void deleteUserCoupon(Integer userCouponId);
    
    // 쿠폰 사용 처리
    void markAsUsed(Integer userCouponId);
    
    // 특정 쿠폰 관련 삭제
    void deleteByCouponId(Integer couponId);
    void deleteUnusedByCouponId(Integer couponId);
    
    // 통계
    int countByCouponId(Integer couponId);
    int countUsedByCouponId(Integer couponId);
    int countUnusedByCouponId(Integer couponId);
}