import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_finder_flutter_app/providers/navigation_provider.dart';
import 'package:recipe_finder_flutter_app/ui/screens/explore/explore_screen.dart';
import 'package:recipe_finder_flutter_app/ui/screens/favorite/favorite_screen.dart';
import 'package:recipe_finder_flutter_app/ui/screens/home/home_screen.dart';


class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navigationProvider);
    final pages = [
      const HomeScreen(),
      const ExploreScreen(),
      const FavoriteScreen(),
    ];

    return Scaffold(
        body: IndexedStack(
          index: index,
          children: pages,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (value) {
            ref.read(navigationProvider.notifier).state = value;
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.search),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
          ],
        ),
    );
  }
}