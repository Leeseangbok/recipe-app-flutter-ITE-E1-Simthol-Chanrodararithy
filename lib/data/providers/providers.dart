import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_service.dart';
import '../repository/meal_repository.dart';
import '../models/meal.dart';
import '../models/category.dart';
import '../local_db/favorite_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final mealRepositoryProvider = Provider<MealRepository>((ref) {
  final api = ref.watch(apiServiceProvider);
  return MealRepository(api);
});

final mealsListProvider = FutureProvider<List<Meal>>((ref) async {
  final repo = ref.watch(mealRepositoryProvider);
  return repo.fetchMeals();
});

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repo = ref.watch(mealRepositoryProvider);
  return repo.fetchCategories();
});

final randomMealProvider = FutureProvider<Meal?>((ref) async {
  final repo = ref.watch(mealRepositoryProvider);
  return repo.fetchRandomMeal();
});

final mealsByCategoryProvider = FutureProvider.family<List<Meal>, String>((ref, categoryId) async {
  final repo = ref.watch(mealRepositoryProvider);
  return repo.fetchMealsByCategory(categoryId);
});

final favoritesDaoProvider = Provider<FavoritesDao>((ref) => FavoritesDao());

final favoritesListProvider = FutureProvider<List<Meal>>((ref) async {
  final db = ref.watch(favoritesDaoProvider);
  return db.getAllFavorites();
});

final isFavoriteProvider = FutureProvider.family<bool, String>((ref, id) async {
  final db = ref.watch(favoritesDaoProvider);
  return db.isFavorite(id);
});

final onboardingCompleteProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('onboarding_complete') ?? false;
});

final setOnboardingCompleteProvider = Provider((ref) => (bool v) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('onboarding_complete', v);
});
