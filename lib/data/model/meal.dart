class Ingredient {
  final String ingredient;
  final String measure;

  Ingredient({required this.ingredient, required this.measure});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      ingredient: json['ingredient'] ?? json['strIngredient'] ?? '',
      measure: json['measure'] ?? json['strMeasure'] ?? '',
    );
  }
}

class Meal {
  final String id;
  final String meal;
  final String category;
  final String area;
  final String instructions;
  final String mealThumb;
  final String tags;
  final String youtube;
  final String categoryId;
  final List<Ingredient> ingredients;
  final String? strCategory;
  final String? strArea;

  Meal({
    required this.id,
    required this.meal,
    required this.category,
    required this.area,
    required this.instructions,
    required this.mealThumb,
    required this.tags,
    required this.youtube,
    required this.categoryId,
    required this.ingredients,
    this.strCategory,
    this.strArea,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id']?.toString() ?? json['idMeal']?.toString() ?? '',
      meal: json['meal'] ?? json['strMeal'] ?? '',
      category: json['category'] ?? json['strCategory'] ?? '',
      strCategory: json['strCategory'],
      area: json['area'] ?? json['strArea'] ?? '',
      strArea: json['strArea'],
      instructions: json['instructions'] ?? json['strInstructions'] ?? '',
      mealThumb: json['mealThumb'] ?? json['strMealThumb'] ?? '',
      tags: json['tags'] ?? json['strTags'] ?? '',
      youtube: json['youtube'] ?? json['strYoutube'] ?? '',
      categoryId: json['categoryId']?.toString() ?? '',
      
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}