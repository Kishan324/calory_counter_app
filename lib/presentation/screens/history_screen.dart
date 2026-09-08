import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_padding.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_space.dart';

import '../../controllers/history_controller.dart';
import '../../data/models/history_model.dart';
import 'history_detail_screen.dart';

/// Historical food log view with date navigation and detailed item cards.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final HistoryController historyController;

  @override
  void initState() {
    super.initState();
    historyController = Get.find<HistoryController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      historyController.fetchHistoryByDate(historyController.selectedDate);
    });
  }

  void _changeDate(int days) {
    final newDate = historyController.selectedDate.add(Duration(days: days));
    historyController.changeDate(newDate);
  }

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return AppLocalizations.of(context)?.historyToday ?? 'Today';
    }
    return DateFormat.yMMMMd(Localizations.localeOf(context).languageCode)
        .format(date);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.history ?? 'History'),
        centerTitle: true,
      ),
      floatingActionButton: Obx(() {
        final isToday = historyController.isSameDay(
            historyController.selectedDate, DateTime.now());

        return AnimatedScale(
          scale: isToday ? 0.0 : 1.0,
          duration: AppDurations.normal,
          curve: Curves.easeOutBack,
          child: FloatingActionButton.extended(
            onPressed: isToday
                ? null
                : () => historyController.changeDate(DateTime.now()),
            backgroundColor: theme.colorScheme.primary,
            elevation: 4,
            icon: Icon(Icons.today_rounded, color: theme.colorScheme.onPrimary),
            label: Text(
              l10n?.historyToday ?? 'Today',
              style: theme.textTheme.labelLarge!.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < -300) {
            if (!historyController.isSameDay(
                historyController.selectedDate, DateTime.now())) {
              _changeDate(1);
            }
          } else if (details.primaryVelocity! > 300) {
            _changeDate(-1);
          }
        },
        child: Column(
          children: [
            _buildDateSelector(context, theme),
            Expanded(
              child: Obx(() {
                if (historyController.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (historyController.filteredHistory.isEmpty) {
                  return _buildEmptyState(
                      context, historyController.selectedDate, theme);
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppPadding.padding16,
                    vertical: AppPadding.padding12,
                  ),
                  itemCount: historyController.filteredHistory.length,
                  separatorBuilder: (context, index) => const VSpace12(),
                  itemBuilder: (context, index) {
                    final item = historyController.filteredHistory[index];
                    return TweenAnimationBuilder<double>(
                      key: ValueKey(item.id),
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(
                          milliseconds: 300 + (index * 50).clamp(0, 300)),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: _buildHistoryItem(item, theme, l10n),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context, ThemeData theme) {
    return Obx(() {
      final selectedDate = historyController.selectedDate;

      return Container(
        padding: EdgeInsets.symmetric(
          vertical: AppPadding.padding14,
          horizontal: AppPadding.padding16,
        ),
        margin: AppPadding.all12,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadius.border20,
          boxShadow: AppShadows.cardSubtle(theme.brightness == Brightness.dark),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => _changeDate(-1),
              icon: const Icon(Icons.chevron_left),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    historyController.changeDate(pickedDate);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today,
                        size: 16.sp, color: theme.colorScheme.primary),
                    const HSpace6(),
                    Text(
                      _formatDate(context, selectedDate),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const HSpace4(),
                    Icon(Icons.keyboard_arrow_down,
                        color: theme.colorScheme.onSurfaceVariant),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: !historyController.isSameDay(
                      selectedDate, DateTime.now())
                  ? () => _changeDate(1)
                  : null,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildEmptyState(
      BuildContext context, DateTime selectedDate, ThemeData theme) {
    final formattedDate = _formatDate(context, selectedDate);
    final emptyText =
        AppLocalizations.of(context)?.noHistoryFound(formattedDate) ??
            "No history found for $formattedDate";

    return Center(
      child: Padding(
        padding: AppPadding.symmetricH32,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_toggle_off_rounded,
              size: 80.sp,
              color: theme.colorScheme.primary.withOpacity(0.35),
            ),
            const VSpace16(),
            Text(
              emptyText,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(
      HistoryModel item, ThemeData theme, AppLocalizations? l10n) {
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: () {
          Get.to(() => HistoryDetailScreen(item: item));
        },
        borderRadius: AppRadius.border20,
        child: Container(
          padding: AppPadding.all12,
          decoration: BoxDecoration(
            borderRadius: AppRadius.border20,
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.08),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.surface,
                theme.colorScheme.surface.withOpacity(isDark ? 0.8 : 0.95),
              ],
            ),
            boxShadow: AppShadows.card(isDark),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: AppRadius.border16,
                child: Hero(
                  tag: 'history_image_${item.id}',
                  child: Image.network(
                    item.imageUrl,
                    width: 68.w,
                    height: 68.w,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 68.w,
                        height: 68.w,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Center(
                          child: SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                              strokeWidth: 2,
                              color: theme.colorScheme.primary.withOpacity(0.5),
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 68.w,
                      height: 68.w,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(Icons.restaurant,
                          color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ),
                ),
              ),
              const HSpace16(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const VSpace8(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppPadding.padding8,
                        vertical: AppPadding.padding4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: AppRadius.border8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_fire_department_rounded,
                            color: theme.colorScheme.primary,
                            size: 14.sp,
                          ),
                          const HSpace4(),
                          Text(
                            '${item.calories} ${l10n?.kcal ?? "kcal"}',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
