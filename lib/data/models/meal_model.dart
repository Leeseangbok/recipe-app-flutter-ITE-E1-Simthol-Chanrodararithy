class Meal {
  final String id;
  final String name;
  final String drinkAlternate;
  final String category;
  final String area;
  final String instructions;
  final String image;
  final String tags;
  final String youtube;
  final List<String> ingredients;

  Meal({
    required this.id,
    required this.name,
    required this.drinkAlternate,
    required this.category,
    required this.area,
    required this.instructions,
    required this.image,
    required this.tags,
    required this.youtube,
    required this.ingredients,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      name: json['meal'],
      drinkAlternate: json['drinkAlternate'],
      category: json['category'],
      area: json['area'],
      instructions: json['instructions'],
      image: json['mealThumb'],
      tags: json['tags'],
      youtube: json['youtube'],
      ingredients: List<String>.from(json['ingredients']),
    );
  }
}
