import 'package:flutter_riverpod/legacy.dart';
import 'package:recipe_finder_flutter_app/data/local/database_helper.dart';
import 'package:recipe_finder_flutter_app/data/model/meal.dart';

final favoriteListProvider = StateNotifierProvider<FavoriteNotifier, List<Meal>>((ref) {
  return FavoriteNotifier();
});

class FavoriteNotifier extends StateNotifier<List<Meal>> {
  FavoriteNotifier() : super([]) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final data = await DatabaseHelper.instance.getFavorites();
    state = data.map((e) => Meal(
      id: e['id'],
      meal: e['meal'],
      mealThumb: e['mealThumb'],
      area: e['area'],
      category: e['category'],
      instructions: '', tags: '', youtube: '', categoryId: '', ingredients: []
    )).toList();
  }

  Future<void> toggleFavorite(Meal meal) async {
    final isFav = await DatabaseHelper.instance.isFavorite(meal.id);
    if (isFav) {
      await DatabaseHelper.instance.removeFavorite(meal.id);
    } else {
      await DatabaseHelper.instance.insertFavorite(meal);
    }
    await loadFavorites();
  }
  
  Future<bool> isFav(String id) async {
    return await DatabaseHelper.instance.isFavorite(id);
  }
}