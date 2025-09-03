<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${restaurant.name} - Catch Table</title>
    <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/resources/images/favicon-32x32.png">
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
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        /* 헤더 이미지 */
        .restaurant-header {
            position: relative;
            height: 400px;
            border-radius: 20px;
            overflow: hidden;
            margin-bottom: 30px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
        }
        
        .restaurant-header img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .restaurant-header-placeholder {
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #d4af37, #c9a96e);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 5rem;
        }
        
        .header-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(transparent, rgba(0, 0, 0, 0.7));
            padding: 40px 30px 30px;
            color: white;
        }
        
        .restaurant-title {
            font-family: 'Crimson Text', serif;
            font-size: 2.5rem;
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .restaurant-category {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 15px;
        }
        
        .restaurant-stats {
            display: flex;
            gap: 30px;
            align-items: center;
        }
        
        .stat-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
        }
        
        .like-button {
            position: absolute;
            top: 20px;
            right: 20px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border: none;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            font-size: 1.5rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .like-button:hover {
            transform: scale(1.1);
        }
        
        .like-button.liked {
            background: rgba(255, 69, 58, 0.95);
            color: white;
        }
        
        /* 컨텐츠 그리드 */
        .content-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }
        
        .main-content {
            background: white;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }
        
        .sidebar {
            background: white;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            height: fit-content;
            position: sticky;
            top: 100px;
        }
        
        /* 섹션 스타일 */
        .section {
            margin-bottom: 40px;
        }
        
        .section:last-child {
            margin-bottom: 0;
        }
        
        .section-title {
            font-family: 'Crimson Text', serif;
            font-size: 1.8rem;
            font-weight: 600;
            color: #2c2c2c;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        /* 레스토랑 정보 */
        .info-grid {
            display: grid;
            gap: 15px;
        }
        
        .info-item {
            display: flex;
            align-items: flex-start;
            gap: 15px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 12px;
        }
        
        .info-icon {
            font-size: 1.2rem;
            min-width: 24px;
        }
        
        .info-content {
            flex: 1;
        }
        
        .info-label {
            font-weight: 600;
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 5px;
        }
        
        .info-value {
            color: #2c2c2c;
            font-weight: 500;
        }
        
        /* 메뉴 */
        .menu-grid {
            display: grid;
            gap: 20px;
        }
        
        .menu-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 12px;
            transition: all 0.3s ease;
        }
        
        .menu-item:hover {
            background: #e9ecef;
            transform: translateY(-2px);
        }
        
        .menu-info {
            flex: 1;
        }
        
        .menu-name {
            font-weight: 600;
            font-size: 1.1rem;
            color: #2c2c2c;
            margin-bottom: 5px;
        }
        
        .menu-description {
            color: #666;
            font-size: 0.9rem;
            line-height: 1.4;
        }
        
        .menu-price {
            font-weight: 700;
            font-size: 1.2rem;
            color: #d4af37;
        }
        
        .signature-badge {
            background: #d4af37;
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.7rem;
            font-weight: 600;
            margin-left: 10px;
        }
        
        /* 예약하기 섹션 */
        .reservation-section {
            text-align: center;
        }
        
        .reservation-btn {
            background: linear-gradient(135deg, #d4af37, #c9a96e);
            color: white;
            border: none;
            padding: 20px 40px;
            border-radius: 50px;
            font-size: 1.2rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            box-shadow: 0 4px 20px rgba(212, 175, 55, 0.3);
        }
        
        .reservation-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 30px rgba(212, 175, 55, 0.4);
        }
        
        .reservation-note {
            margin-top: 15px;
            color: #666;
            font-size: 0.9rem;
        }
        
        /* 통합 리뷰 카드 스타일 */
        .review-summary {
            background: linear-gradient(135deg, #f8f6f3, #ffffff);
            border: 1px solid #e8e6e3;
            border-radius: 16px;
            padding: 30px;
            margin-bottom: 30px;
        }
        
        .review-stats-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .review-main-stat {
            text-align: center;
            border-bottom: 1px solid #f0f0f0;
            padding-bottom: 20px;
        }
        
        .review-main-value {
            font-family: 'Crimson Text', serif;
            font-size: 3rem;
            font-weight: 700;
            color: #d4af37;
            display: block;
        }
        
        .review-main-label {
            font-size: 1rem;
            color: #666;
            font-weight: 600;
            margin-top: 5px;
        }
        
        .review-sub-stats {
            display: flex;
            justify-content: space-around;
            gap: 20px;
        }
        
        .review-sub-stat {
            text-align: center;
            flex: 1;
        }
        
        .review-sub-value {
            font-family: 'Crimson Text', serif;
            font-size: 1.8rem;
            font-weight: 600;
            color: #d4af37;
            display: block;
        }
        
        .review-sub-label {
            font-size: 0.9rem;
            color: #888;
            font-weight: 500;
            margin-top: 5px;
        }
        
        .view-reviews-btn {
            background: transparent;
            color: #666 !important;
            text-decoration: none !important;
            border: 2px solid #e8e6e3;
            padding: 15px 30px;
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-block;
            margin-top: 20px;
        }
        
        .view-reviews-btn:hover {
            color: #d4af37 !important;
            border-color: #d4af37;
            transform: translateY(-2px);
        }
        
        /* 뒤로가기 버튼 */
        .back-btn {
            background: #6c757d;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 25px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 20px;
            text-decoration: none;
            display: inline-block;
        }
        
        .back-btn:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
        
        /* 반응형 */
        @media (max-width: 768px) {
            .content-grid {
                grid-template-columns: 1fr;
            }
            
            .sidebar {
                position: static;
                top: auto;
            }
            
            .restaurant-header {
                height: 300px;
            }
            
            .restaurant-title {
                font-size: 2rem;
            }
            
            .restaurant-stats {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }
            
            .review-sub-stats {
                flex-direction: column;
                gap: 15px;
            }
            
            .review-main-value {
                font-size: 2.5rem;
            }
            
            .review-sub-value {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <!-- 네비게이션 -->
    <jsp:include page="navi.jsp" />
    
    <div class="container">
        <!-- 뒤로가기 버튼 -->
        <a href="${pageContext.request.contextPath}/board/restaurants" class="back-btn">
            ← 목록으로 돌아가기
        </a>
        
        <!-- 레스토랑 헤더 -->
        <div class="restaurant-header">
            <c:choose>
                <c:when test="${not empty restaurant.imageUrl}">
                    <img src="${restaurant.imageUrl}" alt="${restaurant.name}">
                </c:when>
                <c:otherwise>
                    <div class="restaurant-header-placeholder">🍽️</div>
                </c:otherwise>
            </c:choose>
            
            <div class="header-overlay">
                <h1 class="restaurant-title">${restaurant.name}</h1>
                <div class="restaurant-category">${category.name} • ${restaurant.cuisineType}</div>
                <div class="restaurant-stats">
                    <div class="stat-item">
                        <span>⭐</span>
                        <span><fmt:formatNumber value="${reviewStats.averageRating}" pattern="#.#" /></span>
                        <span>(${reviewStats.reviewCount}개 리뷰)</span>
                    </div>
                    <div class="stat-item">
                        <span>❤️</span>
                        <span id="likesCount">${restaurant.likesCount}</span>
                    </div>
                    <div class="stat-item">
                        <span>👀</span>
                        <span>${restaurant.viewCount}</span>
                    </div>
                </div>
            </div>
            
            <!-- 좋아요 버튼 -->
            <button class="like-button ${isLiked ? 'liked' : ''}" id="likeButton" data-restaurant-id="${restaurant.restaurantId}">
                <span>${isLiked ? '❤️' : '🤍'}</span>
            </button>
        </div>
        
        <!-- 컨텐츠 그리드 -->
        <div class="content-grid">
            <!-- 메인 컨텐츠 -->
            <div class="main-content">
                <!-- 레스토랑 소개 -->
                <div class="section">
                    <h2 class="section-title">🏪 레스토랑 소개</h2>
                    <p>${not empty restaurant.description ? restaurant.description : '맛있는 음식과 따뜻한 서비스로 여러분을 맞이합니다.'}</p>
                </div>
                
                <!-- 메뉴 -->
                <div class="section">
                    <h2 class="section-title">📋 메뉴</h2>
                    <div class="menu-grid">
                        <c:choose>
                            <c:when test="${not empty menus}">
                                <c:forEach var="menu" items="${menus}">
                                    <div class="menu-item">
                                        <div class="menu-info">
                                            <div class="menu-name">
                                                ${menu.name}
                                                <c:if test="${menu.isSignature}">
                                                    <span class="signature-badge">시그니처</span>
                                                </c:if>
                                            </div>
                                            <c:if test="${not empty menu.description}">
                                                <div class="menu-description">${menu.description}</div>
                                            </c:if>
                                        </div>
                                        <div class="menu-price">
                                            <fmt:formatNumber value="${menu.price}" pattern="#,###" />원
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p style="text-align: center; color: #666; padding: 40px;">메뉴 정보를 준비 중입니다.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <!-- 통합 리뷰 섹션 -->
                <div class="section">
                    <h2 class="section-title">📝 리뷰</h2>
                    <div class="review-summary">
                        <div class="review-stats-container">
                            <div class="review-main-stat">
                                <span class="review-main-value">
                                    <fmt:formatNumber value="${reviewStats.averageRating}" pattern="0.0" />
                                </span>
                                <div class="review-main-label">평균 평점</div>
                            </div>
                            <div class="review-sub-stats">
                                <div class="review-sub-stat">
                                    <span class="review-sub-value">${reviewStats.reviewCount}</span>
                                    <div class="review-sub-label">총 리뷰수</div>
                                </div>
                                <div class="review-sub-stat">
                                    <span class="review-sub-value">
                                        <fmt:formatNumber value="${reviewStats.recommendationRate}" pattern="0" />%
                                    </span>
                                    <div class="review-sub-label">추천율</div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- 리뷰 보기 버튼 -->
                        <div style="text-align: center;">
                            <a href="${pageContext.request.contextPath}/board/restaurants/${restaurant.restaurantId}/reviews" 
                               class="view-reviews-btn">
                                📝 모든 리뷰 보기 (${reviewStats.reviewCount}개)
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 사이드바 -->
            <div class="sidebar">
                <!-- 레스토랑 정보 -->
                <div class="section">
                    <h3 class="section-title">📍 정보</h3>
                    <div class="info-grid">
                        <div class="info-item">
                            <span class="info-icon">📍</span>
                            <div class="info-content">
                                <div class="info-label">주소</div>
                                <div class="info-value">${restaurant.address}</div>
                            </div>
                        </div>
                        
                        <c:if test="${not empty restaurant.phone}">
                            <div class="info-item">
                                <span class="info-icon">📞</span>
                                <div class="info-content">
                                    <div class="info-label">전화번호</div>
                                    <div class="info-value">${restaurant.phone}</div>
                                </div>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty restaurant.operatingHours}">
                            <div class="info-item">
                                <span class="info-icon">🕐</span>
                                <div class="info-content">
                                    <div class="info-label">영업시간</div>
                                    <div class="info-value">${restaurant.operatingHours}</div>
                                </div>
                            </div>
                        </c:if>
                        
                        <div class="info-item">
                            <span class="info-icon">💰</span>
                            <div class="info-content">
                                <div class="info-label">가격대</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${restaurant.priceRange == 'LOW'}">💰 저렴함</c:when>
                                        <c:when test="${restaurant.priceRange == 'MEDIUM'}">💰💰 보통</c:when>
                                        <c:when test="${restaurant.priceRange == 'HIGH'}">💰💰💰 고급</c:when>
                                        <c:otherwise>💰 보통</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- 예약하기 -->
                <div class="section">
                    <div class="reservation-section">
                        <a href="${pageContext.request.contextPath}/board/restaurants/${restaurant.restaurantId}/reservation" 
                           class="reservation-btn">
                            🍽️ 예약하기
                        </a>
                        <div class="reservation-note">
                            간편하게 예약하고 맛있는 식사를 즐겨보세요!
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 푸터 -->
    <jsp:include page="footer.jsp" />
    
    <script>
        const contextPath = '${pageContext.request.contextPath}';
        const likeButton = document.getElementById('likeButton');
        const likesCountElement = document.getElementById('likesCount');
        
        // 좋아요 버튼 클릭
        likeButton.addEventListener('click', function() {
            const restaurantId = this.dataset.restaurantId;
            
            fetch(contextPath + '/board/api/restaurants/' + restaurantId + '/like', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                credentials: 'same-origin'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // 좋아요 버튼 상태 변경
                    this.classList.toggle('liked');
                    this.querySelector('span').textContent = data.isLiked ? '❤️' : '🤍';
                    
                    // 좋아요 수 업데이트
                    likesCountElement.textContent = data.likesCount || 0;
                } else {
                    alert(data.message || '오류가 발생했습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('네트워크 오류가 발생했습니다.');
            });
        });
    </script>
</body>
</html>