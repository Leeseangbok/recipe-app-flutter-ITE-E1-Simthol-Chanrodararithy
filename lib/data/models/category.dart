class Category {
  final String id;
  final String category;
  final String? categoryThumb;
  final String? categoryDescription;

  Category({
    required this.id,
    required this.category,
    this.categoryThumb,
    this.categoryDescription,
  });

  factory Category.fromJson(Map<String, dynamic> j) => Category(
    id: j['id'].toString(),
    category: j['category'] ?? '',
    categoryThumb: j['categoryThumb'],
    categoryDescription: j['categoryDescription'],
  );
}
