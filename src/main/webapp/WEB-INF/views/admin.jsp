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
<title>관리자 대시보드 - Catch Table</title>
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
	padding-top: 80px;
}

.admin-container {
	max-width: 1200px;
	margin: 60px auto;
	padding: 0 40px;
}

.admin-header {
	background-size: cover;
	background-position: center;
	padding: 50px;
	border-radius: 2px;
	margin-bottom: 50px;
	position: relative;
	overflow: hidden;
	text-align: center;
}

.admin-header::before {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	height: 3px;
}

.admin-title {
	font-family: 'Crimson Text', serif;
	font-size: 2.5rem;
	font-weight: 600;
	margin-bottom: 15px;
	letter-spacing: 0.5px;
}

.admin-subtitle {
	font-size: 1.1rem;
	opacity: 0.8;
	font-weight: 300;
}

/* 새로운 인라인 통계 스타일 */
.stats-summary {
	text-align: center;
	padding: 25px 0;
	background: linear-gradient(135deg, #f8f6f3 0%, #ffffff 100%);
	border-radius: 10px;
	margin-bottom: 50px;
	box-shadow: 0 15px 40px rgba(0, 0, 0, 0.06);
	border: 1px solid rgba(0, 0, 0, 0.02);
}

.stats-inline {
	display: flex;
	justify-content: center;
	align-items: center;
	gap: 40px;
	margin: 0;
	flex-wrap: wrap;
}

.stat-inline-item {
	display: flex;
	align-items: center;
	gap: 6px;
	font-size: 1.1rem;
	color: #666;
}

.stat-icon {
	font-size: 1.2rem;
}

.stat-inline-label {
	color: #666;
	font-weight: 500;
}

.stat-inline-value {
	font-size: 1.3rem;
	font-weight: 700;
	color: #d4af37;
	font-family: 'Crimson Text', serif;
}

.summary-note {
	color: #888;
	font-size: 1rem;
	margin-top: 15px;
	font-style: italic;
}

/* 네비게이션 탭 스타일 */
.nav-tabs {
	display: flex;
	background: #ffffff;
	border-radius: 8px;
	overflow: hidden;
	box-shadow: 0 8px 20px rgba(0, 0, 0, 0.04);
	margin: 20px 0 30px 0;
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
	position: relative;
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

.content-grid {
	display: grid;
	grid-template-columns: 2fr 1fr;
	gap: 40px;
}

.main-content {
	background: #ffffff;
	border-radius: 2px;
	box-shadow: 0 15px 40px rgba(0, 0, 0, 0.06);
	border: 1px solid rgba(0, 0, 0, 0.02);
	overflow: hidden;
	position: relative;
}

.main-content::before {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	height: 3px;
}

.sidebar {
	background: #ffffff;
	border-radius: 2px;
	box-shadow: 0 15px 40px rgba(0, 0, 0, 0.06);
	border: 1px solid rgba(0, 0, 0, 0.02);
	overflow: hidden;
	position: relative;
}

.sidebar::before {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	height: 3px;
}

.section-header {
	background: rgba(250, 248, 245, 0.5);
	padding: 35px;
	border-bottom: 1px solid #ebe8e4;
}

.section-title {
	font-family: 'Crimson Text', serif;
	font-size: 1.6rem;
	font-weight: 600;
	color: #2c2c2c;
	margin: 0 0 10px 0;
	letter-spacing: 0.5px;
}

.section-content {
	padding: 35px;
}

.pending-list {
	list-style: none;
}

.pending-item {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 20px 0;
	border-bottom: 1px solid #f5f3f0;
	transition: all 0.3s ease;
}

.pending-item:hover {
	background: rgba(212, 175, 55, 0.02);
	margin: 0 -20px;
	padding: 20px;
	border-radius: 2px;
}

.pending-item:last-child {
	border-bottom: none;
}

.pending-info h4 {
	margin: 0 0 5px 0;
	font-size: 1.1rem;
	color: #2c2c2c;
	font-weight: 600;
}

.pending-info p {
	margin: 0;
	font-size: 0.9rem;
	color: #666;
}

.pending-actions {
	display: flex;
	gap: 10px;
}

.btn {
	padding: 10px 18px;
	border: 1px solid;
	border-radius: 2px;
	font-family: 'Source Sans Pro', sans-serif;
	font-size: 0.85rem;
	font-weight: 500;
	text-transform: uppercase;
	letter-spacing: 0.5px;
	cursor: pointer;
	transition: all 0.3s ease;
	text-decoration: none;
	display: inline-block;
	text-align: center;
}

.btn:hover {
	transform: translateY(-1px);
}

.btn-approve {
	background: transparent;
	color: #27ae60;
	border-color: #27ae60;
}

.btn-approve:hover {
	background: #27ae60;
	color: #ffffff;
}

.btn-reject {
	background: transparent;
	color: #e74c3c;
	border-color: #e74c3c;
}

.btn-reject:hover {
	background: #e74c3c;
	color: #ffffff;
}

.recent-users {
	list-style: none;
}

.recent-user {
	display: flex;
	align-items: center;
	padding: 15px 0;
	border-bottom: 1px solid #f5f3f0;
	transition: all 0.3s ease;
}

.recent-user:hover {
	background: rgba(212, 175, 55, 0.02);
	margin: 0 -20px;
	padding: 15px 20px;
	border-radius: 2px;
}

.recent-user:last-child {
	border-bottom: none;
}

.user-avatar {
	width: 45px;
	height: 45px;
	border-radius: 50%;
	background: linear-gradient(135deg, #d4af37, #c9a96e);
	display: flex;
	align-items: center;
	justify-content: center;
	color: white;
	font-weight: 600;
	margin-right: 15px;
	font-family: 'Source Sans Pro', sans-serif;
}

.user-info h4 {
	margin: 0 0 3px 0;
	font-size: 1rem;
	color: #2c2c2c;
	font-weight: 600;
}

.user-info p {
	margin: 0;
	font-size: 0.85rem;
	color: #666;
}

.empty-state {
	text-align: center;
	padding: 60px 20px;
	color: #888;
}

.empty-icon {
	font-size: 3rem;
	margin-bottom: 20px;
	opacity: 0.5;
}

/* 미니멀 액션 메뉴 스타일 */
.minimal-actions {
    display: flex;
    flex-direction: column;
    gap: 2px;
}

.minimal-action {
    display: flex;
    align-items: center;
    padding: 20px 25px;
    text-decoration: none;
    color: #2c2c2c;
    transition: all 0.3s ease;
    border-radius: 6px;
    position: relative;
    overflow: hidden;
}

.minimal-action::before {
    content: '';
    position: absolute;
    left: 0;
    top: 0;
    bottom: 0;
    width: 0;
    background: linear-gradient(135deg, #d4af37 0%, #c9a96e 100%);
    transition: width 0.3s ease;
    opacity: 0.1;
}

.minimal-action:hover {
    background: rgba(212, 175, 55, 0.05);
    transform: translateX(8px);
    color: #2c2c2c;
    text-decoration: none;
}

.minimal-action:hover::before {
    width: 4px;
}

.minimal-action:hover .minimal-arrow {
    transform: translateX(8px);
    color: #d4af37;
}

.minimal-icon {
    font-size: 1.4rem;
    margin-right: 20px;
    width: 24px;
    text-align: center;
}

.minimal-text {
    flex: 1;
    font-size: 1.1rem;
    font-weight: 500;
    letter-spacing: 0.3px;
}

.minimal-arrow {
    font-size: 1.2rem;
    color: #999;
    transition: all 0.3s ease;
    margin-left: 15px;
}

/* 반응형 */
@media (max-width: 768px) {
	body {
		padding-top: 70px;
	}
	
	.admin-container {
		margin: 40px auto;
		padding: 0 20px;
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
	
	.content-grid {
		grid-template-columns: 1fr;
		gap: 30px;
	}
	
	.admin-header {
		padding: 40px 30px;
	}
	
	.section-header {
		padding: 25px;
	}
	
	.section-content {
		padding: 25px;
	}
	
	.stats-inline {
		flex-direction: column;
		gap: 15px;
	}
	
	.stat-inline-item {
		font-size: 1rem;
	}
	
	.stat-inline-value {
		font-size: 1.2rem;
	}
    
    .minimal-action {
        padding: 18px 20px;
    }
    
    .minimal-text {
        font-size: 1rem;
    }
    
    .minimal-icon {
        font-size: 1.2rem;
        margin-right: 15px;
        width: 20px;
    }
}
</style>
</head>
<body>
	<!-- 네비게이션 -->
	<%@ include file="/WEB-INF/views/navi.jsp"%>

	<div class="admin-container">
		<!-- 헤더 -->
		<div class="admin-header">
			<h1 class="admin-title">🛠️ 관리자 대시보드</h1>
			<p class="admin-subtitle">Catch Table 시스템 관리 및 모니터링</p>
		</div>

		<!-- 네비게이션 탭 -->
		<div class="nav-tabs">
			<a href="/catchtable/admin/dashboard" class="nav-tab active">Dashboard</a>
			<a href="/catchtable/admin/restaurants" class="nav-tab">Restaurants</a>
			<a href="/catchtable/admin/categories" class="nav-tab">Categories</a>
			<a href="/catchtable/admin/approve-business" class="nav-tab">Business Approval</a>
			<a href="/catchtable/admin/coupons" class="nav-tab">Coupons</a>
			<a href="/catchtable/admin/users" class="nav-tab">Users</a>
		</div>

		<!-- 새로운 인라인 통계 -->
		<div class="stats-summary">
			<div class="stats-inline">
				<div class="stat-inline-item">
					<span class="stat-icon">👥</span>
					<span class="stat-inline-label">일반 회원:</span>
					<span class="stat-inline-value">${totalUsers}명</span>
				</div>
				<div class="stat-inline-item">
					<span class="stat-icon">🏢</span>
					<span class="stat-inline-label">사업자 회원:</span>
					<span class="stat-inline-value">${totalBusinessUsers}명</span>
				</div>
				<div class="stat-inline-item">
					<span class="stat-icon">⏳</span>
					<span class="stat-inline-label">승인 대기:</span>
					<span class="stat-inline-value">${pendingApprovals}건</span>
				</div>
				<div class="stat-inline-item">
					<span class="stat-icon">🍽️</span>
					<span class="stat-inline-label">등록 식당:</span>
					<span class="stat-inline-value">${totalRestaurants}개</span>
				</div>
			</div>
			<p class="summary-note">시스템 현황을 한눈에 확인하세요</p>
		</div>

		<div class="content-grid">
			<!-- 미니멀 액션 메뉴 -->
			<div class="main-content">
				<div class="section-header">
					<h2 class="section-title">⚡ 시스템 관리</h2>
					<p style="color: #666; font-size: 0.9rem; margin: 10px 0 0 0;">관리 화면이동</p>
				</div>
				<div class="section-content">
					<div class="minimal-actions">
						<a href="/catchtable/admin/restaurants" class="minimal-action">
							<span class="minimal-icon">🏪</span> 
							<span class="minimal-text">식당 관리</span> 
							<span class="minimal-arrow">→</span>
						</a> 
						<a href="/catchtable/admin/categories" class="minimal-action">
							<span class="minimal-icon">📂</span> 
							<span class="minimal-text">카테고리 관리</span> 
							<span class="minimal-arrow">→</span>
						</a> 
						<a href="/catchtable/admin/approve-business" class="minimal-action"> 
							<span class="minimal-icon">✅</span> 
							<span class="minimal-text">사업자 승인</span> 
							<span class="minimal-arrow">→</span>
						</a> 
						<a href="/catchtable/admin/coupons" class="minimal-action"> 
							<span class="minimal-icon">🎫</span> 
							<span class="minimal-text">쿠폰 관리</span> 
							<span class="minimal-arrow">→</span>
						</a> 
						<a href="/catchtable/admin/users" class="minimal-action"> 
							<span class="minimal-icon">👤</span> 
							<span class="minimal-text">회원 관리</span> 
							<span class="minimal-arrow">→</span>
						</a>
					</div>
				</div>
			</div>

			<!-- 최근 가입 회원 -->
			<div class="sidebar">
				<div class="section-header">
					<h2 class="section-title">👋 최근 가입 회원</h2>
				</div>
				<div class="section-content">
					<c:choose>
						<c:when test="${not empty recentUsers}">
							<ul class="recent-users">
								<c:forEach var="user" items="${recentUsers}">
									<li class="recent-user">
										<div class="user-avatar">${user.name.substring(0,1)}</div>
										<div class="user-info">
											<h4>${user.name}</h4>
											<p>${user.userType}|${user.email}</p>
										</div>
									</li>
								</c:forEach>
							</ul>
						</c:when>
						<c:otherwise>
							<p style="text-align: center; color: #7f8c8d;">최근 가입 회원이 없습니다.</p>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
	</div>

	<script>
        // 사업자 승인
        function approveBusiness(userId) {
            if (confirm('이 사업자를 승인하시겠습니까?')) {
                fetch('/catchtable/admin/approve-business/' + userId, {
                    method: 'POST'
                })
                .then(response => response.json())
                .then(data => {
                    alert(data.message);
                    if (data.success) {
                        location.reload();
                    }
                })
                .catch(error => {
                    alert('오류가 발생했습니다.');
                });
            }
        }
        
        // 사업자 거부
        function rejectBusiness(userId) {
            const reason = prompt('거부 사유를 입력해주세요:');
            if (reason && reason.trim()) {
                fetch('/catchtable/admin/reject-business/' + userId, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'rejectionReason=' + encodeURIComponent(reason)
                })
                .then(response => response.json())
                .then(data => {
                    alert(data.message);
                    if (data.success) {
                    }
                })
                .catch(error => {
                    alert('오류가 발생했습니다.');
                });
            }
        }
    </script>
</body>
</html>