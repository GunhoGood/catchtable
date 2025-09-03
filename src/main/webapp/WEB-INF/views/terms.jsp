<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/resources/images/favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/resources/images/favicon-16x16.png">
    <meta charset="UTF-8">
    <title>회원가입 약관 동의 - Catch Table</title>
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
            max-width: 800px;
            margin: 60px auto;
            padding: 0 40px;
        }
        
        .terms-card {
            background: #ffffff;
            border-radius: 2px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.05);
            border: 1px solid rgba(0, 0, 0, 0.02);
            overflow: hidden;
            position: relative;
        }
        
        .terms-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #d4af37, #c9a96e);
        }
        
        .terms-header {
            padding: 50px 60px 30px;
            text-align: center;
            border-bottom: 1px solid #ebe8e4;
        }
        
        .terms-title {
            font-family: 'Crimson Text', serif;
            font-size: 2.2rem;
            font-weight: 600;
            color: #2c2c2c;
            margin-bottom: 10px;
            letter-spacing: 0.5px;
        }
        
        .terms-subtitle {
            font-size: 1rem;
            color: #666;
            font-weight: 300;
        }
        
        .terms-content {
            padding: 40px 60px;
        }
        
        .terms-section {
            margin-bottom: 40px;
        }
        
        .section-title {
            font-family: 'Crimson Text', serif;
            font-size: 1.4rem;
            font-weight: 600;
            color: #2c2c2c;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f5f3f0;
        }
        
        .terms-box {
            background: #fafaf9;
            border: 1px solid #ebe8e4;
            border-radius: 2px;
            padding: 25px;
            max-height: 200px;
            overflow-y: auto;
            margin-bottom: 20px;
            font-size: 0.9rem;
            line-height: 1.7;
            color: #555;
        }
        
        .terms-box::-webkit-scrollbar {
            width: 6px;
        }
        
        .terms-box::-webkit-scrollbar-track {
            background: #f5f3f0;
            border-radius: 3px;
        }
        
        .terms-box::-webkit-scrollbar-thumb {
            background: #d4af37;
            border-radius: 3px;
        }
        
        .checkbox-container {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
            padding: 10px;
            border-radius: 2px;
        }
        
        .checkbox-container:hover {
            background: rgba(212, 175, 55, 0.05);
        }
        
        .checkbox-container input[type="checkbox"] {
            width: 18px;
            height: 18px;
            accent-color: #d4af37;
            cursor: pointer;
        }
        
        .checkbox-label {
            font-size: 0.95rem;
            color: #333;
            cursor: pointer;
            font-weight: 500;
        }
        
        .required {
            color: #d4af37;
            font-weight: 600;
        }
        
        .all-agree {
            background: rgba(212, 175, 55, 0.1);
            border: 1px solid rgba(212, 175, 55, 0.3);
            padding: 20px;
            border-radius: 2px;
            margin: 30px 0;
        }
        
        .all-agree .checkbox-label {
            font-size: 1.1rem;
            font-weight: 600;
            color: #2c2c2c;
        }
        
        .signup-type-section {
            margin-top: 40px;
            padding-top: 40px;
            border-top: 1px solid #ebe8e4;
        }
        
        .signup-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .signup-btn {
            display: inline-block;
            padding: 18px 35px;
            text-decoration: none;
            font-family: 'Source Sans Pro', sans-serif;
            font-size: 0.9rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            border-radius: 2px;
            transition: all 0.3s ease;
            border: 1px solid;
            cursor: pointer;
            opacity: 0.4;
            pointer-events: none;
        }
        
        .signup-btn.enabled {
            opacity: 1;
            pointer-events: auto;
        }
        
        .signup-btn.user {
            background: #d4af37;
            color: #2c2c2c;
            border-color: #d4af37;
        }
        
        .signup-btn.user:hover {
            background: transparent;
            color: #d4af37;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(212, 175, 55, 0.3);
        }
        
        .signup-btn.business {
            background: transparent;
            color: #666;
            border-color: #ccc;
        }
        
        .signup-btn.business.enabled {
            color: #2c2c2c;
            border-color: #2c2c2c;
        }
        
        .signup-btn.business:hover {
            background: #2c2c2c;
            color: #ffffff;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(44, 44, 44, 0.3);
        }
        
        .signup-type-title {
            font-family: 'Crimson Text', serif;
            font-size: 1.6rem;
            font-weight: 600;
            color: #2c2c2c;
            text-align: center;
            margin-bottom: 30px;
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
            
            .terms-header {
                padding: 40px 30px 25px;
            }
            
            .terms-content {
                padding: 30px;
            }
            
            .terms-title {
                font-size: 1.8rem;
            }
            
            .signup-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .signup-btn {
                width: 100%;
                max-width: 300px;
                text-align: center;
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
        
        .terms-card {
            animation: fadeInUp 0.8s ease-out;
        }
        
        .signup-btn.enabled {
            animation: buttonActivate 0.5s ease-out;
        }
        
        @keyframes buttonActivate {
            from {
                opacity: 0.4;
                transform: scale(0.95);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }
    </style>
</head>
<body>
    <!-- 네비게이션 -->
    <%@ include file="/WEB-INF/views/navi.jsp" %>
    
    <div class="main-container">
        <div class="terms-card">
            <div class="terms-header">
                <h1 class="terms-title">회원가입 약관</h1>
                <p class="terms-subtitle">서비스 이용을 위해 약관에 동의해주세요</p>
            </div>
            
            <div class="terms-content">
                <!-- 이용약관 -->
                <div class="terms-section">
                    <h2 class="section-title">이용약관 <span class="required">(필수)</span></h2>
                    <div class="terms-box">
                        <h3>제1조 목적</h3>
                        <p>본 약관은 Catch Table(이하 "회사")이 제공하는 맛집 예약 서비스(이하 "서비스")의 이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.</p>
                        
                        <h3>제2조 정의</h3>
                        <p>1. "서비스"란 회사가 제공하는 맛집 정보 제공 및 예약 중개 서비스를 말합니다.</p>
                        <p>2. "이용자"란 본 약관에 따라 회사가 제공하는 서비스를 받는 회원 및 비회원을 말합니다.</p>
                        <p>3. "회원"이란 회사에 개인정보를 제공하여 회원등록을 한 자로서, 회사의 정보를 지속적으로 제공받으며 회사가 제공하는 서비스를 계속적으로 이용할 수 있는 자를 말합니다.</p>
                        
                        <h3>제3조 약관의 효력 및 변경</h3>
                        <p>1. 본 약관은 회원가입 시 동의함으로써 효력이 발생합니다.</p>
                        <p>2. 회사는 약관의 규제에 관한 법률, 정보통신망 이용촉진 및 정보보호 등에 관한 법률 등 관련법을 위배하지 않는 범위에서 본 약관을 개정할 수 있습니다.</p>
                        
                        <h3>제4조 서비스의 제공 및 변경</h3>
                        <p>1. 회사는 다음과 같은 업무를 수행합니다.</p>
                        <p>- 맛집 정보 제공 서비스</p>
                        <p>- 예약 중개 및 관리 서비스</p>
                        <p>- 리뷰 및 평점 서비스</p>
                        <p>- 기타 회사가 정하는 업무</p>
                    </div>
                    <div class="checkbox-container">
                        <input type="checkbox" id="terms-service" />
                        <label for="terms-service" class="checkbox-label">이용약관에 동의합니다 <span class="required">(필수)</span></label>
                    </div>
                </div>
                
                <!-- 개인정보처리방침 -->
                <div class="terms-section">
                    <h2 class="section-title">개인정보처리방침 <span class="required">(필수)</span></h2>
                    <div class="terms-box">
                        <h3>1. 개인정보의 처리 목적</h3>
                        <p>Catch Table은 다음의 목적을 위하여 개인정보를 처리합니다.</p>
                        <p>- 회원 가입 및 관리</p>
                        <p>- 서비스 제공 및 계약 이행</p>
                        <p>- 고객 상담 및 불만처리</p>
                        <p>- 마케팅 및 광고 활용</p>
                        
                        <h3>2. 처리하는 개인정보의 항목</h3>
                        <p>- 필수항목: 이메일, 비밀번호, 이름, 휴대폰번호</p>
                        <p>- 선택항목: 생년월일, 성별</p>
                        <p>- 자동 생성 정보: 접속 IP, 쿠키, 접속 기록</p>
                        
                        <h3>3. 개인정보의 처리 및 보유 기간</h3>
                        <p>회사는 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.</p>
                        
                        <h3>4. 개인정보의 제3자 제공</h3>
                        <p>회사는 정보주체의 개인정보를 제1조(개인정보의 처리 목적)에서 명시한 범위 내에서만 처리하며, 정보주체의 동의, 법률의 특별한 규정 등 개인정보 보호법 제17조 및 제18조에 해당하는 경우에만 개인정보를 제3자에게 제공합니다.</p>
                    </div>
                    <div class="checkbox-container">
                        <input type="checkbox" id="terms-privacy" />
                        <label for="terms-privacy" class="checkbox-label">개인정보처리방침에 동의합니다 <span class="required">(필수)</span></label>
                    </div>
                </div>
                
                <!-- 마케팅 정보 수신 동의 -->
                <div class="terms-section">
                    <h2 class="section-title">마케팅 정보 수신 동의 (선택)</h2>
                    <div class="terms-box">
                        <h3>마케팅 정보 수신 동의</h3>
                        <p>회사는 다음과 같은 마케팅 정보를 제공합니다:</p>
                        <p>- 신규 서비스 및 이벤트 정보</p>
                        <p>- 맞춤형 맛집 추천</p>
                        <p>- 특가 할인 혜택 정보</p>
                        <p>- 기타 프로모션 정보</p>
                        <br>
                        <p>마케팅 정보 수신에 동의하지 않아도 서비스 이용에는 제한이 없으며, 언제든지 마이페이지에서 수신 동의를 철회할 수 있습니다.</p>
                    </div>
                    <div class="checkbox-container">
                        <input type="checkbox" id="terms-marketing" />
                        <label for="terms-marketing" class="checkbox-label">마케팅 정보 수신에 동의합니다 (선택)</label>
                    </div>
                </div>
                
                <!-- 전체 동의 -->
                <div class="all-agree">
                    <div class="checkbox-container">
                        <input type="checkbox" id="terms-all" />
                        <label for="terms-all" class="checkbox-label">전체 약관에 동의합니다</label>
                    </div>
                </div>
                
                <!-- 가입 유형 선택 -->
                <div class="signup-type-section">
                    <h2 class="signup-type-title">가입 유형을 선택해주세요</h2>
                    <div class="signup-buttons">
                        <a href="/catchtable/auth/register" class="signup-btn user" id="userSignupBtn">
                            👤 일반 회원으로 가입하기
                        </a>
                        <a href="/catchtable/auth/business-register" class="signup-btn business" id="businessSignupBtn">
                            🏢 사업자 회원으로 가입하기
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 푸터 -->
    <%@ include file="/WEB-INF/views/footer.jsp" %>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const termsService = document.getElementById('terms-service');
            const termsPrivacy = document.getElementById('terms-privacy');
            const termsMarketing = document.getElementById('terms-marketing');
            const termsAll = document.getElementById('terms-all');
            const userSignupBtn = document.getElementById('userSignupBtn');
            const businessSignupBtn = document.getElementById('businessSignupBtn');
            
            // 필수 약관 체크 상태 확인
            function checkRequiredTerms() {
                const requiredChecked = termsService.checked && termsPrivacy.checked;
                
                if (requiredChecked) {
                    userSignupBtn.classList.add('enabled');
                    businessSignupBtn.classList.add('enabled');
                } else {
                    userSignupBtn.classList.remove('enabled');
                    businessSignupBtn.classList.remove('enabled');
                }
                
                return requiredChecked;
            }
            
            // 전체 동의 체크박스 처리
            termsAll.addEventListener('change', function() {
                const isChecked = this.checked;
                termsService.checked = isChecked;
                termsPrivacy.checked = isChecked;
                termsMarketing.checked = isChecked;
                checkRequiredTerms();
            });
            
            // 개별 체크박스 처리
            [termsService, termsPrivacy, termsMarketing].forEach(checkbox => {
                checkbox.addEventListener('change', function() {
                    // 전체 동의 체크박스 상태 업데이트
                    termsAll.checked = termsService.checked && termsPrivacy.checked && termsMarketing.checked;
                    checkRequiredTerms();
                });
            });
            
            // 가입하기 버튼 클릭 시 필수 약관 체크 확인
            [userSignupBtn, businessSignupBtn].forEach(btn => {
                btn.addEventListener('click', function(e) {
                    if (!checkRequiredTerms()) {
                        e.preventDefault();
                        alert('필수 약관에 동의해주세요.');
                        return false;
                    }
                });
            });
            
            // 초기 상태 체크
            checkRequiredTerms();
        });
    </script>
</body>
</html>