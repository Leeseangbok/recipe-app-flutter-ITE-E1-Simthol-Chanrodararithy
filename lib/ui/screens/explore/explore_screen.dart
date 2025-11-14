import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/meal_provider.dart';
import '../../../providers/category_provider.dart';
import '../../widgets/meal_card.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  String? selectedCategory;
  String search = '';

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryProvider);
    final mealsAsync = ref.watch(mealProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by name…',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => search = v.trim().toLowerCase()),
            ),
          ),
          categoriesAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(12),
              child: LinearProgressIndicator(),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(12),
              child: Text('Categories error: $e'),
            ),
            data: (cats) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: selectedCategory == null,
                    onSelected: (_) => setState(() => selectedCategory = null),
                  ),
                  const SizedBox(width: 8),
                  ...cats.map((c) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: ChoiceChip(
                          label: Text(c.name),
                          selected: selectedCategory == c.name,
                          onSelected: (_) => setState(() => selectedCategory = c.name),
                        ),
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: mealsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Meals error: $e')),
              data: (meals) {
                final filtered = meals.where((m) {
                  final matchesCategory = selectedCategory == null || m.category == selectedCategory;
                  final matchesSearch = search.isEmpty || m.name.toLowerCase().contains(search);
                  return matchesCategory && matchesSearch;
                }).toList();
                if (filtered.isEmpty) {
                  return const Center(child: Text('No meals found'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) => MealCard(meal: filtered[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}