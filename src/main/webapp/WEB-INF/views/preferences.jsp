<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/resources/images/favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/resources/images/favicon-16x16.png">
    <meta charset="UTF-8">
    <title>맛집 선호도 설정 - Catch Table</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Crimson+Text:ital,wght@0,400;0,600;1,400&family=Source+Sans+Pro:wght@300;400;600&display=swap');
        
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
            max-width: 700px;
            margin: 60px auto;
            padding: 0 40px;
        }
        
        .preferences-card {
            background: #ffffff;
            border-radius: 2px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.05);
            border: 1px solid rgba(0, 0, 0, 0.02);
            overflow: hidden;
            position: relative;
        }
        
        .preferences-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #d4af37, #c9a96e);
        }
        
        .preferences-header {
            padding: 50px 60px 30px;
            text-align: center;
            border-bottom: 1px solid #ebe8e4;
        }
        
        .preferences-title {
            font-family: 'Crimson Text', serif;
            font-size: 2.2rem;
            font-weight: 600;
            color: #2c2c2c;
            margin-bottom: 10px;
            letter-spacing: 0.5px;
        }
        
        .preferences-subtitle {
            font-size: 1rem;
            color: #666;
            font-weight: 300;
        }
        
        .preferences-form {
            padding: 40px 60px 60px;
        }
        
        .form-group {
            margin-bottom: 30px;
        }
        
        .form-label {
            display: block;
            font-size: 1rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
            font-family: 'Crimson Text', serif;
        }
        
        .cuisine-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .cuisine-item {
            position: relative;
        }
        
        .cuisine-checkbox {
            position: absolute;
            opacity: 0;
            cursor: pointer;
        }
        
        .cuisine-label {
            display: block;
            background: #fafafa;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            padding: 20px 15px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 0.9rem;
            font-weight: 500;
        }
        
        .cuisine-icon {
            font-size: 1.5rem;
            display: block;
            margin-bottom: 8px;
        }
        
        .cuisine-checkbox:checked + .cuisine-label {
            background: rgba(212, 175, 55, 0.1);
            border-color: #d4af37;
            color: #2c2c2c;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(212, 175, 55, 0.2);
        }
        
        .cuisine-label:hover {
            border-color: #d4af37;
            transform: translateY(-1px);
        }
        
        .price-options, .area-options {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .option-item {
            position: relative;
        }
        
        .option-radio {
            position: absolute;
            opacity: 0;
            cursor: pointer;
        }
        
        .option-label {
            display: block;
            background: #fafafa;
            border: 2px solid #e0e0e0;
            border-radius: 25px;
            padding: 12px 24px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 0.9rem;
            font-weight: 500;
            white-space: nowrap;
        }
        
        .option-radio:checked + .option-label {
            background: #d4af37;
            border-color: #d4af37;
            color: #ffffff;
            transform: scale(1.05);
        }
        
        .option-label:hover {
            border-color: #d4af37;
            transform: scale(1.02);
        }
        
        .submit-btn {
            width: 100%;
            background: #d4af37;
            color: #2c2c2c;
            border: none;
            padding: 18px;
            font-family: 'Source Sans Pro', sans-serif;
            font-size: 1rem;
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
        
        .skip-btn {
            width: 100%;
            background: transparent;
            color: #666;
            border: 1px solid #ccc;
            padding: 15px;
            font-family: 'Source Sans Pro', sans-serif;
            font-size: 0.9rem;
            border-radius: 2px;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 15px;
        }
        
        .skip-btn:hover {
            color: #2c2c2c;
            border-color: #999;
        }
        
        @media (max-width: 768px) {
            body { padding-top: 70px; }
            .main-container { margin: 40px auto; padding: 0 20px; }
            .preferences-header { padding: 40px 30px 25px; }
            .preferences-form { padding: 30px; }
            .preferences-title { font-size: 1.8rem; }
            .cuisine-grid { grid-template-columns: repeat(auto-fit, minmax(100px, 1fr)); }
            .price-options, .area-options { flex-direction: column; }
        }
    </style>
</head>
<body>
    <!-- 네비게이션 -->
    <%@ include file="/WEB-INF/views/navi.jsp" %>
    
    <div class="main-container">
        <div class="preferences-card">
            <div class="preferences-header">
                <h1 class="preferences-title">🍽️ 맛집 선호도 설정</h1>
                <p class="preferences-subtitle">취향에 맞는 맛집을 추천받기 위해 선호도를 설정해주세요</p>
            </div>
            
            <form class="preferences-form" id="preferencesForm">
                <!-- 선호 음식 종류 -->
                <div class="form-group">
                    <label class="form-label">선호하는 음식 종류 (복수 선택 가능)</label>
                    <div class="cuisine-grid">
                        <div class="cuisine-item">
                            <input type="checkbox" id="korean" name="cuisineTypes" value="한식" class="cuisine-checkbox">
                            <label for="korean" class="cuisine-label">
                                <span class="cuisine-icon">🍚</span>
                                한식
                            </label>
                        </div>
                        <div class="cuisine-item">
                            <input type="checkbox" id="chinese" name="cuisineTypes" value="중식" class="cuisine-checkbox">
                            <label for="chinese" class="cuisine-label">
                                <span class="cuisine-icon">🍜</span>
                                중식
                            </label>
                        </div>
                        <div class="cuisine-item">
                            <input type="checkbox" id="japanese" name="cuisineTypes" value="일식" class="cuisine-checkbox">
                            <label for="japanese" class="cuisine-label">
                                <span class="cuisine-icon">🍣</span>
                                일식
                            </label>
                        </div>
                        <div class="cuisine-item">
                            <input type="checkbox" id="western" name="cuisineTypes" value="양식" class="cuisine-checkbox">
                            <label for="western" class="cuisine-label">
                                <span class="cuisine-icon">🍝</span>
                                양식
                            </label>
                        </div>
                        <div class="cuisine-item">
                            <input type="checkbox" id="thai" name="cuisineTypes" value="태국음식" class="cuisine-checkbox">
                            <label for="thai" class="cuisine-label">
                                <span class="cuisine-icon">🍛</span>
                                태국음식
                            </label>
                        </div>
                        <div class="cuisine-item">
                            <input type="checkbox" id="cafe" name="cuisineTypes" value="카페/디저트" class="cuisine-checkbox">
                            <label for="cafe" class="cuisine-label">
                                <span class="cuisine-icon">☕</span>
                                카페/디저트
                            </label>
                        </div>
                    </div>
                </div>
                
                <!-- 선호 가격대 -->
                <div class="form-group">
                    <label class="form-label">선호하는 가격대</label>
                    <div class="price-options">
                        <div class="option-item">
                            <input type="radio" id="low" name="priceRange" value="LOW" class="option-radio">
                            <label for="low" class="option-label">💰 저렴한 (1만원 이하)</label>
                        </div>
                        <div class="option-item">
                            <input type="radio" id="medium" name="priceRange" value="MEDIUM" class="option-radio">
                            <label for="medium" class="option-label">💰💰 보통 (1-3만원)</label>
                        </div>
                        <div class="option-item">
                            <input type="radio" id="high" name="priceRange" value="HIGH" class="option-radio">
                            <label for="high" class="option-label">💰💰💰 고급 (3만원 이상)</label>
                        </div>
                    </div>
                </div>
                
                <!-- 선호 지역 -->
                <div class="form-group">
                    <label class="form-label">선호하는 지역</label>
                    <div class="area-options">
                        <div class="option-item">
                            <input type="radio" id="gangnam" name="preferredArea" value="강남구" class="option-radio">
                            <label for="gangnam" class="option-label">📍 강남구</label>
                        </div>
                        <div class="option-item">
                            <input type="radio" id="hongdae" name="preferredArea" value="마포구" class="option-radio">
                            <label for="hongdae" class="option-label">📍 마포구 (홍대)</label>
                        </div>
                        <div class="option-item">
                            <input type="radio" id="myeongdong" name="preferredArea" value="중구" class="option-radio">
                            <label for="myeongdong" class="option-label">📍 중구 (명동)</label>
                        </div>
                        <div class="option-item">
                            <input type="radio" id="itaewon" name="preferredArea" value="용산구" class="option-radio">
                            <label for="itaewon" class="option-label">📍 용산구 (이태원)</label>
                        </div>
                        <div class="option-item">
                            <input type="radio" id="other" name="preferredArea" value="기타" class="option-radio">
                            <label for="other" class="option-label">📍 기타 지역</label>
                        </div>
                    </div>
                </div>
                
                <button type="submit" class="submit-btn">선호도 저장하기</button>
                <button type="button" class="skip-btn" onclick="skipPreferences()">나중에 설정하기</button>
            </form>
        </div>
    </div>
    
    <!-- 푸터 -->
    <%@ include file="/WEB-INF/views/footer.jsp" %>
    
    <script>
        document.getElementById('preferencesForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // 선택된 음식 종류들 수집
            const selectedCuisines = [];
            document.querySelectorAll('input[name="cuisineTypes"]:checked').forEach(function(checkbox) {
                selectedCuisines.push(checkbox.value);
            });
            
            // 선택된 가격대
            const selectedPriceRange = document.querySelector('input[name="priceRange"]:checked');
            
            // 선택된 지역
            const selectedArea = document.querySelector('input[name="preferredArea"]:checked');
            
            // 기본 유효성 검사
            if (selectedCuisines.length === 0) {
                alert('최소 하나의 음식 종류를 선택해주세요.');
                return;
            }
            
            const formData = {
                preferredCuisineTypes: selectedCuisines.join(','),
                preferredPriceRange: selectedPriceRange ? selectedPriceRange.value : null,
                preferredArea: selectedArea ? selectedArea.value : null
            };
            
            // AJAX 요청
            fetch('/catchtable/preferences/save', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(formData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('선호도가 저장되었습니다! 맞춤 맛집을 추천받아보세요.');
                    window.location.href = '/catchtable/';
                } else {
                    alert(data.message);
                }
            })
            .catch(error => {
                alert('오류가 발생했습니다. 다시 시도해주세요.');
            });
        });
        
        function skipPreferences() {
            if (confirm('선호도 설정을 건너뛰시겠습니까?\n나중에 마이페이지에서 설정할 수 있습니다.')) {
                window.location.href = '/catchtable/';
            }
        }
    </script>
</body>
</html>