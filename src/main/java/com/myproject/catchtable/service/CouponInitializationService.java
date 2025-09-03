package com.myproject.catchtable.service;

import com.myproject.catchtable.mapper.CouponMapper;
import com.myproject.catchtable.model.Coupon;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import javax.annotation.PostConstruct;
import java.time.LocalDate;
import java.util.List;

//@Service
//@Transactional
public class CouponInitializationService {
    
    @Autowired
    private CouponMapper couponMapper;
    
    @PostConstruct
    public void initializeBasicCoupons() {
        System.out.println("쿠폰 시스템 초기화 시작...");
        
        try {
            // 1. 첫 방문 쿠폰
            createCouponIfNotExists("첫 방문 쿠폰", 
                "처음 방문해주신 고객님을 위한 환영 쿠폰입니다.", 
                5000, 0, 0, 30);
            
            // 2. 5회 방문 쿠폰
            createCouponIfNotExists("5회 방문 쿠폰", 
                "5회 방문 단골 고객을 위한 감사 쿠폰입니다.", 
                10000, 20000, 5, 90);
            
            // 3. 10회 방문 쿠폰
            createCouponIfNotExists("10회 방문 쿠폰", 
                "10회 방문 VIP 고객을 위한 특별 쿠폰입니다.", 
                20000, 30000, 10, 90);
            
            // 4. 20회 방문 쿠폰
            createCouponIfNotExists("20회 방문 쿠폰", 
                "20회 방문 플래티넘 고객을 위한 프리미엄 쿠폰입니다.", 
                30000, 50000, 20, 90);
            
            // 5. 50회 방문 쿠폰
            createCouponIfNotExists("50회 방문 쿠폰", 
                "50회 방문 다이아몬드 고객을 위한 최고급 쿠폰입니다.", 
                50000, 80000, 50, 90);
            
            // 6. 100회 방문 쿠폰
            createCouponIfNotExists("100회 방문 쿠폰", 
                "100회 방문 레전드 고객을 위한 전설의 쿠폰입니다.", 
                100000, 150000, 100, 90);
            
            // 7. 생일 축하 쿠폰
            createCouponIfNotExists("생일 축하 쿠폰", 
                "생일을 축하합니다! 특별한 하루를 더욱 맛있게 보내세요.", 
                15000, 30000, 0, 30);
            
            // 8. 주말 특가 쿠폰
            createCouponIfNotExists("주말 특가 쿠폰", 
                "주말 예약 고객을 위한 특가 할인 쿠폰입니다.", 
                8000, 25000, 0, 7);
            
            // 9. 신메뉴 체험 쿠폰
            createCouponIfNotExists("신메뉴 체험 쿠폰", 
                "새로운 메뉴를 체험해보세요! 신메뉴 전용 할인 쿠폰입니다.", 
                12000, 20000, 0, 14);
            
            // 10. 리뷰 작성 감사 쿠폰
            createCouponIfNotExists("리뷰 작성 감사 쿠폰", 
                "소중한 리뷰를 작성해주신 고객님께 드리는 감사 쿠폰입니다.", 
                7000, 15000, 0, 30);
            
            System.out.println("기본 쿠폰 초기화 완료!");
            
        } catch (Exception e) {
            System.err.println("쿠폰 초기화 실패: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 쿠폰이 존재하지 않으면 생성하는 헬퍼 메서드
     * 기존 테이블 구조에 맞춤 (validityDays 파라미터는 end_date 계산용)
     */
    private void createCouponIfNotExists(String name, String description, 
                                       Integer discountAmount, Integer minOrderAmount, 
                                       Integer requiredReservationCount, Integer validDays) {
        
        // 이미 존재하는지 확인
        Coupon existingCoupon = couponMapper.findByName(name);
        
        if (existingCoupon == null) {
            // 새 쿠폰 생성 (기존 테이블 구조에 맞춤)
            Coupon coupon = new Coupon();
            coupon.setName(name);
            coupon.setDescription(description);
            coupon.setDiscountAmount(discountAmount);
            coupon.setMinOrderAmount(minOrderAmount);
            coupon.setRequiredReservationCount(requiredReservationCount);
            coupon.setUsageLimit(10000); // 기본 사용 제한
            coupon.setStartDate(LocalDate.now());
            coupon.setEndDate(LocalDate.now().plusDays(validDays)); // validDays로 종료일 계산
            
            couponMapper.insertCoupon(coupon);
            System.out.println("생성: " + name + " (할인: " + discountAmount + "원)");
        } else {
            System.out.println("건너뜀: " + name + " (이미 존재)");
        }
    }
    
    /**
     * 특별 이벤트 쿠폰 생성 (관리자용)
     */
    public void createSpecialEventCoupons() {
        System.out.println("특별 이벤트 쿠폰 생성 시작...");
        
        // 1. 신규 오픈 기념 쿠폰
        createCouponIfNotExists("신규 오픈 기념 쿠폰", 
            "새로운 식당 오픈을 축하합니다! 특별 할인 혜택을 드려요.", 
            25000, 50000, 0, 60);
        
        // 2. 단체 예약 할인 쿠폰
        createCouponIfNotExists("단체 예약 할인 쿠폰", 
            "5인 이상 단체 예약시 사용 가능한 할인 쿠폰입니다.", 
            35000, 100000, 0, 30);
        
        // 3. 심야 할인 쿠폰
        createCouponIfNotExists("심야 할인 쿠폰", 
            "늦은 시간 예약 고객을 위한 심야 할인 쿠폰입니다.", 
            18000, 40000, 0, 14);
        
        // 4. 조기 예약 할인 쿠폰
        createCouponIfNotExists("조기 예약 할인 쿠폰", 
            "7일 전 미리 예약하신 고객을 위한 할인 쿠폰입니다.", 
            13000, 30000, 0, 21);
        
        // 5. 재방문 감사 쿠폰
        createCouponIfNotExists("재방문 감사 쿠폰", 
            "다시 찾아주신 고객님께 드리는 감사 쿠폰입니다.", 
            9000, 20000, 2, 45);
        
        System.out.println("특별 이벤트 쿠폰 생성 완료!");
    }
    
    /**
     * 계절별 쿠폰 생성 (관리자용)
     */
    public void createSeasonalCoupons(String season) {
        System.out.println(season + " 시즌 쿠폰 생성 시작...");
        
        switch (season.toLowerCase()) {
            case "spring":
            case "봄":
                createCouponIfNotExists("봄맞이 특가 쿠폰", 
                    "따뜻한 봄을 맞아 특별한 할인 혜택을 드려요!", 
                    22000, 45000, 0, 90);
                break;
                
            case "summer":
            case "여름":
                createCouponIfNotExists("여름 시원 쿠폰", 
                    "뜨거운 여름, 시원한 할인으로 더위를 식혀보세요!", 
                    28000, 55000, 0, 90);
                break;
                
            case "autumn":
            case "가을":
                createCouponIfNotExists("가을 추수 감사 쿠폰", 
                    "풍성한 가을을 맞아 감사의 마음을 담은 할인 쿠폰!", 
                    26000, 50000, 0, 90);
                break;
                
            case "winter":
            case "겨울":
                createCouponIfNotExists("겨울 따뜻 쿠폰", 
                    "추운 겨울, 따뜻한 할인으로 마음을 녹여보세요!", 
                    30000, 60000, 0, 90);
                break;
                
            default:
                System.out.println("알 수 없는 계절: " + season);
        }
        
        System.out.println(season + " 시즌 쿠폰 생성 완료!");
    }
    
    /**
     * 현재 시스템의 쿠폰 현황 조회
     */
    public void printCouponStatus() {
        System.out.println("\n=== 쿠폰 시스템 현황 ===");
        
        try {
            List<Coupon> allCoupons = couponMapper.findAll();
            System.out.println("전체 쿠폰 수: " + allCoupons.size());
            
            // 활성 쿠폰 수 계산 (end_date가 현재보다 나중인 것들)
            long activeCoupons = allCoupons.stream()
                    .filter(coupon -> coupon.getEndDate() == null || coupon.getEndDate().isAfter(LocalDate.now()))
                    .count();
            System.out.println("활성 쿠폰 수: " + activeCoupons);
            System.out.println("만료 쿠폰 수: " + (allCoupons.size() - activeCoupons));
            
            // 쿠폰별 간단 정보
            System.out.println("\n쿠폰 목록:");
            for (Coupon coupon : allCoupons) {
                boolean isActive = coupon.getEndDate() == null || coupon.getEndDate().isAfter(LocalDate.now());
                String status = isActive ? "활성" : "만료";
                System.out.println(status + " " + coupon.getName() + 
                                 " (할인: " + coupon.getDiscountAmount() + "원)");
            }
            
        } catch (Exception e) {
            System.err.println("쿠폰 현황 조회 실패: " + e.getMessage());
        }
        
        System.out.println("========================\n");
    }
}