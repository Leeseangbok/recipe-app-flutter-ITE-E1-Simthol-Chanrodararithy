import 'dart:convert';

class Ingredient {
  final String ingredient;
  final String measure;

  Ingredient({required this.ingredient, required this.measure});

  factory Ingredient.fromJson(Map<String, dynamic> j) => Ingredient(
    ingredient: j['ingredient'] ?? '',
    measure: j['measure'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'ingredient': ingredient,
    'measure': measure,
  };
}

class Meal {
  final String id;
  final String meal;
  final String? drinkAlternate;
  final String? category;
  final String? area;
  final String? instructions;
  final String? mealThumb;
  final String? tags;
  final String? youtube;
  final String? source;
  final List<Ingredient> ingredients;
  final String? categoryId;

  Meal({
    required this.id,
    required this.meal,
    this.drinkAlternate,
    this.category,
    this.area,
    this.instructions,
    this.mealThumb,
    this.tags,
    this.youtube,
    this.source,
    required this.ingredients,
    this.categoryId,
  });

  factory Meal.fromJson(Map<String, dynamic> j) {
    var ing = <Ingredient>[];
    if (j['ingredients'] != null) {
      try {
        ing = List.from(j['ingredients']).map((e) => Ingredient.fromJson(Map<String,dynamic>.from(e))).toList();
      } catch (_) {
        ing = [];
      }
    }
    return Meal(
      id: j['id'].toString(),
      meal: j['meal'] ?? '',
      drinkAlternate: j['drinkAlternate'],
      category: j['category'],
      area: j['area'],
      instructions: j['instructions'],
      mealThumb: j['mealThumb'],
      tags: j['tags'],
      youtube: j['youtube'],
      source: j['source'],
      ingredients: ing,
      categoryId: j['categoryId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'meal': meal,
    'drinkAlternate': drinkAlternate,
    'category': category,
    'area': area,
    'instructions': instructions,
    'mealThumb': mealThumb,
    'tags': tags,
    'youtube': youtube,
    'source': source,
    'ingredients': ingredients.map((e) => e.toJson()).toList(),
    'categoryId': categoryId,
  };

  String toRawJson() => json.encode(toJson());

  factory Meal.fromRawJson(String s) => Meal.fromJson(json.decode(s));
}
