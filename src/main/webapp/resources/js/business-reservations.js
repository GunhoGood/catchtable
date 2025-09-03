/**
 * 
 */
 
        let currentReservationId = null;

       function updateStatus(reservationId, status) {
           if (!confirm('예약 상태를 변경하시겠습니까?')) {
               return;
           }

           fetch('/catchtable/business/reservations/' + reservationId + '/status', {
               method: 'POST',
               headers: {
                   'Content-Type': 'application/json',
                   'X-Requested-With': 'XMLHttpRequest'
               },
               body: JSON.stringify({
                   status: status
               })
           })
           .then(response => response.json())
           .then(data => {
               if (data.success) {
                   alert(data.message);
                   location.reload();
               } else {
                   alert(data.message || '상태 변경에 실패했습니다.');
               }
           })
           .catch(error => {
               console.error('Error:', error);
               alert('오류가 발생했습니다.');
           });
       }

       function showCancelModal(reservationId) {
           currentReservationId = reservationId;
           document.getElementById('cancelModal').style.display = 'block';
           document.body.style.overflow = 'hidden';
       }

       function closeCancelModal() {
           document.getElementById('cancelModal').style.display = 'none';
           document.body.style.overflow = 'auto';
           currentReservationId = null;
           document.getElementById('cancelReason').value = '';
       }

       function confirmCancel() {
           if (!currentReservationId) return;

           const reason = document.getElementById('cancelReason').value.trim();

           fetch('/catchtable/business/reservations/' + currentReservationId + '/status', {
               method: 'POST',
               headers: {
                   'Content-Type': 'application/json',
                   'X-Requested-With': 'XMLHttpRequest'
               },
               body: JSON.stringify({
                   status: 'CANCELLED',
                   reason: reason
               })
           })
           .then(response => response.json())
           .then(data => {
               if (data.success) {
                   alert(data.message);
                   closeCancelModal();
                   location.reload();
               } else {
                   alert(data.message || '취소에 실패했습니다.');
               }
           })
           .catch(error => {
               console.error('Error:', error);
               alert('오류가 발생했습니다.');
           });
       }

       function showDetailModal(reservationId) {
           alert('예약 상세 정보 기능은 준비 중입니다. 예약 ID: ' + reservationId);
       }

       function clearFilters() {
           window.location.href = '/catchtable/business/reservations';
       }

       window.onclick = function(event) {
           const cancelModal = document.getElementById('cancelModal');
           if (event.target === cancelModal) {
               closeCancelModal();
           }
       };

       document.addEventListener('keydown', function(event) {
           if (event.key === 'Escape') {
               closeCancelModal();
           }
       });
       
       //  페이지 이동 함수
function goToPage(page) {
    // 현재 URL의 파라미터들을 유지하면서 page만 변경
    const urlParams = new URLSearchParams(window.location.search);
    urlParams.set('page', page);
    
    // 새로운 URL로 이동
    window.location.href = '/catchtable/business/reservations?' + urlParams.toString();
}

//  필터 초기화 함수 수정 (페이지도 1로 리셋)
function clearFilters() {
    window.location.href = '/catchtable/business/reservations?page=1';
}

//  필터 폼 제출 시 페이지를 1로 리셋
document.addEventListener('DOMContentLoaded', function() {
    const filterSelects = document.querySelectorAll('.filter-select, .filter-input');
    
    filterSelects.forEach(function(element) {
        element.addEventListener('change', function() {
            // 필터 변경 시 페이지를 1로 리셋
            const form = document.getElementById('filterForm');
            const pageInput = form.querySelector('input[name="page"]');
            
            if (pageInput) {
                pageInput.value = 1;
            } else {
                // page 히든 필드가 없으면 추가
                const hiddenPage = document.createElement('input');
                hiddenPage.type = 'hidden';
                hiddenPage.name = 'page';
                hiddenPage.value = 1;
                form.appendChild(hiddenPage);
            }
            
            form.submit();
        });
    });
});