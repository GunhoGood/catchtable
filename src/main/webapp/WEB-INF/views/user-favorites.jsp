<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<link rel="icon" type="image/png" sizes="32x32"
	href="${pageContext.request.contextPath}/resources/images/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16"
	href="${pageContext.request.contextPath}/resources/images/favicon-16x16.png">
<meta charset="UTF-8">
<title>My Favorites - Catch Table</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
@import
	url('https://fonts.googleapis.com/css2?family=Crimson+Text:ital,wght@0,400;0,600;1,400&family=Source+Sans+Pro:wght@300;400;600&display=swap')
	;

* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: 'Source Sans Pro', sans-serif;
	color: #2c2c2c;
	line-height: 1.6;
	background: #f7f5f3;
	padding-top: 80px;
	min-height: 100vh;
	padding-bottom: 100px;
}

/* === 레이아웃 === */
.container {
	max-width: 1400px;
	margin: 40px auto;
	padding: 0 20px;
	display: grid;
	grid-template-columns: 1fr;
	gap: 30px;
}

.card {
	background: #ffffff;
	border-radius: 8px;
	padding: 30px;
	box-shadow: 0 15px 35px rgba(0, 0, 0, 0.08);
	border: 1px solid rgba(0, 0, 0, 0.02);
}

/* === 헤더 === */
.header {
	text-align: center;
	background: linear-gradient(135deg, #d4af37 0%, #c9a96e 100%);
	color: #ffffff;
	padding: 40px 30px;
	position: relative;
	overflow: hidden;
}

.header::before {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background:
		url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="20" cy="20" r="2" fill="rgba(255,255,255,0.1)"/><circle cx="80" cy="40" r="1.5" fill="rgba(255,255,255,0.08)"/></svg>');
	opacity: 0.5;
}

.title {
	font-family: 'Crimson Text', serif;
	font-size: 2.5rem;
	font-weight: 600;
	margin-bottom: 10px;
	position: relative;
	z-index: 1;
}

.subtitle {
	font-size: 1.1rem;
	opacity: 0.9;
	font-weight: 300;
	position: relative;
	z-index: 1;
}

/* === 네비게이션 === */
.nav-tabs {
	display: flex;
	background: #ffffff;
	border-radius: 8px;
	overflow: hidden;
	box-shadow: 0 8px 20px rgba(0, 0, 0, 0.04);
	margin: 20px 0;
	border: 1px solid #f5f3f0;
}

.nav-tab {
	flex: 1;
	padding: 18px 20px;
	text-align: center;
	text-decoration: none;
	color: #666;
	font-weight: 500;
	border-right: 1px solid #f5f3f0;
	transition: all 0.3s ease;
}

.nav-tab:last-child {
	border-right: none;
}

.nav-tab.active {
	background: linear-gradient(135deg, #d4af37 0%, #c9a96e 100%);
	color: #ffffff;
	font-weight: 600;
}

.nav-tab:hover:not(.active) {
	background: #f8f6f3;
	color: #2c2c2c;
}

/* === 통계 === */
.stats-summary {
	text-align: center;
	padding: 30px 0;
	background: linear-gradient(135deg, #f8f6f3 0%, #ffffff 100%);
	border-radius: 10px;
	margin-bottom: 10px;
}

.stat-row {
	display: flex;
	justify-content: center;
	align-items: center;
	gap: 30px;
	margin: 15px 0;
}

.stat-item {
	display: flex;
	align-items: center;
	gap: 10px;
	font-size: 1.2rem;
	color: #666;
}

.stat-value {
	font-size: 1.8rem;
	font-weight: 700;
	color: #d4af37;
	font-family: 'Crimson Text', serif;
}

.summary-note {
	color: #888;
	font-size: 1rem;
	margin-top: 20px;
	font-style: italic;
}

/* === 레스토랑 그리드 === */
.restaurants-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
	gap: 25px;
	margin-top: 20px;
}

.restaurant-card {
	background: #ffffff;
	border-radius: 12px;
	overflow: hidden;
	box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
	border: 1px solid rgba(0, 0, 0, 0.02);
	transition: transform 0.3s ease;
	position: relative;
	cursor: pointer;
}

.restaurant-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 15px 35px rgba(0, 0, 0, 0.12);
}

.restaurant-image {
	width: 100%;
	height: 200px;
	object-fit: cover;
	background: linear-gradient(135deg, #d4af37, #c9a96e);
	display: flex;
	align-items: center;
	justify-content: center;
	color: white;
	font-size: 3rem;
}

.restaurant-info {
	padding: 25px;
}

.restaurant-name {
	font-family: 'Crimson Text', serif;
	font-size: 1.5rem;
	font-weight: 600;
	color: #2c2c2c;
	margin-bottom: 10px;
}

.restaurant-category {
	color: #888;
	font-size: 0.9rem;
	margin-bottom: 15px;
	font-weight: 500;
}

.restaurant-stats {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 15px;
	margin: 20px 0;
	padding: 15px 0;
	border-top: 1px solid #f5f3f0;
	border-bottom: 1px solid #f5f3f0;
}

.stat-item-card {
	text-align: center;
}

.stat-number {
	font-family: 'Crimson Text', serif;
	font-size: 1.4rem;
	font-weight: 700;
	color: #d4af37;
	display: block;
}

.stat-label {
	font-size: 0.8rem;
	color: #888;
	font-weight: 500;
	text-transform: uppercase;
	letter-spacing: 0.5px;
}

.visit-badge {
	position: absolute;
	top: 15px;
	right: 15px;
	background: rgba(212, 175, 55, 0.95);
	color: #2c2c2c;
	padding: 6px 12px;
	border-radius: 20px;
	font-size: 0.8rem;
	font-weight: 600;
	backdrop-filter: blur(10px);
	border: 1px solid rgba(255, 255, 255, 0.2);
}

.favorite-actions {
	display: flex;
	gap: 10px;
	margin-top: 20px;
}

.btn {
	padding: 10px 16px;
	border: none;
	border-radius: 6px;
	font-family: 'Source Sans Pro', sans-serif;
	font-size: 0.85rem;
	font-weight: 500;
	cursor: pointer;
	transition: all 0.3s ease;
	text-decoration: none;
	display: inline-flex;
	align-items: center;
	gap: 6px;
	text-transform: uppercase;
	letter-spacing: 0.5px;
}

.btn-primary {
	background: transparent;
	color: #d4af37;
	border: 1px solid #d4af37;
	flex: 1;
	justify-content: center;
}

.btn-primary:hover {
	background: #d4af37;
	color: #ffffff;
	transform: translateY(-2px);
}

/* === 빈 상태 === */
.empty-state {
	text-align: center;
	padding: 60px 20px;
	color: #888;
}

.empty-state .icon {
	font-size: 4rem;
	margin-bottom: 20px;
	opacity: 0.5;
}

.empty-state h3 {
	font-family: 'Crimson Text', serif;
	font-size: 1.5rem;
	margin-bottom: 10px;
	color: #666;
}

/* === 반응형 === */
@media ( max-width : 768px) {
	.container {
		padding: 0 15px;
	}
	.nav-tabs {
		flex-direction: column;
	}
	.nav-tab {
		border-right: none;
		border-bottom: 1px solid #f5f3f0;
	}
	.nav-tab:last-child {
		border-bottom: none;
	}
	.stat-row {
		flex-direction: column;
		gap: 15px;
	}
	.restaurants-grid {
		grid-template-columns: 1fr;
		gap: 20px;
	}
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/navi.jsp"%>

	<div class="container">
		<!-- 헤더 -->
		<div class="header card">
			<h1 class="title">My Favorites</h1>
			<p class="subtitle">자주 방문하는 나만의 단골 레스토랑들</p>
		</div>

		<!-- 네비게이션 -->
		<div class="nav-tabs">
			<a href="/catchtable/user/profile" class="nav-tab">My Profile</a>
			<a href="/catchtable/user/reservations" class="nav-tab">My Reservations</a> 
			<a href="/catchtable/user/reviews" class="nav-tab">My Reviews</a>
			<a href="/catchtable/user/coupons" class="nav-tab">My Coupons</a>
			<a href="/catchtable/user/favorites" class="nav-tab active">My Favorites</a>
		</div>

		<!-- 통계 요약 -->
		<div class="card">
			<div class="stats-summary">
				<div class="stat-row">
					<div class="stat-item">
						<span>단골 레스토랑:</span> <span class="stat-value">${favoriteStats.totalFavorites}곳</span>
					</div>
					<div class="stat-item">
						<span>총 방문 횟수:</span> <span class="stat-value">${favoriteStats.totalVisits}회</span>
					</div>
				</div>
				<p class="summary-note">3회 이상 방문한 레스토랑만 표시됩니다</p>
			</div>
		</div>

		<!-- 단골 레스토랑 목록 -->
		<div class="card">
			<c:choose>
				<c:when test="${not empty favoriteRestaurants}">
					<div class="restaurants-grid">
						<c:forEach var="restaurant" items="${favoriteRestaurants}">
							<div class="restaurant-card" onclick="viewRestaurant(${restaurant.restaurantId})">
								<!-- 방문 횟수 뱃지 -->
								<span class="visit-badge">
									<c:choose>
										<c:when test="${restaurant.visitCount != null}">
											${restaurant.visitCount}회 방문
										</c:when>
										<c:otherwise>
											0회 방문
										</c:otherwise>
									</c:choose>
								</span>

								<!-- 레스토랑 이미지 -->
								<div class="restaurant-image">
									<c:choose>
										<c:when test="${not empty restaurant.imageUrl}">
											<img src="${restaurant.imageUrl}" alt="${restaurant.name}" class="restaurant-image">
										</c:when>
										<c:otherwise>
											🍽️
										</c:otherwise>
									</c:choose>
								</div>

								<!-- 레스토랑 정보 -->
								<div class="restaurant-info">
									<h3 class="restaurant-name">${restaurant.name}</h3>
									<p class="restaurant-category">${restaurant.cuisineType} • ${restaurant.address}</p>

									<!-- 레스토랑 통계 -->
									<div class="restaurant-stats">
										<div class="stat-item-card">
											<span class="stat-number">
												<c:choose>
													<c:when test="${restaurant.averageRating != null}">
														<fmt:formatNumber value="${restaurant.averageRating}" pattern="0.0" />
													</c:when>
													<c:otherwise>0.0</c:otherwise>
												</c:choose>
											</span>
											<span class="stat-label">평점</span>
										</div>
										<div class="stat-item-card">
											<span class="stat-number">
												<c:choose>
													<c:when test="${restaurant.visitCount != null}">
														${restaurant.visitCount}
													</c:when>
													<c:otherwise>0</c:otherwise>
												</c:choose>
											</span>
											<span class="stat-label">방문수</span>
										</div>
										<div class="stat-item-card">
											<span class="stat-number">
												<c:choose>
													<c:when test="${restaurant.reviewCount != null}">
														${restaurant.reviewCount}
													</c:when>
													<c:otherwise>0</c:otherwise>
												</c:choose>
											</span>
											<span class="stat-label">리뷰수</span>
										</div>
									</div>

									<!-- 액션 버튼 -->
									<div class="favorite-actions">
										<a href="${pageContext.request.contextPath}/board/restaurants/${restaurant.restaurantId}" 
										   class="btn btn-primary">상세보기</a>
										<a href="${pageContext.request.contextPath}/board/restaurants/${restaurant.restaurantId}/reservation" 
										   class="btn btn-primary">예약하기</a>
									</div>
								</div>
							</div>
						</c:forEach>
					</div>
				</c:when>
				<c:otherwise>
					<div class="empty-state">
						<div class="icon">🍽️</div>
						<h3>아직 단골 레스토랑이 없습니다</h3>
						<p>레스토랑을 3회 이상 방문하시면 단골 레스토랑으로 등록됩니다!</p>
						<br>
						<a href="${pageContext.request.contextPath}/board/restaurants" class="btn btn-primary">
							레스토랑 둘러보기
						</a>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

	<script>
		function viewRestaurant(restaurantId) {
			window.location.href = '${pageContext.request.contextPath}/board/restaurants/' + restaurantId;
		}
	</script>
</body>
</html>