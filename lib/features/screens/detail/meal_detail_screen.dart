import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_finder_flutter_app/data/provider/meal_provider.dart';
import 'package:recipe_finder_flutter_app/data/provider/favorite_provider.dart';
import 'package:recipe_finder_flutter_app/features/screens/detail/widgets/helper_chip.dart';
import 'package:recipe_finder_flutter_app/features/screens/explore/explore_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MealDetailScreen extends ConsumerWidget {
  const MealDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealDetailAsync = ref.watch(mealDetailsProvider);
    final favoriteMeals = ref.watch(favoriteListProvider);

    return mealDetailAsync.when(
      data: (meal) {
        final isFavorite = favoriteMeals.any((element) => element.id == meal.id);

        return Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            elevation: 4,
            onPressed: () {
              ref.read(favoriteListProvider.notifier).toggleFavorite(meal);
            },
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.black,
            ),
          ),
          
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'meal_${meal.id}',
                        child: Image.network(
                          meal.mealThumb,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => Container(color: Colors.grey[300]),
                        ),
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black26],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  transform: Matrix4.translationValues(0, -20, 0), 
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40, height: 4,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ),

                      Text(
                        meal.meal,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          buildInteractiveChip(
                            context, ref, 
                            label: meal.category, 
                            icon: Icons.restaurant_menu,
                            color: Colors.orange,
                            onTap: () {
                              ref.read(selectedCategoryProvider.notifier).state = meal.category;
                              ref.read(selectedAreaProvider.notifier).state = 'All';
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const ExploreScreen()));
                            }
                          ),
                          const SizedBox(width: 10),
                          buildInteractiveChip(
                            context, ref, 
                            label: meal.area, 
                            icon: Icons.public,
                            color: Colors.blueGrey,
                            onTap: () {
                              ref.read(selectedAreaProvider.notifier).state = meal.area;
                              ref.read(selectedCategoryProvider.notifier).state = 'All';
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const ExploreScreen()));
                            }
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        "Ingredients",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          children: meal.ingredients.map((ing) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  const Icon(Icons.circle, size: 8, color: Colors.orange),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      ing.ingredient,
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Text(
                                    ing.measure,
                                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        "Instructions",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        meal.instructions,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.grey[800],
                        ),
                      ),

                      const SizedBox(height: 30),

                      if (meal.youtube.isNotEmpty)
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton.icon(
                            onPressed: () => _launchUrl(meal.youtube),
                            icon: const Icon(Icons.play_circle_fill, color: Colors.white),
                            label: const Text("Watch Tutorial", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}