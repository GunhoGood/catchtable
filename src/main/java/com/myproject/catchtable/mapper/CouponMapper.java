package com.myproject.catchtable.mapper;

import com.myproject.catchtable.model.Coupon;
import java.util.List;

public interface CouponMapper {
    
    // 쿠폰 생성
    void insertCoupon(Coupon coupon);
    
    // ID로 쿠폰 조회
    Coupon findById(Integer couponId);
    
    // 이름으로 쿠폰 조회
    Coupon findByName(String name);
    
    // 모든 쿠폰 조회
    List<Coupon> findAll();
    
    // 쿠폰 수정
    void updateCoupon(Coupon coupon);
    
    // 쿠폰 삭제
    void deleteCoupon(Integer couponId);
    
    // 활성 쿠폰 조회
    List<Coupon> findActiveCoupons();
    
    // 쿠폰 수 조회
    int countCoupons();
    
    // 활성 쿠폰 수 조회
    int countActiveCoupons();
}