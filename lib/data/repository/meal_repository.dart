import 'dart:convert';
import '../models/meal.dart';
import '../models/category.dart';
import '../api/api_service.dart';

class MealRepository {
  final ApiService api;

  MealRepository(this.api);

  Future<List<Meal>> fetchMeals({Map<String,String>? query}) async {
    final resp = await api.get('/meals', params: query);
    final list = json.decode(resp.body);
    if (list is List) {
      return list.map((e) => Meal.fromJson(Map<String,dynamic>.from(e))).toList();
    }
    return [];
  }

  Future<List<Category>> fetchCategories() async {
    final resp = await api.get('/categories');
    final list = json.decode(resp.body);
    if (list is List) {
      return list.map((e) => Category.fromJson(Map<String,dynamic>.from(e))).toList();
    }
    return [];
  }

  Future<List<Meal>> fetchMealsByCategory(String categoryId) async {
    return await fetchMeals(query: {'categoryId': categoryId});
  }

  Future<Meal?> fetchRandomMeal() async {
    final meals = await fetchMeals();
    if (meals.isEmpty) return null;
    meals.shuffle();
    return meals.first;
  }
}
