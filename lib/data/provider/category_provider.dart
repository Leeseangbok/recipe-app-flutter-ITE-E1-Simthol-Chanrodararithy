import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_finder_flutter_app/data/provider/meal_provider.dart';

final categoryProvider = FutureProvider<List<String>>((ref) async {
  final mealService = ref.watch(mealServiceProvider);
  final meals = await mealService.fetchMeals();

  final uniqueCategories =
      meals.map((meal) => meal.category).toSet().toList()
        ..sort((a, b) => a.compareTo(b));
        
  return uniqueCategories;
});