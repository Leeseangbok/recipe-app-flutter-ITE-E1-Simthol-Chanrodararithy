import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/providers/providers.dart';
import '../../../../config/routes.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  void _complete(WidgetRef ref, BuildContext ctx) async {
    final setter = ref.read(setOnboardingCompleteProvider);
    await setter(true);
    Navigator.of(ctx).pushReplacementNamed(Routes.home);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: PageView(
              children: [
                _page('Find recipes', 'Browse popular meals and categories.'),
                _page('Get inspired', 'Random suggestions when you can\'t decide.'),
                _page('Save favourites', 'Save recipes locally to view offline.'),
              ],
            )),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: () => _complete(ref, context),
                child: const Text('Get Started'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _page(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.restaurant_menu, size: 96),
          const SizedBox(height: 24),
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(desc, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
