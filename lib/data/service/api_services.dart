import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_finder_flutter_app/core/constants/api.dart';
import 'package:recipe_finder_flutter_app/data/model/category.dart';
import 'package:recipe_finder_flutter_app/data/model/meal.dart';

class MealApiService {
  
  Future<List<Meal>> fetchMeals() async {
    final url = Uri.parse("${Api.baseUrl}/meals");
    final response = await http.get(url, headers: {'X-DB-NAME': Api.guidKey});

    if (response.statusCode == 200) {
      final List<dynamic> allMeals = json.decode(response.body);
      return allMeals.map((json) => Meal.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  Future<Meal> fetchMealById(String id) async {
    final url = Uri.parse("${Api.baseUrl}/meals/$id");
    final response = await http.get(url, headers: {'X-DB-NAME': Api.guidKey});

    if (response.statusCode == 200) {
      final Map<String, dynamic> mealById = json.decode(response.body);
      return Meal.fromJson(mealById);
    } else {
      throw Exception('Failed to load meal');
    }
  }

  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final url = Uri.parse("${Api.baseUrl}/meals?category=$category");
    final response = await http.get(url, headers: {'X-DB-NAME': Api.guidKey});

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Meal> meals = data.map((json) => Meal.fromJson(json)).toList();
      return meals.where((m) => m.category == category || m.strCategory == category).toList();
    } else {
      throw Exception('Failed to load meals by category');
    }
  }

  Future<List<Meal>> fetchMealsByArea(String area) async {
    try {
      final url = Uri.parse("${Api.baseUrl}/meals?area=$area");
      final response = await http.get(url, headers: {'X-DB-NAME': Api.guidKey});

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Meal> meals = data.map((json) => Meal.fromJson(json)).toList();
        final filtered = meals.where((m) => m.area == area || m.strArea == area).toList();
        if (filtered.isNotEmpty) return filtered;
      }
    } catch (e) {
      throw Exception('Failed to load meals by area: $e');
    }
    try {
      final allMeals = await fetchMeals();
      return allMeals.where((meal) => 
        meal.area.toLowerCase() == area.toLowerCase() || 
        (meal.strArea ?? '').toLowerCase() == area.toLowerCase()
      ).toList();
    } catch (e) {
      throw Exception('Failed to load meals by area: $e');
    }
  }
}

class CategoryApiService {
  Future<List<Category>> fetchCategories() async {
    final url = Uri.parse("${Api.baseUrl}/categories");
    final response = await http.get(url, headers: {'X-DB-NAME': Api.guidKey});

    if (response.statusCode == 200) {
      final dynamic body = json.decode(response.body);
      final List<dynamic> allCategories = (body is List) ? body : (body['categories'] ?? []);
      return allCategories.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}