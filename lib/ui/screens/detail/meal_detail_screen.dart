import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/favorite_provider.dart';
import '../../../data/models/meal_model.dart';

class MealDetailScreen extends ConsumerWidget {
  final Meal meal;
  const MealDetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteProvider);
    final isFav = favorites.any((f) => f.id == meal.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : null),
            onPressed: () {
              ref.read(favoriteProvider.notifier).toggle(
                    id: meal.id,
                    name: meal.name,
                    image: meal.image,
                    category: meal.category,
                    area: meal.area,
                  );
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(meal.image, height: 220, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 12),
          Text('${meal.category} · ${meal.area}', style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          const Text('Ingredients', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...meal.ingredients.map((ing) => Text('• $ing')),
          const SizedBox(height: 16),
          const Text('Instructions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(meal.instructions),
          if (meal.tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Tags: ${meal.tags}'),
          ],
        ],
      ),
    );
  }
}