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
<title>Business Profile - Catch Table</title>
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
}

.container {
	max-width: 1200px;
	margin: 40px auto;
	padding: 0 20px;
	display: grid;
	grid-template-columns: 2fr 1fr;
	gap: 30px;
}

.card {
	background: #ffffff;
	border-radius: 8px;
	padding: 30px;
	box-shadow: 0 15px 35px rgba(0, 0, 0, 0.08);
	border: 1px solid rgba(0, 0, 0, 0.02);
}

.header {
	grid-column: 1/-1;
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

.nav-tabs {
	display: flex;
	background: #ffffff;
	border-radius: 8px;
	overflow: hidden;
	box-shadow: 0 8px 20px rgba(0, 0, 0, 0.04);
	margin: 20px 0;
	grid-column: 1/-1;
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

.section-title {
	font-family: 'Crimson Text', serif;
	font-size: 1.8rem;
	color: #2c2c2c;
	margin-bottom: 25px;
	border-bottom: 2px solid #d4af37;
	padding-bottom: 10px;
	position: relative;
}

.info-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 20px;
	margin-bottom: 30px;
}

.info-item {
	padding: 20px;
	background: #fafaf9;
	border: 1px solid #f5f3f0;
	border-radius: 6px;
}

.info-label {
	font-size: 0.85rem;
	font-weight: 600;
	color: #888;
	margin-bottom: 8px;
	text-transform: uppercase;
	letter-spacing: 0.5px;
}

.info-value {
	font-size: 1.1rem;
	color: #2c2c2c;
	font-weight: 500;
}
/* 통계 카드  */
.stats-container {
	background: #ffffff;
	border-radius: 12px;
	overflow: hidden;
	box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
	border: 1px solid rgba(0, 0, 0, 0.02);
}

.stat-row {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 25px 30px;
	border-bottom: 1px solid #f5f3f0;
}

.stat-row:last-child {
	border-bottom: none;
}

.stat-info {
	display: flex;
	flex-direction: column;
}

.stat-row .stat-label {
	font-size: 1rem;
	color: #2c2c2c;
	font-weight: 500;
	margin-bottom: 5px;
}

.stat-description {
	font-size: 0.85rem;
	color: #888;
	font-weight: 400;
}

.stat-row .stat-number {
	font-family: 'Crimson Text', serif;
	font-size: 2rem;
	font-weight: 700;
	color: #d4af37;
	margin: 0;
}

/* 반응형 */
@media ( max-width : 768px) {
	.stat-row {
		padding: 20px 20px;
		flex-direction: column;
		text-align: center;
		gap: 10px;
	}
	.stat-info {
		align-items: center;
	}
	.stat-row .stat-number {
		font-size: 1.8rem;
	}
}

@media ( max-width : 480px) {
	.stat-row {
		padding: 15px;
	}
	.stat-row .stat-number {
		font-size: 1.6rem;
	}
}

.btn-group {
	display: flex;
	gap: 15px;
	justify-content: center;
	margin-top: 25px;
}

.btn {
	padding: 12px 24px;
	border: none;
	border-radius: 6px;
	font-family: 'Source Sans Pro', sans-serif;
	font-size: 0.9rem;
	font-weight: 500;
	cursor: pointer;
	transition: all 0.3s ease;
	text-decoration: none;
	display: inline-flex;
	align-items: center;
	gap: 8px;
	text-transform: uppercase;
	letter-spacing: 0.5px;
}

.btn-primary {
	background: transparent;
	color: #d4af37;
	border: 1px solid #d4af37;
}

.btn-primary:hover {
	background: #d4af37;
	color: #ffffff;
	transform: translateY(-2px);
}

.btn-secondary {
	background: transparent;
	color: #d4af37;
	border: 1px solid #d4af37;
}

.btn-secondary:hover {
	background: #d4af37;
	color: #ffffff;
	transform: translateY(-2px);
}

.modal {
	display: none;
	position: fixed;
	z-index: 1000;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	background: rgba(44, 44, 44, 0.6);
	backdrop-filter: blur(5px);
}

.modal-content {
	background: #ffffff;
	margin: 8% auto;
	padding: 35px;
	border-radius: 10px;
	width: 90%;
	max-width: 450px;
	box-shadow: 0 20px 50px rgba(0, 0, 0, 0.2);
	border: 1px solid rgba(212, 175, 55, 0.2);
	animation: modalSlideIn 0.3s ease-out;
}

@
keyframes modalSlideIn {from { transform:translateY(-30px);
	opacity: 0;
}

to {
	transform: translateY(0);
	opacity: 1;
}

}
.modal-title {
	font-family: 'Crimson Text', serif;
	font-size: 1.6rem;
	color: #2c2c2c;
	margin-bottom: 25px;
	text-align: center;
	border-bottom: 2px solid #d4af37;
	padding-bottom: 10px;
}

.form-group {
	margin-bottom: 20px;
}

.form-label {
	display: block;
	font-size: 0.9rem;
	font-weight: 500;
	color: #2c2c2c;
	margin-bottom: 8px;
}

.form-input {
	width: 100%;
	padding: 12px 15px;
	border: 1px solid #e8e6e3;
	border-radius: 6px;
	font-size: 1rem;
	font-family: 'Source Sans Pro', sans-serif;
	background: #fafaf9;
	color: #2c2c2c;
	transition: all 0.3s ease;
}

.form-input:focus {
	outline: none;
	border-color: #d4af37;
	background: #ffffff;
	box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
	transform: translateY(-1px);
}

.modal-actions {
	display: flex;
	gap: 15px;
	justify-content: center;
	margin-top: 30px;
}

.btn-cancel {
	background: #95a5a6;
	color: #ffffff;
	border: 1px solid #95a5a6;
}

.btn-cancel:hover {
	background: #7f8c8d;
	border-color: #7f8c8d;
}

.toast {
	position: fixed;
	top: 20px;
	right: 20px;
	z-index: 10000;
	padding: 15px 20px;
	border-radius: 6px;
	color: white;
	font-weight: 500;
	box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
	animation: toastSlideIn 0.3s ease;
	max-width: 350px;
}

.toast-success {
	background: linear-gradient(135deg, #27ae60, #2ecc71);
}

.toast-error {
	background: linear-gradient(135deg, #e74c3c, #c0392b);
}

@
keyframes toastSlideIn {from { transform:translateX(100%);
	opacity: 0;
}

to {
	transform: translateX(0);
	opacity: 1;
}

}
@media ( max-width : 768px) {
	.container {
		grid-template-columns: 1fr;
		gap: 20px;
		padding: 0 15px;
	}
	.header {
		padding: 30px 20px;
	}
	.title {
		font-size: 2rem;
	}
	.info-grid {
		grid-template-columns: 1fr;
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
	.btn-group {
		flex-direction: column;
	}
	.stats-grid {
		grid-template-columns: 1fr;
		gap: 15px;
	}
	.modal-content {
		margin: 15% auto;
		padding: 25px;
	}
}

@media ( max-width : 480px) {
	.stats-grid {
		grid-template-columns: repeat(2, 1fr);
		gap: 12px;
	}
	.stat-number {
		font-size: 1.8rem;
	}
	.stat-item {
		padding: 15px;
	}
}
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/navi.jsp"%>

<div class="container">
	<!-- 헤더 -->
	<div class="header card">
		<h1 class="title">Business Dashboard</h1>
		<p class="subtitle">사업자 계정 관리 및 현황을 확인하실 수 있습니다</p>
	</div>

	<!-- 네비게이션 -->
	<div class="nav-tabs">
		<a href="/catchtable/business/profile" class="nav-tab active">Business Profile</a> 
		<a href="/catchtable/business/restaurants" class="nav-tab">My Restaurants</a> 
		<a href="/catchtable/business/reservations" class="nav-tab">Reservations</a>
	</div>

	<!-- 프로필 정보 -->
	<div class="card">
		<h2 class="section-title">프로필 정보</h2>

		<div class="info-grid">
			<div class="info-item">
				<div class="info-label">사업자명</div>
				<div class="info-value">${businessUser.name}</div>
			</div>
			<div class="info-item">
				<div class="info-label">이메일</div>
				<div class="info-value">${businessUser.email}</div>
			</div>
			<div class="info-item">
				<div class="info-label">전화번호</div>
				<div class="info-value">${businessUser.phone}</div>
			</div>
			<div class="info-item">
				<div class="info-label">사업자등록번호</div>
				<div class="info-value">${businessUser.businessLicenseNumber}</div>
			</div>
		</div>

		<div class="btn-group">
			<button class="btn btn-primary" onclick="showEditModal()">
				✏️ 정보 수정
			</button>
			<button class="btn btn-secondary" onclick="showPasswordModal()">
				🔒 비밀번호 변경
			</button>
		</div>
	</div>

	<!-- 통계 (개별 카드로) -->
	<div class="card">
		<h2 class="section-title">현황 통계</h2>
		<div class="stats-container">
			<div class="stat-row">
				<div class="stat-info">
					<div class="stat-label">등록 식당</div>
					<div class="stat-description">현재 운영 중인 식당 수</div>
				</div>
				<div class="stat-number">${statistics.totalRestaurants}</div>
			</div>
			<div class="stat-row">
				<div class="stat-info">
					<div class="stat-label">총 예약</div>
					<div class="stat-description">전체 누적 예약 건수</div>
				</div>
				<div class="stat-number">${statistics.totalReservations}</div>
			</div>
			<div class="stat-row">
				<div class="stat-info">
					<div class="stat-label">총 조회수</div>
					<div class="stat-description">식당 페이지 조회 횟수</div>
				</div>
				<div class="stat-number">${statistics.totalViews}</div>
			</div>
			<div class="stat-row">
				<div class="stat-info">
					<div class="stat-label">총 좋아요</div>
					<div class="stat-description">고객들의 좋아요 수</div>
				</div>
				<div class="stat-number">${statistics.totalLikes}</div>
			</div>
			<div class="stat-row">
				<div class="stat-info">
					<div class="stat-label">평균 평점</div>
					<div class="stat-description">고객 만족도 평가</div>
				</div>
				<div class="stat-number">
					<c:set var="totalRating" value="0" />
					<c:set var="ratingCount" value="0" />
					<c:forEach var="restaurant" items="${restaurants}">
						<c:if test="${not empty restaurantRatings[restaurant.restaurantId] and restaurantRatings[restaurant.restaurantId] > 0}">
							<c:set var="totalRating" value="${totalRating + restaurantRatings[restaurant.restaurantId]}" />
							<c:set var="ratingCount" value="${ratingCount + 1}" />
						</c:if>
					</c:forEach>
					<c:choose>
						<c:when test="${ratingCount > 0}">
							<fmt:formatNumber value="${totalRating / ratingCount}" pattern="0.0" />
						</c:when>
						<c:otherwise>
							0.0
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
	</div> 
</div> 

<!-- 프로필 수정 모달 -->
<div id="editModal" class="modal">
	<div class="modal-content">
		<h3 class="modal-title">프로필 정보 수정</h3>
		<form id="editForm">
			<div class="form-group">
				<label class="form-label">사업자명</label> 
				<input type="text" id="editName" class="form-input" value="${businessUser.name}">
			</div>
			<div class="form-group">
				<label class="form-label">이메일</label> 
				<input type="email" id="editEmail" class="form-input" value="${businessUser.email}">
			</div>
			<div class="form-group">
				<label class="form-label">전화번호</label> 
				<input type="tel" id="editPhone" class="form-input" value="${businessUser.phone}">
			</div>
			<div class="modal-actions">
				<button type="button" class="btn btn-cancel" onclick="closeEditModal()">취소</button>
				<button type="button" class="btn btn-primary" onclick="updateProfile()">저장</button>
			</div>
		</form>
	</div>
</div>

<!-- 비밀번호 변경 모달 -->
<div id="passwordModal" class="modal">
	<div class="modal-content">
		<h3 class="modal-title">비밀번호 변경</h3>
		<form id="passwordForm">
			<div class="form-group">
				<label class="form-label">현재 비밀번호</label> 
				<input type="password" id="currentPassword" class="form-input">
			</div>
			<div class="form-group">
				<label class="form-label">새 비밀번호</label> 
				<input type="password" id="newPassword" class="form-input">
			</div>
			<div class="form-group">
				<label class="form-label">새 비밀번호 확인</label> 
				<input type="password" id="confirmPassword" class="form-input">
			</div>
			<div class="modal-actions">
				<button type="button" class="btn btn-cancel" onclick="closePasswordModal()">취소</button>
				<button type="button" class="btn btn-primary" onclick="changePassword()">변경</button>
			</div>
		</form>
	</div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp"%>
			<script>
        function showToast(message, type) {
            var toast = document.createElement('div');
            toast.className = 'toast toast-' + (type || 'success');
            toast.textContent = message;
            document.body.appendChild(toast);
            
            setTimeout(function() {
                toast.style.animation = 'slideOutRight 0.3s ease';
                setTimeout(function() {
                    if (document.body.contains(toast)) {
                        toast.remove();
                    }
                }, 300);
            }, 3000);
        }

        function showEditModal() {
            document.getElementById('editModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
        }

        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
            document.body.style.overflow = 'auto';
        }

        function showPasswordModal() {
            document.getElementById('passwordModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
            document.getElementById('currentPassword').value = '';
            document.getElementById('newPassword').value = '';
            document.getElementById('confirmPassword').value = '';
        }

        function closePasswordModal() {
            document.getElementById('passwordModal').style.display = 'none';
            document.body.style.overflow = 'auto';
        }

        function updateProfile() {
            var data = {
                name: document.getElementById('editName').value,
                email: document.getElementById('editEmail').value,
                phone: document.getElementById('editPhone').value
            };
            
            if (!data.name || !data.email || !data.phone) {
                showToast('모든 필드를 입력해주세요.', 'error');
                return;
            }
            
            var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(data.email)) {
                showToast('올바른 이메일 형식을 입력해주세요.', 'error');
                return;
            }
            
            fetch('/catchtable/business/profile/update', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(data)
            })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if (data.success) {
                    showToast('프로필이 업데이트되었습니다.');
                    closeEditModal();
                    setTimeout(function() { location.reload(); }, 1000);
                } else {
                    showToast(data.message || '업데이트 실패', 'error');
                }
            })
            .catch(function() {
                showToast('네트워크 오류가 발생했습니다.', 'error');
            });
        }

        function changePassword() {
            var current = document.getElementById('currentPassword').value;
            var newPwd = document.getElementById('newPassword').value;
            var confirm = document.getElementById('confirmPassword').value;
            
            // 클라이언트 검증
            if (!current || !newPwd || !confirm) {
                showToast('모든 필드를 입력해주세요.', 'error');
                return;
            }
            
            if (newPwd !== confirm) {
                showToast('새 비밀번호가 일치하지 않습니다.', 'error');
                return;
            }
            
            if (newPwd.length < 6) {
                showToast('비밀번호는 6자 이상이어야 합니다.', 'error');
                return;
            }
            
            if (current === newPwd) {
                showToast('새 비밀번호는 현재 비밀번호와 달라야 합니다.', 'error');
                return;
            }
            
            console.log('비밀번호 변경 요청 시작...');
            
            fetch('/catchtable/business/profile/password', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: JSON.stringify({
                    currentPassword: current,
                    newPassword: newPwd,
                    confirmPassword: confirm
                })
            })
            .then(function(response) {
                console.log('응답 상태:', response.status);
                console.log('응답 헤더:', response.headers);
                
                if (!response.ok) {
                    throw new Error('HTTP 오류! 상태: ' + response.status);
                }
                
                var contentType = response.headers.get('content-type');
                if (!contentType || !contentType.includes('application/json')) {
                    console.warn('JSON이 아닌 응답을 받았습니다:', contentType);
                    return response.text().then(function(text) {
                        console.log('응답 내용:', text);
                        throw new Error('서버에서 JSON이 아닌 응답을 반환했습니다.');
                    });
                }
                
                return response.json();
            })
            .then(function(data) {
                console.log('서버 응답 데이터:', data);
                
                if (data && data.success === true) {
                    showToast(data.message || '비밀번호가 성공적으로 변경되었습니다.');
                    closePasswordModal();
                    
                    // 추가 확인을 위해 프로필 정보 새로고침
                    setTimeout(function() {
                        console.log('변경 완료 후 페이지 새로고침...');
                        location.reload();
                    }, 1500);
                } else {
                    var errorMsg = data && data.message ? data.message : '비밀번호 변경에 실패했습니다.';
                    console.error('서버 오류:', errorMsg);
                    showToast(errorMsg, 'error');
                }
            })
            .catch(function(error) {
                console.error('비밀번호 변경 중 오류 발생:', error);
                
                if (error.message.includes('HTTP 오류')) {
                    showToast('서버 연결에 문제가 있습니다. (HTTP 오류)', 'error');
                } else if (error.message.includes('JSON')) {
                    showToast('서버 응답 형식에 문제가 있습니다.', 'error');
                } else {
                    showToast('비밀번호 변경 중 예기치 않은 오류가 발생했습니다.', 'error');
                }
            });
        }

        // 모달 외부 클릭시 닫기
        window.onclick = function(event) {
            var editModal = document.getElementById('editModal');
            var passwordModal = document.getElementById('passwordModal');
            
            if (event.target === editModal) closeEditModal();
            if (event.target === passwordModal) closePasswordModal();
        };

        // ESC 키로 모달 닫기
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeEditModal();
                closePasswordModal();
            }
        });

        // JSP 메시지 처리
        <c:if test="${not empty error}">
            showToast('${error}', 'error');
        </c:if>
        
        <c:if test="${not empty message}">
            showToast('${message}', 'success');
        </c:if>
    </script>
</body>
</html>