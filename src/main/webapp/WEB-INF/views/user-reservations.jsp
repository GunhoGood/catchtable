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
<title>My Reservations - Catch Table</title>
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

/* === 테이블 === */
.reservations-table {
	width: 100%;
	border-collapse: collapse;
	background: #ffffff;
	border-radius: 8px;
	overflow: hidden;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

.reservations-table th {
	background:#d4af37;
	color: #ffffff;
	padding: 15px 12px;
	text-align: left;
	font-weight: 600;
	font-size: 0.9rem;
	letter-spacing: 0.5px;
}

.reservations-table td {
	padding: 15px 12px;
	border-bottom: 1px solid #f5f3f0;
	vertical-align: middle;
}

.reservations-table tbody tr:hover {
	background: #fafaf9;
}

.reservation-info {
	display: flex;
	flex-direction: column;
	gap: 4px;
}

.reservation-restaurant {
	font-weight: 600;
	color: #2c2c2c;
}

.reservation-details {
	font-size: 0.85rem;
	color: #666;
}

/* === 상태 뱃지 === */
.status-badge {
	padding: 6px 12px;
	border-radius: 20px;
	font-size: 0.8rem;
	font-weight: 600;
	text-transform: uppercase;
	letter-spacing: 0.5px;
	text-align: center;
	min-width: 80px;
}

.status-pending {
	background: #fff3cd;
	color: #856404;
	border: 1px solid #ffeaa7;
}

.status-confirmed {
	background: #d1ecf1;
	color: #0c5460;
	border: 1px solid #bee5eb;
}

.status-completed {
	background: #d4edda;
	color: #155724;
	border: 1px solid #c3e6cb;
}

.status-cancelled {
	background: #f8d7da;
	color: #721c24;
	border: 1px solid #f5c6cb;
}

/* === 버튼 === */
.action-buttons {
	display: flex;
	gap: 8px;
	flex-wrap: wrap;
}

.btn {
	padding: 6px 12px;
	border: none;
	border-radius: 4px;
	font-size: 0.8rem;
	font-weight: 500;
	cursor: pointer;
	transition: all 0.3s ease;
	text-decoration: none;
	display: inline-flex;
	align-items: center;
	gap: 4px;
	white-space: nowrap;
	background: transparent;
	color: #d4af37;
	border: 1px solid #d4af37;
}

.btn:hover {
	background: #d4af37;
	color: #ffffff;
	transform: translateY(-1px);
}

.btn-sm {
	padding: 4px 8px;
	font-size: 0.75rem;
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

/* === 페이징 === */
.results-info {
	margin-bottom: 20px;
	padding-bottom: 15px;
	border-bottom: 1px solid #f5f3f0;
}

.pagination-container {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-top: 30px;
	padding: 20px 0;
	border-top: 1px solid #f5f3f0;
}

.pagination {
	display: flex;
	align-items: center;
	gap: 10px;
}

.page-btn {
	padding: 8px 16px;
	border: 1px solid #e8e6e3;
	border-radius: 6px;
	background: #ffffff;
	color: #666;
	text-decoration: none;
	font-size: 0.9rem;
	font-weight: 500;
	transition: all 0.3s ease;
	cursor: pointer;
}

.page-btn:hover {
	border-color: #d4af37;
	background: #d4af37;
	color: #ffffff;
	transform: translateY(-1px);
}

.page-numbers {
	display: flex;
	gap: 5px;
	margin: 0 15px;
}

.page-number {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	width: 36px;
	height: 36px;
	border: 1px solid #e8e6e3;
	border-radius: 6px;
	background: #ffffff;
	color: #666;
	text-decoration: none;
	font-size: 0.9rem;
	font-weight: 500;
	transition: all 0.3s ease;
	cursor: pointer;
}

.page-number:hover {
	border-color: #d4af37;
	background: #f8f6f3;
	color: #d4af37;
}

.page-number.active {
	border-color: #d4af37;
	background: #d4af37;
	color: #ffffff;
	font-weight: 600;
	cursor: default;
}

.pagination-info {
	color: #888;
	font-size: 0.9rem;
	font-weight: 500;
}

/* === 모달 === */
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
	border-radius: 4px;
	cursor: pointer;
	transition: all 0.3s ease;
}

.btn-modal-confirm {
	background: #d4af37;
	color: #ffffff;
	border: 1px solid #d4af37;
	padding: 10px 20px;
	border-radius: 4px;
	cursor: pointer;
	transition: all 0.3s ease;
}

/* === 토스트 === */
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
	.reservations-table {
		font-size: 0.85rem;
	}
	.reservations-table th, .reservations-table td {
		padding: 10px 8px;
	}
	.action-buttons {
		flex-direction: column;
	}
	.pagination-container {
		flex-direction: column;
		gap: 15px;
		text-align: center;
	}
	.pagination {
		flex-wrap: wrap;
		justify-content: center;
	}
	.page-numbers {
		margin: 0 10px;
	}
	.page-btn {
		padding: 6px 12px;
		font-size: 0.85rem;
	}
	.page-number {
		width: 32px;
		height: 32px;
		font-size: 0.85rem;
	}
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/navi.jsp"%>

	<div class="container">
		<!-- 헤더 -->
		<div class="header card">
			<h1 class="title">My Reservations</h1>
			<p class="subtitle">나의 예약 내역을 확인하고 관리하세요</p>
		</div>

		<!-- 네비게이션 -->
		<div class="nav-tabs">
			<a href="/catchtable/user/profile" class="nav-tab ">My Profile</a>
			<a href="/catchtable/user/reservations" class="nav-tab active">My Reservations</a> 
			<a href="/catchtable/user/reviews" class="nav-tab">My Reviews</a>
			<a href="/catchtable/user/coupons" class="nav-tab">My Coupons</a>
			<a href="/catchtable/user/favorites" class="nav-tab">My Favorites</a>
		</div>

		<!-- 통계 요약 -->
		<div class="card">
			<div class="stats-summary">
				<div class="stat-row">
					<div class="stat-item">
						<span>총 예약:</span> <span class="stat-value">${reservationStats.totalReservations}개</span>
					</div>
					<div class="stat-item">
						<span>완료 예약:</span> <span class="stat-value">${reservationStats.completedReservations}개</span>
					</div>

				</div>
				<p class="summary-note">나의 예약 이용 현황입니다</p>
			</div>
		</div>

		<!-- 예약 목록 -->
		<div class="card">
			<c:choose>
				<c:when test="${not empty reservations}">
					<div class="results-info">
						<p style="color: #666; margin-bottom: 15px; font-size: 0.9rem;">
							총 <strong>${totalReservations}개</strong>의 예약 중 <strong>${currentPage}페이지</strong>
							(${(currentPage-1)*pageSize + 1} - ${(currentPage-1)*pageSize + reservations.size()}번째)
						</p>
					</div>

					<table class="reservations-table">
						<thead>
							<tr>
								<th>식당 정보</th>
								<th>예약 일시</th>
								<th>인원</th>
								<th>상태</th>
								<th>작업</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="reservation" items="${reservations}">
								<tr>
									<td>
										<div class="reservation-info">
											<div class="reservation-restaurant">${restaurantNameMap[reservation.reservationId]}</div>
										</div>
									</td>
									<td>
										<div class="reservation-datetime">
											<div style="font-weight: 600;">
												${reservation.reservationDate}</div>
											<div style="color: #666; font-size: 0.9rem;">
												${reservation.reservationHour}</div>
										</div>
									</td>
									<td><span style="font-weight: 600;">${reservation.partySize}명</span>
										<c:if test="${not empty reservation.specialRequest}">
											<div style="font-size: 0.8rem; color: #666; margin-top: 4px;">
												특별 요청: ${reservation.specialRequest}</div>
										</c:if></td>
									<td><c:choose>
											<c:when
												test="${!reservation.isConfirmed && !reservation.isCancelled && !reservation.isCompleted}">
												<span class="status-badge status-pending">대기 중</span>
											</c:when>
											<c:when
												test="${reservation.isConfirmed && !reservation.isCancelled && !reservation.isCompleted}">
												<span class="status-badge status-confirmed">승인됨</span>
											</c:when>
											<c:when test="${reservation.isCompleted}">
												<span class="status-badge status-completed">완료됨</span>
											</c:when>
											<c:when test="${reservation.isCancelled}">
												<span class="status-badge status-cancelled">취소됨</span>
											</c:when>
										</c:choose></td>
									<td>
										<div class="action-buttons">
											<c:if test="${reservation.canCancel()}">
												<button class="btn btn-sm"
													onclick="cancelReservation(${reservation.reservationId})">취소</button>
											</c:if>
											<c:if test="${reservation.isCompleted}">
												<c:choose>
													<c:when
														test="${reviewStatusMap[reservation.reservationId]}">
														<button class="btn btn-sm" disabled style="opacity: 0.5;">
															리뷰 작성 완료</button>
													</c:when>
													<c:otherwise>
														<a
															href="${pageContext.request.contextPath}/restaurant/${reservation.restaurantId}/review?reservationId=${reservation.reservationId}"
															class="btn btn-sm btn-primary"> 리뷰 쓰기 </a>
													</c:otherwise>
												</c:choose>
											</c:if>
										</div>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>

					<!-- 페이징 네비게이션 -->
					<c:if test="${totalPages > 1}">
						<div class="pagination-container">
							<div class="pagination">
								<c:if test="${hasPrev}">
									<a href="javascript:void(0)" class="page-btn page-prev"
										onclick="goToPage(${currentPage - 1})"> ← 이전 </a>
								</c:if>

								<div class="page-numbers">
									<c:forEach var="pageNum" begin="${startPage}" end="${endPage}">
										<c:choose>
											<c:when test="${pageNum == currentPage}">
												<span class="page-number active">${pageNum}</span>
											</c:when>
											<c:otherwise>
												<a href="javascript:void(0)" class="page-number"
													onclick="goToPage(${pageNum})">${pageNum}</a>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</div>

								<c:if test="${hasNext}">
									<a href="javascript:void(0)" class="page-btn page-next"
										onclick="goToPage(${currentPage + 1})"> 다음 → </a>
								</c:if>
							</div>

							<div class="pagination-info">
								<span>${currentPage} / ${totalPages} 페이지</span>
							</div>
						</div>
					</c:if>

				</c:when>
				<c:otherwise>
					<div class="empty-state">
						<div class="icon">📅</div>
						<h3>예약 내역이 없습니다</h3>
						<p>새로운 예약을 만들어보세요!</p>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<!-- 취소 확인 모달 -->
	<div id="cancelModal" class="modal">
		<div class="modal-content">
			<h3 class="modal-title">예약 취소</h3>
			<p style="text-align: center; margin: 20px 0; color: #666;">
				정말로 이 예약을 취소하시겠습니까?<br> <strong>취소된 예약은 복구할 수 없습니다.</strong>
			</p>
			<div class="modal-actions">
				<button type="button" class="btn-modal-cancel"
					onclick="closeCancelModal()">돌아가기</button>
				<button type="button" class="btn-modal-confirm"
					onclick="confirmCancel()">취소하기</button>
			</div>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

	<script>
        let cancelReservationId = null;

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

        function goToPage(page) {
            const urlParams = new URLSearchParams(window.location.search);
            urlParams.set('page', page);
            window.location.href = '${pageContext.request.contextPath}/user/reservations?' + urlParams.toString();
        }

        function cancelReservation(reservationId) {
            cancelReservationId = reservationId;
            document.getElementById('cancelModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
        }

        function closeCancelModal() {
            document.getElementById('cancelModal').style.display = 'none';
            document.body.style.overflow = 'auto';
            cancelReservationId = null;
        }

        function confirmCancel() {
            if (cancelReservationId) {
                fetch('${pageContext.request.contextPath}/user/reservations/' + cancelReservationId + '/cancel', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showToast('예약이 취소되었습니다.');
                        setTimeout(() => location.reload(), 1000);
                    } else {
                        showToast(data.message || '취소에 실패했습니다.', 'error');
                    }
                })
                .catch(error => {
                    console.error('취소 오류:', error);
                    showToast('취소 중 오류가 발생했습니다.', 'error');
                });
                
                closeCancelModal();
            }
        }

        function writeReview(reservationId, restaurantId) {
            window.location.href = '${pageContext.request.contextPath}/restaurant/' + restaurantId + '/review?reservationId=' + reservationId;
        }

        window.onclick = function(event) {
            var cancelModal = document.getElementById('cancelModal');
            if (event.target === cancelModal) closeCancelModal();
        };

        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeCancelModal();
            }
        });
    </script>
</body>
</html>