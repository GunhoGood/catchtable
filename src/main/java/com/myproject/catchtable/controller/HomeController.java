package com.myproject.catchtable.controller;

import com.myproject.catchtable.model.Restaurant;
import com.myproject.catchtable.model.Category;
import com.myproject.catchtable.model.Review;
import com.myproject.catchtable.service.RestaurantService;
import com.myproject.catchtable.service.CategoryService;
import com.myproject.catchtable.service.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import java.util.List;

@Controller
public class HomeController {

	@Autowired
	private RestaurantService restaurantService;

	@Autowired
	private CategoryService categoryService;

	@Autowired
	private ReviewService reviewService;

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Model model) {

		try {
			// ���� ������ ������ ��ȸ
			List<Category> categories = categoryService.findAll();
			List<Restaurant> popularRestaurants = restaurantService.getTopRestaurants(8);
			List<Review> recentReviews = reviewService.getRecentReviews(6);
			// �� �Ĵ纰 ���� ��ȸ (email ����)
			for(Restaurant restaurant : popularRestaurants) {
			    List<Review> reviews = reviewService.findByRestaurantIdWithEmail(restaurant.getRestaurantId());
			    restaurant.setReviews(reviews);
			}

			// �𵨿� ������ �߰�
			model.addAttribute("categories", categories);
			model.addAttribute("popularRestaurants", popularRestaurants);
			model.addAttribute("recentReviews", recentReviews);

		} catch (Exception e) {
			// ������ �߻��ص� �������� �ε�ǵ���
			model.addAttribute("error", "������ �ε� �� ������ �߻��߽��ϴ�.");
		}

		return "home";
	}

}