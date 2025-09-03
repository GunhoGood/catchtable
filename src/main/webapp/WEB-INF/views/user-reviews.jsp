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
<title>My Reviews - Catch Table</title>
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

.reviews-table {
	width: 100%;
	border-collapse: collapse;
	background: #ffffff;
	border-radius: 8px;
	overflow: hidden;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

.reviews-table th {
	background:#d4af37;
	color: #ffffff;
	padding: 15px 12px;
	text-align: left;
	font-weight: 600;
	font-size: 0.9rem;
	letter-spacing: 0.5px;
}

.reviews-table td {
	padding: 15px 12px;
	border-bottom: 1px solid #f5f3f0;
	vertical-align: middle;
}

.reviews-table tbody tr:hover {
	background: #fafaf9;
}

.review-info {
	display: flex;
	flex-direction: column;
	gap: 4px;
}

.review-restaurant {
	font-weight: 600;
	color: #2c2c2c;
}

.review-details {
	font-size: 0.85rem;
	color: #666;
}

.review-content {
	max-width: 300px;
}

.review-text {
	color: #2c2c2c;
	line-height: 1.5;
	margin-bottom: 8px;
}

.review-image {
	width: 60px;
	height: 60px;
	border-radius: 6px;
	object-fit: cover;
	border: 2px solid #f0f0f0;
	transition: transform 0.2s ease;
	cursor: pointer;
}

.review-image:hover {
	transform: scale(1.05);
	border-color: #d4af37;
}

.rating-stars {
	display: flex;
	gap: 2px;
	margin-bottom: 4px;
}

.star {
	font-size: 16px;
	color: #ddd;
}

.star.filled {
	color: #ffc107;
}

.recommended-badge {
	display: inline-flex;
	align-items: center;
	gap: 4px;
	background: #d4edda;
	color: #155724;
	border: 1px solid #c3e6cb;
	padding: 4px 8px;
	border-radius: 12px;
	font-size: 11px;
	font-weight: 600;
	margin-top: 4px;
}

.not-recommended-badge {
	display: inline-flex;
	align-items: center;
	gap: 4px;
	background: #f8d7da;
	color: #721c24;
	border: 1px solid #f5c6cb;
	padding: 4px 8px;
	border-radius: 12px;
	font-size: 11px;
	font-weight: 600;
	margin-top: 4px;
}

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
}

.btn-sm {
	padding: 4px 8px;
	font-size: 0.75rem;
}

.btn-detail {
	background: transparent;
	color: #d4af37;
	border: 1px solid #d4af37;
}

.btn-detail:hover {
	background: #d4af37;
	color: #ffffff;
	transform: translateY(-1px);
}

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
.image-modal {
	display: none;
	position: fixed;
	z-index: 2000;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.8);
	backdrop-filter: blur(5px);
}

.image-modal-content {
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	max-width: 90%;
	max-height: 90%;
}

.image-modal img {
	width: 100%;
	height: auto;
	border-radius: 8px;
	box-shadow: 0 20px 50px rgba(0, 0, 0, 0.3);
}

.image-modal-close {
	position: absolute;
	top: 20px;
	right: 30px;
	color: white;
	font-size: 40px;
	font-weight: bold;
	cursor: pointer;
	z-index: 2001;
}

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
	.reviews-table {
		font-size: 0.85rem;
	}
	.reviews-table th, .reviews-table td {
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
	.review-content {
		max-width: 200px;
	}
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/navi.jsp"%>

	<div class="container">
		<!-- 헤더 -->
		<div class="header card">
			<h1 class="title">My Reviews</h1>
			<p class="subtitle">내가 작성한 리뷰를 확인하고 관리하세요</p>
		</div>

		<!-- 네비게이션 -->
		<div class="nav-tabs">
			<a href="/catchtable/user/profile" class="nav-tab ">My Profile</a>
			<a href="/catchtable/user/reservations" class="nav-tab">My Reservations</a> 
			<a href="/catchtable/user/reviews" class="nav-tab active">My Reviews</a>
			<a href="/catchtable/user/coupons" class="nav-tab">My Coupons</a>
			<a href="/catchtable/user/favorites" class="nav-tab">My Favorites</a>
		</div>

		<!-- 통계 요약 -->
		<div class="card">
			<div class="stats-summary">
				<div class="stat-row">
					<div class="stat-item">
						<span>총 리뷰:</span> <span class="stat-value">${reviewStats.totalReviews}개</span>
					</div>
					<div class="stat-item">
						<span>평균 평점:</span> <span class="stat-value"> <fmt:formatNumber
								value="${reviewStats.averageRating}" pattern="0.0" />점
						</span>
					</div>
				</div>
				<p class="summary-note">나의 리뷰 작성 현황입니다</p>
			</div>
		</div>

		<!-- 리뷰 목록 -->
		<div class="card">
			<c:choose>
				<c:when test="${not empty reviews}">
					<div class="results-info">
						<p style="color: #666; margin-bottom: 15px; font-size: 0.9rem;">
							총 <strong>${totalReviews}개</strong>의 리뷰 중 <strong>${currentPage}페이지</strong>
							(${(currentPage-1)*pageSize + 1} - ${(currentPage-1)*pageSize + reviews.size()}번째)
						</p>
					</div>

					<table class="reviews-table">
						<thead>
							<tr>
								<th>식당 정보</th>
								<th>평점</th>
								<th>리뷰 내용</th>
								<th>이미지</th>
								<th>작성일</th>
								<th>작업</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="review" items="${reviews}">
								<tr>
									<td>
										<div class="review-info">
											<div class="review-restaurant">
												<div class="review-restaurant">${review.restaurantName}</div>
											</div>
										</div>
									</td>
									<td>
										<div class="rating-stars">
											<c:forEach var="i" begin="1" end="5">
												<span class="star ${i <= review.rating ? 'filled' : ''}">★</span>
											</c:forEach>
										</div> <c:if test="${review.isRecommended}">
											<div class="recommended-badge">👍 추천</div>
										</c:if> <c:if test="${not review.isRecommended}">
											<div class="not-recommended-badge">👎 비추천</div>
										</c:if>
									</td>
									<td>
										<div class="review-content">
											<div class="review-text">
												<c:choose>
													<c:when test="${not empty review.content}">
                                                        ${review.content}
                                                    </c:when>
													<c:otherwise>
														<span style="color: #888; font-style: italic;">작성된
															리뷰가 없습니다</span>
													</c:otherwise>
												</c:choose>
											</div>
										</div>
									</td>
									<td><c:if test="${not empty review.imageUrl}">
											<img
												src="${pageContext.request.contextPath}${review.imageUrl}"
												alt="리뷰 이미지" class="review-image"
												onclick="showImageModal('${pageContext.request.contextPath}${review.imageUrl}')">
										</c:if></td>
									<td>
										<div style="font-weight: 600;">
											${review.createdAt.toString().substring(0, 10)}</div>
										<div style="color: #666; font-size: 0.9rem;">
											${review.createdAt.toString().substring(11, 16)}</div> <c:if
											test="${review.updatedAt != review.createdAt}">
											<div
												style="color: #d4af37; font-size: 0.8rem; margin-top: 4px;">
												수정됨</div>
										</c:if>
									</td>
									<td>
										<div class="action-buttons">
											<button class="btn btn-sm btn-detail"
												onclick="editReview(${review.reviewId}, ${review.restaurantId})">수정</button>
											<button class="btn btn-sm btn-detail"
												onclick="deleteReview(${review.reviewId})">삭제</button>
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
						<div class="icon">⭐</div>
						<h3>작성한 리뷰가 없습니다</h3>
						<p>완료된 예약에서 리뷰를 작성해보세요!</p>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<!-- 삭제 확인 모달 -->
	<div id="deleteModal" class="modal">
		<div class="modal-content">
			<h3 class="modal-title">리뷰 삭제</h3>
			<p style="text-align: center; margin: 20px 0; color: #666;">
				정말로 이 리뷰를 삭제하시겠습니까?<br> <strong>삭제된 리뷰는 복구할 수 없습니다.</strong>
			</p>
			<div class="modal-actions">
				<button type="button" class="btn-modal-cancel"
					onclick="closeDeleteModal()">돌아가기</button>
				<button type="button" class="btn-modal-confirm"
					onclick="confirmDelete()">삭제하기</button>
			</div>
		</div>
	</div>

	<!-- 이미지 확대 모달 -->
	<div id="imageModal" class="image-modal">
		<span class="image-modal-close" onclick="closeImageModal()">&times;</span>
		<div class="image-modal-content">
			<img id="modalImage" src="" alt="리뷰 이미지">
		</div>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

	<script>
        let deleteReviewId = null;

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
            window.location.href = '${pageContext.request.contextPath}/user/reviews?' + urlParams.toString();
        }

        function editReview(reviewId, restaurantId) {
            window.location.href = '${pageContext.request.contextPath}/restaurant/' + restaurantId + '/review/edit?reviewId=' + reviewId;
        }

        function deleteReview(reviewId) {
            deleteReviewId = reviewId;
            document.getElementById('deleteModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
        }

        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none';
            document.body.style.overflow = 'auto';
            deleteReviewId = null;
        }

        function confirmDelete() {
            if (deleteReviewId) {
                fetch('${pageContext.request.contextPath}/user/reviews/' + deleteReviewId + '/delete', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showToast('리뷰가 삭제되었습니다.');
                        setTimeout(() => location.reload(), 1000);
                    } else {
                        showToast(data.message || '삭제에 실패했습니다.', 'error');
                    }
                })
                .catch(error => {
                    console.error('삭제 오류:', error);
                    showToast('삭제 중 오류가 발생했습니다.', 'error');
                });
                
                closeDeleteModal();
            }
        }

        function showImageModal(imageUrl) {
            document.getElementById('modalImage').src = imageUrl;
            document.getElementById('imageModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
        }

        function closeImageModal() {
            document.getElementById('imageModal').style.display = 'none';
            document.body.style.overflow = 'auto';
        }

        window.onclick = function(event) {
            var deleteModal = document.getElementById('deleteModal');
            var imageModal = document.getElementById('imageModal');
            
            if (event.target === deleteModal) {
                closeDeleteModal();
            }
            if (event.target === imageModal) {
                closeImageModal();
            }
        };

        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeDeleteModal();
                closeImageModal();
            }
        });
    </script>
</body>
</html>