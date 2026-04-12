import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../screens/history_screen.dart';

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
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                l10n.caloryCounter,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 32.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
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
                  Navigator.pop(context); // Close the drawer
                  if (!isHistorySelected) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HistoryScreen(),
                      ),
                    );
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
