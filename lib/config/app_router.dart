import 'package:flutter/material.dart';
import 'package:recipe_finder_flutter_app/data/models/meal_model.dart';
import 'package:recipe_finder_flutter_app/ui/screens/shell/app_shell.dart';
import '../ui/screens/splash/splash_screen.dart';
import '../ui/screens/onboarding/onboarding_screen.dart';
import '../ui/screens/detail/meal_detail_screen.dart';

class AppRouter {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const mealDetail = '/meal-detail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const AppShell());
      case mealDetail:
        final meal = settings.arguments as Meal;
        return MaterialPageRoute(builder: (_) => MealDetailScreen(meal: meal));
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
