import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/favorite_provider.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favs = ref.watch(favoriteProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: favs.isEmpty
          ? const Center(child: Text('No favourites yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favs.length,
              itemBuilder: (_, i) {
                final f = favs[i];
                return Card(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(f.image, width: 56, height: 56, fit: BoxFit.cover),
                    ),
                    title: Text(f.name),
                    subtitle: Text('${f.category} · ${f.area}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        ref.read(favoriteProvider.notifier).toggle(
                              id: f.id,
                              name: f.name,
                              image: f.image,
                              category: f.category,
                              area: f.area,
                            );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}