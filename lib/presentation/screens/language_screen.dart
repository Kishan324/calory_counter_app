import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../providers/locale_provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  static const List<Map<String, String>> _supportedLanguages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'hi', 'name': 'हिंदी'},
    {'code': 'gu', 'name': 'ગુજરાતી'},
    {'code': 'es', 'name': 'Español (Spanish)'},
    {'code': 'fr', 'name': 'Français (French)'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localeProvider = context.watch<LocaleProvider>();
    final currentLanguageCode = localeProvider.locale.languageCode;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.languageSelection, style: theme.textTheme.headlineMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: SafeArea(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          itemCount: _supportedLanguages.length,
          itemBuilder: (context, index) {
            final lang = _supportedLanguages[index];
            final isSelected = currentLanguageCode == lang['code'];

            return GestureDetector(
              onTap: () {
                localeProvider.setLocale(Locale(lang['code']!));
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lang['name']!,
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    Radio<String>(
                      value: lang['code']!,
                      groupValue: currentLanguageCode,
                      activeColor: theme.colorScheme.primary,
                      onChanged: (value) {
                        if (value != null) {
                          localeProvider.setLocale(Locale(value));
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
