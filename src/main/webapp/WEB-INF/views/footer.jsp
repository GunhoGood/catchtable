<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
.footer {
    background: linear-gradient(135deg, #2c2c2c 0%, #1a1a1a 100%);
    color: #e8e6e3;
    position: relative;
    overflow: hidden;
}

.footer::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 1px;
    background: linear-gradient(90deg, transparent, #d4af37, transparent);
}

.footer-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 80px 40px 40px;
    position: relative;
    z-index: 1;
}

.footer-content {
    display: grid;
    grid-template-columns: 2fr 1fr 1fr 1fr;
    gap: 60px;
    margin-bottom: 60px;
}

.footer-brand {
    max-width: 300px;
}

.footer-logo {
    font-family: 'Crimson Text', serif;
    font-size: 2.2rem;
    font-weight: 600;
    color: #d4af37;
    margin-bottom: 20px;
    letter-spacing: 0.5px;
}

.footer-description {
    font-family: 'Source Sans Pro', sans-serif;
    font-size: 1rem;
    line-height: 1.7;
    color: #b8b6b3;
    margin-bottom: 30px;
}

.social-links {
    display: flex;
    gap: 20px;
}

.social-link {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 45px;
    height: 45px;
    background: rgba(212, 175, 55, 0.1);
    border: 1px solid rgba(212, 175, 55, 0.3);
    border-radius: 50%;
    color: #d4af37;
    text-decoration: none;
    font-size: 1.2rem;
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
}

.social-link::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.1), transparent);
    transition: left 0.5s ease;
}

.social-link:hover::before {
    left: 100%;
}

.social-link:hover {
    background: #d4af37;
    color: #2c2c2c;
    border-color: #d4af37;
    transform: translateY(-2px);
    box-shadow: 0 8px 25px rgba(212, 175, 55, 0.3);
}

.footer-section {
    margin-bottom: 20px;
}

.footer-title {
    font-family: 'Source Sans Pro', sans-serif;
    font-size: 1.1rem;
    font-weight: 600;
    color: #ffffff;
    margin-bottom: 25px;
    text-transform: uppercase;
    letter-spacing: 1px;
    position: relative;
}

.footer-title::after {
    content: '';
    position: absolute;
    bottom: -8px;
    left: 0;
    width: 30px;
    height: 2px;
    background: #d4af37;
}

.footer-list {
    list-style: none;
    padding: 0;
    margin: 0;
}

.footer-list li {
    margin-bottom: 12px;
}

.footer-link {
    font-family: 'Source Sans Pro', sans-serif;
    font-size: 0.9rem;
    color: #b8b6b3;
    text-decoration: none;
    transition: all 0.3s ease;
    position: relative;
    display: inline-block;
}

.footer-link::before {
    content: '';
    position: absolute;
    bottom: -2px;
    left: 0;
    width: 0;
    height: 1px;
    background: #d4af37;
    transition: width 0.3s ease;
}

.footer-link:hover {
    color: #d4af37;
    padding-left: 8px;
}

.footer-link:hover::before {
    width: 100%;
}

.contact-item {
    display: flex;
    align-items: center;
    margin-bottom: 15px;
    font-family: 'Source Sans Pro', sans-serif;
    font-size: 0.9rem;
    color: #b8b6b3;
}

.contact-icon {
    width: 20px;
    height: 20px;
    margin-right: 12px;
    color: #d4af37;
    font-size: 1rem;
}

.footer-bottom {
    border-top: 1px solid rgba(212, 175, 55, 0.2);
    padding-top: 40px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 20px;
}

.copyright {
    font-family: 'Source Sans Pro', sans-serif;
    font-size: 0.85rem;
    color: #888;
    letter-spacing: 0.5px;
}

.footer-bottom-links {
    display: flex;
    gap: 30px;
}

.footer-bottom-link {
    font-family: 'Source Sans Pro', sans-serif;
    font-size: 0.85rem;
    color: #b8b6b3;
    text-decoration: none;
    transition: color 0.3s ease;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.footer-bottom-link:hover {
    color: #d4af37;
}

/* 반응형 */
@media (max-width: 992px) {
    .footer-content {
        grid-template-columns: 1fr 1fr;
        gap: 40px;
    }
}

@media (max-width: 768px) {
    .footer-container {
        padding: 60px 20px 30px;
    }
    
    .footer-content {
        grid-template-columns: 1fr;
        gap: 40px;
        text-align: center;
    }
    
    .footer-brand {
        max-width: none;
    }
    
    .footer-bottom {
        flex-direction: column;
        text-align: center;
        gap: 15px;
    }
    
    .footer-bottom-links {
        justify-content: center;
        flex-wrap: wrap;
        gap: 20px;
    }
    
    .social-links {
        justify-content: center;
    }
}

@media (max-width: 480px) {
    .footer-logo {
        font-size: 1.8rem;
    }
    
    .footer-bottom-links {
        flex-direction: column;
        gap: 10px;
    }
}

/* 우아한 애니메이션 */
@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.footer-section {
    animation: fadeInUp 0.6s ease-out;
}

.footer-section:nth-child(2) { animation-delay: 0.1s; }
.footer-section:nth-child(3) { animation-delay: 0.2s; }
.footer-section:nth-child(4) { animation-delay: 0.3s; }
</style>

<footer class="footer">
    <div class="footer-container">
        <div class="footer-content">
            <!-- 브랜드 섹션 -->
            <div class="footer-section footer-brand">
                <div class="footer-logo">Catch Table</div>
                <p class="footer-description">
                    최고의 맛집을 발견하고 간편하게 예약하세요. 
                    특별한 순간을 위한 완벽한 장소를 찾아드립니다.
                </p>
                <div class="social-links">
                    <a href="#" class="social-link" title="Facebook">📘</a>
                    <a href="#" class="social-link" title="Instagram">📷</a>
                    <a href="#" class="social-link" title="Twitter">🐦</a>
                    <a href="#" class="social-link" title="YouTube">📺</a>
                </div>
            </div>
            
            <!-- 빠른 링크 -->
            <div class="footer-section">
                <h3 class="footer-title">Quick Links</h3>
                <ul class="footer-list">
                    <li><a href="/catchtable/" class="footer-link">홈</a></li>
                    <li><a href="/catchtable/restaurant/list" class="footer-link">식당 찾기</a></li>
                    <li><a href="/catchtable/reservation/my" class="footer-link">예약 관리</a></li>
                    <li><a href="/catchtable/review/list" class="footer-link">리뷰</a></li>
                    <li><a href="/catchtable/about" class="footer-link">회사 소개</a></li>
                </ul>
            </div>
            
            <!-- 서비스 -->
            <div class="footer-section">
                <h3 class="footer-title">Services</h3>
                <ul class="footer-list">
                    <li><a href="/catchtable/business/register" class="footer-link">사업자 등록</a></li>
                    <li><a href="/catchtable/help" class="footer-link">고객 지원</a></li>
                    <li><a href="/catchtable/faq" class="footer-link">자주 묻는 질문</a></li>
                    <li><a href="/catchtable/event" class="footer-link">이벤트</a></li>
                    <li><a href="/catchtable/gift" class="footer-link">기프트카드</a></li>
                </ul>
            </div>
            
            <!-- 연락처 -->
            <div class="footer-section">
                <h3 class="footer-title">Contact</h3>
                <div class="contact-item">
                    <span class="contact-icon">📍</span>
                    <span>서울시 강남구 테헤란로 123</span>
                </div>
                <div class="contact-item">
                    <span class="contact-icon">📞</span>
                    <span>02-1234-5678</span>
                </div>
                <div class="contact-item">
                    <span class="contact-icon">✉️</span>
                    <span>contact@catchtable.com</span>
                </div>
                <div class="contact-item">
                    <span class="contact-icon">🕒</span>
                    <span>월-금 09:00-18:00</span>
                </div>
            </div>
        </div>
        
        <!-- 하단 영역 -->
        <div class="footer-bottom">
            <div class="copyright">
                © 2025 Catch Table. All rights reserved.
            </div>
            <div class="footer-bottom-links">
                <a href="/catchtable/privacy" class="footer-bottom-link">개인정보처리방침</a>
                <a href="/catchtable/terms" class="footer-bottom-link">이용약관</a>
                <a href="/catchtable/location" class="footer-bottom-link">위치기반서비스</a>
            </div>
        </div>
    </div>
</footer>