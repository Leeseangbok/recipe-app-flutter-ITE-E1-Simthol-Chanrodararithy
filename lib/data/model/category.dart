class Category {
  final String id;
  final String name;
  final String image;
  final String description;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ?? json['idCategory']?.toString() ?? '',
      name: json['name'] ?? json['strCategory'] ?? json['category'] ?? '',
      image: json['image'] ?? json['strCategoryThumb'] ?? json['categoryThumb'] ?? '',
      description: json['description'] ?? json['strCategoryDescription'] ?? json['categoryDescription'] ?? '',
    );
  }
}