// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_finder_flutter_application/data/providers/providers.dart';
import 'package:recipe_finder_flutter_application/domain/presentation/screens/detail/meal_detail_screen.dart';
import 'package:recipe_finder_flutter_application/domain/presentation/screens/explore/explore_screen.dart';
import 'package:recipe_finder_flutter_application/domain/presentation/screens/favorite/favorite_screen.dart';
import 'package:recipe_finder_flutter_application/domain/presentation/screens/home/home_screen.dart';
import 'package:recipe_finder_flutter_application/domain/presentation/screens/list/meal_list_screen.dart';
import 'package:recipe_finder_flutter_application/domain/presentation/screens/onboarding/onboarding_screen.dart';
import 'routes.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingAsync = ref.watch(onboardingCompleteProvider);

    return MaterialApp(
      title: 'Recipe Finder',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      routes: {
        Routes.onboarding: (ctx) {
          return onboardingAsync.when(
            data: (done) => done ? const HomeShell() : const OnboardingScreen(),
            loading: ()=> const Scaffold(body: Center(child: CircularProgressIndicator())),
            error: (e,_) => const OnboardingScreen(),
          );
        },
        Routes.home: (ctx) => const HomeShell(),
        Routes.explore: (ctx) => const ExploreScreen(),
        Routes.favourites: (ctx) => const FavoritesScreen(),
        Routes.mealDetail: (ctx) => const MealDetailScreen(),
        Routes.mealList: (ctx) => const MealListScreen(),
      },
      initialRoute: Routes.onboarding,
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final pages = const [
    null,
    null,
    null,
  ];

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_index == 0) {
      body = const HomeScreen();
    } else if (_index == 1) {
      body = const ExploreScreen();
    } else {
      body = const FavoritesScreen();
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(()=> _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favourite'),
        ],
      ),
    );
  }
}
