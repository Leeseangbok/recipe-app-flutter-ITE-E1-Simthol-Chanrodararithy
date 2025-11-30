import 'package:flutter/material.dart';
import '../../../data/models/meal.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback? onTap;

  const MealCard({super.key, required this.meal, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Row(
          children: [
            if (meal.mealThumb != null && meal.mealThumb!.isNotEmpty)
              SizedBox(
                width: 120,
                height: 90,
                child: CachedNetworkImage(
                  imageUrl: meal.mealThumb!,
                  fit: BoxFit.cover,
                  placeholder: (c,_) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (c,_,__) => const Icon(Icons.broken_image),
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(meal.meal, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(meal.category ?? '-', style: TextStyle(color: Colors.grey[700])),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
