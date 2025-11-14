import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/meal_model.dart';
import '../data/services/api_service.dart';

final mealProvider = FutureProvider<List<Meal>>((ref) async {
  final api = ApiService();
  final data = await api.fetchMeals();
  return data.map<Meal>((json) => Meal.fromJson(json)).toList();
});
