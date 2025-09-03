<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/resources/images/favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/resources/images/favicon-16x16.png">
    <meta charset="UTF-8">
    <title>로그인 - Catch Table</title>
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
            background: linear-gradient(135deg, #f7f5f3 0%, #faf8f5 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .login-container {
            width: 100%;
            max-width: 500px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .login-card {
            background: #ffffff;
            border-radius: 2px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(0, 0, 0, 0.02);
            overflow: hidden;
            position: relative;
        }
        
        .login-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #d4af37, #c9a96e);
        }
        
        .login-header {
            text-align: center;
            padding: 50px 40px 30px;
            background: rgba(247, 245, 243, 0.3);
        }
        
        .logo {
            font-family: 'Crimson Text', serif;
            font-size: 2.5rem;
            font-weight: 600;
            color: #d4af37;
            margin-bottom: 10px;
            letter-spacing: 1px;
        }
        
        .tagline {
            font-size: 0.95rem;
            color: #666;
            font-weight: 300;
        }
        
        .login-tabs {
            display: flex;
            background: #f8f6f4;
            border-top: 1px solid rgba(0, 0, 0, 0.05);
        }
        
        .tab-button {
            flex: 1;
            padding: 20px;
            background: transparent;
            border: none;
            font-family: 'Source Sans Pro', sans-serif;
            font-size: 0.9rem;
            font-weight: 500;
            color: #666;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            position: relative;
        }
        
        .tab-button.active {
            background: #ffffff;
            color: #d4af37;
        }
        
        .tab-button.active::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 2px;
            background: #d4af37;
        }
        
        .tab-button:hover:not(.active) {
            background: rgba(212, 175, 55, 0.05);
            color: #2c2c2c;
        }
        
        .login-content {
            padding: 40px;
        }
        
        .tab-panel {
            display: none;
        }
        
        .tab-panel.active {
            display: block;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-label {
            display: block;
            font-size: 0.85rem;
            font-weight: 500;
            color: #2c2c2c;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .form-input {
            width: 100%;
            padding: 15px 18px;
            border: 1px solid #e0e0e0;
            border-radius: 2px;
            font-size: 0.95rem;
            font-family: 'Source Sans Pro', sans-serif;
            transition: all 0.3s ease;
            background: #fafafa;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #d4af37;
            background: #ffffff;
            box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
        }
        
        .form-input:hover {
            border-color: #c0c0c0;
            background: #ffffff;
        }
        
        .login-button {
            width: 100%;
            padding: 18px;
            background: linear-gradient(135deg, #d4af37 0%, #c9a96e 100%);
            border: none;
            border-radius: 2px;
            color: #ffffff;
            font-family: 'Source Sans Pro', sans-serif;
            font-size: 0.9rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
        }
        
        .login-button:hover {
            transform: translateY(-1px);
            box-shadow: 0 8px 25px rgba(212, 175, 55, 0.3);
        }
        
        .login-button:active {
            transform: translateY(0);
        }
        
        .login-button:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }
        
        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 25px 0;
            font-size: 0.85rem;
        }
        
        .remember-me {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .remember-me input[type="checkbox"] {
            width: 16px;
            height: 16px;
            accent-color: #d4af37;
        }
        
        .forgot-password {
            color: #666;
            text-decoration: none;
            transition: color 0.3s ease;
        }
        
        .forgot-password:hover {
            color: #d4af37;
        }
        
        .divider {
            text-align: center;
            margin: 30px 0;
            position: relative;
            color: #999;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: #e0e0e0;
            z-index: 1;
        }
        
        .divider span {
            background: #ffffff;
            padding: 0 20px;
            position: relative;
            z-index: 2;
        }
        
        .register-link {
            text-align: center;
            padding: 25px 0 10px;
            font-size: 0.9rem;
            color: #666;
        }
        
        .register-link a {
            color: #d4af37;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }
        
        .register-link a:hover {
            color: #b8941f;
            text-decoration: underline;
        }
        
        .error-message {
            background: rgba(231, 76, 60, 0.1);
            color: #e74c3c;
            padding: 15px;
            border-radius: 2px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            display: none;
        }
        
        .success-message {
            background: rgba(39, 174, 96, 0.1);
            color: #27ae60;
            padding: 15px;
            border-radius: 2px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            display: none;
        }
        
        .loading {
            display: none;
            text-align: center;
            color: #666;
            font-size: 0.9rem;
            margin-top: 10px;
        }
        
        .loading::after {
            content: '';
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 2px solid #e0e0e0;
            border-top: 2px solid #d4af37;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-left: 10px;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .admin-notice {
            background: rgba(212, 175, 55, 0.1);
            padding: 15px;
            border-radius: 2px;
            margin-bottom: 20px;
            font-size: 0.85rem;
            
            color: #8b7355;
        }
        
        .business-notice {
            background: rgba(52, 152, 219, 0.1);
            padding: 15px;
            border-radius: 2px;
            margin-bottom: 20px;
            font-size: 0.85rem;
            color: #2980b9;
        }
        
        @media (max-width: 768px) {
            .login-container {
                padding: 0 15px;
                margin: 20px auto;
            }
            
            .login-content {
                padding: 30px 25px;
            }
            
            .login-header {
                padding: 40px 25px 25px;
            }
            
            .logo {
                font-size: 2rem;
            }
            
            .tab-button {
                padding: 15px;
                font-size: 0.85rem;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-card">
            <div class="login-header">
                <div class="logo">Catch Table</div>
                <div class="tagline">맛있는 순간, 특별한 만남</div>
            </div>
            
            <div class="login-tabs">
                <button class="tab-button active" onclick="switchTab('user')">
                    👤 일반회원 
                </button>
                <button class="tab-button" onclick="switchTab('business')">
                    🏢 사업자
                </button>
            </div>
            
            <div class="login-content">
                <div id="error-message" class="error-message"></div>
                <div id="success-message" class="success-message"></div>
                
                <!-- 일반회원/관리자 로그인 탭 -->
                <div id="user-tab" class="tab-panel active">
                    <div class="admin-notice">
                        💡 일반회원 전용 로그인입니다.
                    </div>
                    
                    <form id="user-login-form">
                        <div class="form-group">
                            <label class="form-label">이메일</label>
                            <input type="email" class="form-input" name="email" placeholder="이메일을 입력하세요" required>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">비밀번호</label>
                            <input type="password" class="form-input" name="password" placeholder="비밀번호를 입력하세요" required>
                        </div>
                        
                        <div class="form-options">
                            <label class="remember-me">
                                <input type="checkbox" name="remember">
                                <span>로그인 유지</span>
                            </label>
                            <a href="#" class="forgot-password">비밀번호 찾기</a>
                        </div>
                        
                        <button type="submit" class="login-button">로그인</button>
                        <div class="loading" id="user-loading">로그인 중...</div>
                    </form>
                    
                    <div class="divider">
                        <span>또는</span>
                    </div>
                    
                    <div class="register-link">
                        아직 회원이 아니신가요? <a href="/catchtable/auth/register">회원가입</a>
                    </div>
                </div>
                
                <!-- 사업자 로그인 탭 -->
                <div id="business-tab" class="tab-panel">
                    <div class="business-notice">
                        🏢 사업자 전용 로그인입니다. 승인 완료 후 이용 가능합니다.
                    </div>
                    
                    <form id="business-login-form">
                        <div class="form-group">
                            <label class="form-label">사업자 이메일</label>
                            <input type="email" class="form-input" name="email" placeholder="사업자 이메일을 입력하세요" required>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">비밀번호</label>
                            <input type="password" class="form-input" name="password" placeholder="비밀번호를 입력하세요" required>
                        </div>
                        
                        <div class="form-options">
                            <label class="remember-me">
                                <input type="checkbox" name="remember">
                                <span>로그인 유지</span>
                            </label>
                            <a href="#" class="forgot-password">비밀번호 찾기</a>
                        </div>
                        
                        <button type="submit" class="login-button">사업자 로그인</button>
                        <div class="loading" id="business-loading">로그인 중...</div>
                    </form>
                    
                    <div class="divider">
                        <span>또는</span>
                    </div>
                    
                    <div class="register-link">
                        사업자 등록을 원하시나요? <a href="/catchtable/auth/business-register">사업자 등록</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
<script>
    // 탭 전환 함수
    function switchTab(tabType) {
        // 모든 탭 버튼과 패널 비활성화
        document.querySelectorAll('.tab-button').forEach(btn => btn.classList.remove('active'));
        document.querySelectorAll('.tab-panel').forEach(panel => panel.classList.remove('active'));
        
        // 선택된 탭 활성화
        if (tabType === 'user') {
            document.querySelector('.tab-button:first-child').classList.add('active');
            document.getElementById('user-tab').classList.add('active');
        } else {
            document.querySelector('.tab-button:last-child').classList.add('active');
            document.getElementById('business-tab').classList.add('active');
        }
        
        // 메시지 초기화
        hideMessages();
    }
    
    // 메시지 표시 함수들
    function showError(message) {
        const errorDiv = document.getElementById('error-message');
        errorDiv.textContent = message;
        errorDiv.style.display = 'block';
        document.getElementById('success-message').style.display = 'none';
    }
    
    function showSuccess(message) {
        const successDiv = document.getElementById('success-message');
        successDiv.textContent = message;
        successDiv.style.display = 'block';
        document.getElementById('error-message').style.display = 'none';
    }
    
    function hideMessages() {
        document.getElementById('error-message').style.display = 'none';
        document.getElementById('success-message').style.display = 'none';
    }
    
    // 로딩 표시 함수들
    function showLoading(type) {
        const loadingElement = document.getElementById(type + '-loading');
        const buttonElement = document.querySelector(`#${type}-login-form button[type="submit"]`);
        
        if (loadingElement) {
            loadingElement.style.display = 'block';
        }
        if (buttonElement) {
            buttonElement.disabled = true;
        }
    }
    
    function hideLoading(type) {
        const loadingElement = document.getElementById(type + '-loading');
        const buttonElement = document.querySelector(`#${type}-login-form button[type="submit"]`);
        
        if (loadingElement) {
            loadingElement.style.display = 'none';
        }
        if (buttonElement) {
            buttonElement.disabled = false;
        }
    }
    
    // 일반회원/관리자 로그인 처리
    document.getElementById('user-login-form').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const email = this.email.value.trim();
        const password = this.password.value.trim();
        
        if (!email || !password) {
            showError('이메일과 비밀번호를 모두 입력해주세요.');
            return;
        }
        
        showLoading('user');
        hideMessages();
        
        // 🔥 일반회원/관리자 전용 로그인 API 호출
        fetch('/catchtable/auth/user-login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                email: email,
                password: password
            })
        })
        .then(response => response.json())
        .then(data => {
            hideLoading('user');
            
            if (data.success) {
                showSuccess('로그인 성공! 페이지를 이동합니다...');
                
                // 🎯 리다이렉트 URL 처리
                const redirectUrl = '${redirectUrl}' || '/catchtable/';
                setTimeout(() => {
                    window.location.href = redirectUrl;
                }, 1000);
            } else {
                showError(data.message || '로그인에 실패했습니다.');
            }
        })
        .catch(error => {
            hideLoading('user');
            showError('네트워크 오류가 발생했습니다. 다시 시도해주세요.');
            console.error('로그인 오류:', error);
        });
    });
    
 // 사업자 로그인 처리
    document.getElementById('business-login-form').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const email = this.email.value.trim();
        const password = this.password.value.trim();
        
        if (!email || !password) {
            showError('이메일과 비밀번호를 모두 입력해주세요.');
            return;
        }
        
        showLoading('business');
        hideMessages();
        
        // 사업자 전용 로그인 API 호출
        fetch('/catchtable/auth/business-login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                email: email,
                password: password
            })
        })
        .then(response => response.json())
        .then(data => {
            hideLoading('business');
            
            if (data.success) {
                showSuccess('사업자 로그인 성공! 페이지를 이동합니다...');
                
                // 원래 페이지 또는 메인 페이지로
                const redirectUrl = '${redirectUrl}' || '/catchtable/';
                
                setTimeout(() => {
                    window.location.href = redirectUrl;
                }, 1000);
            } else {
                showError(data.message || '사업자 로그인에 실패했습니다.');
            }
        })
        .catch(error => {
            hideLoading('business');
            showError('네트워크 오류가 발생했습니다. 다시 시도해주세요.');
            console.error('사업자 로그인 오류:', error);
        });
    });
    // Enter 키로 폼 제출
    document.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            const activeTab = document.querySelector('.tab-panel.active');
            const form = activeTab.querySelector('form');
            if (form) {
                form.dispatchEvent(new Event('submit'));
            }
        }
    });
    
    // 페이지 로드 시 URL 파라미터 확인
    document.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const tab = urlParams.get('tab');
        
        if (tab === 'business') {
            switchTab('business');
        }
        
        // 에러 메시지가 있으면 표시
        const error = urlParams.get('error');
        if (error) {
            showError(decodeURIComponent(error));
        }
        
        // 성공 메시지가 있으면 표시
        const success = urlParams.get('success');
        if (success) {
            showSuccess(decodeURIComponent(success));
        }
    });
</script>
 
</body>
</html>