import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_finder_flutter_app/data/provider/meal_provider.dart';
import 'package:recipe_finder_flutter_app/data/provider/category_provider.dart';
import 'package:recipe_finder_flutter_app/features/screens/explore/explore_screen.dart';
import 'package:recipe_finder_flutter_app/features/screens/home/widgets/card_skeleton.dart';
import 'package:recipe_finder_flutter_app/features/screens/home/widgets/chip.dart';
import 'package:recipe_finder_flutter_app/features/screens/home/widgets/error.dart';
import 'package:recipe_finder_flutter_app/features/screens/home/widgets/header.dart';
import 'package:recipe_finder_flutter_app/features/screens/home/widgets/hero_card.dart';
import 'package:recipe_finder_flutter_app/features/screens/home/widgets/meal_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final randomMealAsync = ref.watch(mealsRandomProvider);
    final popularMealsAsync = ref.watch(popularMealProvider);
    final categoriesAsync = ref.watch(categoryProvider);
    final areasAsync = ref.watch(areaProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildCustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Daily Suggestion", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: randomMealAsync.when(
                data: (meals) => meals.isNotEmpty
                    ? buildHeroCard(context, ref, meals.first)
                    : const SizedBox(),
                loading: () => buildSkeletonCard(height: 240, width: double.infinity),
                error: (err, _) => buildErrorWidget(err),
              ),
            ),

            const SizedBox(height: 30),

            buildSectionHeader(
              "Popular Now", 
              "See all", 
              onTap: () {
                ref.read(selectedCategoryProvider.notifier).state = 'All';
                ref.read(selectedAreaProvider.notifier).state = 'All';
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const ExploreScreen())
                );
              }
            ),
            Container(
              height: 240,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: popularMealsAsync.when(
                data: (meals) => ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: meals.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 15),
                  itemBuilder: (context, index) => buildVerticalMealCard(context, ref, meals[index]),
                ),
                loading: () => ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(width: 15),
                  itemBuilder: (_, __) => buildSkeletonCard(height: 220, width: 160),
                ),
                error: (err, _) => Center(child: Text('Error: $err')),
              ),
            ),

            const SizedBox(height: 25),

            buildSectionHeader("Categories", ""),
            SizedBox(
              height: 55,
              child: categoriesAsync.when(
                data: (cats) => ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: cats.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final imageUrl = "https://www.themealdb.com/images/category/${cats[index]}.png";
                    
                    return buildChip(
                      label: cats[index],
                      imageUrl: imageUrl, 
                      bgColor: Colors.orange.shade50,
                      textColor: Colors.orange.shade900,
                      isCircleImage: false,
                      onTap: () {
                        ref.read(selectedCategoryProvider.notifier).state = cats[index];
                        ref.read(selectedAreaProvider.notifier).state = 'All';
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ExploreScreen()));
                      },
                    );
                  },
                ),
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),
            ),

            const SizedBox(height: 25),

            buildSectionHeader("Cuisines", ""),
            SizedBox(
              height: 50,
              child: areasAsync.when(
                data: (areas) => ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: areas.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final countryCode = _getCountryCode(areas[index]);
                    String? flagUrl;
                    if (countryCode != null) {
                      flagUrl = "https://flagcdn.com/w40/$countryCode.png";
                    }

                    return buildChip(
                      label: areas[index],
                      imageUrl: flagUrl,
                      bgColor: Colors.white,
                      textColor: Colors.blue.shade900,
                      borderColor: Colors.blue.shade100,
                      isCircleImage: true,
                      onTap: () {
                        ref.read(selectedCategoryProvider.notifier).state = 'All';
                        ref.read(selectedAreaProvider.notifier).state = areas[index];
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ExploreScreen()));
                      },
                    );
                  },
                ),
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Good Morning,', style: TextStyle(color: Colors.grey, fontSize: 14)),
          Text('Chef!', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset('assets/images/logo.jpg', height: 40),
          ),
        ),
      ],
    );
  }

  String? _getCountryCode(String areaName) {
    const Map<String, String> areaToCountryCode = {
      'American': 'us',
      'British': 'gb',
      'Canadian': 'ca',
      'Chinese': 'cn',
      'Croatian': 'hr',
      'Dutch': 'nl',
      'Egyptian': 'eg',
      'French': 'fr',
      'Greek': 'gr',
      'Indian': 'in',
      'Irish': 'ie',
      'Italian': 'it',
      'Jamaican': 'jm',
      'Japanese': 'jp',
      'Kenyan': 'ke',
      'Malaysian': 'my',
      'Mexican': 'mx',
      'Moroccan': 'ma',
      'Polish': 'pl',
      'Portuguese': 'pt',
      'Russian': 'ru',
      'Spanish': 'es',
      'Thai': 'th',
      'Tunisian': 'tn',
      'Turkish': 'tr',
      'Unknown': 'un',
      'Vietnamese': 'vn',
    };
    return areaToCountryCode[areaName];
  }
}