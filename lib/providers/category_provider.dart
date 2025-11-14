import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/category_model.dart';
import '../data/services/api_service.dart';

final categoryProvider = FutureProvider<List<Category>>((ref) async {
  final api = ApiService();
  final data = await api.fetchCategories();
  return data.map<Category>((json) => Category.fromJson(json)).toList();
});