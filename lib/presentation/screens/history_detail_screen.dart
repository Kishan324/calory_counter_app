import 'package:flutter/material.dart';
import '../../data/models/history_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_padding.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_space.dart';

/// Detailed view for an individual food consumption log entry.
class HistoryDetailScreen extends StatelessWidget {
  final HistoryModel item;

  const HistoryDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    String dateStr = "N/A";
    if (item.createdAt != null) {
      dateStr = DateFormat.yMMMMd(
        Localizations.localeOf(context).languageCode,
      ).format(item.createdAt!);
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        title: const SizedBox(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'history_image_${item.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(AppRadius.radius28),
                      bottomRight: Radius.circular(AppRadius.radius28),
                    ),
                    child: Image.network(
                      item.imageUrl,
                      height: 320.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;

                        return Container(
                          height: 320.h,
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => Container(
                        height: 320.h,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.fastfood,
                          size: 80.sp,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(AppRadius.radius28),
                        bottomRight: Radius.circular(AppRadius.radius28),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.black.withOpacity(0.05),
                          AppColors.black.withOpacity(0.4),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20.h,
                  left: 20.w,
                  right: 20.w,
                  child: Text(
                    item.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: AppPadding.all24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppPadding.padding16,
                      vertical: AppPadding.padding12,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: AppRadius.border16,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_fire_department_rounded,
                          color: theme.colorScheme.primary,
                          size: 24.sp,
                        ),
                        const HSpace8(),
                        Text(
                          '${item.calories} ${l10n?.kcal ?? "kcal"}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const VSpace32(),
                  Text(
                    "Log Report",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const VSpace16(),
                  Container(
                    padding: AppPadding.all20,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: AppRadius.border24,
                      boxShadow: AppShadows.cardSubtle(isDark),
                    ),
                    child: Column(
                      children: [
                        _buildStatRow("Date Logged", dateStr, theme),
                        Divider(
                          height: 24.h,
                          color: theme.colorScheme.outline.withOpacity(0.1),
                        ),
                        _buildStatRow(
                          "Food Entry ID",
                          "#${item.id.toString().padLeft(4, '0')}",
                          theme,
                        ),
                        Divider(
                          height: 24.h,
                          color: theme.colorScheme.outline.withOpacity(0.1),
                        ),
                        _buildStatRow(
                          "Source",
                          "Application Log",
                          theme,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
