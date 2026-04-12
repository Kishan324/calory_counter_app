import 'package:flutter/material.dart';
import '../../data/models/history_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class HistoryDetailScreen extends StatelessWidget {
  final HistoryModel item;

  const HistoryDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    // Format date
    String dateStr = "N/A";
    if (item.createdAt != null) {
      dateStr = DateFormat.yMMMMd(
        Localizations.localeOf(context).languageCode,
      ).format(item.createdAt!);
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      /// ❌ Removed title from AppBar (we show it on image)
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const SizedBox(),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// 🔥 PREMIUM IMAGE HEADER
            Stack(
              children: [
                /// IMAGE
                Hero(
                  tag: 'history_image_${item.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28.r),
                      bottomRight: Radius.circular(28.r),
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

                /// GRADIENT OVERLAY
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(28.r),
                        bottomRight: Radius.circular(28.r),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.05),
                          Colors.black.withOpacity(0.4),
                        ],
                      ),
                    ),
                  ),
                ),

                /// BACK BUTTON
                // Positioned(
                //   top: 40.h,
                //   left: 16.w,
                //   child: InkWell(
                //     onTap: () => Navigator.pop(context),
                //     borderRadius: BorderRadius.circular(50),
                //     child: Container(
                //       padding: EdgeInsets.all(8.w),
                //       decoration: BoxDecoration(
                //         color: Colors.black.withOpacity(0.3),
                //         shape: BoxShape.circle,
                //       ),
                //       child: Icon(
                //         Icons.arrow_back,
                //         color: Colors.white,
                //         size: 20.sp,
                //       ),
                //     ),
                //   ),
                // ),

                /// TITLE ON IMAGE
                Positioned(
                  bottom: 20.h,
                  left: 20.w,
                  right: 20.w,
                  child: Text(
                    item.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            /// 🔽 DETAILS SECTION
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// CALORIES CARD
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_fire_department_rounded,
                          color: theme.colorScheme.primary,
                          size: 24.sp,
                        ),
                        SizedBox(width: 8.w),
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

                  SizedBox(height: 32.h),

                  /// LOG REPORT TITLE
                  Text(
                    "Log Report",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  /// LOG DETAILS CARD
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withOpacity(0.2)
                              : Colors.black.withOpacity(0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
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
