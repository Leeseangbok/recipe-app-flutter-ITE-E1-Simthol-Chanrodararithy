import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_finder_flutter_app/data/provider/category_provider.dart';
import 'package:recipe_finder_flutter_app/data/provider/meal_provider.dart';
import 'package:recipe_finder_flutter_app/features/screens/detail/meal_detail_screen.dart';
import 'package:recipe_finder_flutter_app/features/screens/explore/widgets/empty.dart';
import 'package:recipe_finder_flutter_app/features/screens/explore/widgets/filtered_chip.dart';
import 'package:recipe_finder_flutter_app/features/screens/explore/widgets/meta_chip.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryProvider);
    final areasAsync = ref.watch(areaProvider);
    final mealsAsync = ref.watch(filteredMealProvider);
    
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final selectedArea = ref.watch(selectedAreaProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    if (_searchController.text != searchQuery) {
      _searchController.text = searchQuery;
      _searchController.selection = TextSelection.fromPosition(
          TextPosition(offset: _searchController.text.length));
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Explore', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          if (selectedCategory != 'All' || selectedArea != 'All' || searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.filter_alt_off),
              tooltip: 'Clear Filters',
              onPressed: () {
                ref.read(selectedCategoryProvider.notifier).state = 'All';
                ref.read(selectedAreaProvider.notifier).state = 'All';
                ref.read(searchQueryProvider.notifier).state = '';
                _searchController.clear();
              },
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
              decoration: InputDecoration(
                hintText: 'Search for recipes...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16, top: 10, bottom: 5),
                  child: Text("Category", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                ),
                SizedBox(
                  height: 40,
                  child: categoriesAsync.when(
                    data: (categories) {
                      final allCats = ['All', ...categories];
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: allCats.length,
                        separatorBuilder: (_,__) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final cat = allCats[index];
                          final isSelected = selectedCategory == cat;
                          return buildFilterChip(
                            label: cat,
                            isSelected: isSelected,
                            onTap: () {
                              ref.read(selectedCategoryProvider.notifier).state = cat;
                            },
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: SizedBox()),
                    error: (e, _) => const SizedBox(),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(left: 16, top: 10, bottom: 5),
                  child: Text("Cuisine", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                ),
                SizedBox(
                  height: 40,
                  child: areasAsync.when(
                    data: (areas) {
                      final allAreas = ['All', ...areas];
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: allAreas.length,
                        separatorBuilder: (_,__) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final area = allAreas[index];
                          final isSelected = selectedArea == area;
                          return buildFilterChip(
                            label: area,
                            isSelected: isSelected,
                            onTap: () {
                              ref.read(selectedAreaProvider.notifier).state = area;
                            },
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: SizedBox()),
                    error: (e, _) => const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),

          Expanded(
            child: mealsAsync.when(
              data: (meals) {
                if (meals.isEmpty) return buildEmptyState();
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    final meal = meals[index];
                    final displayCategory = (selectedCategory != 'All') 
                        ? selectedCategory 
                        : (meal.category);

                    final displayArea = (selectedArea != 'All') 
                        ? selectedArea 
                        : (meal.area);

                    return GestureDetector(
                      onTap: () {
                        ref.read(selectedMealIdProvider.notifier).state = meal.id;
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const MealDetailScreen()));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade100,
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 3), 
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Hero(
                              tag: 'meal_${meal.id}',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  meal.mealThumb,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_,__,___) => Container(
                                    width: 90, height: 90, 
                                    color: Colors.grey[200], 
                                    child: const Icon(Icons.broken_image, color: Colors.grey)
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Meal Name
                                  Text(
                                    meal.meal,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      buildMetaChip(
                                        label: displayCategory,
                                        bgColor: Colors.orange.shade50,
                                        textColor: Colors.orange.shade800,
                                      ),
                                      buildMetaChip(
                                        label: displayArea,
                                        bgColor: Colors.blueGrey.shade50,
                                        textColor: Colors.blueGrey.shade700,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error: $e")),
            ),
          ),
        ],
      ),
    );
  }
}