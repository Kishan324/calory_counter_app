import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../providers/theme_provider.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({Key? key}) : super(key: key);

  static const List<Map<String, dynamic>> _themeOptions = [
    {'type': AppThemeType.system, 'name': 'System Default', 'color': Colors.grey},
    {'type': AppThemeType.light, 'name': 'Light (Green)', 'color': Color(0xFF2E6B4F)},
    {'type': AppThemeType.dark, 'name': 'Dark (Teal)', 'color': Color(0xFF4DB6AC)},
    {'type': AppThemeType.mint, 'name': 'Mint Pastel', 'color': Color(0xFF00BFA5)},
    {'type': AppThemeType.berry, 'name': 'Berry Pink', 'color': Color(0xFFD81B60)},
    {'type': AppThemeType.sunset, 'name': 'Sunset Orange', 'color': Color(0xFFFF6D00)},
    {'type': AppThemeType.ocean, 'name': 'Ocean Blue', 'color': Color(0xFF1976D2)},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = context.watch<ThemeProvider>();
    final currentThemeType = themeProvider.themeType;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(loc.theme, style: theme.textTheme.headlineMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: SafeArea(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          itemCount: _themeOptions.length,
          itemBuilder: (context, index) {
            final option = _themeOptions[index];
            final type = option['type'] as AppThemeType;
            final name = option['name'] as String;
            final color = option['color'] as Color;
            final isSelected = currentThemeType == type;

            return GestureDetector(
              onTap: () {
                themeProvider.setThemeType(type);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.05),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(theme.brightness == Brightness.dark ? 0.2 : 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1), width: 1),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        name,
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                    Radio<AppThemeType>(
                      value: type,
                      groupValue: currentThemeType,
                      activeColor: theme.colorScheme.primary,
                      onChanged: (value) {
                        if (value != null) {
                          themeProvider.setThemeType(value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
