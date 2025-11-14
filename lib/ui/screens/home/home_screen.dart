import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/meal_provider.dart';
import '../../widgets/meal_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealsAsync = ref.watch(mealProvider);

    return mealsAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (meals) {
        final popular = meals.take(6).toList();
        final suggestions = meals.skip(6).take(6).toList();

        return Scaffold(
          appBar: AppBar(title: const Text('Home')),
          body: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              const Text('Popular', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: popular.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final m = popular[i];
                    return SizedBox(
                      width: 260,
                      child: MealCard(meal: m),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text('Suggestions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...suggestions.map((m) => MealCard(meal: m)),
            ],
          ),
        );
      },
    );
  }
}