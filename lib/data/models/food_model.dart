class FoodModel {
  final String id;
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fats;

  FoodModel({
    required this.id,
    required this.name,
    required this.calories,
    this.protein = 0.0,
    this.carbs = 0.0,
    this.fats = 0.0,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      calories: json['calories'] ?? 0,
      protein: (json['protein'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      fats: (json['fats'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
    };
  }
}
