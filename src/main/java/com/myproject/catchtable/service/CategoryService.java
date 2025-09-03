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
    
    // ī�װ� ��ȸ
    public Category findById(Integer categoryId) {
        return categoryMapper.findById(categoryId);
    }
    
    public List<Category> findAll() {
        return categoryMapper.findAll();
    }
    
    public Category findByName(String name) {
        return categoryMapper.findByName(name);
    }
    
    // ī�װ� ��� (�����ڸ�)
    public void createCategory(Category category) {
        if (category.getName() == null || category.getName().trim().isEmpty()) {
            throw new RuntimeException("ī�װ����� �ʼ��Դϴ�.");
        }
        
        // �ߺ� �̸� üũ
        Category existingCategory = categoryMapper.findByName(category.getName());
        if (existingCategory != null) {
            throw new RuntimeException("�̹� �����ϴ� ī�װ����Դϴ�.");
        }
        
        categoryMapper.insertCategory(category);
    }
    
    // ī�װ� ���� (�����ڸ�)
    public void updateCategory(Category category) {
        Category existingCategory = categoryMapper.findById(category.getCategoryId());
        if (existingCategory == null) {
            throw new RuntimeException("�������� �ʴ� ī�װ��Դϴ�.");
        }
        
        // �ٸ� ī�װ��� �̸� �ߺ� üũ
        Category duplicateCategory = categoryMapper.findByName(category.getName());
        if (duplicateCategory != null && !duplicateCategory.getCategoryId().equals(category.getCategoryId())) {
            throw new RuntimeException("�̹� �����ϴ� ī�װ����Դϴ�.");
        }
        
        categoryMapper.updateCategory(category);
    }
    
    // ī�װ� ���� (�����ڸ�)
    public void deleteCategory(Integer categoryId) {
        Category category = categoryMapper.findById(categoryId);
        if (category == null) {
            throw new RuntimeException("�������� �ʴ� ī�װ��Դϴ�.");
        }
        
        // �ش� ī�װ��� ���� �Ĵ��� �ִ��� Ȯ��
        int restaurantCount = categoryMapper.countRestaurantsByCategoryId(categoryId);
        if (restaurantCount > 0) {
            throw new RuntimeException("�ش� ī�װ��� ���� �Ĵ��� �־� ������ �� �����ϴ�.");
        }
        
        categoryMapper.deleteCategory(categoryId);
    }
    
    // ī�װ��� �Ĵ� �� ��ȸ
    public int getRestaurantCount(Integer categoryId) {
        return categoryMapper.countRestaurantsByCategoryId(categoryId);
    }
}