import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_padding.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_space.dart';
import '../../controllers/theme_controller.dart';

/// Screen for picking color theme palettes managed via GetX.
class ThemeScreen extends StatelessWidget {
  const ThemeScreen({Key? key}) : super(key: key);

  static const List<Map<String, dynamic>> _themeOptions = [
    {'type': AppThemeType.system, 'name': 'System Default', 'color': AppColors.textSubLight},
    {'type': AppThemeType.light, 'name': 'Light (Green)', 'color': AppColors.primary},
    {'type': AppThemeType.dark, 'name': 'Dark (Teal)', 'color': AppColors.primaryDark},
    {'type': AppThemeType.mint, 'name': 'Mint Pastel', 'color': AppColors.mintPrimary},
    {'type': AppThemeType.berry, 'name': 'Berry Pink', 'color': AppColors.berryPrimary},
    {'type': AppThemeType.sunset, 'name': 'Sunset Orange', 'color': AppColors.sunsetPrimary},
    {'type': AppThemeType.ocean, 'name': 'Ocean Blue', 'color': AppColors.oceanPrimary},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = Get.find<ThemeController>();
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(loc.theme, style: theme.textTheme.headlineMedium),
        backgroundColor: AppColors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: SafeArea(
        child: Obx(() {
          final currentThemeType = themeController.themeType;

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: AppPadding.padding24, vertical: AppPadding.padding16),
            itemCount: _themeOptions.length,
            itemBuilder: (context, index) {
              final option = _themeOptions[index];
              final type = option['type'] as AppThemeType;
              final name = option['name'] as String;
              final color = option['color'] as Color;
              final isSelected = currentThemeType == type;

              return GestureDetector(
                onTap: () {
                  themeController.setThemeType(type);
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
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.1),
                              width: 1),
                        ),
                      ),
                      const HSpace16(),
                      Expanded(
                        child: Text(
                          name,
                          style: theme.textTheme.titleMedium!.copyWith(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                      Radio<AppThemeType>(
                        value: type,
                        groupValue: currentThemeType,
                        activeColor: theme.colorScheme.primary,
                        onChanged: (value) {
                          if (value != null) {
                            themeController.setThemeType(value);
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
