<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${restaurant.name} 리뷰 - Catch Table</title>
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
            padding-top: 150px;
        }
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 30px 20px;
            position: relative;
            z-index: 1;
        }
        
        .page-header {
            background: white;
            border-radius: 16px;
            padding: 40px 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            overflow: visible;
            min-height: 250px;
        }
        
        .back-info {
            text-align: center;
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 20px;
            cursor: pointer;
            transition: color 0.3s ease;
            padding: 15px 0;
            min-height: 30px;
            position: relative;
            z-index: 10;
        }
        
        .back-info:hover {
            color: #d4af37;
        }
        
        .restaurant-title {
            font-family: 'Crimson Text', serif;
            font-size: 2.2rem;
            font-weight: 600;
            color: #2c2c2c;
            text-align: center;
            margin-bottom: 10px;
        }
        
        .restaurant-info {
            text-align: center;
            color: #666;
            margin-bottom: 25px;
        }
        
        .restaurant-address {
            font-size: 1rem;
            margin-bottom: 10px;
        }
        
        .restaurant-category {
            font-size: 0.9rem;
            color: #999;
        }
        
        /* 통합 리뷰 통계 */
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
        
        /* 필터 및 정렬 */
        .filter-section {
            background: white;
            border-radius: 16px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        
        .filter-controls {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .sort-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .sort-btn {
            background: white;
            border: 2px solid #e0e0e0;
            padding: 8px 16px;
            border-radius: 20px;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 500;
            transition: all 0.3s ease;
            color: #666;
        }
        
        .sort-btn:hover {
            border-color: #d4af37;
            color: #d4af37;
        }
        
        .sort-btn.active {
            background: #d4af37;
            border-color: #d4af37;
            color: white;
        }
        
        .rating-filter {
            display: flex;
            gap: 5px;
            align-items: center;
        }
        
        .rating-filter button {
            background: white;
            border: 1px solid #e0e0e0;
            padding: 5px 10px;
            border-radius: 15px;
            cursor: pointer;
            font-size: 0.8rem;
            transition: all 0.3s ease;
        }
        
        .rating-filter button:hover,
        .rating-filter button.active {
            background: #d4af37;
            border-color: #d4af37;
            color: white;
        }
        
        /* 리뷰 목록 */
        .reviews-container {
            background: white;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }
        
        .reviews-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .reviews-title {
            font-size: 1.4rem;
            font-weight: 600;
            color: #2c2c2c;
        }
        
        .reviews-count {
            color: #666;
            font-weight: 500;
        }
        
        .review-list {
            display: grid;
            gap: 25px;
        }
        
        .review-item {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 25px;
            transition: all 0.3s ease;
        }
        
        .review-item:hover {
            background: #e9ecef;
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
        }
        
        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }
        
        .review-user {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .review-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: #d4af37;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 1.2rem;
        }
        
        .review-user-info {
            display: flex;
            flex-direction: column;
        }
        
        .review-user-name {
            font-weight: 600;
            color: #2c2c2c;
            font-size: 1rem;
        }
        
        .review-date {
            font-size: 0.85rem;
            color: #666;
            margin-top: 2px;
        }
        
        .review-rating-section {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 5px;
        }
        
        .review-rating {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .review-stars {
            color: #ffc107;
            font-size: 1.1rem;
        }
        
        .review-score {
            font-weight: 600;
            color: #2c2c2c;
        }
        
        .review-content {
            margin-bottom: 15px;
        }
        
        .review-text {
            color: #2c2c2c;
            line-height: 1.7;
            margin-bottom: 12px;
            font-size: 1rem;
        }
        
        .review-recommendation {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #e8f5e8;
            color: #2e7d32;
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        
        .review-recommendation.not-recommended {
            background: #ffebee;
            color: #c62828;
        }
        
        .review-images {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        
        .review-image {
            width: 80px;
            height: 80px;
            border-radius: 8px;
            object-fit: cover;
            cursor: pointer;
            transition: transform 0.3s ease;
        }
        
        .review-image:hover {
            transform: scale(1.1);
        }
        
        /* 빈 상태 */
        .empty-reviews {
            text-align: center;
            padding: 80px 20px;
            color: #666;
        }
        
        .empty-icon {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        .empty-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #666;
            margin-bottom: 10px;
        }
        
        .empty-message {
            font-size: 1rem;
            color: #999;
        }
        
        /* 스크롤 탑 버튼 */
        .scroll-top-btn {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #d4af37, #c9a96e);
            color: white;
            border: none;
            border-radius: 50%;
            cursor: pointer;
            font-size: 1.2rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(212, 175, 55, 0.3);
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transform: translateY(20px);
        }
        
        .scroll-top-btn.show {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }
        
        .scroll-top-btn:hover {
            background: linear-gradient(135deg, #c9a96e, #b8985f);
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(212, 175, 55, 0.4);
        }
        
        /* 이미지 모달 */
        .image-modal {
            display: none;
            position: fixed;
            z-index: 2000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.8);
            backdrop-filter: blur(5px);
        }
        
        .image-modal-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            max-width: 90%;
            max-height: 90%;
        }
        
        .image-modal img {
            width: 100%;
            height: auto;
            border-radius: 8px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.3);
        }
        
        .image-modal-close {
            position: absolute;
            top: 20px;
            right: 30px;
            color: white;
            font-size: 40px;
            font-weight: bold;
            cursor: pointer;
            z-index: 2001;
        }
        
        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }
            
            .scroll-top-btn {
                bottom: 20px;
                right: 20px;
                width: 45px;
                height: 45px;
                font-size: 1.1rem;
            }
            
            .header-top {
                text-align: center;
            }
            
            .back-info {
                font-size: 0.8rem;
            }
            
            .restaurant-title {
                font-size: 1.8rem;
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
            
            .filter-controls {
                flex-direction: column;
                align-items: stretch;
            }
            
            .sort-buttons {
                justify-content: center;
            }
            
            .review-header {
                flex-direction: column;
                gap: 10px;
                align-items: flex-start;
            }
            
            .review-rating-section {
                align-items: flex-start;
            }
        }
        
        @media (max-width: 480px) {
            .sort-buttons {
                flex-direction: column;
                align-items: stretch;
            }
        }
    </style>
</head>
<body>
    <!-- 네비게이션 -->
    <jsp:include page="navi.jsp" />
    
    <div class="container">
        <!-- 페이지 헤더 -->
        <div class="page-header">
            <p class="back-info" onclick="goBack()">← 리뷰 그만 보기</p>
            
            <h1 class="restaurant-title">${restaurant.name}</h1>
            
            <div class="restaurant-info">
                <div class="restaurant-address">📍 ${restaurant.address}</div>
                <div class="restaurant-category">${restaurant.cuisineType}</div>
            </div>
            
            <!-- 통합 리뷰 통계 -->
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
            </div>
        </div>
        
        <!-- 필터 및 정렬 -->
        <div class="filter-section">
            <div class="filter-controls">
                <div class="sort-buttons">
                    <button class="sort-btn active" data-sort="latest">최신순</button>
                    <button class="sort-btn" data-sort="rating-high">평점 높은순</button>
                    <button class="sort-btn" data-sort="rating-low">평점 낮은순</button>
                    <button class="sort-btn" data-sort="recommended">추천순</button>
                </div>
                
                <div class="rating-filter">
                    <span style="font-size: 0.9rem; color: #666; margin-right: 10px;">평점 필터:</span>
                    <button data-rating="all" class="active">전체</button>
                    <button data-rating="5">⭐5</button>
                    <button data-rating="4">⭐4</button>
                    <button data-rating="3">⭐3</button>
                    <button data-rating="2">⭐2</button>
                    <button data-rating="1">⭐1</button>
                </div>
            </div>
        </div>
        
        <!-- 리뷰 목록 -->
        <div class="reviews-container">
            <div class="reviews-header">
                <h2 class="reviews-title">📝 리뷰</h2>
                <div class="reviews-count">총 <strong>${fn:length(reviews)}</strong>개의 리뷰</div>
            </div>
            
            <div class="review-list" id="reviewList">
                <c:choose>
                    <c:when test="${not empty reviews}">
                        <c:forEach var="review" items="${reviews}">
                            <div class="review-item" data-rating="${review.rating}" data-recommended="${review.isRecommended}">
                                <div class="review-header">
                                    <div class="review-user">
                                        <div class="review-avatar">
                                            ${fn:substring(review.email, 0, 1)}
                                        </div>
                                        <div class="review-user-info">
                                            <div class="review-user-name">작성자: ${review.email}</div>
                                            <div class="review-date">
                                                ${review.createdAt.toLocalDate()}
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="review-rating-section">
                                        <div class="review-rating">
                                            <div class="review-stars">
                                                <c:forEach begin="1" end="5" var="star">
                                                    <span>${star <= review.rating ? '⭐' : '☆'}</span>
                                                </c:forEach>
                                            </div>
                                            <span class="review-score">${review.rating}.0</span>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="review-content">
                                    <div class="review-text">
                                        ${not empty review.content ? review.content : '내용이 없습니다.'}
                                    </div>
                                    
                                    <c:choose>
                                        <c:when test="${review.isRecommended}">
                                            <div class="review-recommendation">
                                                👍 추천해요!
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="review-recommendation not-recommended">
                                                👎 추천하지 않아요
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <c:if test="${not empty review.imageUrl}">
                                        <div class="review-images">
                                            <img src="${pageContext.request.contextPath}${review.imageUrl}" alt="리뷰 이미지" class="review-image" onclick="showImageModal('${pageContext.request.contextPath}${review.imageUrl}')">
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-reviews">
                            <div class="empty-icon">📝</div>
                            <div class="empty-title">아직 리뷰가 없습니다</div>
                            <div class="empty-message">첫 번째 리뷰를 남겨보세요!</div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <!-- 스크롤 탑 버튼 -->
    <button class="scroll-top-btn" id="scrollTopBtn" onclick="scrollToTop()">
        ↑
    </button>
    
    <!-- 이미지 확대 모달 -->
    <div id="imageModal" class="image-modal">
        <span class="image-modal-close" onclick="closeImageModal()">&times;</span>
        <div class="image-modal-content">
            <img id="modalImage" src="" alt="리뷰 이미지">
        </div>
    </div>
    
    <!-- 푸터 -->
    <jsp:include page="footer.jsp" />
    
    <script>
        // 이전 화면으로 돌아가기
        function goBack() {
            window.location.href = '${pageContext.request.contextPath}/board/restaurants';
        }

        // 이미지 모달 기능
        function showImageModal(imageUrl) {
            document.getElementById('modalImage').src = imageUrl;
            document.getElementById('imageModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
        }

        function closeImageModal() {
            document.getElementById('imageModal').style.display = 'none';
            document.body.style.overflow = 'auto';
        }

        // 스크롤 탑 기능
        function scrollToTop() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        }

        // 스크롤 이벤트 (탑 버튼 표시/숨김)
        window.addEventListener('scroll', function() {
            const scrollTopBtn = document.getElementById('scrollTopBtn');
            if (window.pageYOffset > 300) {
                scrollTopBtn.classList.add('show');
            } else {
                scrollTopBtn.classList.remove('show');
            }
        });

        // 전역 변수
        let allReviews = [];
        let currentSort = 'latest';
        let currentRatingFilter = 'all';
        
        // 페이지 로드 시 초기화
        document.addEventListener('DOMContentLoaded', function() {
            // 모든 리뷰 데이터 수집
            collectReviewData();
            
            // 정렬 버튼 이벤트
            const sortButtons = document.querySelectorAll('.sort-btn');
            sortButtons.forEach(btn => {
                btn.addEventListener('click', function() {
                    // 활성화 상태 변경
                    sortButtons.forEach(b => b.classList.remove('active'));
                    this.classList.add('active');
                    
                    currentSort = this.dataset.sort;
                    applyFiltersAndSort();
                });
            });
            
            // 평점 필터 버튼 이벤트
            const ratingButtons = document.querySelectorAll('.rating-filter button');
            ratingButtons.forEach(btn => {
                btn.addEventListener('click', function() {
                    // 활성화 상태 변경
                    ratingButtons.forEach(b => b.classList.remove('active'));
                    this.classList.add('active');
                    
                    currentRatingFilter = this.dataset.rating;
                    applyFiltersAndSort();
                });
            });
        });
        
        // 리뷰 데이터 수집
        function collectReviewData() {
            const reviewItems = document.querySelectorAll('.review-item');
            allReviews = Array.from(reviewItems).map(item => ({
                element: item,
                rating: parseInt(item.dataset.rating),
                recommended: item.dataset.recommended === 'true',
                date: item.querySelector('.review-date').textContent.trim()
            }));
        }
        
        // 필터 및 정렬 적용
        function applyFiltersAndSort() {
            let filteredReviews = [...allReviews];
            
            // 평점 필터 적용
            if (currentRatingFilter !== 'all') {
                const targetRating = parseInt(currentRatingFilter);
                filteredReviews = filteredReviews.filter(review => review.rating === targetRating);
            }
            
            // 정렬 적용
            filteredReviews.sort((a, b) => {
                switch (currentSort) {
                    case 'rating-high':
                        return b.rating - a.rating;
                    case 'rating-low':
                        return a.rating - b.rating;
                    case 'recommended':
                        if (a.recommended && !b.recommended) return -1;
                        if (!a.recommended && b.recommended) return 1;
                        return 0;
                    case 'latest':
                    default:
                        return b.date.localeCompare(a.date);
                }
            });
            
            // 화면에 렌더링
            renderFilteredReviews(filteredReviews);
        }
        
        // 필터링된 리뷰 렌더링
        function renderFilteredReviews(filteredReviews) {
            const reviewList = document.getElementById('reviewList');
            
            if (filteredReviews.length === 0) {
                reviewList.innerHTML = `
                    <div class="empty-reviews">
                        <div class="empty-icon">🔍</div>
                        <div class="empty-title">조건에 맞는 리뷰가 없습니다</div>
                        <div class="empty-message">다른 조건으로 검색해보세요</div>
                    </div>
                `;
                return;
            }
            
            // 기존 내용 모두 지우기
            reviewList.innerHTML = '';
            
            // 필터링된 리뷰만 표시
            filteredReviews.forEach(review => {
                review.element.style.display = 'block';
                reviewList.appendChild(review.element);
            });
        }

        // 모달 외부 클릭시 닫기
        window.onclick = function(event) {
            var imageModal = document.getElementById('imageModal');
            if (event.target === imageModal) {
                closeImageModal();
            }
        };

        // ESC 키로 모달 닫기
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeImageModal();
            }
        });
    </script>
</body>
</html>