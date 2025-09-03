package com.myproject.catchtable.mapper;

import com.myproject.catchtable.model.Coupon;
import java.util.List;

public interface CouponMapper {
    
    // ���� ����
    void insertCoupon(Coupon coupon);
    
    // ID�� ���� ��ȸ
    Coupon findById(Integer couponId);
    
    // �̸����� ���� ��ȸ
    Coupon findByName(String name);
    
    // ��� ���� ��ȸ
    List<Coupon> findAll();
    
    // ���� ����
    void updateCoupon(Coupon coupon);
    
    // ���� ����
    void deleteCoupon(Integer couponId);
    
    // Ȱ�� ���� ��ȸ
    List<Coupon> findActiveCoupons();
    
    // ���� �� ��ȸ
    int countCoupons();
    
    // Ȱ�� ���� �� ��ȸ
    int countActiveCoupons();
}