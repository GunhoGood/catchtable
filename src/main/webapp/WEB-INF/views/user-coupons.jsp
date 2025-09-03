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
<title>My Coupons - Catch Table</title>
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

/* === 쿠폰 그리드 === */
.coupons-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
	gap: 25px;
	margin-top: 20px;
}

.coupon-card {
	background: #ffffff;
	border-radius: 12px;
	overflow: hidden;
	box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
	border: 1px solid rgba(0, 0, 0, 0.02);
	transition: transform 0.3s ease;
	position: relative;
}

.coupon-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 15px 35px rgba(0, 0, 0, 0.12);
}

.coupon-header {
	background: linear-gradient(135deg, #d4af37 0%, #c9a96e 100%);
	color: white;
	padding: 20px;
	position: relative;
	overflow: hidden;
}

.coupon-header::before {
	content: '';
	position: absolute;
	top: 0;
	right: 0;
	width: 80px;
	height: 80px;
	background: rgba(255, 255, 255, 0.1);
	border-radius: 50%;
	transform: translate(30px, -30px);
}

.coupon-icon {
	font-size: 2rem;
	margin-bottom: 10px;
	display: block;
}

.coupon-name {
	font-family: 'Crimson Text', serif;
	font-size: 1.5rem;
	font-weight: 600;
	margin-bottom: 5px;
	position: relative;
	z-index: 1;
}

.coupon-discount {
	font-size: 2rem;
	font-weight: 700;
	margin-bottom: 5px;
	position: relative;
	z-index: 1;
}

.coupon-body {
	padding: 25px;
}

.coupon-description {
	color: #666;
	margin-bottom: 15px;
	line-height: 1.5;
}

.coupon-details {
	display: flex;
	flex-direction: column;
	gap: 8px;
	margin-bottom: 20px;
}

.coupon-detail-item {
	display: flex;
	justify-content: space-between;
	align-items: center;
	font-size: 0.9rem;
}

.coupon-detail-label {
	color: #888;
	font-weight: 500;
}

.coupon-detail-value {
	color: #2c2c2c;
	font-weight: 600;
}

.coupon-expiry {
	text-align: center;
	padding: 15px;
	background: #f8f6f3;
	border-top: 1px solid #f5f3f0;
	font-size: 0.9rem;
	color: #666;
}

.coupon-expiry.expired {
	background: #ffebee;
	color: #c62828;
}

.coupon-expiry.soon {
	background: #fff3e0;
	color: #ef6c00;
}

/* === 상태 뱃지 === */
.status-badge {
	position: absolute;
	top: 15px;
	right: 15px;
	padding: 6px 12px;
	border-radius: 20px;
	font-size: 0.8rem;
	font-weight: 600;
	text-transform: uppercase;
	letter-spacing: 0.5px;
	z-index: 2;
}

.status-available {
	background: rgba(255, 255, 255, 0.9);
	color: #27ae60;
	border: 1px solid rgba(39, 174, 96, 0.3);
}

.status-used {
	background: rgba(255, 255, 255, 0.9);
	color: #95a5a6;
	border: 1px solid rgba(149, 165, 166, 0.3);
}

.status-expired {
	background: rgba(255, 255, 255, 0.9);
	color: #e74c3c;
	border: 1px solid rgba(231, 76, 60, 0.3);
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

/* === 필터 === */
.filter-tabs {
	display: flex;
	background: #ffffff;
	border-radius: 8px;
	overflow: hidden;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
	margin-bottom: 20px;
	border: 1px solid #f5f3f0;
}

.filter-tab {
	flex: 1;
	padding: 15px 20px;
	text-align: center;
	text-decoration: none;
	color: #666;
	font-weight: 500;
	border-right: 1px solid #f5f3f0;
	transition: all 0.3s ease;
	cursor: pointer;
	background: none;
	border: none;
	border-right: 1px solid #f5f3f0;
}

.filter-tab:last-child {
	border-right: none;
}

.filter-tab.active {
	background: #d4af37;
	color: #ffffff;
	font-weight: 600;
}

.filter-tab:hover:not(.active) {
	background: #f8f6f3;
	color: #2c2c2c;
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
	.coupons-grid {
		grid-template-columns: 1fr;
		gap: 20px;
	}
	.filter-tabs {
		flex-direction: column;
	}
	.filter-tab {
		border-right: none;
		border-bottom: 1px solid #f5f3f0;
	}
	.filter-tab:last-child {
		border-bottom: none;
	}
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/navi.jsp"%>

	<div class="container">
		<!-- 헤더 -->
		<div class="header card">
			<h1 class="title">My Coupons</h1>
			<p class="subtitle">보유하고 있는 쿠폰을 확인하고 사용하세요</p>
		</div>

		<!-- 네비게이션 -->
		<div class="nav-tabs">
			<a href="/catchtable/user/profile" class="nav-tab">My Profile</a>
			<a href="/catchtable/user/reservations" class="nav-tab">My Reservations</a> 
			<a href="/catchtable/user/reviews" class="nav-tab">My Reviews</a>
			<a href="/catchtable/user/coupons" class="nav-tab active">My Coupons</a>
			<a href="/catchtable/user/favorites" class="nav-tab">My Favorites</a>
		</div>

		<!-- 통계 요약 -->
		<div class="card">
			<div class="stats-summary">
				<div class="stat-row">
					<div class="stat-item">
						<span>총 쿠폰:</span> <span class="stat-value">${couponStats.totalCoupons}개</span>
					</div>
					<div class="stat-item">
						<span>사용 가능:</span> <span class="stat-value">${couponStats.availableCoupons}개</span>
					</div>
					<div class="stat-item">
						<span>사용 완료:</span> <span class="stat-value">${couponStats.usedCoupons}개</span>
					</div>
				</div>
				<p class="summary-note">나의 쿠폰 보유 현황입니다</p>
			</div>
		</div>

		<!-- 필터 탭 -->
		<div class="card">
			<div class="filter-tabs">
				<button class="filter-tab active" onclick="filterCoupons('all')">전체</button>
				<button class="filter-tab" onclick="filterCoupons('available')">사용 가능</button>
				<button class="filter-tab" onclick="filterCoupons('used')">사용 완료</button>
				<button class="filter-tab" onclick="filterCoupons('expired')">만료됨</button>
			</div>

			<!-- 쿠폰 목록 -->
			<c:choose>
				<c:when test="${not empty userCoupons}">
					<div class="coupons-grid" id="couponsGrid">
						<c:forEach var="userCoupon" items="${userCoupons}">
							<!-- 상태 변수 설정 -->
							<c:set var="isUsed" value="${userCoupon.isUsed}" />
							<c:set var="isExpired" value="${fn:contains(userCoupon.couponDescription, 'EXPIRED:true')}" />
							<c:set var="isExpiringSoon" value="${fn:contains(userCoupon.couponDescription, 'EXPIRING_SOON:true')}" />
							<c:set var="couponStatus" value="${isUsed ? 'used' : (isExpired ? 'expired' : 'available')}" />
							
							<div class="coupon-card" data-status="${couponStatus}">
								<!-- 상태 뱃지 -->
								<c:choose>
									<c:when test="${isUsed}">
										<span class="status-badge status-used">사용완료</span>
									</c:when>
									<c:when test="${isExpired}">
										<span class="status-badge status-expired">만료</span>
									</c:when>
									<c:otherwise>
										<span class="status-badge status-available">사용가능</span>
									</c:otherwise>
								</c:choose>

								<!-- 쿠폰 헤더 -->
								<div class="coupon-header">
									<span class="coupon-icon">🎫</span>
									<div class="coupon-name">${userCoupon.couponName}</div>
									<div class="coupon-discount">
										<fmt:formatNumber value="${userCoupon.discountAmount}" type="number"/>원 할인
									</div>
								</div>

								<!-- 쿠폰 본문 -->
								<div class="coupon-body">
									<div class="coupon-description">
										<c:set var="cleanDescription" value="${fn:substringBefore(userCoupon.couponDescription, '|STATUS:')}" />
										${not empty cleanDescription ? cleanDescription : userCoupon.couponDescription}
									</div>

									<div class="coupon-details">
										<c:if test="${userCoupon.minOrderAmount > 0}">
											<div class="coupon-detail-item">
												<span class="coupon-detail-label">최소 주문금액</span>
												<span class="coupon-detail-value">
													<fmt:formatNumber value="${userCoupon.minOrderAmount}" type="number"/>원 이상
												</span>
											</div>
										</c:if>
										
										<c:if test="${userCoupon.usageLimit > 1}">
											<div class="coupon-detail-item">
												<span class="coupon-detail-label">사용 가능 횟수</span>
												<span class="coupon-detail-value">
													${userCoupon.usageLimit}회
												</span>
											</div>
										</c:if>

										<c:if test="${isUsed}">
											<div class="coupon-detail-item">
												<span class="coupon-detail-label">사용일</span>
												<span class="coupon-detail-value">
													<c:set var="usedAtString" value="${userCoupon.usedAt}" />
													${fn:substringBefore(usedAtString, 'T')}
												</span>
											</div>
										</c:if>
									</div>
								</div>

								<!-- 유효기간 -->
								<c:set var="expiryClass" value="${isExpired ? 'expired' : (isExpiringSoon ? 'soon' : '')}" />
								<div class="coupon-expiry ${expiryClass}">
									<c:choose>
										<c:when test="${isExpired}">
											⚠️ 만료됨 (${userCoupon.endDate})
										</c:when>
										<c:when test="${isExpiringSoon}">
											⏰ 곧 만료 (${userCoupon.endDate}까지)
										</c:when>
										<c:otherwise>
											📅 ${userCoupon.endDate}까지 사용 가능
										</c:otherwise>
									</c:choose>
								</div>
							</div>
						</c:forEach>
					</div>
				</c:when>
				<c:otherwise>
					<div class="empty-state">
						<div class="icon">🎫</div>
						<h3>보유하신 쿠폰이 없습니다</h3>
						<p>예약을 통해 쿠폰을 획득해보세요!</p>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

	<script>
        function filterCoupons(status) {
            // 활성 탭 변경
            document.querySelectorAll('.filter-tab').forEach(tab => {
                tab.classList.remove('active');
            });
            event.target.classList.add('active');

            // 쿠폰 카드 필터링
            const couponCards = document.querySelectorAll('.coupon-card');
            
            couponCards.forEach(card => {
                const cardStatus = card.dataset.status;
                
                if (status === 'all') {
                    card.style.display = 'block';
                } else if (status === 'available' && cardStatus === 'available') {
                    card.style.display = 'block';
                } else if (status === 'used' && cardStatus === 'used') {
                    card.style.display = 'block';
                } else if (status === 'expired' && cardStatus === 'expired') {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });

            // 빈 상태 확인
            const visibleCards = document.querySelectorAll('.coupon-card[style="display: block"], .coupon-card:not([style*="display: none"])');
            const emptyState = document.querySelector('.empty-state');
            const couponsGrid = document.getElementById('couponsGrid');
            
            if (visibleCards.length === 0 && couponsGrid) {
                if (!emptyState) {
                    const emptyDiv = document.createElement('div');
                    emptyDiv.className = 'empty-state';
                    emptyDiv.innerHTML = `
                        <div class="icon">🎫</div>
                        <h3>해당하는 쿠폰이 없습니다</h3>
                        <p>다른 필터를 선택해보세요</p>
                    `;
                    couponsGrid.parentNode.appendChild(emptyDiv);
                }
            } else if (emptyState && visibleCards.length > 0) {
                emptyState.remove();
            }
        }

        // 페이지 로드 시 쿠폰 상태 설정
        document.addEventListener('DOMContentLoaded', function() {
            const couponCards = document.querySelectorAll('.coupon-card');
            
            couponCards.forEach(card => {
                const statusBadge = card.querySelector('.status-badge');
                
                if (statusBadge.classList.contains('status-used')) {
                    card.dataset.status = 'used';
                } else if (statusBadge.classList.contains('status-expired')) {
                    card.dataset.status = 'expired';
                } else {
                    card.dataset.status = 'available';
                }
            });
        });
    </script>
</body>
</html>