<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<link rel="icon" type="image/png" sizes="32x32"
	href="${pageContext.request.contextPath}/resources/images/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16"
	href="${pageContext.request.contextPath}/resources/images/favicon-16x16.png">
<meta charset="UTF-8">
<title>Catch Table - 당신의 특별한 순간을 위한 완벽한 장소</title>
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
	font-family: 'Source Sans Pro', -apple-system, sans-serif;
	color: #2c2c2c;
	line-height: 1.6;
	background: #f7f5f3;
	padding-top: 80px; /* 네비게이션 높이만큼 */
}

/* 히어로 섹션 */
.hero {
	background: linear-gradient(135deg, rgba(247, 245, 243, 0.9) 0%,
		rgba(250, 248, 245, 0.9) 100%),
		url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 800"><defs><pattern id="grain" patternUnits="userSpaceOnUse" width="100" height="100"><rect width="100" height="100" fill="%23f7f5f3"/><circle cx="20" cy="20" r="1" fill="%23e8e6e3" opacity="0.3"/><circle cx="80" cy="50" r="0.8" fill="%23d4af37" opacity="0.2"/><circle cx="40" cy="80" r="1.2" fill="%23c9a96e" opacity="0.2"/></pattern></defs><rect width="100%" height="100%" fill="url(%23grain)"/></svg>');
	background-size: cover;
	background-position: center;
	min-height: 60vh;
	display: flex;
	align-items: center;
	position: relative;
	overflow: hidden;
}

.hero::before {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background: radial-gradient(circle at 30% 60%, rgba(212, 175, 55, 0.1)
		0%, transparent 50%);
}

.hero-container {
	max-width: 1200px;
	margin: 0 auto;
	padding: 0 40px;
	text-align: center;
	position: relative;
	z-index: 1;
}

.hero-title {
	font-family: 'Crimson Text', serif;
	font-size: 3.2rem;
	font-weight: 600;
	color: #2c2c2c;
	margin-bottom: 20px;
	letter-spacing: 0.5px;
	animation: fadeInUp 1s ease-out;
}

.hero-subtitle {
	font-size: 1.1rem;
	color: #666;
	margin-bottom: 40px;
	font-weight: 300;
	letter-spacing: 0.5px;
	animation: fadeInUp 1s ease-out 0.2s both;
}

.search-container {
	max-width: 600px;
	margin: 0 auto;
	position: relative;
	animation: fadeInUp 1s ease-out 0.4s both;
}

.search-form {
	display: flex;
	background: rgba(255, 255, 255, 0.9);
	border-radius: 2px;
	box-shadow: 0 20px 60px rgba(0, 0, 0, 0.08);
	border: 1px solid rgba(212, 175, 55, 0.2);
	overflow: hidden;
}

.search-input {
	flex: 1;
	padding: 20px 25px;
	border: none;
	font-size: 1rem;
	font-family: 'Source Sans Pro', sans-serif;
	background: transparent;
	color: #333;
}

.search-input::placeholder {
	color: #aaa;
	font-style: italic;
}

.search-input:focus {
	outline: none;
}

.search-btn {
	background: #d4af37;
	color: #ffffff;
	border: none;
	padding: 20px 35px;
	font-family: 'Source Sans Pro', sans-serif;
	font-size: 0.9rem;
	font-weight: 600;
	text-transform: uppercase;
	letter-spacing: 1px;
	cursor: pointer;
	transition: all 0.3s ease;
}

.search-btn:hover {
	background: #c9a96e;
	transform: translateX(-2px);
}

/* 섹션 공통 스타일 */
.section {
	padding: 80px 0;
	position: relative;
}

.container {
	max-width: 1200px;
	margin: 0 auto;
	padding: 0 40px;
}

.section-header {
	text-align: center;
	margin-bottom: 60px;
}

.section-title {
	font-family: 'Crimson Text', serif;
	font-size: 2.2rem;
	font-weight: 600;
	color: #2c2c2c;
	margin-bottom: 15px;
	letter-spacing: 0.5px;
}

.section-subtitle {
	font-size: 1rem;
	color: #666;
	font-weight: 300;
}

/* 카테고리 섹션 */
.categories-section {
	background: rgba(250, 248, 245, 0.5);
}

.categories-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
	gap: 20px;
	max-width: 900px;
	margin: 0 auto;
}

.category-item {
	background: #ffffff;
	padding: 25px 15px;
	border-radius: 2px;
	text-align: center;
	box-shadow: 0 8px 20px rgba(0, 0, 0, 0.04);
	border: 1px solid rgba(0, 0, 0, 0.02);
	transition: all 0.3s ease;
	cursor: pointer;
}

.category-item:hover {
	transform: translateY(-3px);
	box-shadow: 0 15px 35px rgba(0, 0, 0, 0.08);
	border-color: rgba(212, 175, 55, 0.3);
}

.category-icon {
	font-size: 2rem;
	display: block;
	margin-bottom: 10px;
}

.category-name {
	font-size: 0.85rem;
	color: #555;
	font-weight: 500;
	font-family: 'Source Sans Pro', sans-serif;
}

/* 인기 식당 + 리뷰 슬라이드 섹션 */
.restaurant-review-slider {
	position: relative;
	overflow: hidden;
}

.slider-container {
	display: flex;
	transition: transform 0.8s ease-in-out;
}

.slide {
	min-width: 100%;
	display: flex;
	gap: 40px;
	align-items: stretch;
}

.restaurant-side {
	flex: 1;
	background: #ffffff;
	border-radius: 2px;
	box-shadow: 0 15px 40px rgba(0, 0, 0, 0.06);
	border: 1px solid rgba(0, 0, 0, 0.02);
	overflow: hidden;
	position: relative;
}

.restaurant-side::before {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	height: 3px;
	background: linear-gradient(90deg, #d4af37, #c9a96e);
}

.restaurant-info {
	padding: 35px;
}

.restaurant-name {
	font-family: 'Crimson Text', serif;
	font-size: 1.6rem;
	font-weight: 600;
	color: #2c2c2c;
	margin-bottom: 12px;
}

.restaurant-description {
	color: #666;
	margin-bottom: 20px;
	line-height: 1.6;
	font-size: 1rem;
}

.restaurant-details {
	font-size: 0.9rem;
	color: #888;
	margin-bottom: 10px;
}

.restaurant-stats {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-top: 25px;
	padding-top: 25px;
	border-top: 1px solid #f5f3f0;
	font-size: 0.85rem;
	color: #666;
}

.stat-item {
	display: flex;
	align-items: center;
	gap: 5px;
}

.review-side {
	flex: 1;
	background: #ffffff;
	border-radius: 2px;
	box-shadow: 0 15px 40px rgba(0, 0, 0, 0.06);
	border: 1px solid rgba(0, 0, 0, 0.02);
	padding: 35px;
	position: relative;
}

.review-side::before {
	content: '"';
	position: absolute;
	left: 25px;
	top: 20px;
	font-family: 'Crimson Text', serif;
	font-size: 3rem;
	color: #f0f0f0;
	line-height: 1;
}

.review-header {
	margin-bottom: 20px;
}

.review-title {
	font-family: 'Crimson Text', serif;
	font-size: 1.3rem;
	color: #2c2c2c;
	margin-bottom: 10px;
}

.review-count {
	font-size: 0.85rem;
	color: #888;
}

.review-list {
	max-height: 300px;
	overflow-y: auto;
}

.review-item {
	margin-bottom: 25px;
	padding-bottom: 20px;
	border-bottom: 1px solid #f8f6f3;
}

.review-item:last-child {
	border-bottom: none;
	margin-bottom: 0;
}

.review-rating {
	font-size: 1rem;
	margin-bottom: 10px;
	color: #d4af37;
}

.review-content {
	font-family: 'Crimson Text', serif;
	font-size: 0.95rem;
	line-height: 1.6;
	color: #555;
	font-style: italic;
	margin-bottom: 8px;
}

.review-author {
	font-size: 0.8rem;
	color: #aaa;
	font-weight: 300;
}

.no-reviews {
	text-align: center;
	color: #888;
	font-style: italic;
	padding: 40px 0;
}

/* 슬라이더 컨트롤 */
.slider-controls {
	display: flex;
	justify-content: center;
	gap: 15px;
	margin-top: 40px;
}

.control-btn {
	background: rgba(212, 175, 55, 0.1);
	border: 1px solid rgba(212, 175, 55, 0.3);
	color: #d4af37;
	padding: 12px 20px;
	border-radius: 2px;
	cursor: pointer;
	font-family: 'Source Sans Pro', sans-serif;
	font-size: 0.85rem;
	font-weight: 500;
	text-transform: uppercase;
	letter-spacing: 0.5px;
	transition: all 0.3s ease;
}

.control-btn:hover {
	background: #d4af37;
	color: #ffffff;
	transform: translateY(-1px);
}

.control-btn.active {
	background: #d4af37;
	color: #ffffff;
}

/* 슬라이더 인디케이터 */
.slider-indicators {
	display: flex;
	justify-content: center;
	gap: 10px;
	margin-top: 20px;
	padding: 25px 0;
}

.indicator {
	width: 8px;
	height: 8px;
	border-radius: 50%;
	background: rgba(212, 175, 55, 0.3);
	cursor: pointer;
	transition: all 0.3s ease;
}

.indicator.active {
	background: #d4af37;
	transform: scale(1.2);
}

/* CTA 섹션 */
.cta-section {
	background: linear-gradient(135deg, #2c2c2c 0%, #1a1a1a 100%);
	color: #ffffff;
	text-align: center;
}

.cta-title {
	font-family: 'Crimson Text', serif;
	font-size: 2rem;
	font-weight: 600;
	margin-bottom: 20px;
	color: #d4af37;
}

.cta-description {
	font-size: 1rem;
	margin-bottom: 40px;
	color: #b8b6b3;
}

.cta-buttons {
	display: flex;
	gap: 20px;
	justify-content: center;
	flex-wrap: wrap;
}

.cta-btn {
	display: inline-block;
	padding: 16px 30px;
	text-decoration: none;
	font-family: 'Source Sans Pro', sans-serif;
	font-size: 0.9rem;
	font-weight: 600;
	text-transform: uppercase;
	letter-spacing: 1px;
	border-radius: 1px;
	transition: all 0.3s ease;
	border: 1px solid;
}

.cta-btn.primary {
	background: #d4af37;
	color: #2c2c2c;
	border-color: #d4af37;
}

.cta-btn.primary:hover {
	background: transparent;
	color: #d4af37;
	transform: translateY(-2px);
}

.cta-btn.secondary {
	background: transparent;
	color: #ffffff;
	border-color: #ffffff;
}

.cta-btn.secondary:hover {
	background: #ffffff;
	color: #2c2c2c;
	transform: translateY(-2px);
}

/* 반응형 */
@media ( max-width : 768px) {
	body {
		padding-top: 70px;
	}
	.hero-title {
		font-size: 2.2rem;
	}
	.hero-subtitle {
		font-size: 0.95rem;
	}
	.search-form {
		flex-direction: column;
	}
	.container {
		padding: 0 20px;
	}
	.section {
		padding: 50px 0;
	}
	.section-header {
		margin-bottom: 40px;
	}
	.categories-grid {
		grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
		gap: 15px;
	}
	.slide {
		flex-direction: column;
		gap: 20px;
	}
	.cta-buttons {
		flex-direction: column;
		align-items: center;
	}
}

/* 애니메이션 */
@
keyframes fadeInUp {from { opacity:0;
	transform: translateY(30px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
.animate-on-scroll {
	opacity: 0;
	transform: translateY(30px);
	transition: all 0.8s ease-out;
}

.animate-on-scroll.animate {
	opacity: 1;
	transform: translateY(0);
}
</style>
</head>
<body>
	<!-- 네비게이션 -->
	<%@ include file="/WEB-INF/views/navi.jsp"%>

	<!-- 히어로 섹션 -->
	<section class="hero">
		<div class="hero-container">
			<h1 class="hero-title">
				당신의 특별한 순간을 위한<br>완벽한 장소
			</h1>
			<p class="hero-subtitle">최고의 맛집을 발견하고 간편하게 예약하세요</p>

			<div class="search-container">
				<form class="search-form" action="/catchtable/board/restaurants"
					method="get">
					<input type="text" name="search" class="search-input"
						placeholder="지역, 음식 종류, 식당명을 검색해보세요...">
					<button type="submit" class="search-btn">Search</button>
				</form>
			</div>
		</div>
	</section>

	<!-- 카테고리 섹션 -->
	<section class="section categories-section">
		<div class="container">
			<div class="section-header animate-on-scroll">
				<h2 class="section-title">🏷️ 카테고리</h2>
				<p class="section-subtitle">다양한 카테고리로 원하는 맛집을 쉽게 찾아보세요</p>
			</div>

			<div class="categories-grid">
				<c:choose>
					<c:when test="${not empty categories}">
						<c:forEach var="category" items="${categories}">
							
							<a
								href="${pageContext.request.contextPath}/board/restaurants?category=${category.categoryId}"
								class="category-item animate-on-scroll"
								style="text-decoration: none; color: inherit;"> <span
								class="category-icon">${category.iconUrl}</span> <span
								class="category-name">${category.name}</span>
							</a>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<div class="category-item animate-on-scroll">
							<span class="category-icon">🍽️</span> <span
								class="category-name">카테고리 준비중</span>
						</div>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</section>

	<!-- 인기 식당 + 리뷰 슬라이드 섹션 -->
	<section class="section">
		<div class="container">
			<div class="section-header animate-on-scroll">
				<h2 class="section-title">인기 식당</h2>
				<p class="section-subtitle">많은 사람들이 선택한 인기 맛집과 실제 후기를 확인해보세요</p>
			</div>

			<div class="restaurant-review-slider">
				<div class="slider-container" id="sliderContainer">
					<c:choose>
						<c:when test="${not empty popularRestaurants}">
							<c:forEach var="restaurant" items="${popularRestaurants}"
								varStatus="status">
								<div class="slide">
									<!-- 식당 정보 -->
									<div class="restaurant-side">
										<div class="restaurant-info">
											<h3 class="restaurant-name">${restaurant.name}</h3>
											<p class="restaurant-description">${restaurant.description}</p>
											<div class="restaurant-details">
												<strong>주소:</strong> ${restaurant.address}
											</div>
											<div class="restaurant-details">
												<strong>영업시간:</strong> ${restaurant.operatingHours}
											</div>
											<div class="restaurant-details">
												<strong>1인 기준가격:</strong>
												<c:choose>
													<c:when test="${restaurant.priceRange == 'LOW'}">1-2만원</c:when>
													<c:when test="${restaurant.priceRange == 'MEDIUM'}">2-5만원</c:when>
													<c:when test="${restaurant.priceRange == 'HIGH'}">5만원 이상</c:when>
													<c:otherwise>문의</c:otherwise>
												</c:choose>
											</div>
											<div class="restaurant-stats">
												<span class="stat-item">👍 좋아요
													${restaurant.likesCount}</span> <span class="stat-item">👀
													조회수 ${restaurant.viewCount}</span> <span class="stat-item">📅
													예약 ${restaurant.reservationCount}</span>
											</div>
										</div>
									</div>

									<!-- 리뷰 정보 -->
									<div class="review-side">
										<div class="review-header">
											<h4 class="review-title">고객 후기</h4>
											<p class="review-count">실제 방문 고객들의 생생한 후기</p>
										</div>

										<div class="review-list">
											<c:forEach var="review" items="${restaurant.reviews}" end="2">
												<div class="review-item">
													<div class="review-rating">${review.ratingStars}
														(${review.rating}/5)</div>
													<p class="review-content">${review.content}</p>
													<p class="review-author">작성자: ${review.email}</p>
												</div>
											</c:forEach>
										</div>
									</div>
								</div>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<div class="slide">
								<div class="restaurant-side">
									<div class="restaurant-info">
										<h3 class="restaurant-name">준비 중입니다</h3>
										<p class="restaurant-description">곧 멋진 식당들을 소개해드릴게요!</p>
									</div>
								</div>
								<div class="review-side">
									<div class="no-reviews">리뷰 준비 중입니다.</div>
								</div>
							</div>
						</c:otherwise>
					</c:choose>
				</div>

				<!-- 슬라이더 컨트롤 -->
				<div class="slider-controls">
					<button class="control-btn" id="pauseBtn">Pause</button>
					<button class="control-btn" id="playBtn">Play</button>
				</div>

				<!-- 슬라이더 인디케이터 -->
				<div class="slider-indicators" id="indicators">
					<c:forEach var="restaurant" items="${popularRestaurants}"
						varStatus="status">
						<div class="indicator ${status.index == 0 ? 'active' : ''}"></div>
					</c:forEach>
				</div>
			</div>
		</div>
	</section>

	<!-- CTA 섹션 -->
	<section class="section cta-section">
		<div class="container">
			<h2 class="cta-title">지금 시작해보세요</h2>
			<p class="cta-description">특별한 순간을 더욱 특별하게 만들어줄 완벽한 장소를 찾아보세요</p>
			<div class="cta-buttons">
				<a href="/catchtable/board/restaurants" class="cta-btn primary">식당
					둘러보기</a> <a href="/catchtable/auth/terms" class="cta-btn secondary">회원가입</a>
			</div>
		</div>
	</section>

	<!-- 푸터 -->
	<%@ include file="/WEB-INF/views/footer.jsp"%>

	<script>
		// 전역 변수
		var currentSlideIndex = 0;
		var autoSlideTimer = null;
		var isAutoPlaying = false;
		var totalSlidesCount = 0;

		// 슬라이드 이동 함수
		function moveSlide(index) {
			currentSlideIndex = index;
			var container = document.getElementById('sliderContainer');
			if (container) {
				var translateValue = 'translateX(' + (-index * 100) + '%)';
				container.style.transform = translateValue;
			}

			// 인디케이터 업데이트
			var indicators = document.querySelectorAll('.indicator');
			for (var i = 0; i < indicators.length; i++) {
				if (i === index) {
					indicators[i].classList.add('active');
				} else {
					indicators[i].classList.remove('active');
				}
			}
		}

		// 자동 슬라이드 시작
		function startAutoSlide() {
			if (totalSlidesCount <= 1)
				return;

			if (autoSlideTimer) {
				clearInterval(autoSlideTimer);
			}

			autoSlideTimer = setInterval(function() {
				currentSlideIndex = (currentSlideIndex + 1) % totalSlidesCount;
				moveSlide(currentSlideIndex);
			}, 4000);

			isAutoPlaying = true;
			updateButtonStates();
		}

		// 자동 슬라이드 정지
		function stopAutoSlide() {
			if (autoSlideTimer) {
				clearInterval(autoSlideTimer);
				autoSlideTimer = null;
			}
			isAutoPlaying = false;
			updateButtonStates();
		}

		// 버튼 상태 업데이트
		function updateButtonStates() {
			var pauseBtn = document.getElementById('pauseBtn');
			var playBtn = document.getElementById('playBtn');

			if (pauseBtn && playBtn) {
				if (isAutoPlaying) {
					pauseBtn.classList.add('active');
					playBtn.classList.remove('active');
				} else {
					pauseBtn.classList.remove('active');
					playBtn.classList.add('active');
				}
			}
		}

		// JSP onclick용 전역 함수
		function goToSlide(index) {
			moveSlide(index);
			if (isAutoPlaying) {
				stopAutoSlide();
				startAutoSlide();
			}
		}

		// 초기화
		document.addEventListener('DOMContentLoaded', function() {
			var slides = document.querySelectorAll('.slide');
			totalSlidesCount = slides.length;

			console.log('Total slides:', totalSlidesCount);

			// 버튼 이벤트
			var pauseBtn = document.getElementById('pauseBtn');
			var playBtn = document.getElementById('playBtn');

			if (pauseBtn) {
				pauseBtn.addEventListener('click', stopAutoSlide);
			}
			if (playBtn) {
				playBtn.addEventListener('click', startAutoSlide);
			}

			// 인디케이터 클릭 이벤트
			var indicators = document.querySelectorAll('.indicator');
			for (var i = 0; i < indicators.length; i++) {
				(function(index) {
					indicators[index].addEventListener('click', function() {
						goToSlide(index);
					});
				})(i);
			}

			// 첫 번째 슬라이드로 초기화
			moveSlide(0);

			// 자동 슬라이드 시작
			if (totalSlidesCount > 1) {
				startAutoSlide();
			}
		});

		// 스크롤 애니메이션
		var observerOptions = {
			threshold : 0.1,
			rootMargin : '0px 0px -50px 0px'
		};

		var observer = new IntersectionObserver(function(entries) {
			entries.forEach(function(entry) {
				if (entry.isIntersecting) {
					entry.target.classList.add('animate');
				}
			});
		}, observerOptions);

		document.querySelectorAll('.animate-on-scroll').forEach(function(el) {
			observer.observe(el);
		});

		// 검색 폼 포커스 효과
		var searchInput = document.querySelector('.search-input');
		var searchForm = document.querySelector('.search-form');

		if (searchInput && searchForm) {
			searchInput
					.addEventListener(
							'focus',
							function() {
								searchForm.style.boxShadow = '0 25px 80px rgba(212, 175, 55, 0.2)';
								searchForm.style.borderColor = 'rgba(212, 175, 55, 0.4)';
							});

			searchInput.addEventListener('blur', function() {
				searchForm.style.boxShadow = '0 20px 60px rgba(0, 0, 0, 0.08)';
				searchForm.style.borderColor = 'rgba(212, 175, 55, 0.2)';
			});
		}
	</script>
</body>
</html>