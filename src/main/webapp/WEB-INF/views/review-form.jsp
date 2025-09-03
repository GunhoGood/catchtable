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
<title><c:choose>
		<c:when test="${mode == 'edit'}">리뷰 수정</c:when>
		<c:otherwise>리뷰 작성</c:otherwise>
	</c:choose> - Catch Table</title>
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
	max-width: 800px;
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

.restaurant-info {
	background: linear-gradient(135deg, #f8f6f3 0%, #ffffff 100%);
	padding: 20px;
	border-radius: 8px;
	margin-bottom: 30px;
}

.restaurant-name {
	font-family: 'Crimson Text', serif;
	font-size: 1.5rem;
	font-weight: 600;
	color: #2c2c2c;
	margin-bottom: 5px;
}

.form-section {
	margin-bottom: 30px;
}

.section-title {
	font-family: 'Crimson Text', serif;
	font-size: 1.3rem;
	color: #2c2c2c;
	margin-bottom: 15px;
	border-bottom: 2px solid #d4af37;
	padding-bottom: 5px;
}

.form-group {
	margin-bottom: 20px;
}

.form-label {
	display: block;
	margin-bottom: 8px;
	font-weight: 600;
	color: #2c2c2c;
	font-size: 1rem;
}

.required {
	color: #d4af37;
}

/* 별점 선택 */
.rating-container {
	display: flex;
	align-items: center;
	gap: 15px;
	margin-bottom: 10px;
}

.star-rating {
	display: flex;
	gap: 5px;
}

.star-input {
	display: none;
}

.star-label {
	font-size: 2rem;
	color: #ddd;
	cursor: pointer;
	transition: all 0.3s ease;
}

.star-label:hover {
	color: #ffc107;
	transform: scale(1.1);
}

.star-label.active {
	color: #ffc107 !important;
	transform: scale(1.1) !important;
}

.rating-text {
	font-weight: 600;
	color: #d4af37;
	font-size: 1.1rem;
}

/* 추천/비추천 */
.recommendation-container {
	display: flex;
	gap: 20px;
	margin-top: 10px;
}

.recommendation-option {
	flex: 1;
	padding: 15px;
	border: 2px solid #e8e6e3;
	border-radius: 8px;
	cursor: pointer;
	transition: all 0.3s ease;
	text-align: center;
	position: relative;
}

.recommendation-option input {
	display: none;
}

.recommendation-option.selected {
	border-color: #d4af37;
	background: #faf9f7;
}

.recommendation-option .icon {
	font-size: 2rem;
	margin-bottom: 5px;
	display: block;
}

.recommendation-option .text {
	font-weight: 600;
	color: #2c2c2c;
}

/* 리뷰 텍스트 */
.review-textarea {
	width: 100%;
	min-height: 120px;
	padding: 15px;
	border: 1px solid #e8e6e3;
	border-radius: 8px;
	font-family: 'Source Sans Pro', sans-serif;
	font-size: 1rem;
	line-height: 1.6;
	resize: vertical;
	background: #fafaf9;
	color: #2c2c2c;
}

.review-textarea:focus {
	outline: none;
	border-color: #d4af37;
	background: #ffffff;
	box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
}

.char-count {
	text-align: right;
	font-size: 0.85rem;
	color: #888;
	margin-top: 5px;
}

/* 이미지 업로드 */
.image-upload-container {
	border: 2px dashed #e8e6e3;
	border-radius: 8px;
	padding: 30px;
	text-align: center;
	transition: all 0.3s ease;
	cursor: pointer;
}

.image-upload-container:hover {
	border-color: #d4af37;
	background: #faf9f7;
}

.image-upload-container.has-image {
	border-style: solid;
	border-color: #d4af37;
	background: #faf9f7;
}

.upload-icon {
	font-size: 3rem;
	color: #d4af37;
	margin-bottom: 10px;
}

.upload-text {
	color: #666;
	margin-bottom: 10px;
}

.file-input {
	display: none;
}

.image-preview {
	max-width: 200px;
	max-height: 200px;
	border-radius: 8px;
	margin-top: 15px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.remove-image {
	background: #ef4444;
	color: white;
	border: none;
	border-radius: 4px;
	padding: 5px 10px;
	font-size: 0.8rem;
	cursor: pointer;
	margin-top: 10px;
	transition: all 0.3s ease;
}

.remove-image:hover {
	background: #dc2626;
}

/* 버튼 */
.form-actions {
	display: flex;
	gap: 15px;
	justify-content: center;
	margin-top: 40px;
	padding-top: 30px;
	border-top: 1px solid #f5f3f0;
}

.btn {
	padding: 12px 30px;
	border: none;
	border-radius: 6px;
	font-family: 'Source Sans Pro', sans-serif;
	font-size: 1rem;
	font-weight: 600;
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
	background: #d4af37;
	color: #ffffff;
	border: 1px solid #d4af37;
}

.btn-primary:hover {
	background: #c9a96e;
	transform: translateY(-2px);
	box-shadow: 0 4px 12px rgba(212, 175, 55, 0.3);
}

.btn-secondary {
	background: transparent;
	color: #666;
	border: 1px solid #e8e6e3;
}

.btn-secondary:hover {
	background: #f5f3f0;
	color: #2c2c2c;
	transform: translateY(-2px);
}

.btn:disabled {
	opacity: 0.6;
	cursor: not-allowed;
	transform: none !important;
}

/* 토스트 */
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

/* 반응형 */
@media ( max-width : 768px) {
	.container {
		padding: 0 15px;
	}
	.title {
		font-size: 2rem;
	}
	.rating-container {
		flex-direction: column;
		align-items: flex-start;
		gap: 10px;
	}
	.star-label {
		font-size: 1.5rem;
	}
	.recommendation-container {
		flex-direction: column;
	}
	.form-actions {
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
					<c:when test="${mode == 'edit'}">리뷰 수정</c:when>
					<c:otherwise>리뷰 작성</c:otherwise>
				</c:choose>
			</h1>
			<p class="subtitle">
				<c:choose>
					<c:when test="${mode == 'edit'}">작성하신 리뷰를 수정할 수 있습니다</c:when>
					<c:otherwise>식당에 대한 솔직한 리뷰를 작성해주세요</c:otherwise>
				</c:choose>
			</p>
		</div>

		<!-- 리뷰 폼 -->
		<div class="card">
			<!-- 레스토랑 정보 -->
			<div class="restaurant-info">
				<div class="restaurant-name">${restaurantName}</div>
			</div>

			<form id="reviewForm" method="post" enctype="multipart/form-data">
				<!-- Hidden Fields -->
				<c:choose>
					<c:when test="${mode == 'edit'}">
						<input type="hidden" name="reviewId" value="${review.reviewId}">
						<input type="hidden" name="restaurantId"
							value="${review.restaurantId}">
						<input type="hidden" name="reservationId"
							value="${review.reservationId}">
					</c:when>
					<c:otherwise>
						<input type="hidden" name="restaurantId" value="${restaurantId}">
						<input type="hidden" name="reservationId" value="${reservationId}">
					</c:otherwise>
				</c:choose>

				<!-- 별점 섹션 -->
				<div class="form-section">
					<h3 class="section-title">
						평점 <span class="required">*</span>
					</h3>
					<div class="rating-container">
						<div class="star-rating">
							<c:forEach var="i" begin="1" end="5">
								<input type="radio" name="rating" value="${i}" id="star${i}"
									class="star-input"
									<c:if test="${mode == 'edit' && review.rating == i}">checked</c:if>
									required>
								<label for="star${i}" class="star-label" data-rating="${i}">★</label>
							</c:forEach>
						</div>
						<span class="rating-text" id="ratingText"> <c:choose>
								<c:when test="${mode == 'edit'}">${review.rating}점</c:when>
								<c:otherwise>별점을 선택해주세요</c:otherwise>
							</c:choose>
						</span>
					</div>
				</div>

				<!-- 추천 여부 -->
				<div class="form-section">
					<h3 class="section-title">
						추천 여부 <span class="required">*</span>
					</h3>
					<div class="recommendation-container">
						<label
							class="recommendation-option ${mode == 'edit' && review.isRecommended ? 'selected' : ''}"
							for="recommend"> <input type="radio" name="isRecommended"
							value="true" id="recommend"
							<c:if test="${mode == 'edit' && review.isRecommended}">checked</c:if>
							required> <span class="icon">👍</span> <span class="text">추천합니다</span>
						</label> <label
							class="recommendation-option ${mode == 'edit' && !review.isRecommended ? 'selected' : ''}"
							for="notRecommend"> <input type="radio"
							name="isRecommended" value="false" id="notRecommend"
							<c:if test="${mode == 'edit' && !review.isRecommended}">checked</c:if>
							required> <span class="icon">👎</span> <span class="text">추천하지
								않습니다</span>
						</label>
					</div>
				</div>

				<!-- 리뷰 내용 -->
				<div class="form-section">
					<h3 class="section-title">리뷰 내용</h3>
					<div class="form-group">
						<label class="form-label" for="content">상세한 리뷰를 작성해주세요</label>
						<textarea name="content" id="content" class="review-textarea"
							placeholder="음식의 맛, 서비스, 분위기 등에 대해 자유롭게 작성해주세요." maxlength="1000"><c:if
								test="${mode == 'edit'}">${review.content}</c:if></textarea>
						<div class="char-count">
							<span id="charCount"> <c:choose>
									<c:when test="${mode == 'edit'}">${review.content.length()}</c:when>
									<c:otherwise>0</c:otherwise>
								</c:choose>
							</span> / 1000
						</div>
					</div>
				</div>

				<!-- 이미지 업로드 -->
				<div class="form-section">
					<h3 class="section-title">사진 첨부</h3>
					<div class="form-group">
						<div
							class="image-upload-container ${mode == 'edit' && !empty review.imageUrl ? 'has-image' : ''}"
							onclick="document.getElementById('imageFile').click()">
							<c:choose>
								<c:when test="${mode == 'edit' && !empty review.imageUrl}">
									<img src="${pageContext.request.contextPath}${review.imageUrl}"
										alt="리뷰 이미지" class="image-preview" id="imagePreview">
									<button type="button" class="remove-image"
										onclick="removeImage(event)">이미지 제거</button>
								</c:when>
								<c:otherwise>
									<div class="upload-icon">📷</div>
									<div class="upload-text">클릭하여 사진을 첨부해주세요</div>
									<div style="font-size: 0.85rem; color: #888;">JPG, PNG
										파일만 가능 (최대 5MB)</div>
								</c:otherwise>
							</c:choose>
						</div>
						<input type="file" name="imageFile" id="imageFile"
							class="file-input" accept="image/*" onchange="previewImage(this)">
					</div>
				</div>

				<!-- 제출 버튼 -->
				<div class="form-actions">
					<button type="button" class="btn btn-secondary" onclick="goBack()">
						취소</button>
					<button type="submit" class="btn btn-primary" id="submitBtn">
						<c:choose>
							<c:when test="${mode == 'edit'}">수정 완료</c:when>
							<c:otherwise>리뷰 작성</c:otherwise>
						</c:choose>
					</button>
				</div>
			</form>
		</div>
	</div>

	<%@ include file="/WEB-INF/views/footer.jsp"%>

	<script>
        // 별점 기능
        const starLabels = document.querySelectorAll('.star-label');
        const ratingText = document.getElementById('ratingText');
        const ratingTexts = ['', '별로예요', '그저 그래요', '괜찮아요', '좋아요', '최고예요'];

        starLabels.forEach((label, index) => {
            label.addEventListener('click', function() {
                const rating = parseInt(this.dataset.rating);
                
                // 라디오 버튼 체크
                const radioInput = document.getElementById('star' + rating);
                if (radioInput) {
                    radioInput.checked = true;
                }
                
                updateStarDisplay(rating);
                ratingText.textContent = rating + '점 - ' + ratingTexts[rating];
            });

            label.addEventListener('mouseenter', function() {
                const rating = parseInt(this.dataset.rating);
                updateStarDisplay(rating);
            });
        });

        document.querySelector('.star-rating').addEventListener('mouseleave', function() {
            const checkedStar = document.querySelector('input[name="rating"]:checked');
            if (checkedStar) {
                updateStarDisplay(parseInt(checkedStar.value));
            } else {
                updateStarDisplay(0);
            }
        });

        function updateStarDisplay(rating) {
            starLabels.forEach((label, index) => {
                if (index < rating) {
                    label.classList.add('active');
                } else {
                    label.classList.remove('active');
                }
            });
        }

        // 초기 별점 표시
        const checkedStar = document.querySelector('input[name="rating"]:checked');
        if (checkedStar) {
            updateStarDisplay(parseInt(checkedStar.value));
        }

        // 추천 여부 선택
        const recommendationOptions = document.querySelectorAll('.recommendation-option');
        recommendationOptions.forEach(option => {
            option.addEventListener('click', function() {
                recommendationOptions.forEach(opt => opt.classList.remove('selected'));
                this.classList.add('selected');
            });
        });

        // 텍스트 카운터
        const contentTextarea = document.getElementById('content');
        const charCount = document.getElementById('charCount');

        contentTextarea.addEventListener('input', function() {
            charCount.textContent = this.value.length;
        });

        // 이미지 미리보기
        function previewImage(input) {
            const container = document.querySelector('.image-upload-container');
            
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    container.classList.add('has-image');
                    container.innerHTML = `
                        <img src="${e.target.result}" alt="미리보기" class="image-preview" id="imagePreview">
                        <button type="button" class="remove-image" onclick="removeImage(event)">이미지 제거</button>
                    `;
                };
                
                reader.readAsDataURL(input.files[0]);
            }
        }

        function removeImage(event) {
            event.stopPropagation();
            const container = document.querySelector('.image-upload-container');
            const fileInput = document.getElementById('imageFile');
            
            container.classList.remove('has-image');
            container.innerHTML = `
                <div class="upload-icon">📷</div>
                <div class="upload-text">클릭하여 사진을 첨부해주세요</div>
                <div style="font-size: 0.85rem; color: #888;">JPG, PNG 파일만 가능 (최대 5MB)</div>
            `;
            fileInput.value = '';
        }

        // 폼 제출
        document.getElementById('reviewForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const submitBtn = document.getElementById('submitBtn');
            const formData = new FormData(this);
            
            // 버튼 비활성화
            submitBtn.disabled = true;
            submitBtn.textContent = '처리중...';
            
            const action = '${mode}' === 'edit' ? 
                '${pageContext.request.contextPath}/review/update' : 
                '${pageContext.request.contextPath}/review/create';
            
            fetch(action, {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast('리뷰가 성공적으로 ${mode == "edit" ? "수정" : "작성"}되었습니다.');
                    setTimeout(() => {
                        window.location.href = '${pageContext.request.contextPath}/user/reviews';
                    }, 1500);
                } else {
                    showToast(data.message || '오류가 발생했습니다.', 'error');
                    submitBtn.disabled = false;
                    submitBtn.textContent = '${mode == "edit" ? "수정 완료" : "리뷰 작성"}';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('네트워크 오류가 발생했습니다.', 'error');
                submitBtn.disabled = false;
                submitBtn.textContent = '${mode == "edit" ? "수정 완료" : "리뷰 작성"}';
            });
        });

        // 토스트 알림
        function showToast(message, type) {
            const toast = document.createElement('div');
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

        // 뒤로가기
        function goBack() {
            if (confirm('작성 중인 내용이 사라집니다. 정말 나가시겠습니까?')) {
                window.history.back();
            }
        }
    </script>
</body>
</html>