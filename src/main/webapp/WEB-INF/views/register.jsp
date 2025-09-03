<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/resources/images/favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/resources/images/favicon-16x16.png">
    <meta charset="UTF-8">
    <title>일반 회원가입 - Catch Table</title>
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
            max-width: 600px;
            margin: 60px auto;
            padding: 0 40px;
        }
        
        .register-card {
            background: #ffffff;
            border-radius: 2px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.05);
            border: 1px solid rgba(0, 0, 0, 0.02);
            overflow: hidden;
            position: relative;
        }
        
        .register-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #d4af37, #c9a96e);
        }
        
        .register-header {
            padding: 50px 60px 30px;
            text-align: center;
            border-bottom: 1px solid #ebe8e4;
        }
        
        .register-title {
            font-family: 'Crimson Text', serif;
            font-size: 2.2rem;
            font-weight: 600;
            color: #2c2c2c;
            margin-bottom: 10px;
            letter-spacing: 0.5px;
        }
        
        .register-subtitle {
            font-size: 1rem;
            color: #666;
            font-weight: 300;
        }
        
        .register-form {
            padding: 40px 60px 60px;
        }
        
        .form-group {
            margin-bottom: 25px;
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
        
        .required {
            color: #d4af37;
        }
        
        .form-input {
            width: 100%;
            padding: 16px 20px;
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
        
        .form-input::placeholder {
            color: #aaa;
            font-style: italic;
        }
        
        .form-row {
            display: flex;
            gap: 20px;
        }
        
        .form-col {
            flex: 1;
        }
        
        .form-select {
            width: 100%;
            padding: 16px 20px;
            border: 1px solid #e0e0e0;
            border-radius: 2px;
            font-size: 1rem;
            font-family: 'Source Sans Pro', sans-serif;
            background: #fafafa;
            color: #333;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .form-select:focus {
            outline: none;
            border-color: #d4af37;
            background: #ffffff;
            box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
        }
        
        .password-strength {
            margin-top: 8px;
            font-size: 0.8rem;
            color: #666;
        }
        
        .strength-indicator {
            display: flex;
            gap: 4px;
            margin-top: 5px;
        }
        
        .strength-bar {
            height: 4px;
            flex: 1;
            background: #e0e0e0;
            border-radius: 2px;
            transition: all 0.3s ease;
        }
        
        .strength-bar.weak { background: #ff6b6b; }
        .strength-bar.medium { background: #ffd93d; }
        .strength-bar.strong { background: #6bcf7f; }
        
        .error-message {
            color: #ff6b6b;
            font-size: 0.85rem;
            margin-top: 5px;
            display: none;
        }
        
        .success-message {
            color: #6bcf7f;
            font-size: 0.85rem;
            margin-top: 5px;
            display: none;
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
        
        .submit-btn:disabled {
            background: #ccc;
            color: #666;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        
        .login-link {
            text-align: center;
            margin-top: 30px;
            padding-top: 30px;
            border-top: 1px solid #ebe8e4;
            font-size: 0.9rem;
            color: #666;
        }
        
        .login-link a {
            color: #d4af37;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }
        
        .login-link a:hover {
            color: #c9a96e;
        }
        
        .loading {
            display: none;
            text-align: center;
            margin-top: 20px;
        }
        
        .loading-spinner {
            width: 30px;
            height: 30px;
            border: 3px solid #f0f0f0;
            border-top: 3px solid #d4af37;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        /* 반응형 */
        @media (max-width: 768px) {
            body {
                padding-top: 70px;
            }
            
            .main-container {
                margin: 40px auto;
                padding: 0 20px;
            }
            
            .register-header {
                padding: 40px 30px 25px;
            }
            
            .register-form {
                padding: 30px;
            }
            
            .register-title {
                font-size: 1.8rem;
            }
            
            .form-row {
                flex-direction: column;
                gap: 0;
            }
        }
        
        /* 애니메이션 */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .register-card {
            animation: fadeInUp 0.8s ease-out;
        }
    </style>
</head>
<body>
    <!-- 네비게이션 -->
    <%@ include file="/WEB-INF/views/navi.jsp" %>
    
    <div class="main-container">
        <div class="register-card">
            <div class="register-header">
                <h1 class="register-title">👤 일반 회원가입</h1>
                <p class="register-subtitle">Catch Table에서 맛있는 여행을 시작해보세요</p>
            </div>
            
            <form class="register-form" id="registerForm">
                <!-- 이메일 -->
                <div class="form-group">
                    <label for="email" class="form-label">이메일 <span class="required">*</span></label>
                    <input type="email" id="email" name="email" class="form-input" 
                           placeholder="이메일을 입력해주세요" required>
                    <div class="error-message" id="emailError"></div>
                    <div class="success-message" id="emailSuccess"></div>
                </div>
                
                <!-- 비밀번호 -->
                <div class="form-group">
                    <label for="password" class="form-label">비밀번호 <span class="required">*</span></label>
                    <input type="password" id="password" name="password" class="form-input" 
                           placeholder="비밀번호를 입력해주세요" required>
                    <div class="password-strength">
                        <div class="strength-indicator">
                            <div class="strength-bar" id="strength1"></div>
                            <div class="strength-bar" id="strength2"></div>
                            <div class="strength-bar" id="strength3"></div>
                            <div class="strength-bar" id="strength4"></div>
                        </div>
                        <div id="strengthText">8자 이상, 영문, 숫자, 특수문자를 포함해주세요</div>
                    </div>
                    <div class="error-message" id="passwordError"></div>
                </div>
                
                <!-- 비밀번호 확인 -->
                <div class="form-group">
                    <label for="passwordConfirm" class="form-label">비밀번호 확인 <span class="required">*</span></label>
                    <input type="password" id="passwordConfirm" name="passwordConfirm" class="form-input" 
                           placeholder="비밀번호를 다시 입력해주세요" required>
                    <div class="error-message" id="passwordConfirmError"></div>
                    <div class="success-message" id="passwordConfirmSuccess"></div>
                </div>
                
                <!-- 이름 -->
                <div class="form-group">
                    <label for="name" class="form-label">이름 <span class="required">*</span></label>
                    <input type="text" id="name" name="name" class="form-input" 
                           placeholder="이름을 입력해주세요" required>
                    <div class="error-message" id="nameError"></div>
                </div>
                
                <!-- 휴대폰번호 -->
                <div class="form-group">
                    <label for="phone" class="form-label">휴대폰번호</label>
                    <input type="tel" id="phone" name="phone" class="form-input" 
                           placeholder="010-1234-5678">
                    <div class="error-message" id="phoneError"></div>
                </div>
                
                <!-- 생년월일과 성별 -->
                <div class="form-row">
                    <div class="form-col">
                        <div class="form-group">
                            <label for="birthDate" class="form-label">생년월일</label>
                            <input type="date" id="birthDate" name="birthDate" class="form-input">
                        </div>
                    </div>
                    <div class="form-col">
                        <div class="form-group">
                            <label for="gender" class="form-label">성별</label>
                            <select id="gender" name="gender" class="form-select">
                                <option value="">선택하지 않음</option>
                                <option value="M">남성</option>
                                <option value="F">여성</option>
                            </select>
                        </div>
                    </div>
                </div>
                
                <!-- 제출 버튼 -->
                <button type="submit" class="submit-btn" id="submitBtn">회원가입</button>
                
                <!-- 로딩 -->
                <div class="loading" id="loading">
                    <div class="loading-spinner"></div>
                    <p>회원가입 처리 중...</p>
                </div>
                
                <!-- 로그인 링크 -->
                <div class="login-link">
                    이미 계정이 있으신가요? <a href="/catchtable/auth/login">로그인하기</a>
                </div>
            </form>
        </div>
    </div>
    
    <!-- 푸터 -->
    <%@ include file="/WEB-INF/views/footer.jsp" %>
    
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('registerForm');
        const emailInput = document.getElementById('email');
        const passwordInput = document.getElementById('password');
        const passwordConfirmInput = document.getElementById('passwordConfirm');
        const nameInput = document.getElementById('name');
        const phoneInput = document.getElementById('phone');
        const submitBtn = document.getElementById('submitBtn');
        const loading = document.getElementById('loading');
        
        let emailCheckTimer = null;
        
        // ===== 이메일 실시간 중복체크 =====
        emailInput.addEventListener('input', function() {
            const email = this.value.trim();
            
            // 기존 타이머 클리어
            if (emailCheckTimer) {
                clearTimeout(emailCheckTimer);
            }
            
            // 이메일이 비어있으면 메시지 숨기기
            if (!email) {
                hideError('emailError');
                hideSuccess('emailSuccess');
                return;
            }
            
            // 기본적인 이메일 형식만 체크 (@ 포함 여부)
            if (!email.includes('@')) {
                return; // 아직 입력 중이므로 메시지 표시 안함
            }
            
            // 완전한 이메일 형식인지 체크
            if (!isValidEmail(email)) {
                return; // 아직 입력 중이므로 메시지 표시 안함
            }
            
            // 500ms 후에 중복체크 실행
            emailCheckTimer = setTimeout(() => {
                checkEmailDuplicate(email);
            }, 500);
        });
        
        // 이메일 중복체크 함수
        function checkEmailDuplicate(email) {
            fetch('/catchtable/auth/check-email?email=' + encodeURIComponent(email), {
                method: 'POST'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    hideError('emailError');
                    showSuccess('emailSuccess', '✅ 사용 가능한 이메일입니다');
                } else {
                    showError('emailError', '❌ 이미 사용중인 이메일입니다');
                    hideSuccess('emailSuccess');
                }
            })
            .catch(error => {
                showError('emailError', '⚠️ 확인 중 오류가 발생했습니다');
                hideSuccess('emailSuccess');
            });
        }
        
        // 이메일 포커스 벗어날 때 형식 검증
        emailInput.addEventListener('blur', function() {
            const email = this.value.trim();
            if (email && !isValidEmail(email)) {
                showError('emailError', '올바른 이메일 형식을 입력해주세요');
                hideSuccess('emailSuccess');
            }
        });
        
        // ===== 비밀번호 강도 체크 =====
        passwordInput.addEventListener('input', function() {
            checkPasswordStrength(this.value);
        });
        
        // ===== 비밀번호 확인 =====
        passwordConfirmInput.addEventListener('input', function() {
            const password = passwordInput.value;
            const passwordConfirm = this.value;
            
            if (passwordConfirm && password !== passwordConfirm) {
                showError('passwordConfirmError', '비밀번호가 일치하지 않습니다.');
                hideSuccess('passwordConfirmSuccess');
            } else if (passwordConfirm && password === passwordConfirm) {
                hideError('passwordConfirmError');
                showSuccess('passwordConfirmSuccess', '비밀번호가 일치합니다.');
            } else {
                hideError('passwordConfirmError');
                hideSuccess('passwordConfirmSuccess');
            }
        });
        
        // ===== 휴대폰번호 형식 자동 변환 =====
        phoneInput.addEventListener('input', function() {
            let value = this.value.replace(/[^0-9]/g, '');
            if (value.length >= 3) {
                if (value.length >= 7) {
                    value = value.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
                } else {
                    value = value.replace(/(\d{3})(\d{4})/, '$1-$2');
                }
            }
            this.value = value;
        });
        
        // ===== 폼 제출 =====
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            
            if (!validateForm()) {
                return;
            }
            
            submitBtn.disabled = true;
            loading.style.display = 'block';
            
            const formData = {
                email: emailInput.value.trim(),
                password: passwordInput.value,
                name: nameInput.value.trim(),
                phone: phoneInput.value.trim() || null,
                birthDate: document.getElementById('birthDate').value || null,
                gender: document.getElementById('gender').value || null
            };
            
            // AJAX 요청
            fetch('/catchtable/auth/register', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(formData)
            })
            .then(response => response.json())
            .then(data => {
                loading.style.display = 'none';
                
                if (data.success) {
                    alert(data.message);
                    
                    // 선호도 설정 페이지로 이동 (특별한 응답 코드 확인)
                    if (data.data === "PREFERENCES") {
                        if (confirm('맞춤 맛집 추천을 위해 선호도를 설정하시겠습니까?\n(나중에도 설정할 수 있습니다)')) {
                            window.location.href = '/catchtable/preferences/setup';
                        } else {
                            window.location.href = '/catchtable/';
                        }
                    } else {
                        window.location.href = '/catchtable/auth/login';
                    }
                } else {
                    alert(data.message);
                    submitBtn.disabled = false;
                }
            })
            .catch(error => {
                loading.style.display = 'none';
                alert('오류가 발생했습니다. 다시 시도해주세요.');
                submitBtn.disabled = false;
            });
        });
        
        // ===== 유틸리티 함수들 =====
        function isValidEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }
        
        function checkPasswordStrength(password) {
            const strengthBars = document.querySelectorAll('.strength-bar');
            const strengthText = document.getElementById('strengthText');
            
            // 초기화
            strengthBars.forEach(bar => bar.className = 'strength-bar');
            
            if (password.length === 0) {
                strengthText.textContent = '8자 이상, 영문, 숫자, 특수문자를 포함해주세요';
                return;
            }
            
            let score = 0;
            if (password.length >= 8) score++;
            if (/[a-zA-Z]/.test(password)) score++;
            if (/\d/.test(password)) score++;
            if (/[!@#$%^&*(),.?":{}|<>]/.test(password)) score++;
            
            // 강도 표시
            if (score >= 1) {
                strengthBars[0].classList.add('weak');
                strengthText.textContent = '약함';
            }
            if (score >= 2) {
                strengthBars[1].classList.add('weak');
                strengthText.textContent = '보통';
            }
            if (score >= 3) {
                strengthBars[0].classList.remove('weak');
                strengthBars[1].classList.remove('weak');
                strengthBars[0].classList.add('medium');
                strengthBars[1].classList.add('medium');
                strengthBars[2].classList.add('medium');
                strengthText.textContent = '좋음';
            }
            if (score === 4) {
                strengthBars.forEach(bar => {
                    bar.classList.remove('weak', 'medium');
                    bar.classList.add('strong');
                });
                strengthText.textContent = '매우 강함';
            }
        }
        
        function validateForm() {
            let isValid = true;
            
            // 이메일 필수 체크
            if (!emailInput.value.trim()) {
                showError('emailError', '이메일은 필수입니다.');
                isValid = false;
            } else if (!isValidEmail(emailInput.value.trim())) {
                showError('emailError', '올바른 이메일 형식을 입력해주세요.');
                isValid = false;
            } else {
                // 중복체크 완료 여부 확인
                const successMessage = document.getElementById('emailSuccess');
                if (successMessage.style.display === 'none' || !successMessage.textContent.includes('사용 가능')) {
                    showError('emailError', '이메일 중복확인을 완료해주세요.');
                    isValid = false;
                }
            }
            
            // 비밀번호 필수 체크
            if (!passwordInput.value) {
                showError('passwordError', '비밀번호는 필수입니다.');
                isValid = false;
            }
            
            // 이름 필수 체크
            if (!nameInput.value.trim()) {
                showError('nameError', '이름은 필수입니다.');
                isValid = false;
            }
            
            // 비밀번호 확인
            if (passwordInput.value !== passwordConfirmInput.value) {
                showError('passwordConfirmError', '비밀번호가 일치하지 않습니다.');
                isValid = false;
            }
            
            return isValid;
        }
        
        function showError(id, message) {
            const element = document.getElementById(id);
            element.textContent = message;
            element.style.display = 'block';
        }
        
        function hideError(id) {
            document.getElementById(id).style.display = 'none';
        }
        
        function showSuccess(id, message) {
            const element = document.getElementById(id);
            element.textContent = message;
            element.style.display = 'block';
        }
        
        function hideSuccess(id) {
            document.getElementById(id).style.display = 'none';
        }
    });
    </script>
</body>
</html>