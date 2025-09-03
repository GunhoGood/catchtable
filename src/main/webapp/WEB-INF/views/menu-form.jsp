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
<title><c:choose><c:when test="${isEdit}">메뉴 수정</c:when><c:otherwise>새 메뉴 등록</c:otherwise></c:choose> - ${restaurant.name} | Catch Table</title>
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

.restaurant-info {
    background: #f8f6f3;
    padding: 20px;
    border-radius: 8px;
    margin-bottom: 30px;
    display: flex;
    align-items: center;
    gap: 15px;
}

.restaurant-name {
    font-family: 'Crimson Text', serif;
    font-size: 1.5rem;
    font-weight: 600;
    color: #2c2c2c;
}

.restaurant-type {
    color: #666;
    font-size: 0.9rem;
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

.checkbox-group {
    display: flex;
    gap: 30px;
    margin-top: 10px;
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
    
    .checkbox-group {
        flex-direction: column;
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
                    <c:when test="${isEdit}">메뉴 수정</c:when>
                    <c:otherwise>새 메뉴 등록</c:otherwise>
                </c:choose>
            </h1>
            <p class="subtitle">
                <c:choose>
                    <c:when test="${isEdit}">메뉴 정보를 수정하고 저장하세요</c:when>
                    <c:otherwise>새로운 메뉴를 등록하여 고객들에게 선보이세요</c:otherwise>
                </c:choose>
            </p>
        </div>

        <!-- 식당 정보 -->
        <div class="restaurant-info">
            <div>
                <div class="restaurant-name">🏪 ${restaurant.name}</div>
                <div class="restaurant-type">${restaurant.cuisineType} • ${restaurant.address}</div>
            </div>
        </div>

        <!-- 메뉴 등록/수정 폼 -->
        <div class="card">
            <form id="menuForm">
                <!-- 기본 정보 -->
                <div class="form-section">
                    <h2 class="section-title">메뉴 정보</h2>
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label required">메뉴명</label>
                            <input type="text" id="name" name="name" class="form-input" 
                                   value="${menu.name}" placeholder="메뉴 이름을 입력하세요" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label required">가격</label>
                            <input type="number" id="price" name="price" class="form-input" 
                                   value="${menu.price}" placeholder="가격을 입력하세요" min="0" step="1000" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">카테고리</label>
                            <input type="text" id="category" name="category" class="form-input" 
                                   value="${menu.category}" placeholder="메인, 사이드, 음료 등">
                        </div>
                        <div class="form-group">
                            <label class="form-label">이미지 URL</label>
                            <input type="url" id="imageUrl" name="imageUrl" class="form-input" 
                                   value="${menu.imageUrl}" placeholder="https://example.com/menu-image.jpg">
                        </div>
                        <div class="form-group full-width">
                            <label class="form-label">메뉴 설명</label>
                            <textarea id="description" name="description" class="form-textarea" 
                                      placeholder="메뉴에 대한 상세 설명을 작성하세요">${menu.description}</textarea>
                        </div>
                    </div>
                </div>

                <!-- 메뉴 옵션 -->
                <div class="form-section">
                    <h2 class="section-title">메뉴 설정</h2>
                    <div class="checkbox-group">
                        <div class="form-checkbox">
                            <input type="checkbox" id="isSignature" name="isSignature" value="1" 
                                   <c:if test="${menu.isSignature}">checked</c:if>>
                            <label for="isSignature">🌟 시그니처 메뉴</label>
                        </div>
                        <div class="form-checkbox">
                            <input type="checkbox" id="isAvailable" name="isAvailable" value="1" 
                                   <c:if test="${menu.isAvailable != false}">checked</c:if>>
                            <label for="isAvailable">✅ 판매 가능</label>
                        </div>
                    </div>
                </div>

                <!-- 버튼 그룹 -->
                <div class="btn-group">
                    <a href="/catchtable/business/restaurants/${restaurant.restaurantId}" class="btn btn-secondary">
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
        document.getElementById('menuForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // 로딩 상태 표시
            const submitBtn = e.target.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '처리 중...';
            submitBtn.classList.add('loading');
            
            // 폼 데이터 수집
            const formData = {
                name: document.getElementById('name').value.trim(),
                price: parseInt(document.getElementById('price').value) || 0,
                category: document.getElementById('category').value.trim(),
                description: document.getElementById('description').value.trim(),
                imageUrl: document.getElementById('imageUrl').value.trim(),
                isSignature: document.getElementById('isSignature').checked,
                isAvailable: document.getElementById('isAvailable').checked
            };
            
            // 유효성 검사
            if (!formData.name) {
                alert('메뉴명을 입력해주세요.');
                resetButton();
                return;
            }
            
            if (formData.price <= 0) {
                alert('올바른 가격을 입력해주세요.');
                resetButton();
                return;
            }
            
            // API 요청
            const isEdit = ${isEdit ? 'true' : 'false'};
            const restaurantId = ${restaurant.restaurantId};
            const menuId = ${menu.menuId != null ? menu.menuId : 'null'};
            
            let url, method;
            if (isEdit) {
                url = '/catchtable/business/restaurants/' + restaurantId + '/menus/' + menuId;
                method = 'PUT';
            } else {
                url = '/catchtable/business/restaurants/' + restaurantId + '/menus';
                method = 'POST';
            }
            
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
                    window.location.href = '/catchtable/business/restaurants/' + restaurantId;
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