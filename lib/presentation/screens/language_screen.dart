import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_padding.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../controllers/locale_controller.dart';

/// Screen for changing active app localization language using GetX.
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  static const List<Map<String, String>> _supportedLanguages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'ar', 'name': 'العربية (Arabic)'},
    {'code': 'de', 'name': 'Deutsch (German)'},
    {'code': 'hi', 'name': 'हिंदी (Hindi)'},
    {'code': 'gu', 'name': 'ગુજરાતી (Gujarati)'},
    {'code': 'es', 'name': 'Español (Spanish)'},
    {'code': 'fr', 'name': 'Français (French)'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localeController = Get.find<LocaleController>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.languageSelection,
            style: theme.textTheme.headlineMedium),
        backgroundColor: AppColors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: SafeArea(
        child: Obx(() {
          final currentLanguageCode = localeController.locale.languageCode;

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: AppPadding.padding24, vertical: AppPadding.padding16),
            itemCount: _supportedLanguages.length,
            itemBuilder: (context, index) {
              final lang = _supportedLanguages[index];
              final isSelected = currentLanguageCode == lang['code'];

              return GestureDetector(
                onTap: () {
                  localeController.setLocale(Locale(lang['code']!));
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  margin: EdgeInsets.only(bottom: AppPadding.padding12),
                  padding:
                      EdgeInsets.symmetric(horizontal: AppPadding.padding20, vertical: AppPadding.padding16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: AppRadius.border16,
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withOpacity(0.05),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: AppShadows.cardSubtle(theme.brightness == Brightness.dark),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lang['name']!,
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                      Radio<String>(
                        value: lang['code']!,
                        groupValue: currentLanguageCode,
                        activeColor: theme.colorScheme.primary,
                        onChanged: (value) {
                          if (value != null) {
                            localeController.setLocale(Locale(value));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
