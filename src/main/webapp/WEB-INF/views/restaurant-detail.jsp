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
<title>${restaurant.name}-메뉴 관리 | Catch Table</title>
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
	margin: 40px auto;
	padding: 0 20px;
	display: grid;
	grid-template-columns: 1fr;
	gap: 30px;
	min-height: auto;
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

.restaurant-info {
	display: grid;
	grid-template-columns: 1fr 2fr;
	gap: 30px;
	align-items: start;
}

.restaurant-image {
	width: 100%;
	height: 250px;
	background: linear-gradient(135deg, #f8f6f3, #e8e6e3);
	border-radius: 8px;
	display: flex;
	align-items: center;
	justify-content: center;
	color: #888;
	font-size: 4rem;
	overflow: hidden;
}

.restaurant-image img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.restaurant-details h2 {
	font-family: 'Crimson Text', serif;
	font-size: 2rem;
	color: #2c2c2c;
	margin-bottom: 15px;
}

.restaurant-meta {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
	gap: 15px;
	margin-bottom: 20px;
}

.meta-item {
	display: flex;
	align-items: center;
	gap: 10px;
	padding: 10px;
	background: #f8f6f3;
	border-radius: 6px;
}

.meta-label {
	font-weight: 600;
	color: #666;
	min-width: 80px;
}

.meta-value {
	color: #2c2c2c;
}

.restaurant-stats {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 20px;
	margin: 20px 0;
	padding: 20px 0;
	border-top: 1px solid #f5f3f0;
	border-bottom: 1px solid #f5f3f0;
}

.stat-item {
	text-align: center;
}

.stat-number {
	font-family: 'Crimson Text', serif;
	font-size: 1.8rem;
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

.menus-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
	gap: 20px;
	margin-top: 20px;
}

.menu-card {
	background: #ffffff;
	border: 1px solid #f5f3f0;
	border-radius: 8px;
	overflow: hidden;
	transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.menu-card:hover {
	transform: translateY(-2px);
	box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}

.menu-image {
	width: 100%;
	height: 150px;
	background: linear-gradient(135deg, #f8f6f3, #e8e6e3);
	display: flex;
	align-items: center;
	justify-content: center;
	color: #888;
	font-size: 2rem;
}

.menu-image img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.menu-info {
	padding: 20px;
}

.menu-name {
	font-family: 'Crimson Text', serif;
	font-size: 1.3rem;
	font-weight: 600;
	color: #2c2c2c;
	margin-bottom: 8px;
}

.menu-description {
	color: #666;
	font-size: 0.9rem;
	margin-bottom: 15px;
	line-height: 1.5;
}

.menu-price {
	font-family: 'Crimson Text', serif;
	font-size: 1.4rem;
	font-weight: 700;
	color: #d4af37;
	margin-bottom: 15px;
}

.menu-badges {
	display: flex;
	gap: 8px;
	margin-bottom: 15px;
}

.badge {
	padding: 4px 8px;
	border-radius: 4px;
	font-size: 0.7rem;
	font-weight: 600;
	text-transform: uppercase;
	letter-spacing: 0.5px;
}

.badge-signature {
	background: #d4af37;
	color: #ffffff;
}

.badge-available {
	background: #27ae60;
	color: #ffffff;
}

.badge-unavailable {
	background: #95a5a6;
	color: #ffffff;
}

.menu-actions {
	display: flex;
	gap: 8px;
}

.btn {
	padding: 8px 12px;
	border: none;
	border-radius: 4px;
	font-family: 'Source Sans Pro', sans-serif;
	font-size: 0.8rem;
	font-weight: 500;
	cursor: pointer;
	transition: all 0.3s ease;
	text-decoration: none;
	display: inline-flex;
	align-items: center;
	gap: 4px;
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
	transform: translateY(-1px);
}

.btn-secondary {
	background: transparent;
	color: #666;
	border: 1px solid #ddd;
	flex: 1;
	justify-content: center;
}

.btn-secondary:hover {
	background: #f8f6f3;
	color: #2c2c2c;
	transform: translateY(-1px);
}

.btn-danger {
	background: transparent;
	color: #e74c3c;
	border: 1px solid #e74c3c;
	padding: 6px 10px;
}

.btn-danger:hover {
	background: #e74c3c;
	color: #ffffff;
	transform: translateY(-1px);
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

.btn-back {
	background: transparent;
	color: #666;
	border: 1px solid #ddd;
	padding: 12px 20px;
	text-decoration: none;
}

.btn-back:hover {
	background: #f8f6f3;
	color: #2c2c2c;
	transform: translateY(-2px);
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

@media ( max-width : 768px) {
	.container {
		padding: 0 15px;
	}
	.restaurant-info {
		grid-template-columns: 1fr;
	}
	.restaurant-stats {
		grid-template-columns: repeat(2, 1fr);
	}
	.actions-bar {
		flex-direction: column;
		align-items: stretch;
	}
	.search-input {
		min-width: 100%;
	}
	.menus-grid {
		grid-template-columns: 1fr;
	}
	.menu-actions {
		flex-direction: column;
	}
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/navi.jsp"%>

	<div class="container">
		<!-- 헤더 -->
		<div class="header card">
			<h1 class="title">${restaurant.name}</h1>
			<p class="subtitle">메뉴 관리 및 식당 운영 현황</p>
		</div>

		<!-- 식당 정보 -->
		<div class="card">
			<div class="restaurant-info">
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
				<div class="restaurant-details">
					<h2>${restaurant.name}</h2>
					<div class="restaurant-meta">
						<div class="meta-item">
							<span class="meta-label">요리 종류:</span> <span class="meta-value">${restaurant.cuisineType}</span>
						</div>
						<div class="meta-item">
							<span class="meta-label">주소:</span> <span class="meta-value">${restaurant.address}</span>
						</div>
						<div class="meta-item">
							<span class="meta-label">전화번호:</span> <span class="meta-value">${restaurant.phone}</span>
						</div>
						<div class="meta-item">
							<span class="meta-label">운영시간:</span> <span class="meta-value">${restaurant.operatingHours}</span>
						</div>
						<div class="meta-item">
							<span class="meta-label">가격대:</span> <span class="meta-value">
								<c:choose>
									<c:when test="${restaurant.priceRange == 'LOW'}">저가 (1-2만원)</c:when>
									<c:when test="${restaurant.priceRange == 'MEDIUM'}">중가 (2-5만원)</c:when>
									<c:when test="${restaurant.priceRange == 'HIGH'}">고가 (5만원 이상)</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</span>
						</div>
						<div class="meta-item">
							<span class="meta-label">예약 가능:</span> <span class="meta-value">
								<c:choose>
									<c:when test="${isReservationAvailable}">
										<span style="color: #27ae60; font-weight: 600;">가능</span>
									</c:when>
									<c:otherwise>
										<span style="color: #e74c3c; font-weight: 600;">준비중</span>
									</c:otherwise>
								</c:choose>
							</span>
						</div>
					</div>
					<c:if test="${not empty restaurant.description}">
						<p style="color: #666; line-height: 1.6; margin-top: 15px;">
							${restaurant.description}</p>
					</c:if>
				</div>
			</div>

			<!-- 식당 통계 -->
			<div class="restaurant-stats">
				<div class="stat-item">
					<span class="stat-number">${actualViewCount}</span> <span
						class="stat-label">조회수</span>
				</div>
				<div class="stat-item">
					<span class="stat-number">${actualLikesCount}</span> <span
						class="stat-label">좋아요</span>
				</div>
				<div class="stat-item">
					<span class="stat-number">${actualReservationCount}</span> <span
						class="stat-label">예약수</span>
				</div>
				<div class="stat-item">
					<span class="stat-number"> <fmt:formatNumber
							value="${actualRating}" pattern="0.0" />
					</span> <span class="stat-label">평점</span>
				</div>
			</div>
		</div>

		<!-- 메뉴 관리 -->
		<div class="card"
			style="background: #ffffff !important; min-height: 400px !important;">
			<h2 class="section-title">메뉴 관리</h2>

			<!-- 액션 바 -->
			<div class="actions-bar">
				<div class="search-section">
					<input type="text" class="search-input" placeholder="메뉴 이름으로 검색..."
						id="menuSearch">
				</div>
				<div style="display: flex; gap: 10px;">
					<a href="/catchtable/business/restaurants" class="btn btn-back">←
						식당 목록</a>
					<button class="btn btn-add" onclick="showAddMenuModal()">➕
						새 메뉴 추가</button>
				</div>
			</div>

			<!-- 메뉴 목록 -->
			<div class="menus-grid">
				<c:choose>
					<c:when test="${not empty menus}">
						<c:forEach var="menu" items="${menus}">
							<div class="menu-card">
								<div class="menu-image">
									<c:choose>
										<c:when
											test="${not empty menu.imageUrl and menu.imageUrl != ''}">
											<img src="${menu.imageUrl}" alt="${menu.name}"
												onerror="this.onerror=null; this.src='https://via.placeholder.com/300x200/cccccc/333333?text=음식';">
										</c:when>
										<c:otherwise>
											<img
												src="https://via.placeholder.com/300x200/cccccc/333333?text=음식"
												alt="기본 음식 이미지">
										</c:otherwise>
									</c:choose>
								</div>
								<div class="menu-info">
									<h3 class="menu-name">${menu.name}</h3>
									<c:if test="${not empty menu.description}">
										<p class="menu-description">${menu.description}</p>
									</c:if>
									<div class="menu-price">
										<fmt:formatNumber value="${menu.price}" type="currency"
											currencySymbol="₩" />
									</div>
									<div class="menu-badges">
										<c:if test="${menu.isSignature}">
											<span class="badge badge-signature">시그니처</span>
										</c:if>
										<c:choose>
											<c:when test="${menu.isAvailable}">
												<span class="badge badge-available">판매중</span>
											</c:when>
											<c:otherwise>
												<span class="badge badge-unavailable">품절</span>
											</c:otherwise>
										</c:choose>
									</div>
									<div class="menu-actions">
										<button class="btn btn-secondary"
											onclick="editMenu(${menu.menuId})">✏️ 수정</button>
										<button class="btn btn-danger"
											onclick="deleteMenu(${menu.menuId})">🗑️</button>
									</div>
								</div>
							</div>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<!-- 빈 상태 -->
						<div class="empty-state"
							style="background: #f9f9f9 !important; border: 2px dashed #ddd !important; min-height: 200px !important;">
							<div class="icon">🍽️</div>
							<h3>등록된 메뉴가 없습니다</h3>
							<p>위의 "새 메뉴 추가" 버튼을 클릭해서 첫 번째 메뉴를 추가해보세요!</p>
						</div>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>

	<!-- 메뉴 삭제 확인 모달 -->
	<div id="deleteModal" class="modal">
		<div class="modal-content">
			<h3 class="modal-title">메뉴 삭제 확인</h3>
			<p style="text-align: center; margin: 20px 0; color: #666;">
				정말로 이 메뉴를 삭제하시겠습니까?<br> <strong>삭제된 데이터는 복구할 수 없습니다.</strong>
			</p>
			<div class="modal-actions">
				<button type="button" class="btn btn-cancel"
					onclick="closeDeleteModal()">취소</button>
				<button type="button" class="btn btn-danger"
					onclick="confirmDeleteMenu()">삭제</button>
			</div>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

	<script>
        let deleteMenuId = null;

        function showAddMenuModal() {
            // 메뉴 추가 페이지로 이동
            const restaurantId = ${restaurant.restaurantId};
            window.location.href = '/catchtable/business/restaurants/' + restaurantId + '/menus/new';
        }

        function editMenu(menuId) {
            // 메뉴 수정 페이지로 이동
            const restaurantId = ${restaurant.restaurantId};
            window.location.href = '/catchtable/business/restaurants/' + restaurantId + '/menus/' + menuId + '/edit';
        }

        function deleteMenu(menuId) {
            deleteMenuId = menuId;
            document.getElementById('deleteModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
        }

        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none';
            document.body.style.overflow = 'auto';
            deleteMenuId = null;
        }

        function confirmDeleteMenu() {
            if (deleteMenuId) {
                const restaurantId = ${restaurant.restaurantId};
                
                fetch('/catchtable/business/restaurants/' + restaurantId + '/menus/' + deleteMenuId, {
                    method: 'DELETE',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert(data.message);
                        location.reload(); // 페이지 새로고침
                    } else {
                        alert(data.message || '삭제에 실패했습니다.');
                    }
                })
                .catch(error => {
                    console.error('삭제 오류:', error);
                    alert('삭제 중 오류가 발생했습니다.');
                });
                
                closeDeleteModal();
            }
        }

        // 메뉴 검색 기능
        document.getElementById('menuSearch').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const menuCards = document.querySelectorAll('.menu-card');
            
            menuCards.forEach(function(card) {
                const menuName = card.querySelector('.menu-name').textContent.toLowerCase();
                const menuDescription = card.querySelector('.menu-description');
                const description = menuDescription ? menuDescription.textContent.toLowerCase() : '';
                
                if (menuName.includes(searchTerm) || description.includes(searchTerm)) {
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