// lib/screens/explore_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_finder_flutter_application/config/routes.dart';
import 'package:recipe_finder_flutter_application/data/providers/providers.dart';
import 'package:recipe_finder_flutter_application/domain/presentation/widgets/meal_card.dart';


class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  String? selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final cats = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: cats.when(
          data: (categories) {
            selectedCategoryId ??= categories.isNotEmpty ? categories.first.id : null;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map((c) => ChoiceChip(
                    label: Text(c.category),
                    selected: c.id == selectedCategoryId,
                    onSelected: (_) {
                      setState(() {
                        selectedCategoryId = c.id;
                      });
                    },
                  )).toList(),
                ),
                const SizedBox(height: 12),
                if (selectedCategoryId != null)
                  Expanded(
                    child: ref.watch(mealsByCategoryProvider(selectedCategoryId!)).when(
                      data: (meals) => ListView.separated(
                        itemCount: meals.length,
                        separatorBuilder: (_,__) => const SizedBox(height: 8),
                        itemBuilder: (ctx,i) => MealCard(
                          meal: meals[i],
                          onTap: ()=> Navigator.of(context).pushNamed(Routes.mealDetail, arguments: meals[i].id),
                        ),
                      ),
                      loading: ()=> const Center(child: CircularProgressIndicator()),
                      error: (e,_) => const Text('Error loading meals'),
                    ),
                  )
                else
                  const Center(child: Text('No category')),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e,_) => const Text('Error'),
        ),
      ),
    );
  }
}
