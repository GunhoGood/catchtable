package com.myproject.catchtable.mapper;

import com.myproject.catchtable.model.Category;
import java.util.List;

public interface CategoryMapper {
    
    // ī�װ� ��ȸ
    Category findById(Integer categoryId);
    List<Category> findAll();
    Category findByName(String name);
    
    // ī�װ� ���/����/���� (�����ڿ�)
    void insertCategory(Category category);
    void updateCategory(Category category);
    void deleteCategory(Integer categoryId);
    
    // ī�װ��� �Ĵ� �� ��ȸ
    int countRestaurantsByCategoryId(Integer categoryId);
}