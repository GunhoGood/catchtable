<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
@import url('https://fonts.googleapis.com/css2?family=Crimson+Text:ital,wght@0,400;0,600;1,400&family=Source+Sans+Pro:wght@300;400;600&display=swap');

.navigation {
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
    box-shadow: 0 2px 20px rgba(0, 0, 0, 0.08);
    border-bottom: 1px solid rgba(212, 175, 55, 0.2);
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    z-index: 1000;
    transition: all 0.3s ease;
}

.nav-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 40px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    height: 80px;
}

.logo {
    font-family: 'Crimson Text', serif;
    font-size: 2rem;
    font-weight: 600;
    color: #2c2c2c;
    text-decoration: none;
    letter-spacing: 0.5px;
    position: relative;
    transition: all 0.3s ease;
}

.logo::after {
    content: '';
    position: absolute;
    bottom: -8px;
    left: 0;
    width: 0;
    height: 2px;
    background: linear-gradient(90deg, #d4af37, #c9a96e);
    transition: width 0.3s ease;
}

.logo:hover::after {
    width: 100%;
}

.nav-menu {
    display: flex;
    list-style: none;
    gap: 50px;
    align-items: center;
}

.nav-item {
    position: relative;
}

.nav-link {
    font-family: 'Source Sans Pro', sans-serif;
    font-size: 0.95rem;
    font-weight: 400;
    color: #555;
    text-decoration: none;
    text-transform: uppercase;
    letter-spacing: 1px;
    transition: all 0.3s ease;
    position: relative;
    padding: 8px 0;
}

.nav-link::before {
    content: '';
    position: absolute;
    bottom: -2px;
    left: 50%;
    transform: translateX(-50%);
    width: 0;
    height: 1px;
    background: #d4af37;
    transition: width 0.3s ease;
}

.nav-link:hover {
    color: #2c2c2c;
}

.nav-link:hover::before {
    width: 100%;
}

.nav-link.active {
    color: #d4af37;
    font-weight: 500;
}

.nav-link.active::before {
    width: 100%;
}

.nav-auth {
    display: flex;
    gap: 20px;
    align-items: center;
}

.auth-link {
    font-family: 'Source Sans Pro', sans-serif;
    font-size: 0.9rem;
    font-weight: 400;
    color: #666;
    text-decoration: none;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    transition: all 0.3s ease;
    padding: 8px 0;
    position: relative;
}

.auth-link::after {
    content: '';
    position: absolute;
    bottom: -2px;
    left: 0;
    width: 0;
    height: 1px;
    background: #8b7355;
    transition: width 0.3s ease;
}

.auth-link:hover {
    color: #2c2c2c;
}

.auth-link:hover::after {
    width: 100%;
}

.login-btn {
    background: transparent;
    border: 1px solid #d4af37;
    color: #d4af37;
    padding: 12px 24px;
    font-family: 'Source Sans Pro', sans-serif;
    font-size: 0.85rem;
    font-weight: 500;
    text-transform: uppercase;
    letter-spacing: 1px;
    border-radius: 1px;
    cursor: pointer;
    transition: all 0.3s ease;
    text-decoration: none;
    display: inline-block;
}

.login-btn:hover {
    background: #d4af37;
    color: #ffffff;
    transform: translateY(-1px);
    box-shadow: 0 4px 15px rgba(212, 175, 55, 0.3);
}

.user-menu {
    position: relative;
    display: inline-block;
}

.user-name {
    font-family: 'Source Sans Pro', sans-serif;
    font-size: 0.9rem;
    color: #2c2c2c;
    cursor: pointer;
    padding: 8px 16px;
    border-radius: 1px;
    transition: all 0.3s ease;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.user-name:hover {
    background: rgba(212, 175, 55, 0.1);
}

.dropdown {
    position: absolute;
    top: 100%;
    right: 0;
    background: #ffffff;
    min-width: 180px;
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
    border: 1px solid rgba(0, 0, 0, 0.05);
    border-radius: 1px;
    opacity: 0;
    visibility: hidden;
    transform: translateY(-10px);
    transition: all 0.3s ease;
    z-index: 1001;
}

.user-menu:hover .dropdown {
    opacity: 1;
    visibility: visible;
    transform: translateY(0);
}

.dropdown a {
    display: block;
    padding: 15px 20px;
    color: #555;
    text-decoration: none;
    font-family: 'Source Sans Pro', sans-serif;
    font-size: 0.85rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    transition: all 0.3s ease;
    border-bottom: 1px solid rgba(0, 0, 0, 0.05);
}

.dropdown a:last-child {
    border-bottom: none;
}

.dropdown a:hover {
    background: rgba(212, 175, 55, 0.05);
    color: #2c2c2c;
    padding-left: 25px;
}

/* 모바일 메뉴 */
.mobile-toggle {
    display: none;
    background: none;
    border: none;
    font-size: 1.5rem;
    color: #2c2c2c;
    cursor: pointer;
}

/* 반응형 */
@media (max-width: 768px) {
    .nav-container {
        padding: 0 20px;
        height: 70px;
    }
    
    .logo {
        font-size: 1.6rem;
    }
    
    .mobile-toggle {
        display: block;
    }
    
    .nav-menu {
        position: fixed;
        top: 70px;
        left: 0;
        right: 0;
        background: rgba(255, 255, 255, 0.98);
        backdrop-filter: blur(10px);
        flex-direction: column;
        gap: 0;
        padding: 20px 0;
        transform: translateY(-100%);
        opacity: 0;
        visibility: hidden;
        transition: all 0.3s ease;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
    }
    
    .nav-menu.active {
        transform: translateY(0);
        opacity: 1;
        visibility: visible;
    }
    
    .nav-item {
        width: 100%;
        text-align: center;
        padding: 15px 0;
        border-bottom: 1px solid rgba(0, 0, 0, 0.05);
    }
    
    .nav-auth {
        flex-direction: column;
        gap: 15px;
        padding-top: 20px;
        border-top: 1px solid rgba(0, 0, 0, 0.1);
        margin-top: 20px;
    }
}

/* 스크롤 시 네비게이션 스타일 */
.navigation.scrolled {
    background: rgba(255, 255, 255, 0.98);
    box-shadow: 0 2px 25px rgba(0, 0, 0, 0.12);
}

.navigation.scrolled .nav-container {
    height: 70px;
}
</style>

<nav class="navigation" id="navbar">
    <div class="nav-container">
        <a href="/catchtable/" class="logo">Catch Table</a>
        
        <ul class="nav-menu" id="nav-menu">
            <li class="nav-item">
                <a href="/catchtable/" class="nav-link">Home</a>
            </li>
            <li class="nav-item">
                <a href="/catchtable/board/restaurants" class="nav-link">Restaurants</a>
            </li>
          
            
            <li class="nav-auth">
    <c:choose>
        <c:when test="${not empty sessionScope.user}">
            <div class="user-menu">
                <span class="user-name">${sessionScope.user.name}</span>
                <div class="dropdown">
                    <c:choose>
                        <%-- 일반회원 메뉴 --%>
                        <c:when test="${sessionScope.user.userType == 'USER'}">
                            <a href="/catchtable/user/profile">My Profile</a>
                            <a href="/catchtable/user/reservations">My Reservations</a>
                            <a href="/catchtable/user/reviews">My Reviews</a>
                            <a href="/catchtable/user/coupons">My Coupons</a>
							<a href="/catchtable/user/reviews">My Favorites</a>

                        </c:when>
                        
                        <%-- 사업자 메뉴 --%>
                        <c:when test="${sessionScope.user.userType == 'BUSINESS'}">
                            <a href="/catchtable/business/profile">Business</a>
                            <a href="/catchtable/business/restaurants">My Restaurants</a>
                            <a href="/catchtable/business/reservations">Reservations</a>
                        </c:when>
                        
                        <%-- 관리자 메뉴 --%>
                        <c:when test="${sessionScope.user.userType == 'ADMIN'}">
                            <a href="/catchtable/admin/dashboard">Admin</a>
                        </c:when>
                    </c:choose>
                    
                    <a href="#" onclick="logout(event)">Logout</a>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <a href="/catchtable/auth/login" class="auth-link">Login</a>
            <a href="/catchtable/auth/terms" class="login-btn">Sign Up</a>
        </c:otherwise>
    </c:choose>
</li>
        </ul>
        
        <button class="mobile-toggle" id="mobile-toggle">☰</button>
    </div>
</nav>

<script>
// 모바일 메뉴 토글
document.getElementById('mobile-toggle').addEventListener('click', function() {
    const navMenu = document.getElementById('nav-menu');
    navMenu.classList.toggle('active');
});

// 스크롤 시 네비게이션 스타일 변경
window.addEventListener('scroll', function() {
    const navbar = document.getElementById('navbar');
    if (window.scrollY > 50) {
        navbar.classList.add('scrolled');
    } else {
        navbar.classList.remove('scrolled');
    }
});

// 현재 페이지에 따른 active 링크 설정
document.addEventListener('DOMContentLoaded', function() {
    const currentPath = window.location.pathname;
    const navLinks = document.querySelectorAll('.nav-link');
    
    navLinks.forEach(link => {
        if (link.getAttribute('href') === currentPath) {
            link.classList.add('active');
        }
    });
});
//개선된 로그아웃 함수
function logout(event) {
    event.preventDefault(); // 링크 기본 동작 방지
    
    if (confirm('정말 로그아웃하시겠습니까?')) {
        // AJAX로 로그아웃 처리
        fetch('/catchtable/auth/logout-ajax', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // 로그아웃 성공 시 메인 페이지로 이동
                window.location.href = '/catchtable/';
            } else {
                // 실패 시에도 메인 페이지로 이동 (세션 만료 등)
                window.location.href = '/catchtable/';
            }
        })
        .catch(error => {
            console.error('로그아웃 오류:', error);
            // 에러 발생 시에도 메인 페이지로 이동
            window.location.href = '/catchtable/';
        });
    }
}

// 모바일 메뉴 토글
document.getElementById('mobile-toggle').addEventListener('click', function() {
    const navMenu = document.getElementById('nav-menu');
    navMenu.classList.toggle('active');
});

// 스크롤 시 네비게이션 스타일 변경
window.addEventListener('scroll', function() {
    const navbar = document.getElementById('navbar');
    if (window.scrollY > 50) {
        navbar.classList.add('scrolled');
    } else {
        navbar.classList.remove('scrolled');
    }
});

// 현재 페이지에 따른 active 링크 설정
document.addEventListener('DOMContentLoaded', function() {
    const currentPath = window.location.pathname;
    const navLinks = document.querySelectorAll('.nav-link');
    
    navLinks.forEach(link => {
        if (link.getAttribute('href') === currentPath) {
            link.classList.add('active');
        }
    });
});
</script>