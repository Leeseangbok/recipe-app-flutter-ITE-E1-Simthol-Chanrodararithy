import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_finder_flutter_application/domain/presentation/widgets/category_chip.dart';
import 'package:recipe_finder_flutter_application/domain/presentation/widgets/meal_card.dart';
import '../../../../data/providers/providers.dart';
import '../../../../config/routes.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _openMeal(BuildContext ctx, String id) {
    Navigator.of(ctx).pushNamed(Routes.mealDetail, arguments: id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealsAsync = ref.watch(mealsListProvider);
    final catsAsync = ref.watch(categoriesProvider);
    final randomAsync = ref.watch(randomMealProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Finder')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Random suggestion', style: Theme.of(context).textTheme.titleLarge),
              randomAsync.when(
                data: (m) {
                  if (m == null) return const Text('No suggestion');
                  return GestureDetector(
                    onTap: () => _openMeal(context, m.id),
                    child: Card(
                      child: Column(children: [
                        if (m.mealThumb != null)
                          Image.network(m.mealThumb!, height: 180, width: double.infinity, fit: BoxFit.cover),
                        ListTile(title: Text(m.meal), subtitle: Text(m.category ?? '')),
                      ]),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e,_) => const Text('Error'),
              ),
              const SizedBox(height: 12),
              Text('Categories', style: Theme.of(context).textTheme.titleLarge),
              catsAsync.when(
                data: (cats) => SizedBox(
                  height: 56,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: cats.length,
                    separatorBuilder: (_,__) => const SizedBox(width: 8),
                    itemBuilder: (ctx,i){
                      final c = cats[i];
                      return CategoryChip(cat: c, onTap: (){
                        Navigator.of(context).pushNamed(Routes.mealList, arguments: {'categoryId': c.id, 'title': c.category});
                      });
                    },
                  ),
                ),
                loading: () => const CircularProgressIndicator(),
                error: (e,_) => const Text('Error'),
              ),
              const SizedBox(height:12),
              Text('Popular meals', style: Theme.of(context).textTheme.titleLarge),
              mealsAsync.when(
                data: (meals) => ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: meals.length,
                  separatorBuilder: (_,__) => const SizedBox(height:8),
                  itemBuilder: (ctx,i){
                    final m = meals[i];
                    return MealCard(
                      meal: m,
                      onTap: () => _openMeal(context, m.id),
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e,_) => const Text('Error'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
