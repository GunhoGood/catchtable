package com.myproject.catchtable.dto;

public class ApiResponse {
    private boolean success;
    private String message;
    private Object data;
    
    // �⺻ ������
    public ApiResponse() {}
    
    // ���� ���� ������
    public ApiResponse(String message) {
        this.success = true;
        this.message = message;
    }
    
    // ���� ���� + ������ ������
    public ApiResponse(String message, Object data) {
        this.success = true;
        this.message = message;
        this.data = data;
    }
    
    // ���� ���� ���� �޼���
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