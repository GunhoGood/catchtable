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
<title>회원 관리 - Catch Table</title>
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

/* 탭 버튼 */
.filter-tabs {
	display: flex;
	gap: 10px;
	margin-bottom: 40px;
	justify-content: center;
}

.tab-btn {
	padding: 12px 24px;
	border: 1px solid #d4af37;
	background: transparent;
	color: #d4af37;
	border-radius: 25px;
	font-family: 'Source Sans Pro', sans-serif;
	font-size: 0.9rem;
	font-weight: 500;
	cursor: pointer;
	transition: all 0.3s ease;
	text-transform: uppercase;
	letter-spacing: 0.5px;
}

.tab-btn.active {
	background: #d4af37;
	color: #2c2c2c;
}

.tab-btn:hover {
	background: #d4af37;
	color: #2c2c2c;
	transform: translateY(-1px);
}

/* 테이블 섹션 */
.users-section {
	background: #ffffff;
	border-radius: 2px;
	box-shadow: 0 15px 40px rgba(0, 0, 0, 0.06);
	border: 1px solid rgba(0, 0, 0, 0.02);
	position: relative;
}

.users-section::before {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	height: 3px;
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

/* 테이블 스타일 */
.table-container {
	padding: 35px;
}

.users-table {
	width: 100%;
	border-collapse: collapse;
	background: #ffffff;
}

.users-table thead {
	background: #d4af37;
	color: #2c2c2c;
}

.users-table th, .users-table td {
	padding: 12px 15px;
	text-align: left;
	border-bottom: 1px solid #f0f0f0;
	font-size: 0.9rem;
}

.users-table th {
	font-weight: 600;
	text-transform: uppercase;
	letter-spacing: 0.5px;
	font-size: 0.8rem;
}

.users-table tbody tr:hover {
	background-color: #fafaf9;
}

.users-table tbody tr:nth-child(even) {
	background-color: #f9f9f9;
}

/* 버튼 스타일 */
.btn-small {
	padding: 4px 8px;
	border: 1px solid;
	border-radius: 2px;
	font-size: 0.75rem;
	font-weight: 500;
	cursor: pointer;
	transition: all 0.2s ease;
	margin: 0 2px;
	background: transparent;
}

.btn-view {
	color: #3498db;
	border-color: #3498db;
}

.btn-view:hover {
	background: #3498db;
	color: #ffffff;
}

.btn-delete {
	color: #e74c3c;
	border-color: #e74c3c;
}

.btn-delete:hover {
	background: #e74c3c;
	color: #ffffff;
}

/* 상태 배지 */
.status-badge {
	padding: 3px 8px;
	border-radius: 10px;
	font-size: 0.7rem;
	font-weight: 600;
}

.status-approved {
	background: #d4edda;
	color: #155724;
}

.status-pending {
	background: #fff3cd;
	color: #856404;
}

.status-rejected {
	background: #f8d7da;
	color: #721c24;
}

/* 선호도 태그 */
.pref-tag {
	background: #d4af37;
	color: #2c2c2c;
	padding: 2px 6px;
	border-radius: 8px;
	font-size: 0.7rem;
	margin: 1px;
	display: inline-block;
}

/* 모달 스타일 */
.modal {
	display: none;
	position: fixed;
	z-index: 99999;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.5);
}

.modal-content {
	background-color: #ffffff;
	margin: 15% auto;
	padding: 0;
	border-radius: 8px;
	width: 90%;
	max-width: 500px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
	overflow: hidden;
}

.modal-header {
	background: #d4af37;
	color: #2c2c2c;
	padding: 20px 30px;
	margin: 0;
	border-bottom: none;
}

.modal-title {
	font-family: 'Crimson Text', serif;
	font-size: 1.4rem;
	font-weight: 600;
	margin: 0;
}

.modal-body {
	padding: 30px;
	margin: 0;
}

.detail-row {
	display: flex;
	align-items: center;
	margin-bottom: 15px;
	padding: 10px 0;
	border-bottom: 1px solid #f0f0f0;
}

.detail-row:last-child {
	border-bottom: none;
	margin-bottom: 0;
}

.detail-label {
	font-weight: 600;
	color: #333;
	width: 140px;
	flex-shrink: 0;
	font-size: 0.95rem;
}

.detail-value {
	color: #555;
	flex: 1;
	font-size: 0.95rem;
}

.no-preferences {
	text-align: center;
	color: #888;
	padding: 40px 20px;
	font-style: italic;
	background: #f8f9fa;
	border-radius: 8px;
	border: 2px dashed #ddd;
}

.no-preferences .emoji {
	font-size: 2rem;
	margin-bottom: 15px;
	display: block;
}

.no-preferences .message {
	font-size: 1rem;
	color: #666;
	margin-bottom: 10px;
}

.no-preferences .sub-message {
	font-size: 0.85rem;
	color: #999;
	line-height: 1.4;
}

.modal-footer {
	padding: 20px 30px;
	text-align: right;
	background: #f8f9fa;
	border-top: 1px solid #f0f0f0;
}

.modal-close {
	background: #d4af37;
	color: #2c2c2c;
	border: none;
	padding: 10px 20px;
	border-radius: 4px;
	cursor: pointer;
	font-family: 'Source Sans Pro', sans-serif;
	font-weight: 500;
	font-size: 0.9rem;
	transition: all 0.3s ease;
}

.modal-close:hover {
	background: #c9a96e;
	transform: translateY(-1px);
}

.actions {
	text-align: center;
	white-space: nowrap;
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
@media (max-width: 768px) {
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
	.main-container {
		padding: 0 20px;
	}
	.users-table {
		font-size: 0.8rem;
	}
	.users-table th, .users-table td {
		padding: 8px 6px;
	}
	.btn-small {
		font-size: 0.7rem;
		padding: 3px 6px;
	}
	.modal-content {
		margin: 5% auto;
		padding: 20px;
	}
	.detail-row {
		flex-direction: column;
	}
	.detail-label {
		width: auto;
		margin-bottom: 5px;
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
			<h1 class="page-title">👥 회원 관리</h1>
			<p class="page-subtitle">일반 회원과 사업자 회원 관리</p>
		</div>
		<div class="nav-tabs">
			<a href="/catchtable/admin/dashboard" class="nav-tab">Dashboard</a> <a
				href="/catchtable/admin/restaurants" class="nav-tab">Restaurants</a>
			<a href="/catchtable/admin/categories" class="nav-tab">Categories</a>
			<a href="/catchtable/admin/approve-business" class="nav-tab">Business Approval</a> 
				<a href="/catchtable/admin/coupons" class="nav-tab">Coupons</a>
			<a href="/catchtable/admin/users" class="nav-tab active">Users</a>
		</div>
		<!-- 탭 버튼 -->
		<div class="filter-tabs">
			<button class="tab-btn active" onclick="showTable('normal')">일반
				회원</button>
			<button class="tab-btn" onclick="showTable('business')">사업자
				회원</button>
		</div>

		<!-- 회원 목록 -->
		<div class="users-section">
			<div class="section-header">
				<h2 class="section-title">등록된 회원</h2>
				<p class="section-description">회원 정보를 확인하고 관리할 수 있습니다</p>
			</div>

			<div class="table-container">
				<!-- 일반 회원 테이블 -->
				<table class="users-table" id="normalTable">
					<thead>
						<tr>
							<th>이름</th>
							<th>이메일</th>
							<th>전화번호</th>
							<th>성별</th>
							<th>생년월일</th>
							<th>예약횟수</th>
							<th>가입일</th>
							<th>관리</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="user" items="${normalUsers}">
							<tr>
								<td>${user.name}</td>
								<td>${user.email}</td>
								<td>${user.phone}</td>
								<td><c:choose>
										<c:when test="${user.gender == 'M'}">남성</c:when>
										<c:when test="${user.gender == 'F'}">여성</c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>
								<td>${user.birthDate}</td>
								<td>${user.reservationCount}회</td>
								<td><c:choose>
										<c:when test="${user.createdAt != null}">
                                            ${user.createdAt.toString().substring(0, 16).replace('T', ' ')}
                                        </c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>
								<td class="actions">
									<!-- 모든 사용자에게 선호도 버튼 표시 -->
									<button class="btn-small btn-view"
										onclick="showUserPreferences(${user.userId}, '${user.name}')">
										선호도</button>
									<button class="btn-small btn-delete"
										onclick="deleteUser(${user.userId}, '${user.name}')">삭제</button>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>

				<!-- 사업자 회원 테이블 -->
				<table class="users-table" id="businessTable" style="display: none;">
					<thead>
						<tr>
							<th>이름</th>
							<th>이메일</th>
							<th>사업자등록번호</th>
							<th>가입일</th>
							<th>승인상태</th>
							<th>관리</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="user" items="${businessUsers}">
							<tr>
								<td>${user.name}</td>
								<td>${user.email}</td>
								<td>${user.businessLicenseNumber}</td>
								<td><c:choose>
										<c:when test="${user.createdAt != null}">
                                            ${user.createdAt.toString().substring(0, 16).replace('T', ' ')}
                                        </c:when>
										<c:otherwise>-</c:otherwise>
									</c:choose></td>
								<td><span
									class="status-badge status-${user.approvalStatus.toLowerCase()}">
										<c:choose>
											<c:when test="${user.approvalStatus == 'APPROVED'}">승인됨</c:when>
											<c:when test="${user.approvalStatus == 'PENDING'}">대기중</c:when>
											<c:when test="${user.approvalStatus == 'REJECTED'}">거절됨</c:when>
											<c:otherwise>${user.approvalStatus}</c:otherwise>
										</c:choose>
								</span></td>
								<td class="actions">
									<button class="btn-small btn-delete"
										onclick="deleteUser(${user.userId}, '${user.name}')">삭제</button>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
	</div>

	<!-- 상세보기 모달 -->
	<div id="userModal" class="modal">
		<div class="modal-content">
			<div class="modal-header">
				<h3 class="modal-title" id="modalTitle">선호도 정보</h3>
			</div>
			<div class="modal-body" id="modalBody">
				<!-- 선호도 정보가 여기에 표시됩니다 -->
			</div>
			<div class="modal-footer">
				<button class="modal-close" onclick="closeModal()">닫기</button>
			</div>
		</div>
	</div>

	<!-- 푸터 -->
	<%@ include file="/WEB-INF/views/footer.jsp"%>

	<script>
        // 테이블 전환
        function showTable(type) {
            // 탭 버튼 활성화
            document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');
            
            // 테이블 표시/숨김
            const normalTable = document.getElementById('normalTable');
            const businessTable = document.getElementById('businessTable');
            
            if (type === 'normal') {
                normalTable.style.display = 'table';
                businessTable.style.display = 'none';
            } else {
                normalTable.style.display = 'none';
                businessTable.style.display = 'table';
            }
        }
        
        // 사용자 선호도 조회 및 표시
        function showUserPreferences(userId, userName) {
            // AJAX로 선호도 정보 조회
            fetch('/catchtable/admin/users/' + userId + '/preferences')
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        displayPreferences(data.data.userName, data.data.preferences);
                    } else {
                        alert('선호도 조회 실패: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('선호도 조회 중 오류가 발생했습니다.');
                });
        }
        
        // 선호도 정보 모달에 표시
        function displayPreferences(userName, preferences) {
            const modalTitle = document.getElementById('modalTitle');
            const modalBody = document.getElementById('modalBody');
            
            modalTitle.textContent = userName + ' 님의 선호도 정보';
            
            let modalContent = '';
            let hasPreferences = false;
            
            if (preferences) {
                // 선호 가격대
                if (preferences.preferredPriceRange) {
                    hasPreferences = true;
                    let priceText = '';
                    let priceEmoji = '';
                    switch(preferences.preferredPriceRange) {
                        case 'LOW': 
                            priceText = '저렴한 (1만원 이하)'; 
                            priceEmoji = '💰';
                            break;
                        case 'MEDIUM': 
                            priceText = '보통 (1-3만원)'; 
                            priceEmoji = '💰💰';
                            break;
                        case 'HIGH': 
                            priceText = '고급 (3만원 이상)'; 
                            priceEmoji = '💰💰💰';
                            break;
                        default: 
                            priceText = preferences.preferredPriceRange;
                            priceEmoji = '💰';
                    }
                    
                    modalContent += '<div class="detail-row">';
                    modalContent += '<div class="detail-label">' + priceEmoji + ' 선호 가격대:</div>';
                    modalContent += '<div class="detail-value">' + priceText + '</div>';
                    modalContent += '</div>';
                }
                
                // 선호 음식
                if (preferences.preferredCuisineTypes) {
                    hasPreferences = true;
                    const cuisineArray = preferences.preferredCuisineTypes.split(',');
                    let cuisineHtml = '';
                    cuisineArray.forEach(function(cuisine) {
                        if (cuisine && cuisine.trim()) {
                            cuisineHtml += '<span class="pref-tag">' + cuisine.trim() + '</span> ';
                        }
                    });
                    
                    modalContent += '<div class="detail-row">';
                    modalContent += '<div class="detail-label">🍽️ 선호 음식:</div>';
                    modalContent += '<div class="detail-value">' + cuisineHtml + '</div>';
                    modalContent += '</div>';
                }
                
                // 선호 지역
                if (preferences.preferredArea) {
                    hasPreferences = true;
                    modalContent += '<div class="detail-row">';
                    modalContent += '<div class="detail-label">📍 선호 지역:</div>';
                    modalContent += '<div class="detail-value">' + preferences.preferredArea + '</div>';
                    modalContent += '</div>';
                }
            }
            
            // 선호도가 없는 경우
            if (!hasPreferences) {
                modalContent = '<div class="no-preferences">';
                modalContent += '<span class="emoji">🍽️</span>';
                modalContent += '<div class="message">아직 설정된 선호도가 없습니다.</div>';
                modalContent += '<div class="sub-message">';
                modalContent += '사용자가 마이페이지에서 선호도를 설정하면<br>';
                modalContent += '여기에 음식 종류, 가격대, 지역 정보가 표시됩니다.';
                modalContent += '</div>';
                modalContent += '</div>';
            }
            
            modalBody.innerHTML = modalContent;
            document.getElementById('userModal').style.display = 'block';
        }
        
        // 모달 닫기
        function closeModal() {
            document.getElementById('userModal').style.display = 'none';
        }
        
        // 모달 외부 클릭시 닫기
        window.onclick = function(event) {
            const modal = document.getElementById('userModal');
            if (event.target === modal) {
                closeModal();
            }
        }
        
        // 사용자 삭제
        function deleteUser(userId, userName) {
            if (confirm(userName + '님을 삭제하시겠습니까?')) {
                fetch('/catchtable/admin/users/' + userId, {
                    method: 'DELETE',
                    headers: { 'Accept': 'application/json' }
                })
                .then(response => response.json())
                .then(data => {
                    alert(data.message || '삭제되었습니다.');
                    location.reload();
                })
                .catch(error => alert('삭제 실패: ' + error.message));
            }
        }
    </script>
</body>
</html>