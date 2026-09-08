import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/theme/app_padding.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_space.dart';
import '../screens/history_screen.dart';

/// Navigation drawer for quick access to history records.
class AppDrawer extends StatelessWidget {
  final bool isHistorySelected;

  const AppDrawer({super.key, this.isHistorySelected = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const VSpace24(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.padding24),
              child: Text(
                l10n.caloryCounter,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const VSpace32(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.padding12),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.border12,
                ),
                leading: Icon(
                  Icons.history_rounded,
                  color: isHistorySelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                ),
                title: Text(
                  l10n.history,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isHistorySelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                    fontWeight: isHistorySelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                selected: isHistorySelected,
                selectedTileColor: theme.colorScheme.primary.withOpacity(0.1),
                onTap: () {
                  Get.back();
                  if (!isHistorySelected) {
                    Get.to(() => const HistoryScreen());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
