package com.myproject.catchtable.mapper;

import com.myproject.catchtable.model.Category;
import java.util.List;

public interface CategoryMapper {
    
    // 카테고리 조회
    Category findById(Integer categoryId);
    List<Category> findAll();
    Category findByName(String name);
    
    // 카테고리 등록/수정/삭제 (관리자용)
    void insertCategory(Category category);
    void updateCategory(Category category);
    void deleteCategory(Integer categoryId);
    
    // 카테고리별 식당 수 조회
    int countRestaurantsByCategoryId(Integer categoryId);
}