package com.myproject.catchtable.dto;

public class ApiResponse {
    private boolean success;
    private String message;
    private Object data;
    
    // 기본 생성자
    public ApiResponse() {}
    
    // 성공 응답 생성자
    public ApiResponse(String message) {
        this.success = true;
        this.message = message;
    }
    
    // 성공 응답 + 데이터 생성자
    public ApiResponse(String message, Object data) {
        this.success = true;
        this.message = message;
        this.data = data;
    }
    
    // 실패 응답 생성 메서드
    public static ApiResponse error(String message) {
        ApiResponse response = new ApiResponse();
        response.success = false;
        response.message = message;
        return response;
    }
    
    // Getter, Setter
    public boolean isSuccess() {
        return success;
    }
    
    public void setSuccess(boolean success) {
        this.success = success;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public Object getData() {
        return data;
    }
    
    public void setData(Object data) {
        this.data = data;
    }
    
    @Override
    public String toString() {
        return "ApiResponse{" +
                "success=" + success +
                ", message='" + message + '\'' +
                ", data=" + data +
                '}';
    }
}