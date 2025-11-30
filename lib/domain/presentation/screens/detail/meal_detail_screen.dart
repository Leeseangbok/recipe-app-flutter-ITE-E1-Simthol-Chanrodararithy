import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_finder_flutter_application/data/models/meal.dart';
import 'package:recipe_finder_flutter_application/data/providers/providers.dart';


class MealDetailScreen extends ConsumerWidget {
  const MealDetailScreen({super.key});

  Future<Meal?> _loadMealById(WidgetRef ref, String id) async {
    // Simple approach: fetch all meals and find id.
    final repo = ref.read(mealRepositoryProvider);
    final list = await repo.fetchMeals(query: {'id': id});
    if (list.isNotEmpty) return list.first;
    // fallback to fetching all and searching
    final all = await repo.fetchMeals();
    return all.cast<Meal?>().firstWhere((m) => m?.id == id, orElse: () => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arg = ModalRoute.of(context)!.settings.arguments;
    final id = arg as String;
    final db = ref.read(favoritesDaoProvider);

    return FutureBuilder<Meal?>(
      future: _loadMealById(ref, id),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        final meal = snap.data;
        if (meal == null) return const Scaffold(body: Center(child: Text('Meal not found')));

        return Scaffold(
          appBar: AppBar(
            title: Text(meal.meal),
            actions: [
              FutureBuilder<bool>(
                future: db.isFavorite(meal.id),
                builder: (ctx,snapFav) {
                  final isFav = snapFav.data ?? false;
                  return IconButton(
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                    onPressed: () async {
                      if (isFav) {
                        await db.removeFavorite(meal.id);
                      } else {
                        await db.insertFavorite(meal);
                      }
                      ref.invalidate(favoritesDaoProvider);
                    },
                  );
                },
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (meal.mealThumb != null)
                  Image.network(meal.mealThumb!, height: 220, width: double.infinity, fit: BoxFit.cover),
                const SizedBox(height: 12),
                Text(meal.meal, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                if (meal.category != null) Text('${meal.category} • ${meal.area ?? ''}'),
                const SizedBox(height: 12),
                const Text('Ingredients', style: TextStyle(fontWeight: FontWeight.bold)),
                ...meal.ingredients.map((ing) => ListTile(
                  dense: true,
                  title: Text(ing.ingredient),
                  trailing: Text(ing.measure),
                )),
                const SizedBox(height: 12),
                const Text('Instructions', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(meal.instructions ?? ''),
                if (meal.youtube != null && meal.youtube!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: InkWell(
                      onTap: () {
                      },
                      child: const Text('Watch on YouTube', style: TextStyle(color: Colors.blue)),
                    ),
                  ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
