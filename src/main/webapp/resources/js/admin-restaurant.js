/**
 * 식당 관리 페이지 JavaScript
 * restaurant-admin.js
 */

// 전역 변수
var RestaurantAdmin = {
    contextPath: '',
    
    // 초기화
    init: function(contextPath) {
        this.contextPath = contextPath;
        this.setupEventListeners();
        console.log('식당 관리 페이지 초기화 완료, contextPath:', contextPath);
    },
    
    // 이벤트 리스너 설정
    setupEventListeners: function() {
        var self = this;
        
        // 검색 버튼
        var searchBtn = document.getElementById('searchBtn');
        if (searchBtn) {
            searchBtn.addEventListener('click', function() {
                self.searchRestaurants();
            });
        }
        
        // 초기화 버튼
        var resetBtn = document.getElementById('resetBtn');
        if (resetBtn) {
            resetBtn.addEventListener('click', function() {
                self.resetFilters();
            });
        }
        
        // 검색 입력에서 엔터키
        var searchInput = document.getElementById('searchInput');
        if (searchInput) {
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    self.searchRestaurants();
                }
            });
        }
        
        // 모달 닫기 버튼
        var modalCloseBtn = document.getElementById('modalCloseBtn');
        if (modalCloseBtn) {
            modalCloseBtn.addEventListener('click', function() {
                self.closeModal();
            });
        }
        
        // 테이블 버튼들
        this.setupTableButtonListeners();
        
        // 모달 외부 클릭시 닫기
        window.onclick = function(event) {
            var modal = document.getElementById('restaurantModal');
            if (event.target === modal) {
                self.closeModal();
            }
        };
    },
    
    // 테이블 버튼 이벤트 리스너 설정
    setupTableButtonListeners: function() {
        var self = this;
        
        // 상세보기 버튼들
        var viewButtons = document.querySelectorAll('.btn-view');
        viewButtons.forEach(function(button) {
            button.addEventListener('click', function() {
                var restaurantId = this.getAttribute('data-restaurant-id');
                self.viewRestaurant(restaurantId);
            });
        });
        
        // 리뷰 관리 버튼들
        var reviewButtons = document.querySelectorAll('.btn-review');
        reviewButtons.forEach(function(button) {
            button.addEventListener('click', function() {
                var restaurantId = this.getAttribute('data-restaurant-id');
                var restaurantName = this.getAttribute('data-restaurant-name');
                self.manageReviews(restaurantId, restaurantName);
            });
        });
        
        // 예약 관리 버튼들
        var reservationButtons = document.querySelectorAll('.btn-reservation');
        reservationButtons.forEach(function(button) {
            button.addEventListener('click', function() {
                var restaurantId = this.getAttribute('data-restaurant-id');
                var restaurantName = this.getAttribute('data-restaurant-name');
                self.manageReservations(restaurantId, restaurantName);
            });
        });
        
        // 삭제 버튼들
        var deleteButtons = document.querySelectorAll('.btn-delete');
        deleteButtons.forEach(function(button) {
            button.addEventListener('click', function() {
                var restaurantId = this.getAttribute('data-restaurant-id');
                var restaurantName = this.getAttribute('data-restaurant-name');
                self.deleteRestaurant(restaurantId, restaurantName);
            });
        });
    },
    
    // 검색 기능
    searchRestaurants: function() {
        try {
            var keyword = document.getElementById('searchInput').value.trim();
            var categoryId = document.getElementById('categoryFilter').value;
            var priceRange = document.getElementById('priceFilter').value;
            var sort = document.getElementById('sortFilter').value;
            
            var params = new URLSearchParams();
            if (keyword) params.append('keyword', keyword);
            if (categoryId) params.append('categoryId', categoryId);
            if (priceRange) params.append('priceRange', priceRange);
            if (sort) params.append('sort', sort);
            
            var url = this.contextPath + '/admin/restaurants';
            if (params.toString()) {
                url += '?' + params.toString();
            }
            
            console.log('검색 URL:', url);
            window.location.href = url;
        } catch (error) {
            console.error('검색 오류:', error);
            alert('검색 중 오류가 발생했습니다.');
        }
    },
    
    // 필터 초기화
    resetFilters: function() {
        try {
            document.getElementById('searchInput').value = '';
            document.getElementById('categoryFilter').value = '';
            document.getElementById('priceFilter').value = '';
            document.getElementById('sortFilter').value = 'newest';
            
            window.location.href = this.contextPath + '/admin/restaurants';
        } catch (error) {
            console.error('초기화 오류:', error);
            alert('초기화 중 오류가 발생했습니다.');
        }
    },
    
    // 식당 상세보기
    viewRestaurant: function(restaurantId) {
        var self = this;
        try {
            console.log('상세보기 호출됨, 식당 ID:', restaurantId);
            
            var modal = document.getElementById('restaurantModal');
            var modalTitle = document.getElementById('modalTitle');
            var modalBody = document.getElementById('modalBody');
            
            if (!modal || !modalTitle || !modalBody) {
                throw new Error('모달 요소를 찾을 수 없습니다.');
            }
            
            // 모달 열기
            modal.style.display = 'block';
            modalTitle.textContent = '로딩 중...';
            modalBody.innerHTML = '<div style="text-align: center; padding: 40px;"><div style="font-size: 2rem;">⏳</div><div>정보를 불러오는 중입니다...</div></div>';
            
            // 서버에서 식당 상세 정보 조회
            fetch(this.contextPath + '/admin/restaurants/' + restaurantId + '/detail')
                .then(function(response) {
                    console.log('응답 상태:', response.status);
                    if (!response.ok) {
                        throw new Error('서버 응답 오류: ' + response.status);
                    }
                    return response.json();
                })
                .then(function(data) {
                    console.log('상세 정보 응답:', data);
                    if (data.success) {
                        self.displayRestaurantDetails(data.data);
                    } else {
                        modalBody.innerHTML = '<div style="text-align: center; padding: 40px; color: #e74c3c;"><div style="font-size: 2rem;">❌</div><div>상세 정보 조회 실패: ' + (data.message || '알 수 없는 오류') + '</div></div>';
                    }
                })
                .catch(function(error) {
                    console.error('상세보기 오류:', error);
                    modalBody.innerHTML = '<div style="text-align: center; padding: 40px; color: #e74c3c;"><div style="font-size: 2rem;">⚠️</div><div>상세 정보 조회 중 오류가 발생했습니다.</div><div style="font-size: 0.9rem; margin-top: 10px;">(' + error.message + ')</div></div>';
                });
        } catch (error) {
            console.error('상세보기 함수 오류:', error);
            alert('상세보기 중 오류가 발생했습니다: ' + error.message);
        }
    },
    
    // 식당 상세 정보 모달 표시
    displayRestaurantDetails: function(data) {
        try {
            var modalTitle = document.getElementById('modalTitle');
            var modalBody = document.getElementById('modalBody');
            
            var restaurant = data.restaurant || {};
            var businessUser = data.businessUser || {};
            var category = data.category || {};
            
            modalTitle.textContent = (restaurant.name || '식당') + ' 상세 정보';
            
            var modalContent = `
                <!-- 식당 기본 정보 -->
                <div class="detail-grid">
                    <div class="detail-item">
                        <div class="detail-label">식당명</div>
                        <div class="detail-value">${restaurant.name || '정보 없음'}</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">카테고리</div>
                        <div class="detail-value">
                            <span style="background: #d4af37; color: #2c2c2c; padding: 4px 10px; border-radius: 10px; font-size: 0.8rem; font-weight: 500;">
                                ${category.name || '미분류'}
                            </span>
                        </div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">음식 종류</div>
                        <div class="detail-value">${restaurant.cuisineType || '정보 없음'}</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">가격대</div>
                        <div class="detail-value">${restaurant.priceRange || '정보 없음'}</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">주소</div>
                        <div class="detail-value">${restaurant.address || '정보 없음'}</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">연락처</div>
                        <div class="detail-value">${restaurant.phone || '정보 없음'}</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">영업시간</div>
                        <div class="detail-value">${restaurant.operatingHours || '정보 없음'}</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">등록일</div>
                        <div class="detail-value">${this.formatDate(restaurant.createdAt)}</div>
                    </div>
                </div>
                
                <!-- 식당 설명 -->
                <div class="detail-item" style="margin-bottom: 25px;">
                    <div class="detail-label">식당 설명</div>
                    <div class="detail-value" style="background: #f8f9fa; padding: 15px; border-radius: 6px; line-height: 1.6;">
                        ${restaurant.description || '설명이 없습니다.'}
                    </div>
                </div>
                
                <!-- 사업자 정보 -->
                <div style="background: #fff3cd; padding: 20px; border-radius: 4px; margin-bottom: 25px;">
                    <h4 style="color: #856404; margin-bottom: 15px; font-family: 'Crimson Text', serif;">👤 사업자 정보</h4>
                    <div class="detail-grid">
                        <div class="detail-item">
                            <div class="detail-label">사업자명</div>
                            <div class="detail-value">${businessUser.name || '정보 없음'}</div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">이메일</div>
                            <div class="detail-value">${businessUser.email || '정보 없음'}</div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">연락처</div>
                            <div class="detail-value">${businessUser.phone || '정보 없음'}</div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">승인상태</div>
                            <div class="detail-value">${businessUser.approvalStatus ? this.getApprovalStatusBadge(businessUser.approvalStatus) : '정보 없음'}</div>
                        </div>
                    </div>
                </div>
                
                <!-- 운영 통계 -->
                <div style="background: #d1ecf1; padding: 20px; border-radius: 4px;">
                    <h4 style="color: #0c5460; margin-bottom: 15px; font-family: 'Crimson Text', serif;">📊 운영 통계</h4>
                    <div class="detail-grid">
                        <div class="detail-item">
                            <div class="detail-label">조회수</div>
                            <div class="detail-value"><strong>${this.formatNumber(restaurant.viewCount || 0)}회</strong></div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">좋아요</div>
                            <div class="detail-value"><strong>${this.formatNumber(restaurant.likesCount || 0)}개</strong></div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">총 예약수</div>
                            <div class="detail-value"><strong>${this.formatNumber(restaurant.reservationCount || 0)}건</strong></div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">인기도</div>
                            <div class="detail-value"><strong>${this.getPopularityLevel(restaurant)}</strong></div>
                        </div>
                    </div>
                </div>
            `;
            
            // 이미지가 있으면 표시
            if (restaurant.imageUrl && restaurant.imageUrl.trim() !== '') {
                modalContent += `
                    <div class="detail-item" style="margin-top: 25px; text-align: center;">
                        <div class="detail-label">대표 이미지</div>
                        <div class="detail-value">
                            <img src="${restaurant.imageUrl}" alt="${restaurant.name}" 
                                 style="max-width: 100%; height: 200px; object-fit: cover; border-radius: 8px; margin-top: 10px;"
                                 onerror="this.style.display='none';">
                        </div>
                    </div>
                `;
            }
            
            modalBody.innerHTML = modalContent;
        } catch (error) {
            console.error('상세 정보 표시 오류:', error);
            var modalBody = document.getElementById('modalBody');
            if (modalBody) {
                modalBody.innerHTML = '<div style="text-align: center; padding: 40px; color: #e74c3c;">상세 정보 표시 중 오류가 발생했습니다.</div>';
            }
        }
    },
    
    // 승인 상태 배지 생성
    getApprovalStatusBadge: function(status) {
        var badges = {
            'APPROVED': '<span style="background: #d4edda; color: #155724; padding: 4px 8px; border-radius: 8px; font-size: 0.8rem;">✅ 승인됨</span>',
            'PENDING': '<span style="background: #fff3cd; color: #856404; padding: 4px 8px; border-radius: 8px; font-size: 0.8rem;">⏳ 대기중</span>',
            'REJECTED': '<span style="background: #f8d7da; color: #721c24; padding: 4px 8px; border-radius: 8px; font-size: 0.8rem;">❌ 거절됨</span>'
        };
        return badges[status] || status;
    },
    
    // 숫자 포맷팅
    formatNumber: function(num) {
        return (num || 0).toLocaleString();
    },
    
    // 개선된 날짜 포맷팅 함수 (yyyy-MM-dd 형식)
    formatDate: function(dateString) {
        if (!dateString) return '정보 없음';
        
        try {
            var date;
            
            console.log('원본 날짜 데이터:', dateString, '타입:', typeof dateString);
            
            // 1. 배열 형식: [2025,7,30,10,21,57] 처리
            if (Array.isArray(dateString)) {
                if (dateString.length >= 3) {
                    date = new Date(dateString[0], dateString[1] - 1, dateString[2]);
                } else {
                    return '정보 없음';
                }
            }
            // 2. 쉼표로 구분된 문자열: "2025,7,30,10,21,57" 처리
            else if (typeof dateString === 'string' && dateString.includes(',')) {
                var parts = dateString.split(',').map(function(part) {
                    return parseInt(part.trim(), 10);
                });
                if (parts.length >= 3) {
                    date = new Date(parts[0], parts[1] - 1, parts[2]);
                } else {
                    return '정보 없음';
                }
            }
            // 3. 일반 문자열이나 다른 형식
            else {
                date = new Date(dateString);
            }
            
            // 유효한 날짜인지 확인
            if (!date || isNaN(date.getTime())) {
                console.log('유효하지 않은 날짜:', dateString);
                return '정보 없음';
            }
            
            // yyyy-MM-dd 형식으로 포맷팅
            var year = date.getFullYear();
            var month = String(date.getMonth() + 1).padStart(2, '0');
            var day = String(date.getDate()).padStart(2, '0');
            
            return year + '-' + month + '-' + day;
            
        } catch (error) {
            console.error('날짜 포맷팅 오류:', error);
            return '정보 없음';
        }
    },
    
    // 인기도 계산
    getPopularityLevel: function(restaurant) {
        var score = (restaurant.viewCount || 0) + 
                   (restaurant.likesCount || 0) * 2 + 
                   (restaurant.reservationCount || 0) * 3;
        
        if (score >= 100) return '🔥 매우 인기';
        else if (score >= 50) return '⭐ 인기';
        else if (score >= 20) return '👍 보통';
        else return '🆕 신규';
    },
    
    // 리뷰 관리
    manageReviews: function(restaurantId, restaurantName) {
        var self = this;
        try {
            console.log('리뷰 관리 호출됨, 식당 ID:', restaurantId, '이름:', restaurantName);
            
            var modal = document.getElementById('restaurantModal');
            var modalTitle = document.getElementById('modalTitle');
            var modalBody = document.getElementById('modalBody');
            
            if (!modal || !modalTitle || !modalBody) {
                throw new Error('모달 요소를 찾을 수 없습니다.');
            }
            
            // 모달 열기
            modal.style.display = 'block';
            modalTitle.textContent = restaurantName + ' - 리뷰 관리';
            modalBody.innerHTML = '<div style="text-align: center; padding: 40px;"><div style="font-size: 2rem;">⏳</div><div>리뷰 목록을 불러오는 중입니다...</div></div>';
            
            // 서버에서 리뷰 목록 조회
            fetch(this.contextPath + '/admin/restaurants/' + restaurantId + '/reviews')
                .then(function(response) {
                    console.log('리뷰 응답 상태:', response.status);
                    if (!response.ok) {
                        throw new Error('서버 응답 오류: ' + response.status);
                    }
                    return response.json();
                })
                .then(function(data) {
                    console.log('리뷰 목록 응답:', data);
                    if (data.success) {
                        self.displayReviewManagement(data.data, restaurantId, restaurantName);
                    } else {
                        modalBody.innerHTML = '<div style="text-align: center; padding: 40px; color: #e74c3c;"><div style="font-size: 2rem;">❌</div><div>리뷰 목록 조회 실패: ' + (data.message || '알 수 없는 오류') + '</div></div>';
                    }
                })
                .catch(function(error) {
                    console.error('리뷰 관리 오류:', error);
                    modalBody.innerHTML = '<div style="text-align: center; padding: 40px; color: #e74c3c;"><div style="font-size: 2rem;">⚠️</div><div>리뷰 목록 조회 중 오류가 발생했습니다.</div><div style="font-size: 0.9rem; margin-top: 10px;">(' + error.message + ')</div></div>';
                });
        } catch (error) {
            console.error('리뷰 관리 함수 오류:', error);
            alert('리뷰 관리 중 오류가 발생했습니다: ' + error.message);
        }
    },
    
    // 리뷰 관리 화면 표시
    displayReviewManagement: function(reviews, restaurantId, restaurantName) {
        var self = this;
        try {
            var modalBody = document.getElementById('modalBody');
            
            if (!reviews || reviews.length === 0) {
                modalBody.innerHTML = `
                    <div style="text-align: center; padding: 60px 20px;">
                        <div style="font-size: 3rem; margin-bottom: 20px;">📝</div>
                        <div style="font-size: 1.2rem; color: #666; margin-bottom: 10px;">등록된 리뷰가 없습니다</div>
                        <div style="font-size: 0.9rem; color: #999;">아직 고객 리뷰가 작성되지 않았습니다.</div>
                    </div>
                `;
                return;
            }
            
            var reviewsHtml = `
                <div style="margin-bottom: 20px; padding: 15px; background: #f8f9fa; border-radius: 8px; border-left: 4px solid #d4af37;">
                    <h4 style="margin: 0; color: #2c2c2c; font-family: 'Crimson Text', serif;">📝 리뷰 관리</h4>
                    <p style="margin: 5px 0 0 0; color: #666; font-size: 0.9rem;">악성 리뷰나 부적절한 내용의 리뷰를 삭제할 수 있습니다. (총 ${reviews.length}개)</p>
                </div>
                
                <div style="max-height: 400px; overflow-y: auto;">
            `;
            
            reviews.forEach(function(review, index) {
                var ratingStars = '⭐'.repeat(review.rating || 0);
                var isRecommended = review.isRecommended ? '👍 추천' : '👎 비추천';
                var reviewDate = self.formatDate(review.createdAt);
                
                reviewsHtml += `
                    <div class="review-item" style="border: 1px solid #e0e0e0; border-radius: 8px; padding: 15px; margin-bottom: 15px; background: #ffffff;">
                        <div style="display: flex; justify-content: between; align-items: flex-start; margin-bottom: 10px;">
                            <div style="flex: 1;">
                                <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 8px;">
                                    <strong style="color: #2c2c2c;">${review.userName || '익명'}</strong>
                                    <span style="font-size: 1.2rem;">${ratingStars}</span>
                                    <span style="background: ${review.isRecommended ? '#d4edda' : '#f8d7da'}; color: ${review.isRecommended ? '#155724' : '#721c24'}; padding: 2px 8px; border-radius: 12px; font-size: 0.75rem;">${isRecommended}</span>
                                </div>
                                <div style="color: #666; font-size: 0.85rem; margin-bottom: 10px;">${reviewDate}</div>
                                <div style="line-height: 1.5; color: #333;">${review.content || '내용 없음'}</div>
                            </div>
                            <button onclick="RestaurantAdmin.deleteReview(${review.reviewId}, '${review.userName || '익명'}', ${restaurantId})" 
                                    style="background: #dc3545; color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; font-size: 0.8rem; margin-left: 10px;">
                                🗑️ 삭제
                            </button>
                        </div>
                        ${review.imageUrl ? `<img src="${review.imageUrl}" style="max-width: 100%; height: 100px; object-fit: cover; border-radius: 6px; margin-top: 10px;" alt="리뷰 이미지">` : ''}
                    </div>
                `;
            });
            
            reviewsHtml += `
                </div>
                <div style="margin-top: 20px; padding: 15px; background: #fff3cd; border-radius: 8px; border-left: 4px solid #ffc107;">
                    <h5 style="margin: 0 0 8px 0; color: #856404;">⚠️ 주의사항</h5>
                    <ul style="margin: 0; padding-left: 20px; color: #856404; font-size: 0.9rem;">
                        <li>삭제된 리뷰는 복구할 수 없습니다.</li>
                        <li>명백한 악성 리뷰나 허위 정보만 삭제해주세요.</li>
                        <li>정당한 비판이나 의견은 보호되어야 합니다.</li>
                    </ul>
                </div>
            `;
            
            modalBody.innerHTML = reviewsHtml;
        } catch (error) {
            console.error('리뷰 관리 화면 표시 오류:', error);
            var modalBody = document.getElementById('modalBody');
            if (modalBody) {
                modalBody.innerHTML = '<div style="text-align: center; padding: 40px; color: #e74c3c;">리뷰 목록 표시 중 오류가 발생했습니다.</div>';
            }
        }
    },
    
    // 예약 관리 (조회 전용)
    manageReservations: function(restaurantId, restaurantName) {
        var self = this;
        try {
            console.log('예약 현황 조회 호출됨, 식당 ID:', restaurantId, '이름:', restaurantName);
            
            var modal = document.getElementById('restaurantModal');
            var modalTitle = document.getElementById('modalTitle');
            var modalBody = document.getElementById('modalBody');
            
            if (!modal || !modalTitle || !modalBody) {
                throw new Error('모달 요소를 찾을 수 없습니다.');
            }
            
            // 모달 열기
            modal.style.display = 'block';
            modalTitle.textContent = restaurantName + ' - 예약 현황 조회';
            modalBody.innerHTML = '<div style="text-align: center; padding: 40px;"><div style="font-size: 2rem;">⏳</div><div>예약 목록을 불러오는 중입니다...</div></div>';
            
            // 서버에서 예약 목록 조회
            fetch(this.contextPath + '/admin/restaurants/' + restaurantId + '/reservations')
                .then(function(response) {
                    console.log('예약 응답 상태:', response.status);
                    if (!response.ok) {
                        throw new Error('서버 응답 오류: ' + response.status);
                    }
                    return response.json();
                })
                .then(function(data) {
                    console.log('예약 목록 응답:', data);
                    if (data.success) {
                        self.displayReservationManagement(data.data, restaurantId, restaurantName);
                    } else {
                        modalBody.innerHTML = '<div style="text-align: center; padding: 40px; color: #e74c3c;"><div style="font-size: 2rem;">❌</div><div>예약 목록 조회 실패: ' + (data.message || '알 수 없는 오류') + '</div></div>';
                    }
                })
                .catch(function(error) {
                    console.error('예약 현황 조회 오류:', error);
                    modalBody.innerHTML = '<div style="text-align: center; padding: 40px; color: #e74c3c;"><div style="font-size: 2rem;">⚠️</div><div>예약 목록 조회 중 오류가 발생했습니다.</div><div style="font-size: 0.9rem; margin-top: 10px;">(' + error.message + ')</div></div>';
                });
        } catch (error) {
            console.error('예약 현황 조회 함수 오류:', error);
            alert('예약 현황 조회 중 오류가 발생했습니다: ' + error.message);
        }
    },
    
    // 예약 관리 화면 표시
    displayReservationManagement: function(reservations, restaurantId, restaurantName) {
        var self = this;
        try {
            var modalBody = document.getElementById('modalBody');
            
            if (!reservations || reservations.length === 0) {
                modalBody.innerHTML = `
                    <div style="text-align: center; padding: 60px 20px;">
                        <div style="font-size: 3rem; margin-bottom: 20px;">📅</div>
                        <div style="font-size: 1.2rem; color: #666; margin-bottom: 10px;">등록된 예약이 없습니다</div>
                        <div style="font-size: 0.9rem; color: #999;">아직 고객 예약이 없습니다.</div>
                    </div>
                `;
                return;
            }
            
            var reservationsHtml = `
                <div style="margin-bottom: 20px; padding: 15px; background: #f8f9fa; border-radius: 8px;">
                    <h4 style="margin: 0; color: #2c2c2c; font-family: 'Crimson Text', serif;">📅 예약 현황 조회</h4>
                    <p style="margin: 5px 0 0 0; color: #666; font-size: 0.9rem;">관리자는 예약 현황을 조회할 수 있습니다. 예약 승인/거절은 사업자가 처리합니다. (총 ${reservations.length}개)</p>
                </div>
                
                <div style="max-height: 400px; overflow-y: auto;">
            `;
            
            reservations.forEach(function(reservation, index) {
                var statusBadge = self.getReservationStatusBadge(reservation.status);
                var reservationDate = self.formatDate(reservation.reservationDate);
                
                reservationsHtml += `
                    <div class="reservation-item" style="border: 1px solid #e0e0e0; border-radius: 8px; padding: 15px; margin-bottom: 15px; background: #ffffff;">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 10px;">
                            <div style="flex: 1;">
                                <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 8px;">
                                    <strong style="color: #2c2c2c;">${reservation.userName || '익명'}</strong>
                                    <span>${statusBadge}</span>
                                </div>
                                <div style="color: #666; font-size: 0.9rem; margin-bottom: 5px;">
                                    📅 ${reservationDate} ${reservation.reservationTime || reservation.reservationHour || ''}
                                </div>
                                <div style="color: #666; font-size: 0.9rem; margin-bottom: 5px;">
                                    👥 ${reservation.partySize || 0}명
                                </div>
                                ${reservation.specialRequest ? `<div style="color: #666; font-size: 0.9rem;">💬 ${reservation.specialRequest}</div>` : ''}
                            </div>
                            <div style="display: flex; flex-direction: column; gap: 5px; margin-left: 10px;">
                                <div style="background: #e9ecef; color: #495057; padding: 6px 12px; border-radius: 4px; font-size: 0.75rem; text-align: center;">
                                    👤 사업자 처리 필요
                                </div>
                            </div>
                        </div>
                    </div>
                `;
            });
            
            reservationsHtml += `
                </div>
                <div style="margin-top: 20px; padding: 15px; background: #d1ecf1; border-radius: 8px;">
                    <h5 style="margin: 0 0 8px 0; color: #0c5460;">💡 예약 관리 안내</h5>
                    <ul style="margin: 0; padding-left: 20px; color: #0c5460; font-size: 0.9rem;">
                        <li>관리자는 예약 현황을 조회할 수 있습니다.</li>
                        <li>예약 승인/거절/완료 처리는 해당 사업자가 직접 처리합니다.</li>
                        <li>문제가 있는 예약은 사업자에게 별도 연락해주세요.</li>
                    </ul>
                </div>
            `;
            
            modalBody.innerHTML = reservationsHtml;
        } catch (error) {
            console.error('예약 관리 화면 표시 오류:', error);
            var modalBody = document.getElementById('modalBody');
            if (modalBody) {
                modalBody.innerHTML = '<div style="text-align: center; padding: 40px; color: #e74c3c;">예약 목록 표시 중 오류가 발생했습니다.</div>';
            }
        }
    },
    
    // 예약 상태 배지 생성
    getReservationStatusBadge: function(status) {
        var badges = {
            'PENDING': '<span style="background: #fff3cd; color: #856404; padding: 3px 8px; border-radius: 8px; font-size: 0.75rem;">⏳ 대기중</span>',
            'CONFIRMED': '<span style="background: #d4edda; color: #155724; padding: 3px 8px; border-radius: 8px; font-size: 0.75rem;">✅ 승인됨</span>',
            'CANCELLED': '<span style="background: #f8d7da; color: #721c24; padding: 3px 8px; border-radius: 8px; font-size: 0.75rem;">❌ 취소됨</span>',
            'COMPLETED': '<span style="background: #d1ecf1; color: #0c5460; padding: 3px 8px; border-radius: 8px; font-size: 0.75rem;">✅ 완료됨</span>'
        };
        return badges[status] || status;
    },
    
    // 예약 상태 업데이트
    updateReservationStatus: function(reservationId, status, restaurantId) {
        var self = this;
        try {
            console.log('예약 상태 업데이트 호출됨, 예약 ID:', reservationId, '상태:', status);
            
            var statusText = {
                'CONFIRMED': '승인',
                'CANCELLED': '거절',
                'COMPLETED': '완료'
            };
            
            if (confirm('이 예약을 ' + statusText[status] + ' 처리하시겠습니까?')) {
                fetch(this.contextPath + '/admin/reservations/' + reservationId + '/status', {
                    method: 'PUT',
                    headers: { 
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify({ status: status })
                })
                .then(function(response) {
                    console.log('예약 상태 업데이트 응답:', response.status);
                    if (!response.ok) {
                        throw new Error('서버 응답 오류: ' + response.status);
                    }
                    return response.json();
                })
                .then(function(data) {
                    console.log('예약 상태 업데이트 결과:', data);
                    if (data.success) {
                        alert('예약 상태가 업데이트되었습니다.');
                        // 예약 목록 새로고침
                        self.manageReservations(restaurantId, '');
                    } else {
                        alert('예약 상태 업데이트 실패: ' + (data.message || '알 수 없는 오류'));
                    }
                })
                .catch(function(error) {
                    console.error('예약 상태 업데이트 오류:', error);
                    alert('예약 상태 업데이트 중 오류가 발생했습니다: ' + error.message);
                });
            }
        } catch (error) {
            console.error('예약 상태 업데이트 함수 오류:', error);
            alert('예약 상태 업데이트 중 오류가 발생했습니다.');
        }
    },
    
    // 리뷰 삭제
    deleteReview: function(reviewId, userName, restaurantId) {
        var self = this;
        try {
            console.log('리뷰 삭제 호출됨, 리뷰 ID:', reviewId, '작성자:', userName);
            
            if (!reviewId) {
                alert('잘못된 리뷰 정보입니다.');
                return;
            }
            
            if (confirm('"' + userName + '"님의 리뷰를 삭제하시겠습니까?\n\n주의: 이 작업은 되돌릴 수 없습니다.')) {
                fetch(this.contextPath + '/admin/reviews/' + reviewId, {
                    method: 'DELETE',
                    headers: { 'Accept': 'application/json' }
                })
                .then(function(response) {
                    console.log('리뷰 삭제 응답 상태:', response.status);
                    if (!response.ok) {
                        throw new Error('서버 응답 오류: ' + response.status);
                    }
                    return response.json();
                })
                .then(function(data) {
                    console.log('리뷰 삭제 결과:', data);
                    if (data.success) {
                        alert('리뷰가 삭제되었습니다.');
                        // 리뷰 목록 새로고침
                        self.manageReviews(restaurantId, '');
                    } else {
                        alert('리뷰 삭제 실패: ' + (data.message || '알 수 없는 오류'));
                    }
                })
                .catch(function(error) {
                    console.error('리뷰 삭제 오류:', error);
                    alert('리뷰 삭제 중 오류가 발생했습니다: ' + error.message);
                });
            }
        } catch (error) {
            console.error('리뷰 삭제 함수 오류:', error);
            alert('리뷰 삭제 중 오류가 발생했습니다.');
        }
    },
    
    // 식당 삭제
    deleteRestaurant: function(restaurantId, restaurantName) {
        var self = this;
        try {
            console.log('삭제 함수 호출됨, ID:', restaurantId, '이름:', restaurantName);
            
            if (!restaurantId) {
                alert('잘못된 식당 정보입니다.');
                return;
            }
            
            if (confirm('"' + restaurantName + '" 식당을 삭제하시겠습니까?\n\n주의: 이 작업은 되돌릴 수 없으며, 관련된 모든 예약과 리뷰도 함께 삭제됩니다.')) {
                fetch(this.contextPath + '/admin/restaurants/' + restaurantId, {
                    method: 'DELETE',
                    headers: { 'Accept': 'application/json' }
                })
                .then(function(response) {
                    console.log('삭제 응답 상태:', response.status);
                    if (!response.ok) {
                        throw new Error('서버 응답 오류: ' + response.status);
                    }
                    return response.json();
                })
                .then(function(data) {
                    console.log('삭제 결과:', data);
                    if (data.success) {
                        alert('식당이 삭제되었습니다.');
                        location.reload();
                    } else {
                        alert('삭제 실패: ' + (data.message || '알 수 없는 오류'));
                    }
                })
                .catch(function(error) {
                    console.error('삭제 오류:', error);
                    alert('삭제 중 오류가 발생했습니다: ' + error.message);
                });
            }
        } catch (error) {
            console.error('삭제 함수 오류:', error);
            alert('삭제 중 오류가 발생했습니다.');
        }
    },
    
    // 모달 닫기
    closeModal: function() {
        try {
            var modal = document.getElementById('restaurantModal');
            if (modal) {
                modal.style.display = 'none';
            }
        } catch (error) {
            console.error('모달 닫기 오류:', error);
        }
    }
};

// DOM 로드 완료 후 초기화
document.addEventListener('DOMContentLoaded', function() {
    // contextPath는 JSP에서 전달받을 예정
    if (typeof window.contextPath !== 'undefined') {
        RestaurantAdmin.init(window.contextPath);
    } else {
        console.error('contextPath가 설정되지 않았습니다.');
    }
});