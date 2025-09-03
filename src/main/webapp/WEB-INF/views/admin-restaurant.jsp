<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/resources/images/favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/resources/images/favicon-16x16.png">
    <meta charset="UTF-8">
    <title>식당 관리 - Catch Table</title>
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
            max-width: 1400px;
            margin: 60px auto;
            padding: 0 40px;
        }
        
        .page-header {
            text-align: center;
            margin-bottom: 40px;
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

        /* 인라인 통계 스타일 */
        .stats-summary {
            text-align: center;
            padding: 25px 0;
            background: linear-gradient(135deg, #f8f6f3 0%, #ffffff 100%);
            border-radius: 10px;
            margin-bottom: 40px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.06);
            border: 1px solid rgba(0, 0, 0, 0.02);
        }

        .stats-inline {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 40px;
            margin: 0;
            flex-wrap: wrap;
        }

        .stat-inline-item {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 1.1rem;
            color: #666;
        }

        .stat-icon {
            font-size: 1.2rem;
        }

        .stat-inline-label {
            color: #666;
            font-weight: 500;
        }

        .stat-inline-value {
            font-size: 1.3rem;
            font-weight: 700;
            color: #d4af37;
            font-family: 'Crimson Text', serif;
        }

        .summary-note {
            color: #888;
            font-size: 1rem;
            margin-top: 15px;
            font-style: italic;
        }

        /* 검색 및 필터 */
        .filter-section {
            background: #ffffff;
            padding: 30px;
            border-radius: 2px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.06);
            border: 1px solid rgba(0, 0, 0, 0.02);
            margin-bottom: 40px;
            position: relative;
        }
        
        .filter-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
        }
        
        .filter-row {
            display: flex;
            gap: 20px;
            align-items: center;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }
        
        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        
        .filter-label {
            font-weight: 600;
            color: #333;
            font-size: 0.9rem;
        }
        
        .filter-select,
        .search-input {
            padding: 10px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 2px;
            font-size: 0.9rem;
            min-width: 150px;
            transition: border-color 0.3s ease;
            font-family: 'Source Sans Pro', sans-serif;
        }
        
        .filter-select:focus,
        .search-input:focus {
            outline: none;
            border-color: #d4af37;
        }
        
        .search-btn {
            background: #d4af37;
            color: #2c2c2c;
            border: none;
            padding: 10px 20px;
            border-radius: 2px;
            cursor: pointer;
            font-weight: 500;
            font-family: 'Source Sans Pro', sans-serif;
            transition: all 0.3s ease;
        }
        
        .search-btn:hover {
            background: #c9a96e;
            transform: translateY(-1px);
        }
        
        .btn-secondary {
            background: #95a5a6;
            color: #ffffff;
        }
        
        .btn-secondary:hover {
            background: #7f8c8d;
        }
        
        /* 테이블 섹션 */
        .restaurants-section {
            background: #ffffff;
            border-radius: 2px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.06);
            border: 1px solid rgba(0, 0, 0, 0.02);
            position: relative;
        }
        
        .restaurants-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
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
        
        /* 테이블 스타일 */
        .table-container {
            padding: 35px;
        }
        
        .restaurants-table {
            width: 100%;
            border-collapse: collapse;
            background: #ffffff;
        }
        
        .restaurants-table thead {
            background:#d4af37;
            color: #2c2c2c;
        }
        
        .restaurants-table th,
        .restaurants-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #f0f0f0;
            font-size: 0.9rem;
        }
        
        .restaurants-table th {
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.8rem;
        }
        
        .restaurants-table tbody tr:hover {
            background-color: #fafaf9;
        }
        
        .restaurants-table tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        
        /* 레스토랑 정보 셀 */
        .restaurant-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .restaurant-image {
            width: 50px;
            height: 50px;
            border-radius: 6px;
            object-fit: cover;
            border: 2px solid #f0f0f0;
        }
        
        .restaurant-details h4 {
            font-weight: 600;
            color: #2c2c2c;
            margin-bottom: 4px;
            font-size: 0.95rem;
        }
        
        .restaurant-details p {
            color: #666;
            font-size: 0.8rem;
            line-height: 1.3;
        }
        
        /* 카테고리 태그 */
        .category-tag {
            background: #d4af37;
            color: #2c2c2c;
            padding: 4px 10px;
            border-radius: 10px;
            font-size: 0.75rem;
            font-weight: 500;
        }
        
        /* 통계 숫자 */
        .stat-number-small {
            font-weight: 600;
            color: #2c2c2c;
        }
        
        .stat-label-small {
            color: #666;
            font-size: 0.8rem;
            display: block;
        }
        
        /* 버튼 스타일 */
        .btn-small {
            padding: 4px 8px;
            border: 1px solid;
            border-radius: 2px;
            font-size: 0.75rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
            margin: 0 2px;
            background: transparent;
        }
        
        .btn-view {
            color: #3498db;
            border-color: #3498db;
        }
        
        .btn-view:hover {
            background: #3498db;
            color: #ffffff;
        }
        
        .btn-review {
            color: #17a2b8;
            border-color: #17a2b8;
        }
        
        .btn-review:hover {
            background: #17a2b8;
            color: #ffffff;
        }
        
        .btn-reservation {
            color: #28a745;
            border-color: #28a745;
        }
        
        .btn-reservation:hover {
            background: #28a745;
            color: #ffffff;
        }
        
        .btn-delete {
            color: #e74c3c;
            border-color: #e74c3c;
        }
        
        .btn-delete:hover {
            background: #e74c3c;
            color: #ffffff;
        }
        
        .actions {
            text-align: center;
            white-space: nowrap;
            min-width: 140px;
        }
        
        .actions .btn-small {
            display: block;
            width: 100%;
            margin: 2px 0;
            text-align: center;
        }
        
        /* 모달 스타일 */
        .modal {
            display: none;
            position: fixed;
            z-index: 99999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
        }
        
        .modal-content {
            background-color: #ffffff;
            margin: 5% auto;
            padding: 0;
            border-radius: 8px;
            width: 90%;
            max-width: 700px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            max-height: 90vh;
            overflow-y: auto;
        }
        
        .modal-header {
            background: #d4af37;
            color: #2c2c2c;
            padding: 20px 30px;
            margin: 0;
        }
        
        .modal-title {
            font-family: 'Crimson Text', serif;
            font-size: 1.4rem;
            font-weight: 600;
            margin: 0;
        }
        
        .modal-body {
            padding: 30px;
        }
        
        .detail-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 25px;
        }
        
        .detail-item {
            padding: 15px;
            background: #f8f9fa;
            border-radius: 4px;
        }
        
        .detail-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
            font-size: 0.9rem;
        }
        
        .detail-value {
            color: #555;
            font-size: 0.95rem;
        }
        
        .modal-footer {
            padding: 20px 30px;
            text-align: right;
            background: #f8f9fa;
            border-top: 1px solid #f0f0f0;
        }
        
        .modal-close {
            background: #d4af37;
            color: #2c2c2c;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-family: 'Source Sans Pro', sans-serif;
            font-weight: 500;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        
        .modal-close:hover {
            background: #c9a96e;
            transform: translateY(-1px);
        }

        /* 빈 상태 */
        .empty-state {
            text-align: center;
            padding: 80px 20px;
            color: #888;
        }
        
        .empty-state .emoji {
            font-size: 4rem;
            margin-bottom: 20px;
            display: block;
        }
        
        .empty-state .message {
            font-size: 1.2rem;
            color: #666;
            margin-bottom: 10px;
        }
        
        .empty-state .sub-message {
            font-size: 0.9rem;
            color: #999;
        }

        /* 반응형 */
        @media (max-width: 768px) {
            .main-container { 
                padding: 0 20px; 
                margin: 30px auto;
            }
            
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
            
            .stats-inline {
                flex-direction: column;
                gap: 15px;
            }
            
            .stat-inline-item {
                font-size: 1rem;
            }
            
            .stat-inline-value {
                font-size: 1.2rem;
            }
            
            .filter-row {
                flex-direction: column;
                align-items: stretch;
            }
            
            .filter-group {
                width: 100%;
            }
            
            .restaurants-table {
                font-size: 0.8rem;
            }
            
            .restaurants-table th,
            .restaurants-table td {
                padding: 8px 6px;
            }
            
            .restaurant-info {
                flex-direction: column;
                text-align: center;
                gap: 8px;
            }
            
            .btn-small {
                font-size: 0.7rem;
                padding: 3px 6px;
            }
            
            .detail-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- 네비게이션 -->
    <%@ include file="/WEB-INF/views/navi.jsp" %>
    
    <div class="main-container">
        <!-- 페이지 헤더 -->
        <div class="page-header">
            <h1 class="page-title">🏪 식당 관리</h1>
            <p class="page-subtitle">등록된 식당 정보를 관리하고 모니터링할 수 있습니다</p>
        </div>
        
        <!-- 네비게이션 탭 -->
        <div class="nav-tabs">
            <a href="/catchtable/admin/dashboard" class="nav-tab">Dashboard</a>
            <a href="/catchtable/admin/restaurants" class="nav-tab active">Restaurants</a>
            <a href="/catchtable/admin/categories" class="nav-tab">Categories</a>
            <a href="/catchtable/admin/approve-business" class="nav-tab">Business Approval</a>
            <a href="/catchtable/admin/coupons" class="nav-tab">Coupons</a>
            <a href="/catchtable/admin/users" class="nav-tab">Users</a>
        </div>
        
        <!-- 인라인 통계 -->
        <div class="stats-summary">
            <div class="stats-inline">
                <div class="stat-inline-item">
                    <span class="stat-icon">🏪</span>
                    <span class="stat-inline-label">총 등록 식당:</span>
                    <span class="stat-inline-value">
                        <c:choose>
                            <c:when test="${not empty restaurants}">
                                ${fn:length(restaurants)}개
                            </c:when>
                            <c:otherwise>0개</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="stat-inline-item">
                    <span class="stat-icon">📂</span>
                    <span class="stat-inline-label">운영 카테고리:</span>
                    <span class="stat-inline-value">
                        <c:choose>
                            <c:when test="${not empty categories}">
                                ${fn:length(categories)}개
                            </c:when>
                            <c:otherwise>0개</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="stat-inline-item">
                    <span class="stat-icon">⭐</span>
                    <span class="stat-inline-label">평균 평점:</span>
                    <span class="stat-inline-value">
                        <c:choose>
                            <c:when test="${not empty avgRating}">
                                <fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/>점
                            </c:when>
                            <c:otherwise>0.0점</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="stat-inline-item">
                    <span class="stat-icon">📅</span>
                    <span class="stat-inline-label">총 예약 수:</span>
                    <span class="stat-inline-value">
                        <c:choose>
                            <c:when test="${not empty totalReservations}">
                                <fmt:formatNumber value="${totalReservations}" groupingUsed="true"/>건
                            </c:when>
                            <c:otherwise>0건</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
            <p class="summary-note">식당 운영 현황을 한눈에 확인하세요</p>
        </div>
        
        <!-- 필터 및 검색 -->
        <div class="filter-section">
            <div class="filter-row">
                <div class="filter-group">
                    <label class="filter-label">카테고리</label>
                    <select class="filter-select" id="categoryFilter">
                        <option value="">전체 카테고리</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.categoryId}" 
                                    <c:if test="${selectedCategoryId == category.categoryId}">selected</c:if>>
                                ${category.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label class="filter-label">가격대</label>
                    <select class="filter-select" id="priceFilter">
                        <option value="">전체 가격대</option>
                        <option value="LOW" <c:if test="${selectedPriceRange == 'LOW'}">selected</c:if>>저렴한 (1만원 이하)</option>
                        <option value="MEDIUM" <c:if test="${selectedPriceRange == 'MEDIUM'}">selected</c:if>>보통 (1-3만원)</option>
                        <option value="HIGH" <c:if test="${selectedPriceRange == 'HIGH'}">selected</c:if>>고급 (3만원 이상)</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label class="filter-label">정렬</label>
                    <select class="filter-select" id="sortFilter">
                        <option value="newest" <c:if test="${selectedSort == 'newest'}">selected</c:if>>최신 등록순</option>
                        <option value="popular" <c:if test="${selectedSort == 'popular'}">selected</c:if>>인기순</option>
                        <option value="rating" <c:if test="${selectedSort == 'rating'}">selected</c:if>>평점순</option>
                        <option value="name" <c:if test="${selectedSort == 'name'}">selected</c:if>>이름순</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label class="filter-label">검색</label>
                    <div style="display: flex; gap: 5px;">
                        <input type="text" class="search-input" id="searchInput" placeholder="식당명 또는 주소로 검색..." value="${searchKeyword}">
                        <button class="search-btn" id="searchBtn">검색</button>
                        <button class="search-btn btn-secondary" id="resetBtn">초기화</button>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- 식당 목록 -->
        <div class="restaurants-section">
            <div class="section-header">
                <h2 class="section-title">등록된 식당</h2>
                <p class="section-description">
                    식당 정보를 확인하고 관리할 수 있습니다
                    <c:if test="${not empty searchKeyword or not empty selectedCategoryId or not empty selectedPriceRange or selectedSort != 'newest'}">
                        <br><strong style="color: #d4af37;">
                            <c:if test="${not empty searchKeyword}">검색: "${searchKeyword}" | </c:if>
                            <c:if test="${not empty selectedCategoryId}">카테고리 필터 적용 | </c:if>
                            <c:if test="${not empty selectedPriceRange}">가격대 필터 적용 | </c:if>
                            총 ${fn:length(restaurants)}개 식당 표시
                        </strong>
                    </c:if>
                </p>
            </div>
            
            <div class="table-container">
                <c:choose>
                    <c:when test="${not empty restaurants}">
                        <table class="restaurants-table">
                            <thead>
                                <tr>
                                    <th>식당 정보</th>
                                    <th>위치</th>
                                    <th>설명</th>
                                    <th>연락처</th>
                                    <th>관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="restaurant" items="${restaurants}">
                                    <tr>
                                        <td>
                                            <div class="restaurant-info">
                                                <c:choose>
                                                    <c:when test="${not empty restaurant.imageUrl}">
                                                        <img src="${restaurant.imageUrl}" alt="${restaurant.name}" class="restaurant-image">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="restaurant-image" style="background: #f0f0f0; display: flex; align-items: center; justify-content: center; color: #999;">🏪</div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <div class="restaurant-details">
                                                    <h4>${restaurant.name}</h4>
                                                    <p style="color: #666; font-size: 0.8rem; margin-bottom: 4px;">${restaurant.cuisineType}</p>
                                                    <c:set var="categoryName" value="미분류"/>
                                                    <c:forEach var="category" items="${categories}">
                                                        <c:if test="${category.categoryId == restaurant.categoryId}">
                                                            <c:set var="categoryName" value="${category.name}"/>
                                                        </c:if>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div style="max-width: 200px; word-wrap: break-word; line-height: 1.4;">
                                                ${restaurant.address}
                                            </div>
                                        </td>
                                        <td>
                                            <div style="max-width: 300px; word-wrap: break-word; line-height: 1.4;">
                                                <c:choose>
                                                    <c:when test="${not empty restaurant.description and fn:length(restaurant.description) > 60}">
                                                        ${fn:substring(restaurant.description, 0, 60)}...
                                                    </c:when>
                                                    <c:when test="${not empty restaurant.description}">
                                                        ${restaurant.description}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #999; font-style: italic;">설명 없음</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                        <td>
                                            <div style="font-weight: 500;">${restaurant.phone}</div>
                                            <div style="font-size: 0.8rem; color: #666; margin-top: 4px;">
                                                ${restaurant.operatingHours != null ? restaurant.operatingHours : '영업시간 미등록'}
                                            </div>
                                        </td>
                                        <td class="actions">
                                            <button class="btn-small btn-view" data-restaurant-id="${restaurant.restaurantId}" title="상세 정보">📋 상세</button>
                                            <button class="btn-small btn-review" data-restaurant-id="${restaurant.restaurantId}" data-restaurant-name="${fn:escapeXml(restaurant.name)}" title="리뷰 관리">📝 리뷰</button>
                                            <button class="btn-small btn-reservation" data-restaurant-id="${restaurant.restaurantId}" data-restaurant-name="${fn:escapeXml(restaurant.name)}" title="예약 관리">📅 예약</button>
                                            <button class="btn-small btn-delete" data-restaurant-id="${restaurant.restaurantId}" data-restaurant-name="${fn:escapeXml(restaurant.name)}" title="식당 삭제" style="margin-top: 4px;">🗑️ 삭제</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <span class="emoji">🏪</span>
                            <div class="message">등록된 식당이 없습니다</div>
                            <div class="sub-message">첫 번째 식당을 등록해보세요!</div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <!-- 상세보기 모달 -->
    <div id="restaurantModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="modalTitle">식당 상세 정보</h3>
            </div>
            <div class="modal-body" id="modalBody">
                <!-- 식당 상세 정보가 여기에 표시됩니다 -->
            </div>
            <div class="modal-footer">
                <button class="modal-close" id="modalCloseBtn">닫기</button>
            </div>
        </div>
    </div>
    
    <!-- 푸터 -->
    <%@ include file="/WEB-INF/views/footer.jsp" %>

    <!-- JavaScript 파일 로드 -->
    <script>
        // contextPath를 전역 변수로 설정
        window.contextPath = '<c:out value="${pageContext.request.contextPath}"/>';
        console.log('Context Path 설정:', window.contextPath);
    </script>
    
    <!-- JavaScript 파일 로드 -->
    <script src="${pageContext.request.contextPath}/resources/js/admin-restaurant.js"></script>
</body>
</html>