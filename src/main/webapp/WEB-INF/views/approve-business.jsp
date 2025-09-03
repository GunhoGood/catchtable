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
<title>사업자 승인 관리 - Catch Table</title>
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

.approval-section {
	background: #ffffff;
	border-radius: 2px;
	box-shadow: 0 15px 40px rgba(0, 0, 0, 0.06);
	border: 1px solid rgba(0, 0, 0, 0.02);
	overflow: hidden;
	position: relative;
}

.approval-section::before {
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

.approval-list {
	padding: 35px;
}

.business-item {
	background: #fafaf9;
	border: 1px solid #ebe8e4;
	border-radius: 2px;
	padding: 25px;
	margin-bottom: 20px;
	transition: all 0.3s ease;
	position: relative;
}

.business-item:hover {
	transform: translateY(-2px);
	box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
	border-color: rgba(231, 76, 60, 0.3);
}

.business-header {
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
	margin-bottom: 20px;
}

.business-info h3 {
	font-family: 'Crimson Text', serif;
	font-size: 1.4rem;
	font-weight: 600;
	color: #2c2c2c;
	margin-bottom: 5px;
}

.business-email {
	color: #666;
	font-size: 0.9rem;
}

.status-badge {
	background: #f39c12;
	color: #2c2c2c;
	padding: 5px 12px;
	border-radius: 15px;
	font-size: 0.8rem;
	font-weight: 600;
	text-transform: uppercase;
	letter-spacing: 0.5px;
}

.business-details {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 15px 30px;
	margin-bottom: 20px;
}

.detail-item {
	font-size: 0.9rem;
	color: #555;
}

.detail-label {
	font-weight: 600;
	color: #333;
	margin-bottom: 3px;
}

.business-actions {
	display: flex;
	gap: 10px;
	flex-wrap: wrap;
	border-top: 1px solid #eee;
	padding-top: 20px;
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

.btn-approve {
	background: transparent;
	color: #27ae60;
	border: 1px solid #27ae60;
}

.btn-approve:hover {
	background: #27ae60;
	color: #ffffff;
}

.btn-reject {
	background: transparent;
	color: #e74c3c;
	border: 1px solid #e74c3c;
}

.btn-reject:hover {
	background: #e74c3c;
	color: #ffffff;
}

.btn-download {
	background: transparent;
	color: #3498db;
	border: 1px solid #3498db;
}

.btn-download:hover {
	background: #3498db;
	color: #ffffff;
}

.btn-cancel {
	background: transparent;
	color: #95a5a6;
	border: 1px solid #95a5a6;
}

.btn-cancel:hover {
	background: #95a5a6;
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

/* 거절 사유 모달 */
.modal {
	display: none;
	position: fixed;
	z-index: 1000;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.5);
}

.modal-content {
	background-color: #ffffff;
	margin: 15% auto;
	padding: 30px;
	border-radius: 4px;
	width: 90%;
	max-width: 500px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
}

.modal-header {
	margin-bottom: 20px;
}

.modal-title {
	font-size: 1.3rem;
	font-weight: 600;
	color: #2c2c2c;
}

.form-group {
	margin-bottom: 20px;
}

.form-label {
	display: block;
	font-size: 0.9rem;
	font-weight: 500;
	color: #333;
	margin-bottom: 8px;
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
	min-height: 100px;
}

.form-textarea:focus {
	outline: none;
	border-color: #e74c3c;
	background: #ffffff;
	box-shadow: 0 0 0 3px rgba(231, 76, 60, 0.1);
}

.modal-actions {
	display: flex;
	gap: 10px;
	justify-content: flex-end;
}

.btn-cancel {
	background: #95a5a6;
	color: #ffffff;
}

.btn-cancel:hover {
	background: #7f8c8d;
}

@media ( max-width : 768px) {
	body {
		padding-top: 70px;
	}
	.main-container {
		margin: 40px auto;
		padding: 0 20px;
	}
	.section-header {
		padding: 25px;
	}
	.approval-list {
		padding: 25px;
	}
	.business-details {
		grid-template-columns: 1fr;
		gap: 10px;
	}
	.business-actions {
		justify-content: center;
	}
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
.image-modal-content {
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
}
</style>
</head>
<body>
	<!-- 네비게이션 -->
	<%@ include file="/WEB-INF/views/navi.jsp"%>

	<div class="main-container">
		<!-- 페이지 헤더 -->
		<div class="page-header">
			<h1 class="page-title">사업자 승인 관리</h1>
			<p class="page-subtitle">사업자 등록 신청을 검토하고 승인/거절 처리를 할 수 있습니다</p>
		</div>
		<div class="nav-tabs">
			<a href="/catchtable/admin/dashboard" class="nav-tab">Dashboard</a> <a
				href="/catchtable/admin/restaurants" class="nav-tab">Restaurants</a>
			<a href="/catchtable/admin/categories" class="nav-tab">Categories</a>
			<a href="/catchtable/admin/approve-business" class="nav-tab active">Business
				Approval</a> <a href="/catchtable/admin/coupons" class="nav-tab">Coupons</a>
			<a href="/catchtable/admin/users" class="nav-tab">Users</a>
		</div>
		<!-- 승인 대기 목록 -->
		<div class="approval-section">
			<div class="section-header">
				<h2 class="section-title">승인 대기 목록</h2>
				<p class="section-description">
					승인 대기 중인 사업자 등록 신청 <strong>${pendingCount}건</strong>
				</p>
			</div>

			<div class="approval-list">
				<c:choose>
					<c:when test="${not empty pendingUsers}">
						<c:forEach var="user" items="${pendingUsers}">
							<div class="business-item">
								<div class="business-header">
									<div class="business-info">
										<h3>${user.name}</h3>
										<div class="business-email">${user.email}</div>
									</div>
									<div class="status-badge">대기중</div>
								</div>

								<div class="business-details">
									<div class="detail-item">
										<div class="detail-label">전화번호</div>
										<div>${user.phone}</div>
									</div>
									<div class="detail-item">
										<div class="detail-label">신청일시</div>
										<!-- LocalDateTime을 문자열로 변환 -->
										<div>${user.createdAt.toString().substring(0, 16).replace('T', ' ')}</div>
									</div>
									<div class="detail-item">
										<div class="detail-label">사업자등록번호</div>
										<div>${user.businessLicenseNumber}</div>
									</div>
									<div class="detail-item">
										<div class="detail-label">첨부파일</div>
										<div>
											<c:choose>
												<c:when test="${not empty user.businessLicenseImage}">
													<a
														href="${pageContext.request.contextPath}/uploads/business/${user.businessLicenseImage}"
														target="_blank"
														style="color: #3498db; text-decoration: underline;">
														${user.businessLicenseImage} </a>
												</c:when>
												<c:otherwise>
													<span style="color: #999;">없음</span>
												</c:otherwise>
											</c:choose>
										</div>
									</div>
								</div>

								<div class="business-actions">
									<button class="btn btn-approve"
										onclick="approveBusiness(${user.userId})">승인</button>
									<button class="btn btn-reject"
										onclick="showRejectModal(${user.userId}, '${user.name}')">거절</button>
									<c:if test="${not empty user.businessLicenseImage}">
										<button class="btn btn-download"
											onclick="showBusinessLicense('${user.businessLicenseImage}')">
											첨부파일 확인</button>
									</c:if>
								</div>
							</div>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<div class="empty-state">
							<div class="empty-icon">📋</div>
							<h3>승인 대기 중인 신청이 없습니다</h3>
							<p>모든 사업자 신청이 처리되었습니다.</p>
						</div>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>

	<!-- 거절 사유 입력 모달 -->
	<div id="rejectModal" class="modal">
		<div class="modal-content">
			<div class="modal-header">
				<h3 class="modal-title">사업자 등록 거절</h3>
			</div>
			<div class="form-group">
				<label class="form-label">거절 사유 (필수)</label>
				<textarea id="rejectionReason" class="form-textarea"
					placeholder="거절 사유를 상세히 입력해주세요.&#10;예: 사업자등록증 이미지가 불명확합니다."></textarea>
			</div>
			<div class="modal-actions">
				<button class="btn btn-cancel" onclick="closeRejectModal()">취소</button>
				<button class="btn btn-reject" onclick="confirmReject()">거절
					처리</button>
			</div>
		</div>
	</div>
	<div id="imageModal" class="modal">
		<div class="image-modal-content">
			<div class="image-modal-header">
				<span class="close-btn" onclick="closeImageModal()">&times;</span>
			</div>
			<div class="image-modal-body">
				<div class="image-container">
					<img id="modalImage" src="" alt="사업자 등록증" />
					<div class="image-loading" id="imageLoading">
						<div class="loading-spinner"></div>
						<p>이미지를 불러오는 중...</p>
					</div>
					<div class="image-error" id="imageError" style="display: none;">
						<p>❌ 이미지를 불러올 수 없습니다</p>
						<button class="btn btn-download" onclick="openInNewWindow()">새
							창에서 열기</button>
					</div>
				</div>
			</div>
			<div class="image-modal-footer">
				<button class="btn btn-cancel" onclick="closeImageModal()">닫기</button>
			</div>
		</div>
	</div>
	<!-- 푸터 -->
	<%@ include file="/WEB-INF/views/footer.jsp"%>

	<script>
        var currentUserId = null;
        var currentUserName = null;
        
        // 이미지 모달 관련 변수
        let currentImageUrl = '';
        let currentZoom = 1;
        
        // 승인 처리
        function approveBusiness(userId) {
            if (!confirm('이 사업자 등록을 승인하시겠습니까?')) {
                return;
            }
            
            fetch('/catchtable/admin/approve-business/' + userId, {
                method: 'POST',
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
                alert(data.message || '승인이 완료되었습니다.');
                location.reload();
            })
            .catch(function(error) {
                alert('승인 처리 중 오류가 발생했습니다: ' + error.message);
            });
        }
        
        // 거절 모달 표시
        function showRejectModal(userId, userName) {
            currentUserId = userId;
            currentUserName = userName;
            document.getElementById('rejectionReason').value = '';
            document.getElementById('rejectModal').style.display = 'block';
        }
        
        // 거절 모달 닫기
        function closeRejectModal() {
            document.getElementById('rejectModal').style.display = 'none';
            currentUserId = null;
            currentUserName = null;
        }
        
        // 거절 확인 처리
        function confirmReject() {
            var reason = document.getElementById('rejectionReason').value.trim();
            
            if (!reason) {
                alert('거절 사유를 입력해주세요.');
                return;
            }
            
            if (!confirm(currentUserName + '님의 사업자 등록을 거절하시겠습니까?')) {
                return;
            }
            
            var formData = new FormData();
            formData.append('rejectionReason', reason);
            
            fetch('/catchtable/admin/reject-business/' + currentUserId, {
                method: 'POST',
                body: formData
            })
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                return response.json();
            })
            .then(function(data) {
                alert(data.message || '거절 처리가 완료되었습니다.');
                closeRejectModal();
                location.reload();
            })
            .catch(function(error) {
                alert('거절 처리 중 오류가 발생했습니다: ' + error.message);
            });
        }
        
        // ===== 이미지 모달 관련 함수들 =====
        
        // 이미지 모달 열기
        function showImageModal(fileName) {
            const modal = document.getElementById('imageModal');
            const modalImage = document.getElementById('modalImage');
            const imageLoading = document.getElementById('imageLoading');
            const imageError = document.getElementById('imageError');
            
            // URL 생성
            currentImageUrl = '/catchtable/uploads/business/' + fileName;
            
            // 모달 표시
            modal.style.display = 'block';
            
            // 로딩 상태 표시
            imageLoading.style.display = 'flex';
            imageError.style.display = 'none';
            modalImage.style.display = 'none';
            
            // 이미지 로드
            modalImage.onload = function() {
                imageLoading.style.display = 'none';
                modalImage.style.display = 'block';
                resetZoom();
            };
            
            modalImage.onerror = function() {
                imageLoading.style.display = 'none';
                imageError.style.display = 'flex';
                modalImage.style.display = 'none';
            };
            
            modalImage.src = currentImageUrl;
            
            // 바디 스크롤 방지
            document.body.style.overflow = 'hidden';
        }
        
        // 이미지 모달 닫기
        function closeImageModal() {
            const modal = document.getElementById('imageModal');
            modal.style.display = 'none';
            document.body.style.overflow = 'auto';
            
            // 이미지 초기화
            const modalImage = document.getElementById('modalImage');
            modalImage.src = '';
            resetZoom();
        }
        
        
        // 사업자 등록증 보기 (메인 함수)
        function showBusinessLicense(fileName) {
            showImageModal(fileName);
        }
        
        // 모달 외부 클릭시 닫기 
        window.onclick = function(event) {
            var rejectModal = document.getElementById('rejectModal');
            var imageModal = document.getElementById('imageModal');
            
            if (event.target == rejectModal) {
                closeRejectModal();
            }
            if (event.target == imageModal) {
                closeImageModal();
            }
        }
        
        // 페이지 로드 완료
        document.addEventListener('DOMContentLoaded', function() {
            console.log('사업자 승인 관리 페이지 로드 완료');
            
            // 이미지 모달 이벤트 리스너 추가
            const modalImage = document.getElementById('modalImage');
            if (modalImage) {
                // 마우스 휠로 줌 조절
                modalImage.addEventListener('wheel', function(e) {
                    e.preventDefault();
                    
                    if (e.deltaY < 0) {
                        zoomIn();
                    } else {
                        zoomOut();
                    }
                });
            }
            
            // ESC 키로 모달 닫기
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    // 열려있는 모달 확인 후 닫기
                    const rejectModal = document.getElementById('rejectModal');
                    const imageModal = document.getElementById('imageModal');
                    
                    if (rejectModal && rejectModal.style.display === 'block') {
                        closeRejectModal();
                    }
                    if (imageModal && imageModal.style.display === 'block') {
                        closeImageModal();
                    }
                }
            });
        });
	</script>
</body>
</html>