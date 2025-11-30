import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_finder_flutter_application/config/routes.dart';
import 'package:recipe_finder_flutter_application/data/providers/providers.dart';
import 'package:recipe_finder_flutter_application/domain/presentation/widgets/meal_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favsAsync = ref.watch(favoritesListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favourite')),
      body: favsAsync.when(
        data: (list) {
          if (list.isEmpty) return const Center(child: Text('No favourites yet'));
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            separatorBuilder: (_,__) => const SizedBox(height: 8),
            itemBuilder: (ctx,i) => MealCard(meal: list[i], onTap: ()=> Navigator.of(context).pushNamed(Routes.mealDetail, arguments: list[i].id)),
          );
        },
        loading: ()=> const Center(child: CircularProgressIndicator()),
        error: (e,_) => const Center(child: Text('Error')),
      ),
    );
  }
}
