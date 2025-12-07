import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_finder_flutter_app/data/provider/meal_provider.dart';
import 'package:recipe_finder_flutter_app/features/screens/detail/meal_detail_screen.dart';

Widget buildHeroCard(BuildContext context, WidgetRef ref, dynamic meal) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedMealIdProvider.notifier).state = meal.id;
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MealDetailScreen()));
      },
      child: Hero(
        tag: 'meal_${meal.id}',
        child: Container(
          height: 240,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10, offset: const Offset(0, 5))],
            image: DecorationImage(
              image: NetworkImage(meal.mealThumb),
              fit: BoxFit.cover,
              onError: (exception, stackTrace) => {},
            )
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.grey.shade900],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text("Top Pick", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      meal.meal,
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
