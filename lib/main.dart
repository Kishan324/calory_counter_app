import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/services/api_service.dart';
import 'data/repositories/food_repository.dart';
import 'providers/food_provider.dart';
import 'providers/date_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/onboarding_provider.dart';
import 'providers/auth_provider.dart';
import 'data/repositories/auth_repository.dart';
import 'providers/history_provider.dart';
import 'presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final savedTheme = prefs.getString('appThemeType');

  final apiService = ApiService();
  final foodRepository = FoodRepository(apiService);
  final authRepository = AuthRepository(apiService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FoodProvider(foodRepository)),
        ChangeNotifierProvider(create: (_) => DateProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider(initialTheme: savedTheme)),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepository)),
        ChangeNotifierProvider(create: (_) => HistoryProvider(apiService)),
      ],
      child: MyApp(savedTheme: savedTheme),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? savedTheme;
  const MyApp({super.key, this.savedTheme});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, themeProvider, localeProvider, child) {
        return ScreenUtilInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Calorie Counter',
              theme: themeProvider.themeData,
              darkTheme: themeProvider.darkThemeData,
              themeMode: themeProvider.themeMode,
              locale: localeProvider.locale,
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
      },
    );
  }
}
