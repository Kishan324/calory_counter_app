import 'package:get/get.dart';

import '../../data/services/api_service.dart';
import '../../data/repositories/food_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/profile_repository.dart';

import '../../controllers/theme_controller.dart';
import '../../controllers/locale_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/food_controller.dart';
import '../../controllers/history_controller.dart';
import '../../controllers/date_controller.dart';
import '../../controllers/analytics_controller.dart';

/// Global initial dependency binding for production-ready GetX architecture.
class InitialBinding extends Bindings {
  final String? savedTheme;

  InitialBinding({this.savedTheme});

  @override
  void dependencies() {
    // Services & Repositories
    final apiService = Get.put(ApiService(), permanent: true);
    final foodRepository = Get.put(FoodRepository(apiService), permanent: true);
    final authRepository = Get.put(AuthRepository(apiService), permanent: true);
    final profileRepository = Get.put(ProfileRepository(apiService), permanent: true);

    // Global Production Controllers
    Get.put(ThemeController(initialTheme: savedTheme), permanent: true);
    Get.put(LocaleController(), permanent: true);
    Get.put(AuthController(authRepository), permanent: true);
    Get.put(ProfileController(profileRepository), permanent: true);
    Get.put(FoodController(foodRepository), permanent: true);
    Get.put(HistoryController(apiService), permanent: true);
    Get.put(DateController(), permanent: true);
    Get.put(AnalyticsController(), permanent: true);
  }
}
