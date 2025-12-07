import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_finder_flutter_app/data/model/meal.dart';
import 'package:recipe_finder_flutter_app/data/provider/favorite_provider.dart';
import 'package:recipe_finder_flutter_app/data/provider/meal_provider.dart';
import 'package:recipe_finder_flutter_app/features/screens/detail/meal_detail_screen.dart';
import 'package:recipe_finder_flutter_app/features/screens/favorite/widgets/mini_chip.dart';

Widget buildFavoriteItem(BuildContext context, WidgetRef ref, Meal meal) {
    return Dismissible(
      key: Key(meal.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete_outline, color: Colors.red.shade700, size: 30),
      ),
      onDismissed: (direction) {
        ref.read(favoriteListProvider.notifier).toggleFavorite(meal);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${meal.meal} removed"),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          ref.read(selectedMealIdProvider.notifier).state = meal.id;
          Navigator.push(context, MaterialPageRoute(builder: (_) => const MealDetailScreen()));
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Hero(
                tag: 'fav_${meal.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    meal.mealThumb,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (_,__,___) => Container(
                      width: 90, height: 90, 
                      color: Colors.grey[200], 
                      child: const Icon(Icons.broken_image, color: Colors.grey)
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.meal,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      children: [
                        if (meal.category.isNotEmpty)
                          buildMiniChip(meal.category, Colors.orange),
                        if (meal.area.isNotEmpty)
                          buildMiniChip(meal.area, Colors.blueGrey),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }