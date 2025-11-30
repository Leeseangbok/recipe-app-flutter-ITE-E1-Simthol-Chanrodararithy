import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_finder_flutter_application/config/routes.dart';
import 'package:recipe_finder_flutter_application/data/providers/providers.dart';
import 'package:recipe_finder_flutter_application/domain/presentation/widgets/meal_card.dart';

class MealListScreen extends ConsumerWidget {
  const MealListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>?;
    final categoryId = args?['categoryId'] as String?;
    final title = args?['title'] as String? ?? 'Meals';
    if (categoryId == null) {
      return const Scaffold(body: Center(child: Text('No category')));
    }

    final mealsAsync = ref.watch(mealsByCategoryProvider(categoryId));

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: mealsAsync.when(
        data: (meals) => ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: meals.length,
          separatorBuilder: (_,__) => const SizedBox(height: 8),
          itemBuilder: (ctx,i) => MealCard(
            meal: meals[i],
            onTap: ()=> Navigator.of(context).pushNamed(Routes.mealDetail, arguments: meals[i].id),
          ),
        ),
        loading: ()=> const Center(child: CircularProgressIndicator()),
        error: (e,_) => const Center(child: Text('Error')),
      ),
    );
  }
}
