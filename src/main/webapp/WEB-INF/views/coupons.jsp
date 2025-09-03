<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<link rel="icon" type="image/png" sizes="32x32"
	href="${pageContext.request.contextPath}/resources/images/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16"
	href="${pageContext.request.contextPath}/resources/images/favicon-16x16.png">
<meta charset="UTF-8">
<title>쿠폰 관리 - Catch Table</title>
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

.main-container {
	max-width: 1200px;
	margin: 60px auto;
	padding: 0 40px;
}

.page-header {
	text-align: center;
	margin-bottom: 60px;
}

.page-title {
	font-family: 'Crimson Text', serif;
	font-size: 2.2rem;
	font-weight: 600;
	color: #2c2c2c;
	margin-bottom: 15px;
	letter-spacing: 0.5px;
}

.page-subtitle {
	font-size: 1rem;
	color: #666;
	font-weight: 300;
}

.content-wrapper {
	display: flex;
	gap: 40px;
	align-items: flex-start;
}

.coupons-section {
	flex: 2;
	background: #ffffff;
	border-radius: 2px;
	box-shadow: 0 15px 40px rgba(0, 0, 0, 0.06);
	border: 1px solid rgba(0, 0, 0, 0.02);
	overflow: hidden;
	position: relative;
}

.coupons-section::before {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	height: 3px;
}

.create-section {
	flex: 1;
	background: #ffffff;
	border-radius: 2px;
	box-shadow: 0 15px 40px rgba(0, 0, 0, 0.06);
	border: 1px solid rgba(0, 0, 0, 0.02);
	padding: 35px;
	height: fit-content;
	position: sticky;
	top: 100px;
}

.section-header {
	padding: 35px;
	border-bottom: 1px solid #f5f3f0;
}

.section-title {
	font-family: 'Crimson Text', serif;
	font-size: 1.6rem;
	font-weight: 600;
	color: #2c2c2c;
	margin-bottom: 10px;
}

.section-description {
	color: #666;
	font-size: 0.95rem;
}

.coupon-list {
	padding: 35px;
}

.coupon-item {
	background: #fafaf9;
	border: 1px solid #ebe8e4;
	border-radius: 2px;
	padding: 25px;
	margin-bottom: 20px;
	transition: all 0.3s ease;
	position: relative;
}

.coupon-item:hover {
	transform: translateY(-2px);
	box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
	border-color: rgba(212, 175, 55, 0.3);
}

.coupon-item:last-child {
	margin-bottom: 0;
}

.coupon-header {
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
	margin-bottom: 15px;
}

.coupon-name {
	font-family: 'Crimson Text', serif;
	font-size: 1.3rem;
	font-weight: 600;
	color: #2c2c2c;
	margin-bottom: 5px;
}

.coupon-discount {
	font-size: 1.1rem;
	font-weight: 600;
	color: #d4af37;
}

.coupon-badge {
	background: #d4af37;
	color: #2c2c2c;
	padding: 5px 12px;
	border-radius: 15px;
	font-size: 0.8rem;
	font-weight: 600;
	text-transform: uppercase;
	letter-spacing: 0.5px;
}

.coupon-details {
	margin-bottom: 20px;
}

.coupon-detail {
	font-size: 0.9rem;
	color: #555;
	margin-bottom: 5px;
}

.coupon-actions {
	display: flex;
	gap: 10px;
	flex-wrap: wrap;
}

.coupon-list {
	padding: 35px;
	max-height: 950px;
	overflow-y: auto;
}

/* 스크롤바 스타일링 */
.coupon-list::-webkit-scrollbar {
	width: 8px;
}

.coupon-list::-webkit-scrollbar-track {
	background: #f1f1f1;
	border-radius: 4px;
}

.coupon-list::-webkit-scrollbar-thumb {
	background: #d4af37;
	border-radius: 4px;
}

.coupon-list::-webkit-scrollbar-thumb:hover {
	background: #c9a96e;
}

.btn {
	padding: 8px 16px;
	border: none;
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

.btn-edit {
	background: transparent;
	color: #d4af37;
	border: 1px solid #d4af37;
}

.btn-edit:hover {
	background: #d4af37;
	color: #2c2c2c;
}

.btn-issue {
	background: transparent;
	color: #27ae60;
	border: 1px solid #27ae60;
}

.btn-issue:hover {
	background: #27ae60;
	color: #ffffff;
}

.btn-delete {
	background: transparent;
	color: #e74c3c;
	border: 1px solid #e74c3c;
}

.btn-delete:hover {
	background: #e74c3c;
	color: #ffffff;
}

.btn-bulk {
	background: transparent;
	color: #3498db;
	border: 1px solid #3498db;
}

.btn-bulk:hover {
	background: #3498db;
	color: #ffffff;
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

/* 폼 스타일 */
.form-group {
	margin-bottom: 20px;
}

.form-label {
	display: block;
	font-size: 0.9rem;
	font-weight: 500;
	color: #333;
	margin-bottom: 8px;
	text-transform: uppercase;
	letter-spacing: 0.5px;
}

.form-input {
	width: 100%;
	padding: 12px 15px;
	border: 1px solid #e0e0e0;
	border-radius: 2px;
	font-size: 1rem;
	font-family: 'Source Sans Pro', sans-serif;
	background: #fafafa;
	color: #333;
	transition: all 0.3s ease;
}

.form-input:focus {
	outline: none;
	border-color: #d4af37;
	background: #ffffff;
	box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
}

.form-textarea {
	width: 100%;
	padding: 12px 15px;
	border: 1px solid #e0e0e0;
	border-radius: 2px;
	font-size: 1rem;
	font-family: 'Source Sans Pro', sans-serif;
	background: #fafafa;
	color: #333;
	resize: vertical;
	min-height: 80px;
	transition: all 0.3s ease;
}

.form-textarea:focus {
	outline: none;
	border-color: #d4af37;
	background: #ffffff;
	box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
}

.form-row {
	display: flex;
	gap: 15px;
}

.form-col {
	flex: 1;
}

.submit-btn {
	width: 100%;
	background: #d4af37;
	color: #2c2c2c;
	border: none;
	padding: 15px;
	font-family: 'Source Sans Pro', sans-serif;
	font-size: 0.9rem;
	font-weight: 600;
	text-transform: uppercase;
	letter-spacing: 1px;
	border-radius: 2px;
	cursor: pointer;
	transition: all 0.3s ease;
	margin-top: 20px;
}

.submit-btn:hover {
	background: #c9a96e;
	transform: translateY(-2px);
	box-shadow: 0 8px 25px rgba(212, 175, 55, 0.3);
}

/* 빠른 생성 버튼 */
.quick-create {
	margin-bottom: 30px;
	padding-bottom: 30px;
	border-bottom: 1px solid #f5f3f0;
}

.quick-btn {
	width: 100%;
	background: #ffffff;
	border: 1px solid #ebe8e4;
	border-radius: 2px;
	padding: 15px;
	margin-bottom: 10px;
	cursor: pointer;
	transition: all 0.3s ease;
	text-align: left;
}

.quick-btn:hover {
	border-color: #d4af37;
	transform: translateY(-1px);
	box-shadow: 0 4px 15px rgba(212, 175, 55, 0.1);
}

.quick-btn-title {
	font-weight: 600;
	color: #2c2c2c;
	margin-bottom: 5px;
}

.quick-btn-desc {
	font-size: 0.85rem;
	color: #666;
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

/* 반응형 */
@media ( max-width : 768px) {
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
}

@media ( max-width : 768px) {
	body {
		padding-top: 70px;
	}
	.main-container {
		margin: 40px auto;
		padding: 0 20px;
	}
	.content-wrapper {
		flex-direction: column;
		gap: 30px;
	}
	.section-header {
		padding: 25px;
	}
	.coupon-list {
		padding: 25px;
	}
	.create-section {
		position: static;
	}
	.coupon-actions {
		justify-content: center;
	}
	.form-row {
		flex-direction: column;
		gap: 0;
	}
}
</style>
</head>
<body>
	<!-- 네비게이션 -->
	<%@ include file="/WEB-INF/views/navi.jsp"%>

	<div class="main-container">
		<!-- 페이지 헤더 -->
		<div class="page-header">
			<h1 class="page-title">🎫 쿠폰 관리</h1>
			<p class="page-subtitle">쿠폰 생성, 수정, 삭제 및 사용자 지급 관리</p>
		</div>
		<div class="nav-tabs">
			<a href="/catchtable/admin/dashboard" class="nav-tab ">Dashboard</a>
			<a href="/catchtable/admin/restaurants" class="nav-tab">Restaurants</a>
			<a href="/catchtable/admin/categories" class="nav-tab">Categories</a>
			<a href="/catchtable/admin/approve-business" class="nav-tab">Business
				Approval</a> <a href="/catchtable/admin/coupons" class="nav-tab active">Coupons</a>
			<a href="/catchtable/admin/users" class="nav-tab">Users</a>
		</div>
		<div class="content-wrapper">
			<!-- 쿠폰 목록 -->
			<div class="coupons-section">
				<div class="section-header">
					<h2 class="section-title">등록된 쿠폰</h2>
					<p class="section-description">현재 시스템에 등록된 모든 쿠폰을 관리할 수 있습니다</p>
				</div>

				<div class="coupon-list">
					<c:choose>
						<c:when test="${not empty coupons}">
							<c:forEach var="coupon" items="${coupons}">
								<div class="coupon-item">
									<div class="coupon-header">
										<div>
											<div class="coupon-name">${coupon.name}</div>
											<div class="coupon-discount">
												<fmt:formatNumber value="${coupon.discountAmount}"
													pattern="#,###" />
												원 할인
											</div>
										</div>
										<div class="coupon-badge">쿠폰</div>
									</div>

									<div class="coupon-details">
										<c:if
											test="${coupon.description != null && !empty coupon.description}">
											<div class="coupon-detail">
												<strong>설명:</strong> ${coupon.description}
											</div>
										</c:if>
										<c:if test="${coupon.minOrderAmount > 0}">
											<div class="coupon-detail">
												<strong>최소 주문:</strong>
												<fmt:formatNumber value="${coupon.minOrderAmount}"
													pattern="#,###" />
												원
											</div>
										</c:if>
										<c:if test="${coupon.requiredReservationCount > 0}">
											<div class="coupon-detail">
												<strong>필요 예약 횟수:</strong>
												${coupon.requiredReservationCount}회
											</div>
										</c:if>
										<div class="coupon-detail">
											<strong>기간:</strong>
											<c:choose>
												<c:when
													test="${coupon.startDate != null && coupon.endDate != null}">
                                                    ${coupon.startDate} ~ ${coupon.endDate}
                                                </c:when>
												<c:otherwise>무제한</c:otherwise>
											</c:choose>
										</div>
										<div class="coupon-detail">
											<strong>사용 제한:</strong> ${coupon.usageLimit}개
										</div>
									</div>

									<div class="coupon-actions">
										<button class="btn btn-edit"
											onclick="editCoupon(${coupon.couponId})">수정</button>
										<button class="btn btn-issue"
											onclick="issueCoupon(${coupon.couponId})">개별 지급</button>
										<button class="btn btn-bulk"
											onclick="issueToAll(${coupon.couponId})">일괄 지급</button>
										<button class="btn btn-delete"
											onclick="deleteCoupon(${coupon.couponId})">삭제</button>
									</div>
								</div>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<div class="empty-state">
								<div class="empty-icon">🎫</div>
								<h3>등록된 쿠폰이 없습니다</h3>
								<p>새로운 쿠폰을 생성해보세요!</p>
							</div>
						</c:otherwise>
					</c:choose>
				</div>
			</div>

			<!-- 쿠폰 생성 -->
			<div class="create-section">
				<!-- 빠른 생성 -->
				<div class="quick-create">
					<h3 class="section-title">빠른 생성</h3>
					<button class="quick-btn" onclick="createQuickCoupon('welcome')">
						<div class="quick-btn-title">🎉 첫 방문 쿠폰</div>
						<div class="quick-btn-desc">5,000원 할인 • 신규 회원용</div>
					</button>
					<button class="quick-btn" onclick="createQuickCoupon('visit5')">
						<div class="quick-btn-title">🏆 5회 방문 쿠폰</div>
						<div class="quick-btn-desc">10,000원 할인 • 단골 고객용</div>
					</button>
					<button class="quick-btn" onclick="createQuickCoupon('visit10')">
						<div class="quick-btn-title">💎 10회 방문 쿠폰</div>
						<div class="quick-btn-desc">20,000원 할인 • VIP 고객용</div>
					</button>
				</div>

				<!-- 커스텀 생성 -->
				<h3 class="section-title">커스텀 생성</h3>
				<form id="couponForm">
					<div class="form-group">
						<label class="form-label">쿠폰명 *</label> <input type="text"
							class="form-input" id="couponName" placeholder="예: 신규회원 할인 쿠폰"
							required>
					</div>

					<div class="form-group">
						<label class="form-label">할인 금액 (원) *</label> <input type="number"
							class="form-input" id="discountAmount" placeholder="5000"
							required>
					</div>

					<div class="form-group">
						<label class="form-label">쿠폰 설명</label>
						<textarea class="form-textarea" id="description"
							placeholder="쿠폰에 대한 자세한 설명"></textarea>
					</div>

					<div class="form-row">
						<div class="form-col">
							<div class="form-group">
								<label class="form-label">최소 주문 금액</label> <input type="number"
									class="form-input" id="minOrderAmount" placeholder="0">
							</div>
						</div>
						<div class="form-col">
							<div class="form-group">
								<label class="form-label">사용 제한 개수</label> <input type="number"
									class="form-input" id="usageLimit" placeholder="1000">
							</div>
						</div>
					</div>

					<div class="form-row">
						<div class="form-col">
							<div class="form-group">
								<label class="form-label">시작일</label> <input type="date"
									class="form-input" id="startDate">
							</div>
						</div>
						<div class="form-col">
							<div class="form-group">
								<label class="form-label">종료일</label> <input type="date"
									class="form-input" id="endDate">
							</div>
						</div>
					</div>

					<button type="submit" class="submit-btn">쿠폰 생성하기</button>
				</form>
			</div>
		</div>
	</div>

	<!-- 푸터 -->
	<%@ include file="/WEB-INF/views/footer.jsp"%>
	<script>
// 쿠폰 생성
function createCoupon() {
   // 입력값 수집
   var name = document.getElementById('couponName').value.trim();
   var description = document.getElementById('description').value.trim();
   var discountAmount = parseInt(document.getElementById('discountAmount').value);
   var minOrderAmount = parseInt(document.getElementById('minOrderAmount').value) || 0;
   var usageLimit = parseInt(document.getElementById('usageLimit').value) || 1000;
   var startDate = document.getElementById('startDate').value;
   var endDate = document.getElementById('endDate').value;
   
   // 입력값 검증
   if (!name) {
       alert('쿠폰명을 입력해주세요.');
       document.getElementById('couponName').focus();
       return;
   }
   
   if (!discountAmount || discountAmount <= 0) {
       alert('할인 금액을 올바르게 입력해주세요.');
       document.getElementById('discountAmount').focus();
       return;
   }
   
   if (minOrderAmount < 0) {
       alert('최소 주문 금액은 0 이상이어야 합니다.');
       document.getElementById('minOrderAmount').focus();
       return;
   }
   
   // 쿠폰 데이터 구성
   var couponData = {
       name: name,
       description: description || '쿠폰 설명',
       discountAmount: discountAmount,
       minOrderAmount: minOrderAmount,
       usageLimit: usageLimit,
       startDate: startDate || null,
       endDate: endDate || null,
       requiredReservationCount: 0
   };
   
   console.log('쿠폰 생성 데이터:', couponData);
   
   // API 호출
   fetch('/catchtable/admin/coupons', {
       method: 'POST',
       headers: {
           'Content-Type': 'application/json; charset=UTF-8',
           'Accept': 'application/json'
       },
       body: JSON.stringify(couponData)
   })
   .then(function(response) {
       console.log('Response status:', response.status);
       
       if (!response.ok) {
           throw new Error('HTTP error! status: ' + response.status);
       }
       return response.json();
   })
   .then(function(data) {
       console.log('Response data:', data);
       alert(data.message || '쿠폰이 생성되었습니다.');
       
       if (data.success !== false) {
           // 폼 초기화
           var form = document.getElementById('couponForm');
           if (form) {
               form.reset();
           }
           // 페이지 새로고침
           location.reload();
       }
   })
   .catch(function(error) {
       console.error('쿠폰 생성 오류:', error);
       alert('쿠폰 생성 중 오류가 발생했습니다: ' + error.message);
   });
}

//개별 사용자에게 쿠폰 지급 - 이메일로 변경
function issueCoupon(couponId) {
    console.log('개별 쿠폰 지급 시작 - couponId:', couponId);
    
    if (!couponId) {
        alert('쿠폰 ID가 없습니다.');
        return;
    }
    
    // 사용자 이메일 입력받기
    var userEmail = prompt('쿠폰을 지급할 사용자 이메일을 입력하세요:');
    if (!userEmail) {
        return;
    }
    
    // 이메일 형식 간단 검증
    if (!userEmail.includes('@') || !userEmail.includes('.')) {
        alert('올바른 이메일 형식을 입력해주세요.');
        return;
    }
    
    if (!confirm('이메일 ' + userEmail + '에게 쿠폰을 지급하시겠습니까?')) {
        return;
    }
    
    var issueUrl = '/catchtable/admin/coupons/' + couponId + '/issue-by-email?email=' + encodeURIComponent(userEmail);
    console.log('개별 지급 API 호출:', issueUrl);
    
    fetch(issueUrl, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
        }
    })
    .then(function(response) {
        if (!response.ok) {
            throw new Error('HTTP error! status: ' + response.status);
        }
        return response.json();
    })
    .then(function(data) {
        alert(data.message || '쿠폰이 지급되었습니다.');
    })
    .catch(function(error) {
        alert('쿠폰 지급 중 오류가 발생했습니다: ' + error.message);
    });
}
// 모든 사용자에게 일괄 지급
function issueToAll(couponId) {
   console.log('일괄 쿠폰 지급 시작 - couponId:', couponId);
   
   // 쿠폰 ID 검증
   if (!couponId || couponId === '' || couponId === 'undefined') {
       alert('쿠폰 ID가 없습니다.');
       return;
   }
   
   // 확인 메시지
   if (!confirm('모든 일반 회원에게 이 쿠폰을 지급하시겠습니까?\n\n이미 보유중인 사용자는 건너뜁니다.\n이 작업은 시간이 걸릴 수 있습니다.')) {
       return;
   }
   
   var issueUrl = '/catchtable/admin/coupons/' + couponId + '/issue-all';
   console.log('일괄지급 URL:', issueUrl);
   
   // 로딩 표시
   var loadingMsg = '쿠폰 일괄 지급 중입니다...\n잠시만 기다려주세요. (최대 1분 소요)';
   console.log(loadingMsg);
   
   // 버튼 비활성화
   var allButtons = document.querySelectorAll('.btn-bulk');
   allButtons.forEach(function(btn) {
       btn.disabled = true;
       btn.textContent = '지급중...';
   });
   
   // API 호출
   fetch(issueUrl, {
       method: 'POST',
       headers: {
           'Content-Type': 'application/json; charset=UTF-8',
           'Accept': 'application/json'
       }
   })
   .then(function(response) {
       console.log('일괄 지급 응답 status:', response.status);
       
       if (!response.ok) {
           throw new Error('HTTP error! status: ' + response.status);
       }
       return response.json();
   })
   .then(function(data) {
       console.log('일괄 지급 응답 data:', data);
       
       // 결과 메시지 표시
       var message = data.message || '일괄 지급이 완료되었습니다.';
       alert(message);
       
       // 성공시 페이지 새로고침
       if (data.success !== false) {
           location.reload();
       }
   })
   .catch(function(error) {
       console.error('일괄 쿠폰 지급 오류:', error);
       alert('일괄 지급 중 오류가 발생했습니다: ' + error.message);
   })
   .finally(function() {
       // 버튼 복원
       setTimeout(function() {
           allButtons.forEach(function(btn) {
               btn.disabled = false;
               btn.textContent = '일괄 지급';
           });
       }, 1000);
   });
}

// 쿠폰 수정
function editCoupon(couponId) {
   console.log('쿠폰 수정 시작 - couponId:', couponId);
   
   if (!couponId) {
       alert('쿠폰 ID가 없습니다.');
       return;
   }
   
   var newName = prompt('새로운 쿠폰명을 입력하세요:');
   if (!newName || newName.trim() === '') {
       return; // 취소하거나 빈 값인 경우
   }
   
   var newDescription = prompt('새로운 쿠폰 설명을 입력하세요:') || '수정된 쿠폰 설명';
   
   var couponData = { 
       name: newName.trim(),
       description: newDescription.trim()
   };
   
   console.log('쿠폰 수정 데이터:', couponData);
   
   var editUrl = '/catchtable/admin/coupons/' + couponId;
   
   fetch(editUrl, {
       method: 'PUT',
       headers: {
           'Content-Type': 'application/json; charset=UTF-8',
           'Accept': 'application/json'
       },
       body: JSON.stringify(couponData)
   })
   .then(function(response) {
       console.log('수정 응답 status:', response.status);
       
       if (!response.ok) {
           throw new Error('HTTP error! status: ' + response.status);
       }
       return response.json();
   })
   .then(function(data) {
       console.log('수정 응답 data:', data);
       alert(data.message || '쿠폰이 수정되었습니다.');
       
       if (data.success !== false) {
           location.reload();
       }
   })
   .catch(function(error) {
       console.error('쿠폰 수정 오류:', error);
       alert('쿠폰 수정 중 오류가 발생했습니다: ' + error.message);
   });
}

//쿠폰 삭제 - 중복 fetch 제거
function deleteCoupon(couponId) {
    console.log('쿠폰 삭제 시작 - couponId:', couponId);
    
    if (!couponId) {
        alert('쿠폰 ID가 없습니다.');
        return;
    }
    
    if (!confirm('이 쿠폰을 삭제하시겠습니까?')) {
        return;
    }
    
    var deleteUrl = '/catchtable/admin/coupons/' + couponId;
    console.log('삭제 URL:', deleteUrl);
    
    // 중복된 fetch 제거하고 하나만 남김
    fetch(deleteUrl, {
        method: 'DELETE',
        headers: {
            'Accept': 'application/json'
        }
    })
    .then(function(response) {
        console.log('삭제 응답 status:', response.status);
        
        if (!response.ok) {
            throw new Error('HTTP error! status: ' + response.status);
        }
        return response.json();
    })
    .then(function(data) {
        console.log('삭제 응답 data:', data);
        alert(data.message || '쿠폰이 삭제되었습니다.');
        location.reload();
    })
    .catch(function(error) {
        console.error('쿠폰 삭제 오류:', error);
        alert('쿠폰 삭제 중 오류가 발생했습니다: ' + error.message);
    });
}

// 쿠폰 비활성화
function deactivateCoupon(couponId) {
   console.log('쿠폰 비활성화 시작 - couponId:', couponId);
   
   var deactivateUrl = '/catchtable/admin/coupons/' + couponId + '/deactivate';
   
   fetch(deactivateUrl, {
       method: 'PUT',
       headers: {
           'Accept': 'application/json'
       }
   })
   .then(function(response) {
       if (!response.ok) {
           throw new Error('HTTP error! status: ' + response.status);
       }
       return response.json();
   })
   .then(function(data) {
       console.log('비활성화 응답:', data);
       alert(data.message || '쿠폰이 비활성화되었습니다.');
       location.reload();
   })
   .catch(function(error) {
       console.error('쿠폰 비활성화 오류:', error);
       alert('쿠폰 비활성화 중 오류가 발생했습니다: ' + error.message);
   });
}

// 강제 삭제
function forceDeleteCoupon(couponId) {
   console.log('쿠폰 강제 삭제 시작 - couponId:', couponId);
   
   var confirmed = confirm(
       '경고: 강제 삭제 기능입니다!\n\n' +
       '이 작업은 발급된 모든 쿠폰을 삭제하며 복구할 수 없습니다.\n' +
       '사용자가 보유한 쿠폰도 모두 사라집니다.\n\n' +
       '정말로 강제 삭제하시겠습니까?'
   );
   
   if (!confirmed) return;
   
   // 2차 확인
   var doubleConfirm = confirm('마지막 확인: 정말 강제 삭제하시겠습니까?\n\n이 작업은 되돌릴 수 없습니다!');
   if (!doubleConfirm) return;
   
   var forceUrl = '/catchtable/admin/coupons/' + couponId + '/force';
   
   fetch(forceUrl, {
       method: 'DELETE',
       headers: {
           'Accept': 'application/json'
       }
   })
   .then(function(response) {
       if (!response.ok) {
           throw new Error('HTTP error! status: ' + response.status);
       }
       return response.json();
   })
   .then(function(data) {
       console.log('강제 삭제 응답:', data);
       alert(data.message);
       
       if (data.success !== false) {
           location.reload();
       }
   })
   .catch(function(error) {
       console.error('강제 삭제 오류:', error);
       alert('강제 삭제 중 오류가 발생했습니다: ' + error.message);
   });
}

// 쿠폰 통계 조회
function viewCouponStats(couponId) {
   if (!couponId) {
       alert('쿠폰 ID가 없습니다.');
       return;
   }
   
   var statsUrl = '/catchtable/admin/coupons/' + couponId + '/stats';
   
   fetch(statsUrl, {
       method: 'GET',
       headers: {
           'Accept': 'application/json'
       }
   })
   .then(function(response) {
       if (!response.ok) {
           throw new Error('HTTP error! status: ' + response.status);
       }
       return response.json();
   })
   .then(function(data) {
       console.log('통계 응답 data:', data);
       if (data.success !== false) {
           alert(data.message);
       } else {
           alert('통계 조회 실패: ' + (data.message || '알 수 없는 오류'));
       }
   })
   .catch(function(error) {
       console.error('통계 조회 오류:', error);
       alert('통계 조회 중 오류가 발생했습니다: ' + error.message);
   });
}

// 빠른 쿠폰 생성
function createQuickCoupon(type) {
   console.log('빠른 쿠폰 생성:', type);
   
   var couponData = {};
   
   switch(type) {
       case 'welcome':
           couponData = {
               name: '첫 방문 환영 쿠폰',
               description: '처음 방문해주신 고객님을 위한 특별 할인 쿠폰입니다.',
               discountAmount: 5000,
               minOrderAmount: 0,
               requiredReservationCount: 0,
               usageLimit: 1000,
               endDate: getDateString(30)
           };
           break;
           
       case 'visit5':
           couponData = {
               name: '5회 방문 단골 쿠폰',
               description: '5회 방문해주신 단골 고객님을 위한 감사 쿠폰입니다.',
               discountAmount: 10000,
               minOrderAmount: 20000,
               requiredReservationCount: 5,
               usageLimit: 500,
               endDate: getDateString(90)
           };
           break;
           
       case 'visit10':
           couponData = {
               name: '10회 방문 VIP 쿠폰',
               description: '10회 방문해주신 VIP 고객님을 위한 특별 쿠폰입니다.',
               discountAmount: 20000,
               minOrderAmount: 30000,
               requiredReservationCount: 10,
               usageLimit: 200,
               endDate: getDateString(90)
           };
           break;
           
       default:
           alert('알 수 없는 쿠폰 타입입니다.');
           return;
   }
   
   // 확인 메시지
   if (!confirm('\'' + couponData.name + '\' 쿠폰을 생성하시겠습니까?\n\n할인액: ' + couponData.discountAmount.toLocaleString() + '원')) {
       return;
   }
   
   // API 호출
   fetch('/catchtable/admin/coupons', {
       method: 'POST',
       headers: {
           'Content-Type': 'application/json; charset=UTF-8',
           'Accept': 'application/json'
       },
       body: JSON.stringify(couponData)
   })
   .then(function(response) {
       if (!response.ok) {
           throw new Error('HTTP error! status: ' + response.status);
       }
       return response.json();
   })
   .then(function(data) {
       console.log('빠른 생성 응답:', data);
       alert(data.message || '쿠폰이 생성되었습니다.');
       
       if (data.success !== false) {
           location.reload();
       }
   })
   .catch(function(error) {
       console.error('빠른 쿠폰 생성 오류:', error);
       alert('쿠폰 생성 중 오류가 발생했습니다: ' + error.message);
   });
}

// 전체 쿠폰 현황 조회
function viewOverview() {
   fetch('/catchtable/admin/coupons/overview', {
       method: 'GET',
       headers: {
           'Accept': 'application/json'
       }
   })
   .then(function(response) {
       if (!response.ok) {
           throw new Error('HTTP error! status: ' + response.status);
       }
       return response.json();
   })
   .then(function(data) {
       console.log('현황 응답 data:', data);
       if (data.success !== false) {
           alert(data.message);
       } else {
           alert('현황 조회 실패: ' + (data.message || '알 수 없는 오류'));
       }
   })
   .catch(function(error) {
       console.error('현황 조회 오류:', error);
       alert('현황 조회 중 오류가 발생했습니다: ' + error.message);
   });
}

// 날짜 문자열 생성 헬퍼 함수
function getDateString(daysFromNow) {
   var date = new Date();
   date.setDate(date.getDate() + daysFromNow);
   return date.toISOString().split('T')[0];
}

// 페이지 로드 시 초기화
document.addEventListener('DOMContentLoaded', function() {
   console.log('쿠폰 관리 페이지 로드 완료');
   
   // 쿠폰 생성 폼 이벤트 리스너
   var couponForm = document.getElementById('couponForm');
   if (couponForm) {
       couponForm.addEventListener('submit', function(e) {
           e.preventDefault();
           createCoupon();
       });
   }
   
   // 숫자 입력 필드 검증
   var numberInputs = document.querySelectorAll('input[type="number"]');
   numberInputs.forEach(function(input) {
       input.addEventListener('input', function() {
           if (this.value < 0) {
               this.value = 0;
           }
       });
   });
   
   // 전체 현황 버튼 이벤트
   var overviewBtn = document.getElementById('overviewBtn');
   if (overviewBtn) {
       overviewBtn.addEventListener('click', viewOverview);
   }
   
   // 쿠폰 카드에 마우스 호버 효과
   var couponItems = document.querySelectorAll('.coupon-item');
   couponItems.forEach(function(item) {
       item.addEventListener('mouseenter', function() {
           this.style.transform = 'translateY(-3px)';
       });
       
       item.addEventListener('mouseleave', function() {
           this.style.transform = 'translateY(0)';
       });
   });
});
</script>
</body>
</html>