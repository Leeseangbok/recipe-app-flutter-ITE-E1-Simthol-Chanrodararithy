import 'package:flutter/material.dart';
import 'package:recipe_finder_flutter_app/features/screens/onboarding/onboarding_screen.dart';
import 'package:recipe_finder_flutter_app/features/widgets/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late Future<bool> _isOnboardingComplete;
  
  @override
  void initState() {
    super.initState();
    _isOnboardingComplete = _checkOnboardingComplete();
  }

  Future<bool> _checkOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('seenOnboarding'); 
    return prefs.getBool('seenOnboarding') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isOnboardingComplete,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          if (snapshot.data == true) {
            return const MainNavigationScreen();
          } else {
            return const OnboardingScreen();
          }
        }
      },
    );
  }
}