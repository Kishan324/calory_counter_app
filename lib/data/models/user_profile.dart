class UserProfile {
  final String? name;
  final String? profileImage;
  final double? weightGoal;
  final int? dailyCalories;
  final DateTime? birthDate;

  UserProfile({
    this.name,
    this.profileImage,
    this.weightGoal,
    this.dailyCalories,
    this.birthDate,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final String? name = data['name'] as String?;

    // Check if there is a nested "profile" map
    final Map<String, dynamic>? profile = data.containsKey('profile') && data['profile'] is Map<String, dynamic>
        ? data['profile'] as Map<String, dynamic>
        : null;

    final String? profileImage = profile != null
        ? profile['profile_image'] as String?
        : data['profile_image'] as String?;

    final dynamic weightGoalRaw = profile != null
        ? profile['weight_goal']
        : data['weight_goal'];

    final dynamic dailyCaloriesRaw = profile != null
        ? profile['daily_calories']
        : data['daily_calories'];

    final dynamic birthDateRaw = profile != null
        ? profile['birth_date']
        : data['birth_date'];

    DateTime? parsedBirthDate;
    if (birthDateRaw != null) {
      parsedBirthDate = DateTime.tryParse(birthDateRaw.toString());
    }

    return UserProfile(
      name: name,
      profileImage: profileImage,
      weightGoal: weightGoalRaw != null ? double.tryParse(weightGoalRaw.toString()) : null,
      dailyCalories: dailyCaloriesRaw != null ? int.tryParse(dailyCaloriesRaw.toString()) : null,
      birthDate: parsedBirthDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'profile_image': profileImage,
      'weight_goal': weightGoal,
      'daily_calories': dailyCalories,
      'birth_date': birthDate?.toIso8601String(),
    };
  }
}
