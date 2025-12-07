import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_finder_flutter_app/data/provider/meal_provider.dart';
import 'package:recipe_finder_flutter_app/features/screens/detail/meal_detail_screen.dart';
import 'package:recipe_finder_flutter_app/features/screens/home/widgets/mini_chip.dart';

Widget buildVerticalMealCard(BuildContext context, WidgetRef ref, dynamic meal) {
  final String category = (meal.category?.isNotEmpty == true)
      ? meal.category
      : (meal.strCategory?.isNotEmpty == true ? meal.strCategory! : 'Recipe');
      
  final String area = (meal.area?.isNotEmpty == true)
      ? meal.area
      : (meal.strArea?.isNotEmpty == true ? meal.strArea! : 'Global');

  return GestureDetector(
    onTap: () {
      ref.read(selectedMealIdProvider.notifier).state = meal.id;
      Navigator.push(context, MaterialPageRoute(builder: (_) => const MealDetailScreen()));
    },
    child: Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  meal.mealThumb,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 140,
                      color: Colors.grey[200],
                      child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                    );
                  },
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  meal.meal,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 16, 
                    height: 1.2,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    buildMiniChip(category, Colors.orange.shade50, Colors.orange.shade800),
                    buildMiniChip(area, Colors.blueGrey.shade50, Colors.blueGrey.shade700),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}