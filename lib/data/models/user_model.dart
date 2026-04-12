class UserModel {
  final String gender;
  final DateTime birthDate;
  final double weight;
  final double height;

  const UserModel({
    required this.gender,
    required this.birthDate,
    required this.weight,
    required this.height,
  });

  Map<String, dynamic> toMap() {
    return {
      'gender': gender,
      'birthDate': birthDate.toIso8601String(),
      'weight': weight,
      'height': height,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      gender: map['gender'] as String,
      birthDate: DateTime.parse(map['birthDate'] as String),
      weight: (map['weight'] as num).toDouble(),
      height: (map['height'] as num).toDouble(),
    );
  }
}
