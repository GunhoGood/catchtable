<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<title><c:choose><c:when test="${isEdit}">식당 정보 수정</c:when><c:otherwise>새 식당 등록</c:otherwise></c:choose> - Catch Table</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
@import url('https://fonts.googleapis.com/css2?family=Crimson+Text:ital,wght@0,400;0,600;1,400&family=Source+Sans+Pro:wght@300;400;600&display=swap');

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
    max-width: 800px;
    margin: 40px auto;
    padding: 0 20px;
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
    margin-bottom: 30px;
}

.header::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="20" cy="20" r="2" fill="rgba(255,255,255,0.1)"/><circle cx="80" cy="40" r="1.5" fill="rgba(255,255,255,0.08)"/></svg>');
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

.form-section {
    margin-bottom: 30px;
}

.section-title {
    font-family: 'Crimson Text', serif;
    font-size: 1.5rem;
    color: #2c2c2c;
    margin-bottom: 20px;
    border-bottom: 2px solid #d4af37;
    padding-bottom: 10px;
}

.form-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 20px;
    margin-bottom: 20px;
}

.form-group {
    margin-bottom: 20px;
}

.form-group.full-width {
    grid-column: 1 / -1;
}

.form-label {
    display: block;
    margin-bottom: 8px;
    font-weight: 600;
    color: #2c2c2c;
}

.form-label.required::after {
    content: ' *';
    color: #e74c3c;
}

.form-input,
.form-select,
.form-textarea {
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

.form-input:focus,
.form-select:focus,
.form-textarea:focus {
    outline: none;
    border-color: #d4af37;
    background: #ffffff;
    box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
}

.form-textarea {
    min-height: 100px;
    resize: vertical;
}

.form-checkbox {
    display: flex;
    align-items: center;
    gap: 10px;
    margin: 10px 0;
}

.form-checkbox input[type="checkbox"] {
    width: 18px;
    height: 18px;
}

.price-range-group {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 15px;
    margin-top: 8px;
}

.price-range-option {
    position: relative;
    cursor: pointer;
}

.price-range-option input[type="radio"] {
    position: absolute;
    opacity: 0;
    width: 0;
    height: 0;
}

.price-range-label {
    display: block;
    padding: 15px 20px;
    border: 2px solid #e8e6e3;
    border-radius: 8px;
    text-align: center;
    background: #fafaf9;
    color: #666;
    font-weight: 500;
    transition: all 0.3s ease;
    cursor: pointer;
    position: relative;
}

.price-range-label::before {
    content: '';
    position: absolute;
    top: 50%;
    left: 15px;
    transform: translateY(-50%);
    width: 12px;
    height: 12px;
    border: 2px solid #ddd;
    border-radius: 50%;
    background: #fff;
    transition: all 0.3s ease;
}

.price-range-option:hover .price-range-label {
    border-color: #d4af37;
    background: #ffffff;
    transform: translateY(-2px);
    box-shadow: 0 4px 15px rgba(212, 175, 55, 0.2);
}

.price-range-option input[type="radio"]:checked + .price-range-label {
    border-color: #d4af37;
    background: linear-gradient(135deg, #d4af37 0%, #c9a96e 100%);
    color: #ffffff;
    font-weight: 600;
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(212, 175, 55, 0.3);
}

.price-range-option input[type="radio"]:checked + .price-range-label::before {
    border-color: #ffffff;
    background: #ffffff;
    box-shadow: inset 0 0 0 3px #d4af37;
}

.price-info {
    display: block;
    font-size: 0.9rem;
    margin-top: 5px;
    opacity: 0.8;
}

.price-range-option input[type="radio"]:checked + .price-range-label .price-info {
    opacity: 1;
}

.btn-group {
    display: flex;
    gap: 15px;
    justify-content: center;
    margin-top: 40px;
}

.btn {
    padding: 12px 24px;
    border: none;
    border-radius: 6px;
    font-family: 'Source Sans Pro', sans-serif;
    font-size: 1rem;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s ease;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    min-width: 120px;
    justify-content: center;
}

.btn-primary {
    background: #d4af37;
    color: #ffffff;
    border: 1px solid #d4af37;
    box-shadow: 0 4px 15px rgba(212, 175, 55, 0.3);
}

.btn-primary:hover {
    background: #c9a96e;
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(212, 175, 55, 0.4);
}

.btn-secondary {
    background: transparent;
    color: #666;
    border: 1px solid #ddd;
}

.btn-secondary:hover {
    background: #f8f6f3;
    color: #2c2c2c;
    transform: translateY(-2px);
}

.error-message {
    color: #e74c3c;
    font-size: 0.9rem;
    margin-top: 5px;
}

.success-message {
    color: #27ae60;
    font-size: 0.9rem;
    margin-top: 5px;
}

.loading {
    opacity: 0.6;
    pointer-events: none;
}

@media (max-width: 768px) {
    .container {
        padding: 0 15px;
    }
    
    .header {
        padding: 30px 20px;
    }
    
    .title {
        font-size: 2rem;
    }
    
    .form-grid {
        grid-template-columns: 1fr;
    }
    
    .price-range-group {
        grid-template-columns: 1fr;
        gap: 10px;
    }
    
    .btn-group {
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
            <h1 class="title">
                <c:choose>
                    <c:when test="${isEdit}">식당 정보 수정</c:when>
                    <c:otherwise>새 식당 등록</c:otherwise>
                </c:choose>
            </h1>
            <p class="subtitle">
                <c:choose>
                    <c:when test="${isEdit}">식당 정보를 수정하고 저장하세요</c:when>
                    <c:otherwise>새로운 식당을 등록하여 고객들에게 선보이세요</c:otherwise>
                </c:choose>
            </p>
        </div>

        <!-- 식당 등록/수정 폼 -->
        <div class="card">
            <form id="restaurantForm">
                <!-- 기본 정보 -->
                <div class="form-section">
                    <h2 class="section-title">기본 정보</h2>
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label required">식당명</label>
                            <input type="text" id="name" name="name" class="form-input" 
                                   value="${restaurant.name}" placeholder="식당 이름을 입력하세요" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label required">카테고리</label>
                            <select id="categoryId" name="categoryId" class="form-select" required>
                                <option value="">카테고리를 선택하세요</option>
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.categoryId}" 
                                            <c:if test="${restaurant.categoryId == category.categoryId}">selected</c:if>>
                                        ${category.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label required">요리 종류</label>
                            <input type="text" id="cuisineType" name="cuisineType" class="form-input" 
                                   value="${restaurant.cuisineType}" placeholder="한식, 양식, 중식 등" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">전화번호</label>
                            <input type="tel" id="phone" name="phone" class="form-input" 
                                   value="${restaurant.phone}" placeholder="02-1234-5678">
                        </div>
                        <div class="form-group full-width">
                            <label class="form-label required">주소</label>
                            <input type="text" id="address" name="address" class="form-input" 
                                   value="${restaurant.address}" placeholder="식당 주소를 입력하세요" required>
                        </div>
                        <div class="form-group full-width">
                            <label class="form-label">식당 소개</label>
                            <textarea id="description" name="description" class="form-textarea" 
                                      placeholder="식당에 대한 간단한 소개를 작성하세요">${restaurant.description}</textarea>
                        </div>
                    </div>
                </div>

                <!-- 운영 정보 -->
                <div class="form-section">
                    <h2 class="section-title">운영 정보</h2>
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label">운영시간</label>
                            <input type="text" id="operatingHours" name="operatingHours" class="form-input" 
                                   value="${restaurant.operatingHours}" placeholder="09:00 - 22:00">
                        </div>
                        <div class="form-group full-width">
                            <label class="form-label">이미지 URL</label>
                            <input type="url" id="imageUrl" name="imageUrl" class="form-input" 
                                   value="${restaurant.imageUrl}" placeholder="https://example.com/image.jpg">
                        </div>
                    </div>
                    
                    <!-- 가격대를 grid 밖으로 이동 -->
                    <div class="form-group">
                        <label class="form-label">가격대</label>
                        <div class="price-range-group">
                            <div class="price-range-option">
                                <input type="radio" id="priceLow" name="priceRange" value="LOW" 
                                       <c:if test="${restaurant.priceRange == 'LOW'}">checked</c:if>>
                                <label for="priceLow" class="price-range-label">
                                    💰 저가
                                    <span class="price-info">1~2만원</span>
                                </label>
                            </div>
                            <div class="price-range-option">
                                <input type="radio" id="priceMedium" name="priceRange" value="MEDIUM" 
                                       <c:if test="${restaurant.priceRange == 'MEDIUM'}">checked</c:if>>
                                <label for="priceMedium" class="price-range-label">
                                    💰 중가
                                    <span class="price-info">2~5만원</span>
                                </label>
                            </div>
                            <div class="price-range-option">
                                <input type="radio" id="priceHigh" name="priceRange" value="HIGH" 
                                       <c:if test="${restaurant.priceRange == 'HIGH'}">checked</c:if>>
                                <label for="priceHigh" class="price-range-label">
                                    💰 고가
                                    <span class="price-info">5만원~</span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 추가 옵션 -->
                <div class="form-section">
                    <h2 class="section-title">운영 설정</h2>
                    <div class="form-group">
                        <div class="form-checkbox">
                            <input type="checkbox" id="acceptReservations" name="acceptReservations" value="1" checked>
                            <label for="acceptReservations">예약 접수 받기</label>
                        </div>
                    </div>
                </div>

                <!-- 버튼 그룹 -->
                <div class="btn-group">
                    <a href="/catchtable/business/restaurants" class="btn btn-secondary">
                        ← 취소
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <c:choose>
                            <c:when test="${isEdit}">✏️ 수정하기</c:when>
                            <c:otherwise>➕ 등록하기</c:otherwise>
                        </c:choose>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/footer.jsp"%>

    <script>
        document.getElementById('restaurantForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // 로딩 상태 표시
            const submitBtn = e.target.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '처리 중...';
            submitBtn.classList.add('loading');
            
            // 폼 데이터 수집
            const formData = {
                name: document.getElementById('name').value.trim(),
                categoryId: document.getElementById('categoryId').value,
                cuisineType: document.getElementById('cuisineType').value.trim(),
                phone: document.getElementById('phone').value.trim(),
                address: document.getElementById('address').value.trim(),
                description: document.getElementById('description').value.trim(),
                operatingHours: document.getElementById('operatingHours').value.trim(),
                priceRange: document.querySelector('input[name="priceRange"]:checked')?.value || '',
                imageUrl: document.getElementById('imageUrl').value.trim(),
                acceptReservations: document.getElementById('acceptReservations').checked
            };
            
            // 유효성 검사
            if (!formData.name) {
                alert('식당명을 입력해주세요.');
                resetButton();
                return;
            }
            
            if (!formData.categoryId) {
                alert('카테고리를 선택해주세요.');
                resetButton();
                return;
            }
            
            if (!formData.cuisineType) {
                alert('요리 종류를 입력해주세요.');
                resetButton();
                return;
            }
            
            if (!formData.address) {
                alert('주소를 입력해주세요.');
                resetButton();
                return;
            }
            
            // API 요청
            const isEdit = ${isEdit ? 'true' : 'false'};
            const url = isEdit ? '/catchtable/business/restaurants/${restaurant.restaurantId}' : '/catchtable/business/restaurants';
            const method = isEdit ? 'PUT' : 'POST';
            
            fetch(url, {
                method: method,
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: JSON.stringify(formData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(data.message);
                    window.location.href = '/catchtable/business/restaurants';
                } else {
                    alert(data.message || '처리 중 오류가 발생했습니다.');
                    resetButton();
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('서버 오류가 발생했습니다.');
                resetButton();
            });
            
            function resetButton() {
                submitBtn.innerHTML = originalText;
                submitBtn.classList.remove('loading');
            }
        });
    </script>
</body>
</html>