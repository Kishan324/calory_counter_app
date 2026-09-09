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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        final rawMedia = MediaQuery.of(context);

        final targetWidth = isWide ? 420.0 : constraints.maxWidth;
        final targetHeight = isWide
            ? constraints.maxHeight.clamp(650.0, 900.0)
            : constraints.maxHeight;

        final clampedMedia = rawMedia.copyWith(
          size: Size(targetWidth, targetHeight),
          textScaler: const TextScaler.linear(1.0),
        );

        return MediaQuery(
          data: clampedMedia,
          child: ScreenUtilInit(
            designSize: const Size(390, 844),
            minTextAdapt: true,
            splitScreenMode: false,
            useInheritedMediaQuery: true,
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
                    final childWidget = widget ?? const SizedBox.shrink();

                    final appWidget = Theme(
                      data: themeController.themeData,
                      child: Localizations.override(
                        context: context,
                        locale: localeController.locale,
                        child: GestureDetector(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          behavior: HitTestBehavior.translucent,
                          child: childWidget,
                        ),
                      ),
                    );

                    if (isWide) {
                      final isDark = themeController.isDarkMode;
                      return Container(
                        color: isDark
                            ? const Color(0xFF0F172A)
                            : const Color(0xFFE2E8F0),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: targetWidth,
                              maxHeight: targetHeight,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withValues(alpha: 0.25),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: MediaQuery(
                                  data: clampedMedia,
                                  child: appWidget,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    return MediaQuery(
                      data: clampedMedia,
                      child: appWidget,
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
          ),
        );
      },
    );
  }
}
