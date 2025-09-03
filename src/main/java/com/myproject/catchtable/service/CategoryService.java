package com.myproject.catchtable.service;

import com.myproject.catchtable.mapper.CategoryMapper;
import com.myproject.catchtable.model.Category;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@Transactional
public class CategoryService {
    
    @Autowired
    private CategoryMapper categoryMapper;
    
    // 카테고리 조회
    public Category findById(Integer categoryId) {
        return categoryMapper.findById(categoryId);
    }
    
    public List<Category> findAll() {
        return categoryMapper.findAll();
    }
    
    public Category findByName(String name) {
        return categoryMapper.findByName(name);
    }
    
    // 카테고리 등록 (관리자만)
    public void createCategory(Category category) {
        if (category.getName() == null || category.getName().trim().isEmpty()) {
            throw new RuntimeException("카테고리명은 필수입니다.");
        }
        
        // 중복 이름 체크
        Category existingCategory = categoryMapper.findByName(category.getName());
        if (existingCategory != null) {
            throw new RuntimeException("이미 존재하는 카테고리명입니다.");
        }
        
        categoryMapper.insertCategory(category);
    }
    
    // 카테고리 수정 (관리자만)
    public void updateCategory(Category category) {
        Category existingCategory = categoryMapper.findById(category.getCategoryId());
        if (existingCategory == null) {
            throw new RuntimeException("존재하지 않는 카테고리입니다.");
        }
        
        // 다른 카테고리와 이름 중복 체크
        Category duplicateCategory = categoryMapper.findByName(category.getName());
        if (duplicateCategory != null && !duplicateCategory.getCategoryId().equals(category.getCategoryId())) {
            throw new RuntimeException("이미 존재하는 카테고리명입니다.");
        }
        
        categoryMapper.updateCategory(category);
    }
    
    // 카테고리 삭제 (관리자만)
    public void deleteCategory(Integer categoryId) {
        Category category = categoryMapper.findById(categoryId);
        if (category == null) {
            throw new RuntimeException("존재하지 않는 카테고리입니다.");
        }
        
        // 해당 카테고리에 속한 식당이 있는지 확인
        int restaurantCount = categoryMapper.countRestaurantsByCategoryId(categoryId);
        if (restaurantCount > 0) {
            throw new RuntimeException("해당 카테고리에 속한 식당이 있어 삭제할 수 없습니다.");
        }
        
        categoryMapper.deleteCategory(categoryId);
    }
    
    // 카테고리별 식당 수 조회
    public int getRestaurantCount(Integer categoryId) {
        return categoryMapper.countRestaurantsByCategoryId(categoryId);
    }
}