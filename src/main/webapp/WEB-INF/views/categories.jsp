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
<title>카테고리 관리 - Catch Table</title>
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

.categories-section {
	flex: 2;
	background: #ffffff;
	border-radius: 2px;
	box-shadow: 0 15px 40px rgba(0, 0, 0, 0.06);
	border: 1px solid rgba(0, 0, 0, 0.02);
	overflow: hidden;
	position: relative;
}

.categories-section::before {
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

.category-list {
	padding: 35px;
}

.category-item {
	background: #fafaf9;
	border: 1px solid #ebe8e4;
	border-radius: 2px;
	padding: 25px;
	margin-bottom: 20px;
	transition: all 0.3s ease;
	position: relative;
}

.category-item:hover {
	transform: translateY(-2px);
	box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
	border-color: rgba(212, 175, 55, 0.3);
}

.category-item:last-child {
	margin-bottom: 0;
}

.category-header {
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
	margin-bottom: 20px;
}

.category-info h3 {
	font-family: 'Crimson Text', serif;
	font-size: 1.4rem;
	font-weight: 600;
	color: #2c2c2c;
	margin-bottom: 5px;
	display: flex;
	align-items: center;
	gap: 10px;
}

.category-emoji {
	font-size: 1.5rem;
}

.category-id {
	color: #666;
	font-size: 0.9rem;
}

.status-badge {
	background: #d4af37;
	color: #2c2c2c;
	padding: 5px 12px;
	border-radius: 15px;
	font-size: 0.8rem;
	font-weight: 600;
	text-transform: uppercase;
	letter-spacing: 0.5px;
}

.category-details {
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

.category-actions {
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

.btn-edit {
	background: transparent;
	color: #d4af37;
	border: 1px solid #d4af37;
}

.btn-edit:hover {
	background: #d4af37;
	color: #2c2c2c;
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
	.category-list {
		padding: 25px;
	}
	.create-section {
		position: static;
	}
	.category-details {
		grid-template-columns: 1fr;
		gap: 10px;
	}
	.category-actions {
		justify-content: center;
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
			<h1 class="page-title">카테고리 관리</h1>
			<p class="page-subtitle">식당 카테고리 생성, 수정, 삭제 관리</p>
		</div>
		<div class="nav-tabs">
			<a href="/catchtable/admin/dashboard" class="nav-tab">Dashboard</a> <a
				href="/catchtable/admin/restaurants" class="nav-tab">Restaurants</a>
			<a href="/catchtable/admin/categories " class="nav-tab active">Categories</a>
			<a href="/catchtable/admin/approve-business" class="nav-tab">Business
				Approval</a> <a href="/catchtable/admin/coupons" class="nav-tab">Coupons</a>
			<a href="/catchtable/admin/users" class="nav-tab">Users</a>
		</div>
		<div class="content-wrapper">
			<!-- 카테고리 목록 -->
			<div class="categories-section">
				<div class="section-header">
					<h2 class="section-title">등록된 카테고리</h2>
					<p class="section-description">
						현재 시스템에 등록된 모든 카테고리 <strong>${categories.size()}개</strong>
					</p>
				</div>

				<div class="category-list">
					<c:choose>
						<c:when test="${not empty categories}">
							<c:forEach var="category" items="${categories}">
								<div class="category-item">
									<div class="category-header">
										<div class="category-info">
											<h3>
												<span class="category-emoji"> <c:choose>
														<c:when test="${not empty category.iconUrl}">
                                                            ${category.iconUrl}
                                                        </c:when>
														<c:otherwise>📂</c:otherwise>
													</c:choose>
												</span> ${category.name}
											</h3>
											<div class="category-id">ID: ${category.categoryId}</div>
										</div>
										<div class="status-badge">카테고리</div>
									</div>

									<div class="category-details">
										<div class="detail-item">
											<div class="detail-label">카테고리 ID</div>
											<div>${category.categoryId}</div>
										</div>
										<div class="detail-item">
											<div class="detail-label">카테고리명</div>
											<div>${category.name}</div>
										</div>
										<c:if test="${not empty category.iconUrl}">
											<div class="detail-item">
												<div class="detail-label">이모지</div>
												<div>${category.iconUrl}</div>
											</div>
										</c:if>
									</div>

									<div class="category-actions">
										<button class="btn btn-edit"
											onclick="editCategory(${category.categoryId}, '${category.name}', '${category.iconUrl}')">수정</button>
										<button class="btn btn-delete"
											onclick="deleteCategory(${category.categoryId}, '${category.name}')">삭제</button>
									</div>
								</div>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<div class="empty-state">
								<div class="empty-icon">📂</div>
								<h3>등록된 카테고리가 없습니다</h3>
								<p>새로운 카테고리를 생성해보세요!</p>
							</div>
						</c:otherwise>
					</c:choose>
				</div>
			</div>

			<!-- 카테고리 생성 -->
			<div class="create-section">
				<h3 class="section-title">카테고리 생성</h3>
				<form id="categoryForm">
					<div class="form-group">
						<label class="form-label">카테고리명 *</label> <input type="text"
							class="form-input" id="categoryName" placeholder="예: 한식, 중식, 일식"
							required>
					</div>

					<div class="form-group">
						<label class="form-label">이모지</label> <input type="text"
							class="form-input" id="iconUrl" placeholder="예: 🍚, 🍜, 🍣">
					</div>

					<button type="submit" class="submit-btn">카테고리 생성하기</button>
				</form>
			</div>
		</div>
	</div>

	<!-- 푸터 -->
	<%@ include file="/WEB-INF/views/footer.jsp"%>

	<script>
        // 카테고리 생성
        function createCategory() {
            var name = document.getElementById('categoryName').value.trim();
            var iconUrl = document.getElementById('iconUrl').value.trim();
            
            if (!name) {
                alert('카테고리명을 입력해주세요.');
                document.getElementById('categoryName').focus();
                return;
            }
            
            var categoryData = {
                name: name,
                iconUrl: iconUrl || null
            };
            
            console.log('카테고리 생성 데이터:', categoryData);
            
            fetch('/catchtable/admin/categories', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Accept': 'application/json'
                },
                body: JSON.stringify(categoryData)
            })
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                return response.json();
            })
            .then(function(data) {
                alert(data.message || '카테고리가 생성되었습니다.');
                
                if (data.success !== false) {
                    document.getElementById('categoryForm').reset();
                    location.reload();
                }
            })
            .catch(function(error) {
                console.error('카테고리 생성 오류:', error);
                alert('카테고리 생성 중 오류가 발생했습니다: ' + error.message);
            });
        }
        
        // 카테고리 수정
        function editCategory(categoryId, currentName, currentIconUrl) {
            var newName = prompt('새로운 카테고리명을 입력하세요:', currentName);
            if (!newName || newName.trim() === '') {
                return;
            }
            
            var newIconUrl = prompt('새로운 이모지를 입력하세요 (선택사항):', currentIconUrl || '');
            
            var categoryData = {
                name: newName.trim(),
                iconUrl: newIconUrl.trim() || null
            };
            
            var editUrl = '/catchtable/admin/categories/' + categoryId;
            
            fetch(editUrl, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Accept': 'application/json'
                },
                body: JSON.stringify(categoryData)
            })
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                return response.json();
            })
            .then(function(data) {
                alert(data.message || '카테고리가 수정되었습니다.');
                
                if (data.success !== false) {
                    location.reload();
                }
            })
            .catch(function(error) {
                console.error('카테고리 수정 오류:', error);
                alert('카테고리 수정 중 오류가 발생했습니다: ' + error.message);
            });
        }
        
        // 카테고리 삭제
        function deleteCategory(categoryId, categoryName) {
            if (!confirm('\'' + categoryName + '\' 카테고리를 삭제하시겠습니까?\\n\\n이 카테고리를 사용하는 식당이 있다면 삭제할 수 없습니다.')) {
                return;
            }
            
            var deleteUrl = '/catchtable/admin/categories/' + categoryId;
            
            fetch(deleteUrl, {
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
                alert(data.message || '카테고리가 삭제되었습니다.');
                
                if (data.success !== false) {
                    location.reload();
                }
            })
            .catch(function(error) {
                console.error('카테고리 삭제 오류:', error);
                alert('카테고리 삭제 중 오류가 발생했습니다: ' + error.message);
            });
        }
        
        // 페이지 로드 시 초기화
        document.addEventListener('DOMContentLoaded', function() {
            console.log('카테고리 관리 페이지 로드 완료');
            
            var categoryForm = document.getElementById('categoryForm');
            if (categoryForm) {
                categoryForm.addEventListener('submit', function(e) {
                    e.preventDefault();
                    createCategory();
                });
            }
        });
    </script>
</body>
</html>