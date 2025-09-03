<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>레스토랑 둘러보기 - Catch Table</title>
<link rel="icon" type="image/png" sizes="32x32"
	href="${pageContext.request.contextPath}/resources/images/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16"
	href="${pageContext.request.contextPath}/resources/images/favicon-16x16.png">
<style>
@import
	url('https://fonts.googleapis.com/css2?family=Crimson+Text:ital,wght@0,400;0,600;1,400&family=Source+Sans+Pro:wght@300;400;600;700&display=swap')
	;

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
	padding: 40px 20px;
}

/* 헤더 */
.page-header {
	text-align: center;
	margin-bottom: 50px;
}

.page-title {
	font-family: 'Crimson Text', serif;
	font-size: 2.5rem;
	font-weight: 600;
	color: #2c2c2c;
	margin-bottom: 15px;
	letter-spacing: 0.5px;
}

.page-subtitle {
	font-size: 1.1rem;
	color: #666;
	font-weight: 300;
}

/* 필터 바 */
.filter-bar {
	background: #ffffff;
	border-radius: 50px;
	padding: 20px 30px;
	margin-bottom: 40px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
	border: 1px solid #f0f0f0;
}

.filter-controls {
	display: flex;
	align-items: center;
	gap: 20px;
	flex-wrap: wrap;
	justify-content: center;
}

.filter-group {
	display: flex;
	align-items: center;
	gap: 10px;
}

.filter-label {
	font-weight: 600;
	color: #333;
	font-size: 0.9rem;
	white-space: nowrap;
}

.filter-select {
	padding: 8px 15px;
	border: 2px solid #e0e0e0;
	border-radius: 25px;
	font-size: 0.9rem;
	background: #ffffff;
	cursor: pointer;
	transition: all 0.3s ease;
	font-family: 'Source Sans Pro', sans-serif;
}

.filter-select:focus {
	outline: none;
	border-color: #d4af37;
	box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
}

.search-container {
	position: relative;
	min-width: 250px;
}

.search-input {
	width: 100%;
	padding: 10px 45px 10px 20px;
	border: 2px solid #e0e0e0;
	border-radius: 25px;
	font-size: 0.9rem;
	background: #ffffff;
	transition: all 0.3s ease;
	font-family: 'Source Sans Pro', sans-serif;
}

.search-input:focus {
	outline: none;
	border-color: #d4af37;
	box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
}

.search-btn {
	position: absolute;
	right: 5px;
	top: 50%;
	transform: translateY(-50%);
	background: #d4af37;
	border: none;
	width: 35px;
	height: 35px;
	border-radius: 50%;
	cursor: pointer;
	display: flex;
	align-items: center;
	justify-content: center;
	transition: all 0.3s ease;
	color: #2c2c2c;
	font-weight: bold;
}

.search-btn:hover {
	background: #c9a96e;
	transform: translateY(-50%) scale(1.05);
}

/* 정렬 및 뷰 옵션 */
.toolbar {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 30px;
	padding: 0 10px;
}

.sort-options {
	display: flex;
	align-items: center;
	gap: 15px;
}

.sort-btn {
	background: none;
	border: 2px solid #e0e0e0;
	padding: 8px 16px;
	border-radius: 20px;
	cursor: pointer;
	font-size: 0.85rem;
	font-weight: 500;
	transition: all 0.3s ease;
	color: #666;
	font-family: 'Source Sans Pro', sans-serif;
}

.sort-btn.active {
	background: #d4af37;
	border-color: #d4af37;
	color: #2c2c2c;
}

.sort-btn:hover {
	border-color: #d4af37;
	color: #d4af37;
}

.result-count {
	font-size: 0.9rem;
	color: #666;
	font-weight: 500;
}

/* 인스타그램 스타일 그리드 */
.restaurant-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
	gap: 30px;
	margin-bottom: 50px;
}

.restaurant-card {
	background: #ffffff;
	border-radius: 16px;
	overflow: hidden;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
	transition: all 0.3s ease;
	cursor: pointer;
	position: relative;
}

.restaurant-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
}

.card-image-container {
	position: relative;
	width: 100%;
	aspect-ratio: 1;
	overflow: hidden;
}

.card-image {
	width: 100%;
	height: 100%;
	object-fit: cover;
	transition: transform 0.3s ease;
}

.restaurant-card:hover .card-image {
	transform: scale(1.05);
}

.card-overlay {
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background: linear-gradient(to bottom, rgba(0, 0, 0, 0) 0%,
		rgba(0, 0, 0, 0.1) 50%, rgba(0, 0, 0, 0.7) 100%);
	opacity: 0;
	transition: opacity 0.3s ease;
}

.restaurant-card:hover .card-overlay {
	opacity: 1;
}

.card-badges {
	position: absolute;
	top: 15px;
	left: 15px;
	display: flex;
	flex-direction: column;
	gap: 8px;
}

.badge {
	background: rgba(255, 255, 255, 0.95);
	backdrop-filter: blur(10px);
	padding: 6px 12px;
	border-radius: 20px;
	font-size: 0.75rem;
	font-weight: 600;
	color: #2c2c2c;
	border: 1px solid rgba(255, 255, 255, 0.2);
}

.badge-category {
	background: rgba(212, 175, 55, 0.95);
	color: #2c2c2c;
}

.badge-price {
	background: rgba(255, 255, 255, 0.95);
}

.like-btn {
	position: absolute;
	top: 15px;
	right: 15px;
	background: rgba(255, 255, 255, 0.95);
	backdrop-filter: blur(10px);
	border: none;
	width: 40px;
	height: 40px;
	border-radius: 50%;
	cursor: pointer;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 1.2rem;
	transition: all 0.3s ease;
	border: 1px solid rgba(255, 255, 255, 0.2);
}

.like-btn:hover {
	transform: scale(1.1);
	background: rgba(255, 255, 255, 1);
}

.like-btn.liked {
	background: rgba(255, 69, 58, 0.95);
	color: white;
}

.like-btn.liked:hover {
	background: rgba(255, 69, 58, 1);
}

.card-quick-actions {
	position: absolute;
	bottom: 15px;
	left: 15px;
	right: 15px;
	display: flex;
	gap: 10px;
	opacity: 0;
	transform: translateY(10px);
	transition: all 0.3s ease;
}

.restaurant-card:hover .card-quick-actions {
	opacity: 1;
	transform: translateY(0);
}

.quick-action-btn {
	flex: 1;
	background: rgba(255, 255, 255, 0.95);
	backdrop-filter: blur(10px);
	border: none;
	padding: 10px;
	border-radius: 8px;
	font-size: 0.8rem;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.3s ease;
	color: #2c2c2c;
	border: 1px solid rgba(255, 255, 255, 0.2);
}

.quick-action-btn:hover {
	background: rgba(212, 175, 55, 0.95);
	transform: translateY(-2px);
}

.card-info {
	padding: 20px;
}

.restaurant-name {
	font-family: 'Crimson Text', serif;
	font-size: 1.3rem;
	font-weight: 600;
	color: #2c2c2c;
	margin-bottom: 8px;
	line-height: 1.3;
}

.restaurant-details {
	display: flex;
	align-items: center;
	gap: 15px;
	margin-bottom: 12px;
	font-size: 0.85rem;
	color: #666;
}

.rating {
	display: flex;
	align-items: center;
	gap: 5px;
	color: #d4af37;
	font-weight: 600;
}

.likes-count {
	display: flex;
	align-items: center;
	gap: 5px;
	color: #ff4757;
	font-weight: 600;
}

.restaurant-address {
	font-size: 0.8rem;
	color: #999;
	margin-bottom: 12px;
	line-height: 1.4;
}

.restaurant-description {
	font-size: 0.85rem;
	color: #666;
	line-height: 1.4;
	display: -webkit-box;
	-webkit-line-clamp: 2;
	-webkit-box-orient: vertical;
	overflow: hidden;
}

/* 빈 상태 */
.empty-state {
	text-align: center;
	padding: 100px 20px;
	color: #999;
}

.empty-icon {
	font-size: 4rem;
	margin-bottom: 20px;
	opacity: 0.5;
}

.empty-message {
	font-size: 1.2rem;
	color: #666;
	margin-bottom: 10px;
}

.empty-submessage {
	font-size: 0.9rem;
	color: #999;
}

/* 로딩 애니메이션 */
.loading {
	display: flex;
	justify-content: center;
	align-items: center;
	padding: 50px;
}

.loading-spinner {
	width: 40px;
	height: 40px;
	border: 3px solid #f3f3f3;
	border-top: 3px solid #d4af37;
	border-radius: 50%;
	animation: spin 1s linear infinite;
}
@keyframes spin { 0% {transform: rotate(0deg);}100%{transform:rotate(360deg);}}

/* 페이지네이션 */
.pagination {
	display: flex;
	justify-content: center;
	align-items: center;
	gap: 10px;
	margin-top: 50px;
}

.page-btn {
	padding: 10px 15px;
	border: 2px solid #e0e0e0;
	background: #ffffff;
	color: #666;
	text-decoration: none;
	border-radius: 8px;
	font-weight: 500;
	transition: all 0.3s ease;
	cursor: pointer;
}

.page-btn:hover {
	border-color: #d4af37;
	color: #d4af37;
}

.page-btn.active {
	background: #d4af37;
	border-color: #d4af37;
	color: #2c2c2c;
}

/* 스크롤 상단 이동 버튼 */
.scroll-to-top {
	position: fixed;
	bottom: 30px;
	right: 30px;
	width: 50px;
	height: 50px;
	background: #d4af37;
	border: none;
	border-radius: 50%;
	cursor: pointer;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 1.2rem;
	color: #2c2c2c;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
	transition: all 0.3s ease;
	z-index: 1000;
	opacity: 0;
	visibility: hidden;
	transform: translateY(20px);
}

.scroll-to-top.show {
	opacity: 1;
	visibility: visible;
	transform: translateY(0);
}

.scroll-to-top:hover {
	background: #c9a96e;
	transform: translateY(-3px);
	box-shadow: 0 6px 25px rgba(0, 0, 0, 0.2);
}

.scroll-to-top:active {
	transform: translateY(-1px);
}

/* 반응형 */
@media ( max-width : 768px) {
	.container {
		padding: 20px 15px;
	}
	.restaurant-grid {
		grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
		gap: 20px;
	}
	.filter-controls {
		flex-direction: column;
		gap: 15px;
	}
	.search-container {
		min-width: 100%;
	}
	.toolbar {
		flex-direction: column;
		gap: 15px;
		align-items: stretch;
	}
	.sort-options {
		justify-content: center;
		flex-wrap: wrap;
	}
	.scroll-to-top {
		bottom: 20px;
		right: 20px;
		width: 45px;
		height: 45px;
	}
}

@media ( max-width : 480px) {
	.restaurant-grid {
		grid-template-columns: 1fr;
	}
	.page-title {
		font-size: 2rem;
	}
	.scroll-to-top {
		width: 40px;
		height: 40px;
		font-size: 1rem;
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
			<h1 class="page-title">🍽️ 레스토랑 둘러보기</h1>
			<p class="page-subtitle">맛있는 레스토랑들을 발견해보세요</p>
		</div>

		<!-- 필터 바 -->
		<div class="filter-bar">
			<div class="filter-controls">
				<div class="filter-group">
					<label class="filter-label">카테고리</label> <select
						class="filter-select" id="categoryFilter">
						<option value="">전체</option>
						<c:forEach var="category" items="${categories}">
							<option value="${category.categoryId}"
								${selectedCategory == category.categoryId.toString() ? 'selected' : ''}>
								${category.name}</option>
						</c:forEach>
					</select>
				</div>

				<div class="filter-group">
					<label class="filter-label">가격대</label> <select
						class="filter-select" id="priceFilter">
						<option value="">전체</option>
						<option value="LOW">저렴한 (1만원 이하)</option>
						<option value="MEDIUM">보통 (1-3만원)</option>
						<option value="HIGH">고급 (3만원 이상)</option>
					</select>
				</div>

				<div class="filter-group">
					<label class="filter-label">지역</label> <select
						class="filter-select" id="locationFilter">
						<option value="">전체</option>
						<option value="서울">서울</option>
						<option value="부산">부산</option>
						<option value="대구">대구</option>
						<option value="인천">인천</option>
						<option value="광주">광주</option>
						<option value="대전">대전</option>
					</select>
				</div>

				<div class="search-container">
					<input type="text" class="search-input" id="searchInput"
						placeholder="검색..." value="${searchKeyword}">
					<button class="search-btn" id="searchBtn">🔍</button>
				</div>
			</div>
		</div>

		<!-- 툴바 -->
		<div class="toolbar">
			<div class="sort-options">
				<button class="sort-btn active" data-sort="latest">최신순</button>
				<button class="sort-btn" data-sort="popular">인기순</button>
				<button class="sort-btn" data-sort="rating">평점순</button>
				<button class="sort-btn" data-sort="likes">좋아요순</button>
			</div>
			<div class="result-count">
				총 <strong id="totalCount">${totalCount}</strong>개의 레스토랑
			</div>
		</div>

		<!-- 레스토랑 그리드 -->
		<div class="restaurant-grid" id="restaurantGrid">
			<c:choose>
				<c:when test="${not empty restaurants}">
					<c:forEach var="restaurant" items="${restaurants}">
						<div class="restaurant-card"
							data-restaurant-id="${restaurant.restaurantId}">
							<div class="card-image-container">
								<c:choose>
									<c:when test="${not empty restaurant.imageUrl}">
										<img src="${restaurant.imageUrl}" alt="${restaurant.name}"
											class="card-image">
									</c:when>
									<c:otherwise>
										<div class="card-image"
											style="background: linear-gradient(135deg, #d4af37, #c9a96e); display: flex; align-items: center; justify-content: center; color: white; font-size: 3rem;">
											🍽️</div>
									</c:otherwise>
								</c:choose>

								<div class="card-overlay"></div>

								<div class="card-badges">
									<span class="badge badge-category">${restaurant.cuisineType}</span>
									<c:if test="${not empty restaurant.priceRange}">
										<span class="badge badge-price"> <c:choose>
												<c:when test="${restaurant.priceRange == 'LOW'}">💰</c:when>
												<c:when test="${restaurant.priceRange == 'MEDIUM'}">💰💰</c:when>
												<c:when test="${restaurant.priceRange == 'HIGH'}">💰💰💰</c:when>
												<c:otherwise>💰</c:otherwise>
											</c:choose>
										</span>
									</c:if>
								</div>

								<button class="like-btn"
									data-restaurant-id="${restaurant.restaurantId}">
									<span class="like-icon">🤍</span>
								</button>

								<div class="card-quick-actions">
									<button class="quick-action-btn"
										onclick="viewDetails(${restaurant.restaurantId})">상세보기</button>
									<button class="quick-action-btn"
										onclick="makeReservation(${restaurant.restaurantId})">예약하기</button>
								</div>
							</div>

							<div class="card-info">
								<h3 class="restaurant-name">${restaurant.name}</h3>

								<div class="restaurant-details">
									<div class="rating">
										<span>⭐</span> <span> <fmt:formatNumber
												value="${restaurant.averageRating}" pattern="#.#" /> <c:if
												test="${restaurant.reviewCount > 0}">
            (${restaurant.reviewCount}개)
        </c:if>
										</span>
									</div>
									<div class="likes-count">
										<span>❤️</span> <span>${restaurant.likesCount}</span>
									</div>
								</div>

								<div class="restaurant-address">📍 ${restaurant.address}</div>

								<div class="restaurant-description">
									<c:choose>
										<c:when test="${not empty restaurant.description}">
                                            ${restaurant.description}
                                        </c:when>
										<c:otherwise>
                                            맛있는 음식과 따뜻한 서비스로 여러분을 맞이합니다.
                                        </c:otherwise>
									</c:choose>
								</div>
							</div>
						</div>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<div class="empty-state">
						<div class="empty-icon">🍽️</div>
						<div class="empty-message">레스토랑이 없습니다</div>
						<div class="empty-submessage">다른 검색 조건을 시도해보세요</div>
					</div>
				</c:otherwise>
			</c:choose>
		</div>

		<!-- 페이지네이션 -->
		<div class="pagination" id="pagination">
			<!-- 페이지네이션 버튼들이 여기에 생성됩니다 -->
		</div>
	</div>

	<!-- 스크롤 상단 이동 버튼 -->
	<button class="scroll-to-top" id="scrollToTop" title="맨 위로">
		↑
	</button>

	<!-- 푸터 -->
	<jsp:include page="footer.jsp" />

	<script>
        // 전역 변수
        let currentPage = 1;
        let currentSort = 'latest';
        let isLoading = false;
        const contextPath = '${pageContext.request.contextPath}';
        
        console.log('페이지 로드 완료');
        console.log('Context Path:', contextPath);
        console.log('총 레스토랑:', ${totalCount});
        
        // 평점 포맷팅 함수
        function formatRating(rating) {
            if (!rating || rating === 0) return '0.0';
            return parseFloat(rating).toFixed(1);
        }
        
        // 스크롤 상단 이동 버튼 제어
        function initScrollToTop() {
            const scrollToTopBtn = document.getElementById('scrollToTop');
            
            if (!scrollToTopBtn) return;
            
            // 스크롤 이벤트 리스너
            window.addEventListener('scroll', function() {
                if (window.pageYOffset > 300) {
                    scrollToTopBtn.classList.add('show');
                } else {
                    scrollToTopBtn.classList.remove('show');
                }
            });
            
            // 클릭 이벤트 리스너
            scrollToTopBtn.addEventListener('click', function() {
                window.scrollTo({
                    top: 0,
                    behavior: 'smooth'
                });
            });
        }
        
        // 좋아요 토글
        function toggleLike(restaurantId, button) {
            if (isLoading) return;
            
            isLoading = true;
            const icon = button.querySelector('.like-icon');
            const isLiked = button.classList.contains('liked');
            
            fetch(contextPath + '/board/api/restaurants/' + restaurantId + '/like', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                credentials: 'same-origin'
            })
            .then(response => {
                const contentType = response.headers.get('content-type');
                if (!contentType || !contentType.includes('application/json')) {
                    throw new Error('서버에서 올바른 응답을 받지 못했습니다.');
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    button.classList.toggle('liked');
                    icon.textContent = data.isLiked ? '❤️' : '🤍';
                    
                    const card = button.closest('.restaurant-card');
                    const likesCountElement = card.querySelector('.likes-count span:last-child');
                    if (likesCountElement) {
                        likesCountElement.textContent = data.likesCount || 0;
                    }
                } else {
                    alert(data.message || '오류가 발생했습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('네트워크 오류가 발생했습니다: ' + error.message);
            })
            .finally(() => {
                isLoading = false;
            });
        }
        
        // 상세보기
       function viewDetails(restaurantId) {
    		window.location.href = contextPath + '/board/restaurants/' + restaurantId;
		}
        // 예약하기
        function makeReservation(restaurantId) {
   			window.location.href = contextPath + '/board/restaurants/' + restaurantId + '/reservation';
		}
        
        // 정렬 변경
        function changeSort(sortType) {
            currentSort = sortType;
            
            const sortButtons = document.querySelectorAll('.sort-btn');
            sortButtons.forEach(btn => btn.classList.remove('active'));
            
            const activeButton = document.querySelector('[data-sort="' + sortType + '"]');
            if (activeButton) {
                activeButton.classList.add('active');
            }
            
            loadRestaurants();
        }
        
        // 필터 적용
        function applyFilters() {
            currentPage = 1;
            loadRestaurants();
        }
        
        // 레스토랑 목록 로드
        function loadRestaurants() {
            const grid = document.getElementById('restaurantGrid');
            if (!grid) return;
            
            grid.innerHTML = '<div class="loading"><div class="loading-spinner"></div></div>';
            
            const params = new URLSearchParams({
                page: currentPage,
                sort: currentSort,
                category: document.getElementById('categoryFilter')?.value || '',
                price: document.getElementById('priceFilter')?.value || '',
                location: document.getElementById('locationFilter')?.value || '',
                search: document.getElementById('searchInput')?.value || ''
            });
            
            const apiUrl = contextPath + '/board/api/restaurants?' + params;
            console.log('API 요청 URL:', apiUrl);
            
            fetch(apiUrl)
                .then(response => {
                    console.log('응답 상태:', response.status);
                    const contentType = response.headers.get('content-type');
                    if (!contentType || !contentType.includes('application/json')) {
                        throw new Error('서버에서 올바른 응답을 받지 못했습니다.');
                    }
                    return response.json();
                })
                .then(data => {
                    console.log('받은 데이터:', data);
                    if (data.success) {
                        renderRestaurants(data.restaurants || []);
                        renderPagination(data.pagination || {});
                        const totalCountElement = document.getElementById('totalCount');
                        if (totalCountElement) {
                            totalCountElement.textContent = data.totalCount || 0;
                        }
                    } else {
                        throw new Error(data.message || '데이터를 불러올 수 없습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    grid.innerHTML = '<div class="empty-state"><div class="empty-icon">⚠️</div><div class="empty-message">오류가 발생했습니다</div><div class="empty-submessage">' + error.message + '</div></div>';
                });
        }
        
        // 레스토랑 렌더링
        function renderRestaurants(restaurants) {
            const grid = document.getElementById('restaurantGrid');
            if (!grid) return;
            
            if (restaurants.length === 0) {
                grid.innerHTML = '<div class="empty-state"><div class="empty-icon">🍽️</div><div class="empty-message">레스토랑이 없습니다</div><div class="empty-submessage">다른 검색 조건을 시도해보세요</div></div>';
                return;
            }
            
            grid.innerHTML = restaurants.map(restaurant => 
                '<div class="restaurant-card" data-restaurant-id="' + restaurant.restaurantId + '">' +
                    '<div class="card-image-container">' +
                        (restaurant.imageUrl ? 
                            '<img src="' + restaurant.imageUrl + '" alt="' + restaurant.name + '" class="card-image">' :
                            '<div class="card-image" style="background: linear-gradient(135deg, #d4af37, #c9a96e); display: flex; align-items: center; justify-content: center; color: white; font-size: 3rem;">🍽️</div>'
                        ) +
                        '<div class="card-overlay"></div>' +
                        '<div class="card-badges">' +
                            '<span class="badge badge-category">' + (restaurant.cuisineType || '') + '</span>' +
                            '<span class="badge badge-price">' + 
                                (restaurant.priceRange === 'LOW' ? '💰' : 
                                 restaurant.priceRange === 'MEDIUM' ? '💰💰' : 
                                 restaurant.priceRange === 'HIGH' ? '💰💰💰' : '💰') +
                            '</span>' +
                        '</div>' +
                        '<button class="like-btn ' + (restaurant.likedByCurrentUser ? 'liked' : '') + '" data-restaurant-id="' + restaurant.restaurantId + '">' +
                            '<span class="like-icon">' + (restaurant.likedByCurrentUser ? '❤️' : '🤍') + '</span>' +
                        '</button>' +
                        '<div class="card-quick-actions">' +
                            '<button class="quick-action-btn" onclick="viewDetails(' + restaurant.restaurantId + ')">상세보기</button>' +
                            '<button class="quick-action-btn" onclick="makeReservation(' + restaurant.restaurantId + ')">예약하기</button>' +
                        '</div>' +
                    '</div>' +
                    '<div class="card-info">' +
                        '<h3 class="restaurant-name">' + restaurant.name + '</h3>' +
                        '<div class="restaurant-details">' +
                            '<div class="rating"><span>⭐</span><span>' + formatRating(restaurant.averageRating) + 
                            (restaurant.reviewCount > 0 ? ' (' + restaurant.reviewCount + '개)' : '') + '</span></div>' +
                            '<div class="likes-count"><span>❤️</span><span>' + (restaurant.likesCount || 0) + '</span></div>' +
                        '</div>' +
                        '<div class="restaurant-address">📍 ' + restaurant.address + '</div>' +
                        '<div class="restaurant-description">' + 
                            (restaurant.description || '맛있는 음식과 따뜻한 서비스로 여러분을 맞이합니다.') +
                        '</div>' +
                    '</div>' +
                '</div>'
            ).join('');
        }
        
        // 페이지네이션 렌더링
        function renderPagination(pagination) {
            const container = document.getElementById('pagination');
            if (!container || !pagination) return;
            
            const { currentPage, totalPages, hasPrev, hasNext } = pagination;
            
            if (totalPages <= 1) {
                container.innerHTML = '';
                return;
            }
            
            let paginationHTML = '<div class="pagination">';
            
            if (hasPrev) {
                paginationHTML += '<a href="javascript:void(0)" class="page-btn" onclick="goToPage(' + (currentPage - 1) + ')">← 이전</a>';
            }
            
            paginationHTML += '<div class="page-numbers">';
            for (let i = 1; i <= totalPages; i++) {
                const activeClass = i === currentPage ? 'active' : '';
                paginationHTML += '<a href="javascript:void(0)" class="page-number ' + activeClass + '" onclick="goToPage(' + i + ')">' + i + '</a>';
            }
            paginationHTML += '</div>';
            
            if (hasNext) {
                paginationHTML += '<a href="javascript:void(0)" class="page-btn" onclick="goToPage(' + (currentPage + 1) + ')">다음 →</a>';
            }
            
            paginationHTML += '</div>';
            container.innerHTML = paginationHTML;
        }
        
        // 페이지 이동
        function goToPage(page) {
            currentPage = page;
            loadRestaurants();
        }
        
        // 이벤트 리스너
        document.addEventListener('DOMContentLoaded', function() {
            // 스크롤 상단 이동 버튼 초기화
            initScrollToTop();
            
            // 초기 데이터 로드
            loadRestaurants();
            
            // 좋아요 버튼 이벤트
            document.addEventListener('click', function(e) {
                if (e.target.closest('.like-btn')) {
                    const button = e.target.closest('.like-btn');
                    const restaurantId = button.dataset.restaurantId;
                    toggleLike(restaurantId, button);
                }
            });
            
            // 정렬 버튼 이벤트
            const sortButtons = document.querySelectorAll('.sort-btn');
            sortButtons.forEach(btn => {
                btn.addEventListener('click', () => {
                    const sortType = btn.dataset.sort;
                    if (sortType) {
                        changeSort(sortType);
                    }
                });
            });
            
            // 필터 변경 이벤트
            const filterSelects = document.querySelectorAll('.filter-select');
            filterSelects.forEach(select => {
                select.addEventListener('change', applyFilters);
            });
            
            // 검색 이벤트
            const searchBtn = document.getElementById('searchBtn');
            const searchInput = document.getElementById('searchInput');
            
            if (searchBtn) {
                searchBtn.addEventListener('click', applyFilters);
            }
            
            if (searchInput) {
                searchInput.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        applyFilters();
                    }
                });
            }
        });
    </script>
</body>
</html>