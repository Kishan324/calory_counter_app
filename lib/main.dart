import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/bindings/initial_binding.dart';
import 'core/constants/app_storage_keys.dart';
import 'core/theme/app_theme.dart';
import 'controllers/theme_controller.dart';
import 'controllers/locale_controller.dart';
import 'presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final savedTheme = prefs.getString(AppStorageKeys.appThemeType);

  runApp(MyApp(savedTheme: savedTheme));
}

class MyApp extends StatelessWidget {
  final String? savedTheme;
  const MyApp({super.key, this.savedTheme});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Calorie Counter',
          defaultTransition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 320),
          initialBinding: InitialBinding(savedTheme: savedTheme),
          builder: (context, widget) {
            return Obx(() {
              final themeController = Get.find<ThemeController>();
              final localeController = Get.find<LocaleController>();

              return Theme(
                data: themeController.themeData,
                child: Localizations.override(
                  context: context,
                  locale: localeController.locale,
                  child: widget ?? const SizedBox.shrink(),
                ),
              );
            });
          },
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SplashScreen(),
        );
      },
    );
  }
}
