import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_padding.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_space.dart';
import '../widgets/app_back_button.dart';
import '../../controllers/theme_controller.dart';

/// Screen allowing user theme selection with immediate GetX reactive switching.
class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  static const List<Map<String, dynamic>> _themeOptions = [
    {'type': AppThemeType.system, 'name': 'System Default', 'color': Color(0xFF64748B)},
    {'type': AppThemeType.light, 'name': 'Light (Green)', 'color': Color(0xFF10B981)},
    {'type': AppThemeType.dark, 'name': 'Dark (Teal)', 'color': Color(0xFF0EA5E9)},
    {'type': AppThemeType.mint, 'name': 'Mint Pastel', 'color': Color(0xFF059669)},
    {'type': AppThemeType.berry, 'name': 'Berry Pink', 'color': Color(0xFFEC4899)},
    {'type': AppThemeType.sunset, 'name': 'Sunset Orange', 'color': Color(0xFFF97316)},
    {'type': AppThemeType.ocean, 'name': 'Ocean Blue', 'color': Color(0xFF2563EB)},
  ];

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(loc.theme, style: theme.textTheme.headlineMedium),
        backgroundColor: AppColors.transparent,
        elevation: 0,
        centerTitle: false,
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
                          : theme.colorScheme.onSurface.withValues(alpha: 0.05),
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
                                  theme.colorScheme.onSurface.withValues(alpha: 0.1),
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
