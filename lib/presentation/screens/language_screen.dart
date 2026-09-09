import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_padding.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../widgets/app_back_button.dart';
import '../../controllers/locale_controller.dart';

/// Screen allowing dynamic user language selection from the 7 supported locales.
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  static const List<Map<String, String>> _supportedLanguages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'de', 'name': 'Deutsch (German)'},
    {'code': 'hi', 'name': 'हिंदी (Hindi)'},
    {'code': 'gu', 'name': 'ગુજરાતી (Gujarati)'},
    {'code': 'ar', 'name': 'العربية (Arabic)'},
    {'code': 'fr', 'name': 'Français (French)'},
    {'code': 'es', 'name': 'Español (Spanish)'},
  ];

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(AppLocalizations.of(context)!.languageSelection,
            style: theme.textTheme.headlineMedium),
        backgroundColor: AppColors.transparent,
        elevation: 0,
        centerTitle: false,
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
                          : theme.colorScheme.onSurface.withValues(alpha: 0.05),
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
