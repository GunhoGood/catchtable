<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>예약 완료 - Catch Table</title>
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
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .success-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            text-align: center;
        }
        
        .success-header {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            padding: 50px 30px;
        }
        
        .success-icon {
            font-size: 4rem;
            margin-bottom: 20px;
        }
        
        .success-title {
            font-family: 'Crimson Text', serif;
            font-size: 2.2rem;
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .success-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
        }
        
        .reservation-details {
            padding: 40px 30px;
        }
        
        .details-grid {
            display: grid;
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .detail-card {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 20px;
            
        }
        
        .detail-label {
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 5px;
            font-weight: 600;
        }
        
        .detail-value {
            font-size: 1.1rem;
            color: #2c2c2c;
            font-weight: 600;
        }
        
        .restaurant-info {
            background: #e3f2fd;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 30px;
        }
        
        .restaurant-name {
            font-family: 'Crimson Text', serif;
            font-size: 1.6rem;
            font-weight: 600;
            color: #1976d2;
            margin-bottom: 10px;
        }
        
        .restaurant-address {
            color: #666;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .notice-section {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
            text-align: left;
        }
        
        .notice-title {
            font-weight: 600;
            color: #b8860b;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .notice-list {
            list-style: none;
            color: #666;
        }
        
        .notice-list li {
            margin-bottom: 8px;
            padding-left: 20px;
            position: relative;
        }
        
        .notice-list li:before {
            content: "•";
            color: #b8860b;
            position: absolute;
            left: 0;
            font-weight: bold;
        }
        
        .button-section {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 15px 25px;
            border: none;
            border-radius: 25px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-primary {
            background: #d4af37;
            color: white;
            box-shadow: 0 4px 20px rgba(212, 175, 55, 0.3);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 25px rgba(212, 175, 55, 0.4);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
        
        .btn-outline {
            background: transparent;
            color: #d4af37;
            border: 2px solid #d4af37;
        }
        
        .btn-outline:hover {
            background: #d4af37;
            color: white;
        }
        
        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }
            
            .success-header {
                padding: 40px 20px;
            }
            
            .reservation-details {
                padding: 30px 20px;
            }
            
            .button-section {
                flex-direction: column;
                align-items: center;
            }
        }
    </style>
</head>
<body>
    <!-- 네비게이션 -->
    <jsp:include page="navi.jsp" />
    
    <div class="container">
        <div class="success-container">
            <!-- 성공 헤더 -->
            <div class="success-header">
                <div class="success-icon">🎉</div>
                <h1 class="success-title">예약이 완료되었습니다!</h1>
                <p class="success-subtitle">예약 정보를 확인해 주세요</p>
            </div>
            
            <!-- 예약 상세 정보 -->
            <div class="reservation-details">
                <!-- 레스토랑 정보 -->
                <div class="restaurant-info">
                    <h2 class="restaurant-name">${restaurant.name}</h2>
                    <div class="restaurant-address">
                        <span>📍</span>
                        <span>${restaurant.address}</span>
                    </div>
                </div>
                
                <!-- 예약 정보 -->
                <div class="details-grid">
                    <div class="detail-card">
                        <div class="detail-label">예약 날짜</div>
                        <div class="detail-value">${formattedDate}</div>
                    </div>
                    
                    <div class="detail-card">
                        <div class="detail-label">예약 시간</div>
                        <div class="detail-value">${reservation.reservationHour}</div>
                    </div>
                    
                    <div class="detail-card">
                        <div class="detail-label">인원</div>
                        <div class="detail-value">${reservation.partySize}명</div>
                    </div>
                    
                    <c:if test="${not empty reservation.specialRequest}">
                        <div class="detail-card">
                            <div class="detail-label">특별 요청사항</div>
                            <div class="detail-value">${reservation.specialRequest}</div>
                        </div>
                    </c:if>
                </div>
                
                <!-- 안내사항 -->
                <div class="notice-section">
                    <div class="notice-title">
                        <span>📋</span>
                        <span>예약 안내</span>
                    </div>
                    <ul class="notice-list">
                        <li>예약 확정까지 1-2시간 소요될 수 있습니다</li>
                        <li>확정 시 SMS로 알림을 보내드립니다</li>
                        <li>예약 변경/취소는 마이페이지에서 가능합니다</li>
                        <li>예약 시간 15분 전에 도착해 주세요</li>
                        <li>결제는 식당에서 직접 진행됩니다</li>
                    </ul>
                </div>
                
                <!-- 버튼 영역 -->
                <div class="button-section">
                    <a href="${pageContext.request.contextPath}/user/reservations" class="btn btn-primary">
                        내 예약 보기
                    </a>
                    <a href="${pageContext.request.contextPath}/board/restaurants" class="btn btn-outline">
                        다른 레스토랑 보기
                    </a>
                    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">
                        홈으로
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 푸터 -->
    <jsp:include page="footer.jsp" />
    
    <script>
        // 페이지 로드 시 축하 애니메이션
        document.addEventListener('DOMContentLoaded', function() {
            const successIcon = document.querySelector('.success-icon');
            
            // 간단한 bounce 애니메이션
            setTimeout(() => {
                successIcon.style.animation = 'bounce 0.6s ease-in-out';
            }, 500);
        });
        
        // CSS 애니메이션 추가
        const style = document.createElement('style');
        style.textContent = `
            @keyframes bounce {
                0%, 20%, 60%, 100% { transform: translateY(0); }
                40% { transform: translateY(-20px); }
                80% { transform: translateY(-10px); }
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>