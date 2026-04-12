class HistoryModel {
  final int id;
  final String imageUrl;
  final String name;
  final int calories;
  final DateTime? createdAt;

  HistoryModel({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.calories,
    this.createdAt,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
      name: json['name'] ?? 'Unknown',
      calories: json['calories'] is int ? json['calories'] : int.tryParse(json['calories'].toString()) ?? 0,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : (json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'name': name,
      'calories': calories,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
