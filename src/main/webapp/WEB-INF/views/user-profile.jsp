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
<title>My Profile - Catch Table</title>
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

.container {
	max-width: 1200px;
	margin: 30px auto;
	padding: 0 20px;
	display: grid;
	grid-template-columns: 1fr;
	gap: 25px;
}

.card {
	background: #ffffff;
	border-radius: 8px;
	padding: 25px;
	box-shadow: 0 15px 35px rgba(0, 0, 0, 0.08);
	border: 1px solid rgba(0, 0, 0, 0.02);
}

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
}

.profile-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 30px;
}

.info-section {
	background: #f8f6f3;
	padding: 25px;
	border-radius: 8px;
}

.info-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 15px;
	margin-bottom: 25px;
}

.info-item {
	padding: 15px;
	background: #ffffff;
	border: 1px solid #f5f3f0;
	border-radius: 6px;
}

.info-label {
	font-size: 0.8rem;
	font-weight: 600;
	color: #888;
	margin-bottom: 6px;
	text-transform: uppercase;
	letter-spacing: 0.5px;
}

.info-value {
	font-size: 1rem;
	color: #2c2c2c;
	font-weight: 500;
}

.preferences-grid {
	display: grid;
	grid-template-columns: 1fr 1fr 1fr; 
	gap: 15px;
	margin-bottom: 20px;
}

.btn-group {
	display: flex;
	gap: 15px;
	justify-content: center;
	margin-top: 20px;
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
	max-width: 500px;
	box-shadow: 0 20px 50px rgba(0, 0, 0, 0.2);
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
	margin-bottom: 20px;
	text-align: center;
	border-bottom: 2px solid #d4af37;
	padding-bottom: 10px;
}

.form-group {
	margin-bottom: 20px;
}

.form-label {
	display: block;
	margin-bottom: 8px;
	font-weight: 600;
	color: #2c2c2c;
}

.form-input, .form-select {
	width: 100%;
	padding: 12px 15px;
	border: 1px solid #e8e6e3;
	border-radius: 6px;
	font-size: 1rem;
	font-family: 'Source Sans Pro', sans-serif;
	background: #fafaf9;
	color: #2c2c2c;
}

.form-input:focus, .form-select:focus {
	outline: none;
	border-color: #d4af37;
	background: #ffffff;
	box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
}

.modal-actions {
	display: flex;
	gap: 15px;
	justify-content: center;
	margin-top: 25px;
}

.btn-modal-cancel {
	background: #95a5a6;
	color: #ffffff;
	border: 1px solid #95a5a6;
	padding: 10px 20px;
}

.btn-modal-confirm {
	background: #d4af37;
	color: #ffffff;
	border: 1px solid #d4af37;
	padding: 10px 20px;
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
		padding: 0 15px;
	}
	.header {
		padding: 30px 20px;
	}
	.title {
		font-size: 2rem;
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
	.profile-grid {
		grid-template-columns: 1fr;
	}
	.info-grid {
		grid-template-columns: 1fr;
	}
	.btn-group {
		flex-direction: column;
	}
	.card {
		padding: 20px;
	}
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/navi.jsp"%>

	<div class="container">
		<!-- 헤더 -->
		<div class="header card">
			<h1 class="title">My Profile</h1>
			<p class="subtitle">개인 정보 및 설정을 관리하세요</p>
		</div>

		<!-- 네비게이션 -->
		<div class="nav-tabs">
			<a href="/catchtable/user/profile" class="nav-tab active">My Profile</a>
			<a href="/catchtable/user/reservations" class="nav-tab">My Reservations</a> 
			<a href="/catchtable/user/reviews" class="nav-tab">My Reviews</a>
			<a href="/catchtable/user/coupons" class="nav-tab">My Coupons</a>
			<a href="/catchtable/user/favorites" class="nav-tab">My Favorites</a>
		</div>

		<!-- 프로필 정보 -->
		<div class="card">
			<h2 class="section-title">기본 정보</h2>

			<div class="info-grid">
				<div class="info-item">
					<div class="info-label">이름</div>
					<div class="info-value">${user.name}</div>
				</div>
				<div class="info-item">
					<div class="info-label">이메일</div>
					<div class="info-value">${user.email}</div>
				</div>
				<div class="info-item">
					<div class="info-label">전화번호</div>
					<div class="info-value">${user.phone}</div>
				</div>
				<div class="info-item">
					<div class="info-label">생년월일</div>
					<div class="info-value">
						<c:choose>
							<c:when test="${not empty user.createdAt}">
        ${user.createdAt.toString().substring(0, 10)}
    </c:when>
							<c:otherwise>미설정</c:otherwise>
						</c:choose>
					</div>
				</div>
				<div class="info-item">
					<div class="info-label">성별</div>
					<div class="info-value">
						<c:choose>
							<c:when test="${user.gender == 'M'}">남성</c:when>
							<c:when test="${user.gender == 'F'}">여성</c:when>
							<c:otherwise>미설정</c:otherwise>
						</c:choose>
					</div>
				</div>
				<div class="info-item">
					<div class="info-label">가입일</div>
					<div class="info-value">
						<c:choose>
							<c:when test="${not empty user.createdAt}">
                ${user.createdAt.toString().substring(0, 10)}
            </c:when>
							<c:otherwise>미설정</c:otherwise>
						</c:choose>
					</div>
				</div>
			</div>

			<div class="btn-group">
				<button class="btn btn-primary" onclick="showEditModal()">
					정보 수정</button>
				<button class="btn btn-secondary" onclick="showPasswordModal()">
					비밀번호 변경</button>
			</div>
		</div>

		<!-- 선호도 정보 -->
		<div class="card">
			<h2 class="section-title">선호도 설정</h2>

			<div class="preferences-grid">
				<div class="info-item">
					<div class="info-label">선호 음식 종류</div>
					<div class="info-value">
						<c:choose>
							<c:when test="${not empty preferences.preferredCuisineTypes}">
                                ${preferences.preferredCuisineTypes}
                            </c:when>
							<c:otherwise>미설정</c:otherwise>
						</c:choose>
					</div>
				</div>
				<div class="info-item">
					<div class="info-label">선호 가격대</div>
					<div class="info-value">
						<c:choose>
							<c:when test="${preferences.preferredPriceRange == 'LOW'}">저가 (1-2만원)</c:when>
							<c:when test="${preferences.preferredPriceRange == 'MEDIUM'}">중가 (2-5만원)</c:when>
							<c:when test="${preferences.preferredPriceRange == 'HIGH'}">고가 (5만원 이상)</c:when>
							<c:otherwise>미설정</c:otherwise>
						</c:choose>
					</div>
				</div>
				<div class="info-item">
					<div class="info-label">선호 지역</div>
					<div class="info-value">
						<c:choose>
							<c:when test="${not empty preferences.preferredArea}">
                                ${preferences.preferredArea}
                            </c:when>
							<c:otherwise>미설정</c:otherwise>
						</c:choose>
					</div>
				</div>
			</div>

			<div class="btn-group">
				<button class="btn btn-primary" onclick="showPreferencesModal()">
					선호도 설정</button>
			</div>
		</div>
	</div>

	<!-- 프로필 수정 모달 -->
	<div id="editModal" class="modal">
		<div class="modal-content">
			<h3 class="modal-title">프로필 정보 수정</h3>
			<form id="editForm">
				<div class="form-group">
					<label class="form-label">이름</label> <input type="text"
						id="editName" class="form-input" value="${user.name}">
				</div>
				<div class="form-group">
					<label class="form-label">이메일</label> <input type="email"
						id="editEmail" class="form-input" value="${user.email}">
				</div>
				<div class="form-group">
					<label class="form-label">전화번호</label> <input type="tel"
						id="editPhone" class="form-input" value="${user.phone}">
				</div>
				<div class="modal-actions">
					<button type="button" class="btn btn-modal-cancel"
						onclick="closeEditModal()">취소</button>
					<button type="button" class="btn btn-modal-confirm"
						onclick="updateProfile()">저장</button>
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
					<label class="form-label">현재 비밀번호</label> <input type="password"
						id="currentPassword" class="form-input">
				</div>
				<div class="form-group">
					<label class="form-label">새 비밀번호</label> <input type="password"
						id="newPassword" class="form-input">
				</div>
				<div class="form-group">
					<label class="form-label">새 비밀번호 확인</label> <input type="password"
						id="confirmPassword" class="form-input">
				</div>
				<div class="modal-actions">
					<button type="button" class="btn btn-modal-cancel"
						onclick="closePasswordModal()">취소</button>
					<button type="button" class="btn btn-modal-confirm"
						onclick="changePassword()">변경</button>
				</div>
			</form>
		</div>
	</div>

	<!-- 선호도 설정 모달 -->
	<div id="preferencesModal" class="modal">
		<div class="modal-content">
			<h3 class="modal-title">선호도 설정</h3>
			<form id="preferencesForm">
				<div class="form-group">
					<label class="form-label">선호 음식 종류</label> <input type="text"
						id="preferredCuisineTypes" class="form-input"
						value="${preferences.preferredCuisineTypes}"
						placeholder="한식, 양식, 중식 등">
				</div>
				<div class="form-group">
					<label class="form-label">선호 가격대</label> <select
						id="preferredPriceRange" class="form-select">
						<option value="">선택해주세요</option>
						<option value="LOW"
							<c:if test="${preferences.preferredPriceRange == 'LOW'}">selected</c:if>>저가
							(1-2만원)</option>
						<option value="MEDIUM"
							<c:if test="${preferences.preferredPriceRange == 'MEDIUM'}">selected</c:if>>중가
							(2-5만원)</option>
						<option value="HIGH"
							<c:if test="${preferences.preferredPriceRange == 'HIGH'}">selected</c:if>>고가
							(5만원 이상)</option>
					</select>
				</div>
				<div class="form-group">
					<label class="form-label">선호 지역</label> <input type="text"
						id="preferredArea" class="form-input"
						value="${preferences.preferredArea}" placeholder="강남구, 서초구 등">
				</div>
				<div class="modal-actions">
					<button type="button" class="btn btn-modal-cancel"
						onclick="closePreferencesModal()">취소</button>
					<button type="button" class="btn btn-modal-confirm"
						onclick="updatePreferences()">저장</button>
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

        function showPreferencesModal() {
            document.getElementById('preferencesModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
        }

        function closePreferencesModal() {
            document.getElementById('preferencesModal').style.display = 'none';
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
            
            fetch('/catchtable/user/profile/update', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(data)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast('프로필이 업데이트되었습니다.');
                    closeEditModal();
                    setTimeout(() => location.reload(), 1000);
                } else {
                    showToast(data.message || '업데이트 실패', 'error');
                }
            })
            .catch(() => {
                showToast('네트워크 오류가 발생했습니다.', 'error');
            });
        }

        function updatePreferences() {
            var data = {
                preferredCuisineTypes: document.getElementById('preferredCuisineTypes').value,
                preferredPriceRange: document.getElementById('preferredPriceRange').value,
                preferredArea: document.getElementById('preferredArea').value
            };
            
            fetch('/catchtable/user/profile/update', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(data)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast('선호도 설정이 저장되었습니다.');
                    closePreferencesModal();
                    setTimeout(() => location.reload(), 1000);
                } else {
                    showToast(data.message || '저장 실패', 'error');
                }
            })
            .catch(() => {
                showToast('네트워크 오류가 발생했습니다.', 'error');
            });
        }

        function changePassword() {
            
            var current = document.getElementById('currentPassword').value;
            var newPwd = document.getElementById('newPassword').value;
            var confirm = document.getElementById('confirmPassword').value;
            
            
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
            
            
            var requestUrl = '${pageContext.request.contextPath}/user/profile/password';
            
            fetch(requestUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: JSON.stringify({
                    currentPassword: current,
                    newPassword: newPwd
                })
            })
            .then(response => {
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    showToast('비밀번호가 변경되었습니다.');
                    closePasswordModal();
                } else {
                    showToast(data.message || '비밀번호 변경 실패', 'error');
                }
            })
            .catch(error => {
                showToast('네트워크 오류가 발생했습니다.', 'error');
            });
        }
        window.onclick = function(event) {
            var editModal = document.getElementById('editModal');
            var passwordModal = document.getElementById('passwordModal');
            var preferencesModal = document.getElementById('preferencesModal');
            
            if (event.target === editModal) closeEditModal();
            if (event.target === passwordModal) closePasswordModal();
            if (event.target === preferencesModal) closePreferencesModal();
        };

        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeEditModal();
                closePasswordModal();
                closePreferencesModal();
            }
        });
    </script>
</body>
</html>
