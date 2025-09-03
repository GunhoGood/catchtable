package com.myproject.catchtable.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.myproject.catchtable.mapper.CouponMapper;
import com.myproject.catchtable.mapper.UserCouponMapper;
import com.myproject.catchtable.mapper.UserMapper;
import com.myproject.catchtable.model.Coupon;
import com.myproject.catchtable.model.User;
import com.myproject.catchtable.model.UserCoupon;

@Service
@Transactional
public class CouponService {
    
    @Autowired
    private CouponMapper couponMapper;
    
    @Autowired
    private UserCouponMapper userCouponMapper;
    
    @Autowired
    private UserMapper userMapper;
    
    // 쿠폰 이름으로 찾기
    public Coupon findByName(String name) {
        if (name == null || name.trim().isEmpty()) {
            return null;
        }
        return couponMapper.findByName(name.trim());
    }
    
    // ID로 쿠폰 찾기
    public Coupon findById(Integer couponId) {
        if (couponId == null) {
            return null;
        }
        return couponMapper.findById(couponId);
    }
    
    // 모든 쿠폰 조회
    public List<Coupon> findAll() {
        return couponMapper.findAll();
    }
    
    // 쿠폰 생성
    public void createCoupon(Coupon coupon) {
        // 필수 필드 검증
        if (coupon.getName() == null || coupon.getName().trim().isEmpty()) {
            throw new RuntimeException("쿠폰명은 필수입니다.");
        }
        if (coupon.getDiscountAmount() == null || coupon.getDiscountAmount() <= 0) {
            throw new RuntimeException("할인 금액은 0보다 커야 합니다.");
        }
        
        // 기본값 설정
        if (coupon.getMinOrderAmount() == null) {
            coupon.setMinOrderAmount(0);
        }
        if (coupon.getRequiredReservationCount() == null) {
            coupon.setRequiredReservationCount(0);
        }
        if (coupon.getUsageLimit() == null) {
            coupon.setUsageLimit(1000);
        }
        if (coupon.getDescription() == null) {
            coupon.setDescription("쿠폰 설명");
        }
        if (coupon.getStartDate() == null) {
            coupon.setStartDate(LocalDate.now());
        }
        
        // 이름 정리
        coupon.setName(coupon.getName().trim());
        
        couponMapper.insertCoupon(coupon);
    }
    
    // 쿠폰 수정
    public void updateCoupon(Coupon coupon) {
        if (coupon.getCouponId() == null) {
            throw new RuntimeException("쿠폰 ID는 필수입니다.");
        }
        
        Coupon existingCoupon = couponMapper.findById(coupon.getCouponId());
        if (existingCoupon == null) {
            throw new RuntimeException("존재하지 않는 쿠폰입니다.");
        }
        
        couponMapper.updateCoupon(coupon);
    }
    
    // 쿠폰 삭제
    public void deleteCoupon(Integer couponId) {
        if (couponId == null) {
            throw new RuntimeException("쿠폰 ID는 필수입니다.");
        }
        
        Coupon coupon = couponMapper.findById(couponId);
        if (coupon == null) {
            throw new RuntimeException("존재하지 않는 쿠폰입니다.");
        }
        
        couponMapper.deleteCoupon(couponId);
    }
    
    // 안전한 쿠폰 삭제
    public void safeDeleteCoupon(Integer couponId) {
        if (couponId == null) {
            throw new RuntimeException("쿠폰 ID는 필수입니다.");
        }
        
        // 쿠폰 존재 확인
        Coupon coupon = couponMapper.findById(couponId);
        if (coupon == null) {
            throw new RuntimeException("존재하지 않는 쿠폰입니다.");
        }
        
        // 발급된 쿠폰 확인
        int issuedCount = userCouponMapper.countByCouponId(couponId);
        int usedCount = userCouponMapper.countUsedByCouponId(couponId);
        
        if (usedCount > 0) {
            throw new RuntimeException(
                String.format("이미 %d개의 쿠폰이 사용되어 삭제할 수 없습니다. 쿠폰 비활성화를 권장합니다.", usedCount)
            );
        }
        
        if (issuedCount > 0) {
            throw new RuntimeException(
                String.format("아직 %d개의 미사용 쿠폰이 발급되어 있습니다.", issuedCount - usedCount)
            );
        }
        
        // 안전하게 삭제
        couponMapper.deleteCoupon(couponId);
        
        System.out.println("쿠폰 안전 삭제 완료: " + coupon.getName());
    }
    
 // 강제 쿠폰 삭제 - DB에서 완전 삭제
    public void forceDeleteCoupon(Integer couponId) {
        if (couponId == null) {
            throw new RuntimeException("쿠폰 ID는 필수입니다.");
        }
        
        // 쿠폰 존재 확인
        Coupon coupon = couponMapper.findById(couponId);
        if (coupon == null) {
            throw new RuntimeException("존재하지 않는 쿠폰입니다.");
        }
        
        // 통계 조회
        int issuedCount = userCouponMapper.countByCouponId(couponId);
        int usedCount = userCouponMapper.countUsedByCouponId(couponId);
        
        
        try {
            if (issuedCount > 0) {
                userCouponMapper.deleteByCouponId(couponId);
            }
            
            couponMapper.deleteCoupon(couponId);
            
            
        } catch (Exception e) {
            System.err.println("DB 삭제 실패: " + e.getMessage());
            throw new RuntimeException("DB에서 삭제 중 오류: " + e.getMessage());
        }
    }
    // 쿠폰 비활성화
    public void deactivateCoupon(Integer couponId) {
        if (couponId == null) {
            throw new RuntimeException("쿠폰 ID는 필수입니다.");
        }
        
        Coupon coupon = couponMapper.findById(couponId);
        if (coupon == null) {
            throw new RuntimeException("존재하지 않는 쿠폰입니다.");
        }
        
        // 이미 만료된 쿠폰인지 확인
        if (coupon.getEndDate() != null && coupon.getEndDate().isBefore(LocalDate.now())) {
            throw new RuntimeException("이미 만료된 쿠폰입니다.");
        }
        
        // 종료일을 어제로 설정하여 비활성화
        coupon.setEndDate(LocalDate.now().minusDays(1));
        couponMapper.updateCoupon(coupon);
        
        System.out.println("쿠폰 비활성화 완료: " + coupon.getName());
    }
    
    // 쿠폰 통계 조회
    public String getCouponStatistics(Integer couponId) {
        if (couponId == null) {
            throw new RuntimeException("쿠폰 ID는 필수입니다.");
        }
        
        Coupon coupon = couponMapper.findById(couponId);
        if (coupon == null) {
            throw new RuntimeException("존재하지 않는 쿠폰입니다.");
        }
        
        int issuedCount = userCouponMapper.countByCouponId(couponId);
        int usedCount = userCouponMapper.countUsedByCouponId(couponId);
        int remainingCount = issuedCount - usedCount;
        double usageRate = issuedCount > 0 ? (double) usedCount * 100 / issuedCount : 0;
        
        StringBuilder stats = new StringBuilder();
        stats.append("쿠폰 통계 - ").append(coupon.getName()).append("\n\n");
        stats.append("총 발급: ").append(issuedCount).append("개\n");
        stats.append("사용완료: ").append(usedCount).append("개\n");
        stats.append("미사용: ").append(remainingCount).append("개\n");
        stats.append("사용률: ").append(String.format("%.1f", usageRate)).append("%\n\n");
        
        // 쿠폰 정보
        stats.append("쿠폰 정보:\n");
        stats.append("• 할인금액: ").append(String.format("%,d원", coupon.getDiscountAmount())).append("\n");
        if (coupon.getMinOrderAmount() > 0) {
            stats.append("• 최소주문: ").append(String.format("%,d원", coupon.getMinOrderAmount())).append("\n");
        }
        if (coupon.getEndDate() != null) {
            stats.append("• 종료일: ").append(coupon.getEndDate()).append("\n");
        }
        
        // 상태 정보
        boolean isActive = coupon.getEndDate() == null || coupon.getEndDate().isAfter(LocalDate.now());
        stats.append("• 상태: ").append(isActive ? "활성" : "만료");
        
        return stats.toString();
    }
    
    // 사용자에게 쿠폰 지급
    public void issueCouponToUser(Integer userId, Integer couponId) {
        // 입력값 검증
        if (userId == null) {
            throw new RuntimeException("사용자 ID는 필수입니다.");
        }
        if (couponId == null) {
            throw new RuntimeException("쿠폰 ID는 필수입니다.");
        }
        
        // 사용자 존재 확인
        User user = userMapper.findById(userId);
        if (user == null) {
            throw new RuntimeException("존재하지 않는 사용자입니다. (ID: " + userId + ")");
        }
        
        // 쿠폰 정보 확인
        Coupon coupon = couponMapper.findById(couponId);
        if (coupon == null) {
            throw new RuntimeException("존재하지 않는 쿠폰입니다. (ID: " + couponId + ")");
        }
        
        // 쿠폰이 활성화되어 있는지 확인
        if (coupon.getEndDate() != null && coupon.getEndDate().isBefore(LocalDate.now())) {
            throw new RuntimeException("만료된 쿠폰입니다: " + coupon.getName());
        }
        
        // 중복 발급 확인
        List<UserCoupon> existingCoupons = userCouponMapper.findByUserId(userId);
        boolean alreadyIssued = existingCoupons.stream()
            .anyMatch(uc -> uc.getCouponId().equals(couponId));
        
        if (alreadyIssued) {
            throw new RuntimeException("이미 보유중인 쿠폰입니다: " + coupon.getName());
        }
        
        // 사용자 쿠폰 생성
        UserCoupon userCoupon = new UserCoupon();
        userCoupon.setUserId(userId);
        userCoupon.setCouponId(couponId);
        userCoupon.setIsUsed(false);
        userCoupon.setUsageLimit(1);
        
        // 쿠폰 만료일 설정
        LocalDate expiryDate = LocalDate.now().plusDays(30);
        userCoupon.setEndDate(expiryDate);
        
        userCouponMapper.insertUserCoupon(userCoupon);
        
        System.out.println(user.getName() + "님에게 '" + coupon.getName() + "' 쿠폰 지급 완료");
    }
    
    // 여러 사용자에게 쿠폰 일괄 지급
    public void issueCouponToUsers(List<Integer> userIds, Integer couponId) {
        if (userIds == null || userIds.isEmpty()) {
            throw new RuntimeException("지급 대상 사용자가 없습니다.");
        }
        
        int successCount = 0;
        int errorCount = 0;
        
        for (Integer userId : userIds) {
            try {
                issueCouponToUser(userId, couponId);
                successCount++;
            } catch (Exception e) {
                errorCount++;
                System.err.println("쿠폰 지급 실패 - 사용자 ID: " + userId + ", 사유: " + e.getMessage());
            }
        }
        
        System.out.println("일괄 지급 결과 - 성공: " + successCount + "명, 실패: " + errorCount + "명");
    }
    
    // 사용자별 쿠폰 목록 조회
    public List<UserCoupon> findUserCoupons(Integer userId) {
        if (userId == null) {
            return new ArrayList<>();
        }
        return userCouponMapper.findByUserId(userId);
    }
    
    // 사용 가능한 쿠폰 목록 조회
    public List<UserCoupon> findAvailableUserCoupons(Integer userId) {
        if (userId == null) {
            return new ArrayList<>();
        }
        return userCouponMapper.findAvailableByUserId(userId);
    }
    
    // 특정 쿠폰의 모든 사용자 쿠폰 조회
    public List<UserCoupon> findAllUserCoupons(Integer couponId) {
        if (couponId == null) {
            return new ArrayList<>();
        }
        return userCouponMapper.findAllByCouponId(couponId);
    }
    
    // 쿠폰별 발급 통계
    public int getCouponIssuedCount(Integer couponId) {
        if (couponId == null) {
            return 0;
        }
        return userCouponMapper.countByCouponId(couponId);
    }
    
    // 쿠폰별 사용 통계
    public int getCouponUsedCount(Integer couponId) {
        if (couponId == null) {
            return 0;
        }
        return userCouponMapper.countUsedByCouponId(couponId);
    }
    
    // 미사용 쿠폰만 회수
    public void reclaimUnusedCoupons(Integer couponId) {
        if (couponId == null) {
            throw new RuntimeException("쿠폰 ID는 필수입니다.");
        }
        
        Coupon coupon = couponMapper.findById(couponId);
        if (coupon == null) {
            throw new RuntimeException("존재하지 않는 쿠폰입니다.");
        }
        
        // 미사용 쿠폰 개수 확인
        int unusedCount = userCouponMapper.countByCouponId(couponId) - userCouponMapper.countUsedByCouponId(couponId);
        
        if (unusedCount == 0) {
            throw new RuntimeException("회수할 미사용 쿠폰이 없습니다.");
        }
        
        // 미사용 쿠폰만 삭제
        userCouponMapper.deleteUnusedByCouponId(couponId);
        
        System.out.println("미사용 쿠폰 " + unusedCount + "개 회수 완료: " + coupon.getName());
    }
    
    // 쿠폰 사용 처리
    public void useCoupon(Integer userCouponId, Integer userId) {
        // 사용자 쿠폰 존재 확인
        UserCoupon userCoupon = userCouponMapper.findById(userCouponId);
        if (userCoupon == null) {
            throw new RuntimeException("존재하지 않는 사용자 쿠폰입니다.");
        }
        
        // 권한 확인
        if (!userCoupon.getUserId().equals(userId)) {
            throw new RuntimeException("본인의 쿠폰만 사용할 수 있습니다.");
        }
        
        // 이미 사용된 쿠폰인지 확인
        if (userCoupon.getIsUsed()) {
            throw new RuntimeException("이미 사용된 쿠폰입니다.");
        }
        
        // 만료 확인
        if (userCoupon.getEndDate() != null && 
            userCoupon.getEndDate().isBefore(LocalDate.now())) {
            throw new RuntimeException("만료된 쿠폰입니다.");
        }
        
        // 쿠폰 사용 처리
        userCouponMapper.markAsUsed(userCouponId);
        
        System.out.println("쿠폰 사용 완료 - ID: " + userCouponId);
    }
    
    // 첫 방문 쿠폰 지급
    public void issueWelcomeCoupon(Integer userId) {
        Coupon welcomeCoupon = couponMapper.findByName("첫 방문 쿠폰");
        
        if (welcomeCoupon == null) {
            welcomeCoupon = createWelcomeCoupon();
        }
        
        try {
            issueCouponToUser(userId, welcomeCoupon.getCouponId());
            
            User user = userMapper.findById(userId);
            String userName = user != null ? user.getName() : "고객";
            
            System.out.println(userName + "님에게 첫 방문 쿠폰이 지급되었습니다!");
            
        } catch (Exception e) {
            System.out.println("첫 방문 쿠폰 지급 실패: " + e.getMessage());
        }
    }
    
    // 방문 횟수별 쿠폰 지급
    public void issueVisitCountCoupon(Integer userId, Integer visitCount) {
        String couponName = visitCount + "회 방문 쿠폰";
        Coupon visitCoupon = couponMapper.findByName(couponName);
        
        if (visitCoupon == null) {
            visitCoupon = createVisitCountCoupon(visitCount);
        }
        
        try {
            issueCouponToUser(userId, visitCoupon.getCouponId());
            
            User user = userMapper.findById(userId);
            String userName = user != null ? user.getName() : "고객";
            
            System.out.println(userName + "님에게 " + visitCount + "회 방문 쿠폰이 지급되었습니다!");
            
        } catch (Exception e) {
            System.out.println(visitCount + "회 방문 쿠폰 지급 실패: " + e.getMessage());
        }
    }
    
    // 특별 이벤트 쿠폰 지급
    public void issueSpecialEventCoupon(Integer userId, Integer visitCount) {
        String couponName = "특별 이벤트 쿠폰 " + visitCount + "회";
        Coupon eventCoupon = couponMapper.findByName(couponName);
        
        if (eventCoupon == null) {
            eventCoupon = createSpecialEventCoupon(visitCount);
        }
        
        try {
            issueCouponToUser(userId, eventCoupon.getCouponId());
            
            User user = userMapper.findById(userId);
            String userName = user != null ? user.getName() : "고객";
            
            System.out.println(userName + "님에게 " + visitCount + "회 특별 이벤트 쿠폰이 지급되었습니다!");
            
        } catch (Exception e) {
            System.out.println("특별 이벤트 쿠폰 지급 실패: " + e.getMessage());
        }
    }
    
    // 생일 쿠폰 지급
    public void issueBirthdayCoupon(Integer userId) {
        String couponName = "생일 축하 쿠폰";
        Coupon birthdayCoupon = couponMapper.findByName(couponName);
        
        if (birthdayCoupon == null) {
            birthdayCoupon = createBirthdayCoupon();
        }
        
        try {
            issueCouponToUser(userId, birthdayCoupon.getCouponId());
            
            User user = userMapper.findById(userId);
            String userName = user != null ? user.getName() : "고객";
            
            System.out.println(userName + "님에게 생일 축하 쿠폰이 지급되었습니다!");
            
        } catch (Exception e) {
            System.out.println("생일 쿠폰 지급 실패: " + e.getMessage());
        }
    }
    
    // 웰컴 쿠폰 생성
    private Coupon createWelcomeCoupon() {
        Coupon coupon = new Coupon();
        coupon.setName("첫 방문 쿠폰");
        coupon.setDescription("처음 방문해주신 고객님을 위한 환영 쿠폰입니다.");
        coupon.setDiscountAmount(5000);
        coupon.setMinOrderAmount(0);
        coupon.setRequiredReservationCount(0);
        coupon.setUsageLimit(1000);
        coupon.setStartDate(LocalDate.now());
        coupon.setEndDate(LocalDate.now().plusDays(365));
        
        createCoupon(coupon);
        return coupon;
    }
    
    // 방문 횟수별 쿠폰 생성
    private Coupon createVisitCountCoupon(Integer visitCount) {
        Coupon coupon = new Coupon();
        coupon.setName(visitCount + "회 방문 쿠폰");
        coupon.setDescription(visitCount + "회 방문 고객을 위한 감사 쿠폰입니다.");
        coupon.setRequiredReservationCount(visitCount);
        coupon.setUsageLimit(5000);
        coupon.setStartDate(LocalDate.now());
        coupon.setEndDate(LocalDate.now().plusDays(365));
        
        // 방문 횟수별 혜택 차등화
        if (visitCount == 5) {
            coupon.setDiscountAmount(10000);
            coupon.setMinOrderAmount(20000);
        } else if (visitCount == 10) {
            coupon.setDiscountAmount(20000);
            coupon.setMinOrderAmount(30000);
        } else if (visitCount == 20) {
            coupon.setDiscountAmount(30000);
            coupon.setMinOrderAmount(50000);
        } else if (visitCount == 50) {
            coupon.setDiscountAmount(50000);
            coupon.setMinOrderAmount(80000);
        } else if (visitCount == 100) {
            coupon.setDiscountAmount(100000);
            coupon.setMinOrderAmount(150000);
        } else {
            coupon.setDiscountAmount(visitCount * 1000);
            coupon.setMinOrderAmount(visitCount * 500);
        }
        
        createCoupon(coupon);
        return coupon;
    }
    
    // 특별 이벤트 쿠폰 생성
    private Coupon createSpecialEventCoupon(Integer visitCount) {
        Coupon coupon = new Coupon();
        coupon.setName("특별 이벤트 쿠폰 " + visitCount + "회");
        coupon.setDescription(visitCount + "회 달성 기념 특별 이벤트 쿠폰입니다.");
        coupon.setRequiredReservationCount(visitCount);
        coupon.setUsageLimit(1000);
        coupon.setStartDate(LocalDate.now());
        coupon.setEndDate(LocalDate.now().plusDays(60));
        
        // 방문 횟수에 따른 특별 혜택
        if (visitCount >= 50) {
            coupon.setDiscountAmount(80000);
            coupon.setMinOrderAmount(120000);
        } else if (visitCount >= 30) {
            coupon.setDiscountAmount(50000);
            coupon.setMinOrderAmount(80000);
        } else if (visitCount >= 20) {
            coupon.setDiscountAmount(35000);
            coupon.setMinOrderAmount(60000);
        } else {
            coupon.setDiscountAmount(25000);
            coupon.setMinOrderAmount(50000);
        }
        
        createCoupon(coupon);
        return coupon;
    }
    
    // 생일 쿠폰 생성
    private Coupon createBirthdayCoupon() {
        Coupon coupon = new Coupon();
        coupon.setName("생일 축하 쿠폰");
        coupon.setDescription("생일을 축하합니다! 특별한 하루를 더욱 맛있게 보내세요.");
        coupon.setDiscountAmount(15000);
        coupon.setMinOrderAmount(30000);
        coupon.setRequiredReservationCount(0);
        coupon.setUsageLimit(10000);
        coupon.setStartDate(LocalDate.now());
        coupon.setEndDate(LocalDate.now().plusDays(365));
        
        createCoupon(coupon);
        return coupon;
    }
}