import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/favorite_provider.dart';
import '../../data/models/meal_model.dart';
import '../../config/app_router.dart';

class MealCard extends ConsumerWidget {
  final Meal meal;
  const MealCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteProvider);
    final isFav = favorites.any((f) => f.id == meal.id);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, AppRouter.mealDetail, arguments: meal),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              height: 100,
              child: Image.network(meal.image, fit: BoxFit.cover),
            ),
            Expanded(
              child: ListTile(
                title: Text(meal.name),
                subtitle: Text('${meal.category} · ${meal.area}'),
                trailing: IconButton(
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}