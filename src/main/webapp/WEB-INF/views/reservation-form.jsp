<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>예약하기 - ${restaurant.name}</title>
    <link rel="icon" type="image/png" sizes="32x32"
	href="${pageContext.request.contextPath}/resources/images/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16"
	href="${pageContext.request.contextPath}/resources/images/favicon-16x16.png">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Crimson+Text:ital,wght@0,400;0,600;1,400&family=Source+Sans+Pro:wght@300;400;600;700&display=swap');
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Source Sans Pro', -apple-system, sans-serif;
            color: #2c2c2c;
            line-height: 1.6;
            background: #fafafa;
            padding-top: 80px;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .reservation-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        /* 헤더 */
        .reservation-header {
            background: linear-gradient(135deg, #d4af37, #c9a96e);
            color: white;
            padding: 40px 30px;
            text-align: center;
        }
        
        .header-title {
            font-family: 'Crimson Text', serif;
            font-size: 2.2rem;
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .header-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
        }
        
        /* 레스토랑 정보 */
        .restaurant-info {
            background: #f8f9fa;
            padding: 25px 30px;
            border-bottom: 1px solid #e9ecef;
        }
        
        .restaurant-name {
            font-family: 'Crimson Text', serif;
            font-size: 1.8rem;
            font-weight: 600;
            color: #2c2c2c;
            margin-bottom: 10px;
        }
        
        .restaurant-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            color: #666;
        }
        
        .detail-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        /* 예약 폼 */
        .reservation-form {
            padding: 40px 30px;
        }
        
        .form-section {
            margin-bottom: 30px;
        }
        
        .form-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #2c2c2c;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        
        .form-label {
            font-weight: 600;
            color: #555;
        }
        
        .form-input, .form-select, .form-textarea {
            padding: 15px;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.3s ease;
            font-family: 'Source Sans Pro', sans-serif;
        }
        
        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none;
            border-color: #d4af37;
            box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
        }
        
        .form-textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        /* 시간 선택 그리드 */
        .time-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 10px;
            margin-top: 10px;
        }
        
        .time-slot {
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background: white;
        }
        
        .time-slot:hover {
            border-color: #d4af37;
            background: #faf9f0;
        }
        
        .time-slot.selected {
            background: #d4af37;
            border-color: #d4af37;
            color: white;
            font-weight: 600;
        }
        
        .time-slot.disabled {
            background: #f8f9fa;
            color: #ccc;
            cursor: not-allowed;
        }
        
        /* 인원 선택 */
        .party-size-selector {
            display: flex;
            align-items: center;
            gap: 15px;
            justify-content: center;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 12px;
        }
        
        .party-btn {
            background: white;
            border: 2px solid #e0e0e0;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            font-size: 1.5rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .party-btn:hover {
            border-color: #d4af37;
            color: #d4af37;
        }
        
        .party-count {
            font-size: 2rem;
            font-weight: 700;
            color: #d4af37;
            min-width: 60px;
            text-align: center;
        }
        
        /* 쿠폰 섹션 */
        .coupon-section {
            margin-top: 15px;
        }
        
        .coupon-selector {
            margin-bottom: 20px;
        }
        
        .selected-coupon-info {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 15px;
            border: 2px solid #d4af37;
        }
        
        .coupon-card-mini {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .coupon-icon {
            font-size: 2rem;
        }
        
        .coupon-details {
            flex: 1;
        }
        
        .coupon-name {
            font-weight: 600;
            color: #2c2c2c;
            margin-bottom: 5px;
        }
        
        .coupon-discount {
            font-size: 1.2rem;
            font-weight: 700;
            color: #d4af37;
        }
        
        .remove-coupon-btn {
            background: #dc3545;
            color: white;
            border: none;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            cursor: pointer;
            font-size: 1.2rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .no-coupons-message {
            text-align: center;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 12px;
            color: #666;
        }
        
        .no-coupons-message small {
            color: #888;
        }
        
        /* 알림 섹션 */
        .notice-section {
            background: #e3f2fd;
            border: 1px solid #bbdefb;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
        }
        
        .notice-title {
            font-weight: 600;
            color: #1976d2;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .notice-list {
            list-style: none;
            color: #666;
        }
        
        .notice-list li {
            margin-bottom: 5px;
            padding-left: 20px;
            position: relative;
        }
        
        .notice-list li:before {
            content: "•";
            color: #1976d2;
            position: absolute;
            left: 0;
        }
        
        /* 버튼 영역 */
        .button-section {
            display: flex;
            gap: 15px;
            justify-content: center;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }
        
        .btn {
            padding: 15px 30px;
            border: none;
            border-radius: 25px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .btn-cancel {
            background: #6c757d;
            color: white;
        }
        
        .btn-cancel:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
        
        .btn-submit {
            background: linear-gradient(135deg, #d4af37, #c9a96e);
            color: white;
            box-shadow: 0 4px 20px rgba(212, 175, 55, 0.3);
        }
        
        .btn-submit:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 30px rgba(212, 175, 55, 0.4);
        }
        
        .btn-submit:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        
        /* 반응형 */
        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }
            
            .reservation-form {
                padding: 30px 20px;
            }
            
            .restaurant-info {
                padding: 20px;
            }
            
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .time-grid {
                grid-template-columns: repeat(3, 1fr);
            }
            
            .button-section {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <!-- 네비게이션 -->
    <jsp:include page="navi.jsp" />
    
    <div class="container">
        <div class="reservation-container">
            <!-- 헤더 -->
            <div class="reservation-header">
                <h1 class="header-title">🍽️ 예약하기</h1>
                <p class="header-subtitle">원하는 시간에 자리를 미리 예약하세요</p>
            </div>
            
            <!-- 레스토랑 정보 -->
            <div class="restaurant-info">
                <h2 class="restaurant-name">${restaurant.name}</h2>
                <div class="restaurant-details">
                    <div class="detail-item">
                        <span>📍</span>
                        <span>${restaurant.address}</span>
                    </div>
                    <c:if test="${not empty restaurant.phone}">
                        <div class="detail-item">
                            <span>📞</span>
                            <span>${restaurant.phone}</span>
                        </div>
                    </c:if>
                    <c:if test="${not empty restaurant.operatingHours}">
                        <div class="detail-item">
                            <span>🕐</span>
                            <span>${restaurant.operatingHours}</span>
                        </div>
                    </c:if>
                </div>
            </div>
            
            <!-- 예약 폼 -->
            <form class="reservation-form" id="reservationForm" action="${pageContext.request.contextPath}/board/restaurants/${restaurant.restaurantId}/reservation" method="post">
                <!-- 날짜 및 시간 선택 -->
                <div class="form-section">
                    <h3 class="form-title">📅 날짜 및 시간</h3>
                    <div class="form-group">
                        <label class="form-label">예약 날짜</label>
                        <input type="date" class="form-input" id="reservationDate" name="reservationDate" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">예약 시간</label>
                        <div class="time-grid" id="timeSlots">
                            <!-- 시간 슬롯들이 JavaScript로 생성됩니다 -->
                        </div>
                        <input type="hidden" id="reservationTime" name="reservationHour" required>
                    </div>
                </div>
                
                <!-- 인원 선택 -->
                <div class="form-section">
                    <h3 class="form-title">👥 인원</h3>
                    <div class="party-size-selector">
                        <button type="button" class="party-btn" id="decreaseBtn">-</button>
                        <span class="party-count" id="partyCount">2</span>
                        <button type="button" class="party-btn" id="increaseBtn">+</button>
                    </div>
                    <input type="hidden" id="partySize" name="partySize" value="2">
                </div>
                
                <!-- 쿠폰 선택 -->
                <div class="form-section">
                    <h3 class="form-title">🎫 쿠폰 사용</h3>
                    <div class="coupon-section">
                        <div class="coupon-selector">
                            <select class="form-select" id="couponSelect" name="selectedCouponId">
                                <option value="">쿠폰을 선택하세요 (선택사항)</option>
                                <c:forEach var="coupon" items="${availableCoupons}">
                                    <option value="${coupon.userCouponId}" 
                                            data-discount="${coupon.discountAmount}"
                                            data-min-order="${coupon.minOrderAmount}">
                                        ${coupon.couponName} - ${coupon.discountAmount}원 할인
                                        <c:if test="${coupon.minOrderAmount > 0}">
                                            (${coupon.minOrderAmount}원 이상)
                                        </c:if>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <!-- 선택된 쿠폰 정보 표시 -->
                        <div class="selected-coupon-info" id="selectedCouponInfo" style="display: none;">
                            <div class="coupon-card-mini">
                                <div class="coupon-icon">🎫</div>
                                <div class="coupon-details">
                                    <div class="coupon-name" id="selectedCouponName"></div>
                                    <div class="coupon-discount" id="selectedCouponDiscount"></div>
                                </div>
                                <div class="coupon-remove">
                                    <button type="button" class="remove-coupon-btn" onclick="removeCoupon()">×</button>
                                </div>
                            </div>
                        </div>
                        
                        <!-- 쿠폰 없을 때 안내 -->
                        <c:if test="${empty availableCoupons}">
                            <div class="no-coupons-message">
                                <p>사용 가능한 쿠폰이 없습니다.</p>
                                <small>예약을 완료하시면 쿠폰을 받을 수 있어요!</small>
                            </div>
                        </c:if>
                    </div>
                </div>
                
                <!-- 특별 요청 -->
                <div class="form-section">
                    <h3 class="form-title">📝 특별 요청사항</h3>
                    <div class="form-group">
                        <textarea class="form-textarea" name="specialRequest" placeholder="알레르기, 기념일, 좌석 요청 등 특별한 요청사항이 있으시면 작성해 주세요. (선택사항)"></textarea>
                    </div>
                </div>
                
                <!-- 예약 안내 -->
                <div class="notice-section">
                    <div class="notice-title">
                        <span>💡</span>
                        <span>예약 안내</span>
                    </div>
                    <ul class="notice-list">
                        <li>예약은 무료이며, 결제는 식당에서 직접 진행됩니다</li>
                        <li>예약 확정 후 SMS로 예약 정보를 보내드립니다</li>
                        <li>예약 변경/취소는 예약일 1일 전까지 가능합니다</li>
                        <li>예약 시간보다 15분 이상 늦으실 경우 자동 취소될 수 있습니다</li>
                        <li>노쇼(무단 불참) 시 향후 예약이 제한될 수 있습니다</li>
                        <li>선택한 쿠폰은 예약 확정 후 자동으로 사용됩니다</li>
                    </ul>
                </div>
                
                <!-- 버튼 영역 -->
                <div class="button-section">
                    <a href="${pageContext.request.contextPath}/board/restaurants/${restaurant.restaurantId}" class="btn btn-cancel">
                        취소
                    </a>
                    <button type="submit" class="btn btn-submit" id="submitBtn" disabled>
                        예약 신청하기
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- 푸터 -->
    <jsp:include page="footer.jsp" />
    
    <script>
        // 전역 변수
        let selectedTimeSlot = null;
        let partySize = 2;
        
        // 날짜 초기화 (오늘부터 30일 후까지)
        function initializeDatePicker() {
            const dateInput = document.getElementById('reservationDate');
            const today = new Date();
            const maxDate = new Date();
            maxDate.setDate(today.getDate() + 30);
            
            dateInput.min = today.toISOString().split('T')[0];
            dateInput.max = maxDate.toISOString().split('T')[0];
            
            // 기본값: 내일
            const tomorrow = new Date();
            tomorrow.setDate(today.getDate() + 1);
            dateInput.value = tomorrow.toISOString().split('T')[0];
        }
        
        // 시간 슬롯 생성
        function generateTimeSlots() {
            const timeSlotsContainer = document.getElementById('timeSlots');
            const timeSlots = [];
            
            // 11:00 ~ 21:00 (30분 간격)
            for (let hour = 11; hour <= 21; hour++) {
                for (let minute = 0; minute < 60; minute += 30) {
                    if (hour === 21 && minute > 0) break; // 21:30은 제외
                    
                    const timeString = String(hour).padStart(2, '0') + ':' + String(minute).padStart(2, '0');
                    timeSlots.push(timeString);
                }
            }
            
            timeSlotsContainer.innerHTML = timeSlots.map(function(time) {
                return '<div class="time-slot" data-time="' + time + '">' + time + '</div>';
            }).join('');
            
            // 시간 슬롯 클릭 이벤트
            document.querySelectorAll('.time-slot').forEach(slot => {
                slot.addEventListener('click', function() {
                    if (this.classList.contains('disabled')) return;
                    
                    // 기존 선택 해제
                    document.querySelectorAll('.time-slot').forEach(s => s.classList.remove('selected'));
                    
                    // 새로운 선택
                    this.classList.add('selected');
                    selectedTimeSlot = this.dataset.time;
                    document.getElementById('reservationTime').value = selectedTimeSlot;
                    
                    checkFormValidity();
                });
            });
        }
        
        // 인원 수 조정
        function initializePartySize() {
            const decreaseBtn = document.getElementById('decreaseBtn');
            const increaseBtn = document.getElementById('increaseBtn');
            const partyCountElement = document.getElementById('partyCount');
            const partySizeInput = document.getElementById('partySize');
            
            decreaseBtn.addEventListener('click', () => {
                if (partySize > 1) {
                    partySize--;
                    partyCountElement.textContent = partySize;
                    partySizeInput.value = partySize;
                }
            });
            
            increaseBtn.addEventListener('click', () => {
                if (partySize < 20) {
                    partySize++;
                    partyCountElement.textContent = partySize;
                    partySizeInput.value = partySize;
                }
            });
        }
        
        // 쿠폰 관련 기능
        function initializeCouponSelector() {
            const couponSelect = document.getElementById('couponSelect');
            const selectedCouponInfo = document.getElementById('selectedCouponInfo');
            
            if (couponSelect) {
                couponSelect.addEventListener('change', function() {
                    const selectedOption = this.options[this.selectedIndex];
                    
                    if (this.value) {
                        // 쿠폰이 선택된 경우
                        const couponName = selectedOption.textContent.trim();
                        const discountAmount = selectedOption.dataset.discount;
                        
                        document.getElementById('selectedCouponName').textContent = couponName;
                        document.getElementById('selectedCouponDiscount').textContent = discountAmount + '원 할인';
                        
                        selectedCouponInfo.style.display = 'block';
                        
                        // 셀렉트박스 숨기기 (선택 완료 후)
                        couponSelect.style.display = 'none';
                    } else {
                        // 쿠폰 선택 해제
                        selectedCouponInfo.style.display = 'none';
                        couponSelect.style.display = 'block';
                    }
                });
            }
        }
        
        // 쿠폰 제거 함수
        function removeCoupon() {
            const couponSelect = document.getElementById('couponSelect');
            const selectedCouponInfo = document.getElementById('selectedCouponInfo');
            
            // 선택 초기화
            couponSelect.value = '';
            selectedCouponInfo.style.display = 'none';
            couponSelect.style.display = 'block';
        }
        
        // 폼 유효성 검사
        function checkFormValidity() {
            const dateInput = document.getElementById('reservationDate');
            const submitBtn = document.getElementById('submitBtn');
            
            const isValid = dateInput.value && selectedTimeSlot;
            submitBtn.disabled = !isValid;
        }
        
        // 폼 제출 처리
        function initializeForm() {
            const form = document.getElementById('reservationForm');
            const dateInput = document.getElementById('reservationDate');
            
            dateInput.addEventListener('change', checkFormValidity);
            
            form.addEventListener('submit', function(e) {
                if (!selectedTimeSlot) {
                    e.preventDefault();
                    alert('예약 시간을 선택해 주세요.');
                    return false;
                }
            });
        }
        
        // 페이지 로드 시 초기화
        document.addEventListener('DOMContentLoaded', function() {
            initializeDatePicker();
            generateTimeSlots();
            initializePartySize();
            initializeCouponSelector();
            initializeForm();
        });
    </script>
</body>
</html>