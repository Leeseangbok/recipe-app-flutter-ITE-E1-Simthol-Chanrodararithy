import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';

class FavoriteEntry {
  final String id;
  final String name;
  final String image;
  final String category;
  final String area;

  FavoriteEntry({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.area,
  });

  Map<String, String> toMap() => {
    'id': id,
    'name': name,
    'image': image,
    'category': category,
    'area': area,
  };

  static FavoriteEntry fromMap(Map<String, String> map) => FavoriteEntry(
    id: map['id'] as String,
    name: map['name'] as String,
    image: map['image'] as String,
    category: map['category'] as String,
    area: map['area'] as String,
  );
}

class FavoriteNotifier extends StateNotifier<List<FavoriteEntry>> {
  FavoriteNotifier() : super([]) {
    _load();
  }

  Box get _box => Hive.box('favorites');

  void _load() {
    final raw = _box.get('favorites', defaultValue: <Map<String, String>>[]);
    final list = (raw is List ? raw : <Map<String, String>>[])
        .cast<Map<String, String>>()
        .map(FavoriteEntry.fromMap)
        .toList();
    state = list;
  }
  void _save() {
    _box.put('favorites', state.map((e) => e.toMap()).toList());
  }

  bool isFavorite(String id) => state.any((e) => e.id == id);

  void toggle({
    required String id,
    required String name,
    required String image,
    required String category,
    required String area,
  }) {
    if (isFavorite(id)) {
      state = state.where((e) => e.id != id).toList();
    } else {
      state = [
        ...state,
        FavoriteEntry(id: id, name: name, image: image, category: category, area: area),
      ];
    }
    _save();
  }
}

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, List<FavoriteEntry>>((ref) => FavoriteNotifier());