import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:recipe_finder_flutter_app/data/model/meal.dart';
import 'package:recipe_finder_flutter_app/data/service/api_services.dart';

final mealServiceProvider = Provider<MealApiService>((ref) => MealApiService());
final searchQueryProvider = StateProvider<String>((ref) => '');

final mealProvider = FutureProvider<List<Meal>>((ref) async {
  final mealService = ref.watch(mealServiceProvider);
  return await mealService.fetchMeals();
});

final popularMealProvider = FutureProvider<List<Meal>>((ref) async {
  final mealService = ref.watch(mealServiceProvider);
  final meals = await mealService.fetchMeals();
  return meals.take(5).toList();
});

final selectedMealIdProvider = StateProvider<String>((ref) => '');
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');
final selectedAreaProvider = StateProvider<String>((ref) => 'All');

final mealDetailsProvider = FutureProvider.autoDispose<Meal>((ref) async {
  final mealService = ref.watch(mealServiceProvider);
  final mealId = ref.watch(selectedMealIdProvider);
  return await mealService.fetchMealById(mealId);
});

final mealsRandomProvider = FutureProvider<List<Meal>>((ref) async {
  final mealService = ref.watch(mealServiceProvider);
  final meals = await mealService.fetchMeals();

  meals.shuffle();
  return meals.take(1).toList();
});

final areaProvider = FutureProvider<List<String>>((ref) async {
  final mealService = ref.watch(mealServiceProvider);
  final meals = await mealService.fetchMeals();

  final areas = meals
      .map((meal) => meal.area)
      .where((area) => area.isNotEmpty)
      .toSet()
      .toList()
    ..sort();
  return areas;
});

final filteredMealProvider = FutureProvider.autoDispose<List<Meal>>((ref) async {
  final mealService = ref.watch(mealServiceProvider);
  final category = ref.watch(selectedCategoryProvider);
  final area = ref.watch(selectedAreaProvider);
  
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase(); 

  List<Meal> meals;

  if (category == 'All' && area == 'All') {
    meals = await mealService.fetchMeals();
  } else if (category != 'All' && area == 'All') {
    meals = await mealService.fetchMealsByCategory(category);
  } else if (category == 'All' && area != 'All') {
    meals = await mealService.fetchMealsByArea(area);
  } else {
    final results = await Future.wait([
      mealService.fetchMealsByCategory(category),
      mealService.fetchMealsByArea(area)
    ]);
    final catList = results[0];
    final areaList = results[1];
    final areaIds = areaList.map((m) => m.id).toSet();
    meals = catList.where((meal) => areaIds.contains(meal.id)).toList();
  }

  if (searchQuery.isNotEmpty) {
    meals = meals.where((meal) => 
      meal.meal.toLowerCase().contains(searchQuery)
    ).toList();
  }

  return meals;
});