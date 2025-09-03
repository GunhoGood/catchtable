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
<title>My Restaurants - Catch Table</title>
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

.section-title {
	font-family: 'Crimson Text', serif;
	font-size: 1.8rem;
	color: #2c2c2c;
	margin-bottom: 25px;
	border-bottom: 2px solid #d4af37;
	padding-bottom: 10px;
	position: relative;
}

.actions-bar {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 30px;
	gap: 20px;
}

.search-section {
	display: flex;
	gap: 15px;
	align-items: center;
}

.search-input {
	padding: 12px 15px;
	border: 1px solid #e8e6e3;
	border-radius: 6px;
	font-size: 1rem;
	font-family: 'Source Sans Pro', sans-serif;
	background: #fafaf9;
	color: #2c2c2c;
	min-width: 250px;
}

.search-input:focus {
	outline: none;
	border-color: #d4af37;
	background: #ffffff;
	box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
}

.restaurants-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
	gap: 25px;
	margin-top: 20px;
}

.restaurant-card {
	background: #ffffff;
	border-radius: 12px;
	overflow: hidden;
	box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
	border: 1px solid rgba(0, 0, 0, 0.02);
	transition: transform 0.3s ease;
}

.restaurant-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 15px 35px rgba(0, 0, 0, 0.12);
}

.restaurant-image {
	width: 100%;
	height: 200px;
	background: linear-gradient(135deg, #f8f6f3, #e8e6e3);
	display: flex;
	align-items: center;
	justify-content: center;
	color: #888;
	font-size: 3rem;
	position: relative;
}

.restaurant-image img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.restaurant-info {
	padding: 25px;
}

.restaurant-name {
	font-family: 'Crimson Text', serif;
	font-size: 1.5rem;
	font-weight: 600;
	color: #2c2c2c;
	margin-bottom: 10px;
}

.restaurant-category {
	color: #888;
	font-size: 0.9rem;
	margin-bottom: 15px;
	font-weight: 500;
}

.restaurant-stats {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 15px;
	margin: 20px 0;
	padding: 15px 0;
	border-top: 1px solid #f5f3f0;
	border-bottom: 1px solid #f5f3f0;
}

.stat-item {
	text-align: center;
}

.stat-number {
	font-family: 'Crimson Text', serif;
	font-size: 1.4rem;
	font-weight: 700;
	color: #d4af37;
	display: block;
}

.stat-label {
	font-size: 0.8rem;
	color: #888;
	font-weight: 500;
	text-transform: uppercase;
	letter-spacing: 0.5px;
}

.restaurant-actions {
	display: flex;
	gap: 10px;
	margin-top: 20px;
}

.btn {
	padding: 10px 16px;
	border: none;
	border-radius: 6px;
	font-family: 'Source Sans Pro', sans-serif;
	font-size: 0.85rem;
	font-weight: 500;
	cursor: pointer;
	transition: all 0.3s ease;
	text-decoration: none;
	display: inline-flex;
	align-items: center;
	gap: 6px;
	text-transform: uppercase;
	letter-spacing: 0.5px;
}

.btn-primary {
	background: transparent;
	color: #d4af37;
	border: 1px solid #d4af37;
	flex: 1;
	justify-content: center;
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
	flex: 1;
	justify-content: center;
}

.btn-secondary:hover {
	background: #d4af37;
	color: #ffffff;
	transform: translateY(-2px);
}

.btn-danger {
	background: transparent;
	color: #e74c3c;
	border: 1px solid #e74c3c;
	padding: 8px 12px;
}

.btn-danger:hover {
	background: #e74c3c;
	color: #ffffff;
	transform: translateY(-2px);
}

.btn-add {
	background: #d4af37;
	color: #ffffff;
	border: 1px solid #d4af37;
	box-shadow: 0 4px 15px rgba(212, 175, 55, 0.3);
	padding: 12px 24px;
	font-size: 0.9rem;
}

.btn-add:hover {
	background: #c9a96e;
	transform: translateY(-2px);
	box-shadow: 0 6px 20px rgba(212, 175, 55, 0.4);
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

.empty-state p {
	margin-bottom: 30px;
	font-size: 1rem;
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
	.actions-bar {
		flex-direction: column;
		align-items: stretch;
	}
	.search-input {
		min-width: 100%;
	}
	.restaurants-grid {
		grid-template-columns: 1fr;
		gap: 20px;
	}
	.restaurant-actions {
		flex-direction: column;
	}
}

@media ( max-width : 480px) {
	.restaurant-stats {
		grid-template-columns: 1fr;
		gap: 10px;
	}
	.stat-item {
		display: flex;
		justify-content: space-between;
		align-items: center;
	}
	.modal-content {
		margin: 15% auto;
		padding: 25px;
	}
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/navi.jsp"%>

	<div class="container">
		<!-- 헤더 -->
		<div class="header card">
			<h1 class="title">My Restaurants</h1>
			<p class="subtitle">등록된 식당을 관리하고 새로운 식당을 추가하세요</p>
		</div>

		<!-- 네비게이션 -->
		<div class="nav-tabs">
			<a href="/catchtable/business/profile" class="nav-tab">Business
				Profile</a> <a href="/catchtable/business/restaurants"
				class="nav-tab active">My Restaurants</a> <a
				href="/catchtable/business/reservations" class="nav-tab">Reservations</a>
		</div>

		<!-- 식당 관리 섹션 -->
		<div class="card">
			<h2 class="section-title">등록된 식당</h2>

			<!-- 액션 바 -->
			<div class="actions-bar">
				<div class="search-section">
					<input type="text" class="search-input" placeholder="식당 이름으로 검색...">
				</div>
				<button class="btn btn-add" onclick="showAddRestaurantModal()">
					➕ 새 식당 등록</button>
			</div>

			<!-- 식당 목록 -->
			<div class="restaurants-grid">
				<c:choose>
					<c:when test="${not empty restaurants}">
						<c:forEach var="restaurant" items="${restaurants}">
							<div class="restaurant-card">
								<div class="restaurant-image">
									<c:choose>
										<c:when test="${not empty restaurant.imageUrl}">
											<img src="${restaurant.imageUrl}" alt="${restaurant.name}">
										</c:when>
										<c:otherwise>
                                            🏪
                                        </c:otherwise>
									</c:choose>
								</div>
								<div class="restaurant-info">
									<h3 class="restaurant-name">${restaurant.name}</h3>
									<p class="restaurant-category">${restaurant.cuisineType}•
										${restaurant.address}</p>

									<!-- 식당 통계 부분 수정 -->
									<div class="restaurant-stats">
										<div class="stat-item">
											<span class="stat-number"> <!-- 평점 표시 개선 --> <c:choose>
													<c:when
														test="${not empty restaurantRatings and not empty restaurantRatings[restaurant.restaurantId] and restaurantRatings[restaurant.restaurantId] > 0}">
														<fmt:formatNumber
															value="${restaurantRatings[restaurant.restaurantId]}"
															pattern="0.0" />
													</c:when>
													<c:when
														test="${not empty restaurant.averageRating and restaurant.averageRating > 0}">
														<fmt:formatNumber value="${restaurant.averageRating}"
															pattern="0.0" />
													</c:when>
													<c:otherwise>0.0</c:otherwise>
												</c:choose>
											</span> <span class="stat-label">평점</span>
										</div>
										<div class="stat-item">
											<span class="stat-number"> ${restaurant.viewCount != null ? restaurant.viewCount : 0}
											</span> <span class="stat-label">조회수</span>
										</div>
										<div class="stat-item">
											<!--  실제 예약수 사용 -->
											<span class="stat-number"> <c:choose>
													<c:when
														test="${not empty actualReservationCounts and not empty actualReservationCounts[restaurant.restaurantId]}">
                    ${actualReservationCounts[restaurant.restaurantId]}
                </c:when>
													<c:otherwise>0</c:otherwise>
												</c:choose>
											</span> <span class="stat-label">예약수</span>
										</div>
									</div>
									<div class="restaurant-actions">
										<a
											href="/catchtable/business/restaurants/${restaurant.restaurantId}"
											class="btn btn-primary"> 📜 메뉴관리 </a>
										<button class="btn btn-secondary"
											onclick="editRestaurant(${restaurant.restaurantId})">
											✏️ 수정</button>
										<button class="btn btn-danger"
											onclick="deleteRestaurant(${restaurant.restaurantId})">
											🗑️</button>
									</div>
								</div>
							</div>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<!-- 빈 상태 -->
						<div class="empty-state">
							<div class="icon">🏪</div>
							<h3>등록된 식당이 없습니다</h3>
							<p>첫 번째 식당을 등록해보세요!</p>
							<button class="btn btn-primary"
								onclick="showAddRestaurantModal()">식당 등록하기</button>
						</div>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>

	<!-- 삭제 확인 모달 -->
	<div id="deleteModal" class="modal">
		<div class="modal-content">
			<h3 class="modal-title">식당 삭제 확인</h3>
			<p style="text-align: center; margin: 20px 0; color: #666;">
				정말로 이 식당을 삭제하시겠습니까?<br> <strong>삭제된 데이터는 복구할 수 없습니다.</strong>
			</p>
			<div class="modal-actions">
				<button type="button" class="btn btn-cancel"
					onclick="closeDeleteModal()">취소</button>
				<button type="button" class="btn btn-danger"
					onclick="confirmDelete()">삭제</button>
			</div>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

	<script>
        let deleteRestaurantId = null;

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

        function showAddRestaurantModal() {
            // 새 식당 등록 모달 또는 페이지로 이동
            window.location.href = '/catchtable/business/restaurants/new';
        }

        function editRestaurant(restaurantId) {
            // 식당 수정 페이지로 이동
            window.location.href = '/catchtable/business/restaurants/' + restaurantId + '/edit';
        }

        function deleteRestaurant(restaurantId) {
            deleteRestaurantId = restaurantId;
            document.getElementById('deleteModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
        }

        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none';
            document.body.style.overflow = 'auto';
            deleteRestaurantId = null;
        }

        function confirmDelete() {
            if (deleteRestaurantId) {
                // 실제 삭제 요청
                fetch('/catchtable/business/restaurants/' + deleteRestaurantId, {
                    method: 'DELETE',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                .then(function(response) {
                    return response.json();
                })
                .then(function(data) {
                    if (data.success) {
                        showToast('식당이 삭제되었습니다.');
                        setTimeout(function() {
                            location.reload();
                        }, 1000);
                    } else {
                        showToast(data.message || '삭제에 실패했습니다.', 'error');
                    }
                })
                .catch(function(error) {
                    console.error('삭제 오류:', error);
                    showToast('삭제 중 오류가 발생했습니다.', 'error');
                });
                
                closeDeleteModal();
            }
        }

        // 검색 기능
        document.querySelector('.search-input').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const restaurantCards = document.querySelectorAll('.restaurant-card');
            
            restaurantCards.forEach(function(card) {
                const restaurantName = card.querySelector('.restaurant-name').textContent.toLowerCase();
                if (restaurantName.includes(searchTerm)) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        });

        // 모달 외부 클릭시 닫기
        window.onclick = function(event) {
            var deleteModal = document.getElementById('deleteModal');
            if (event.target === deleteModal) closeDeleteModal();
        };

        // ESC 키로 모달 닫기
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeDeleteModal();
            }
        });
    </script>
</body>
</html>