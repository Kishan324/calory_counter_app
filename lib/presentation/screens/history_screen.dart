import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../providers/history_provider.dart';
import '../../data/models/history_model.dart';
import 'history_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<HistoryProvider>(context, listen: false);
      provider.fetchHistoryByDate(provider.selectedDate);
    });
  }

  void _changeDate(BuildContext context, int days) {
    final provider = Provider.of<HistoryProvider>(context, listen: false);
    final newDate = provider.selectedDate.add(Duration(days: days));
    provider.changeDate(newDate);
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
      floatingActionButton: Consumer<HistoryProvider>(
        builder: (context, provider, _) {
          final isToday = provider.isSameDay(provider.selectedDate, DateTime.now());
          
          return AnimatedScale(
            scale: isToday ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            child: FloatingActionButton.extended(
              onPressed: isToday ? null : () => provider.changeDate(DateTime.now()),
              backgroundColor: theme.colorScheme.primary,
              elevation: 4,
              icon: Icon(Icons.today_rounded, color: theme.colorScheme.onPrimary),
              label: Text(
                l10n?.historyToday ?? 'Today',
                style: TextStyle(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragEnd: (details) {
          final provider = Provider.of<HistoryProvider>(context, listen: false);
          if (details.primaryVelocity! < -300) {
            // Swipe Left (Next Day)
            if (!provider.isSameDay(provider.selectedDate, DateTime.now())) {
              _changeDate(context, 1);
            }
          } else if (details.primaryVelocity! > 300) {
            // Swipe Right (Previous Day)
            _changeDate(context, -1);
          }
        },
        child: Column(
          children: [
            _buildDateSelector(context, theme),
          Expanded(
            child: Consumer<HistoryProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.filteredHistory.isEmpty) {
                  return _buildEmptyState(
                      context, provider.selectedDate, theme);
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  itemCount: provider.filteredHistory.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final item = provider.filteredHistory[index];
                    return TweenAnimationBuilder<double>(
                      key: ValueKey(item.id),
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 300 + (index * 50).clamp(0, 300)),
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
              },
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context, ThemeData theme) {
    return Consumer<HistoryProvider>(
      builder: (context, provider, _) {
        final selectedDate = provider.selectedDate;

        return Container(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
          margin: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: theme.brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.2)
                    : Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              /// LEFT ARROW
              IconButton(
                onPressed: () => _changeDate(context, -1),
                icon: Icon(Icons.chevron_left),
              ),

              /// DATE TEXT (CLICKABLE)
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(), // 🔥 no future
                    );

                    if (pickedDate != null) {
                      provider.changeDate(pickedDate);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today,
                          size: 16.sp, color: theme.colorScheme.primary),
                      SizedBox(width: 6.w),
                      Text(
                        _formatDate(context, selectedDate),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(Icons.keyboard_arrow_down,
                          color: theme.colorScheme.onSurfaceVariant),
                    ],
                  ),
                ),
              ),

              /// RIGHT ARROW (DISABLED FOR FUTURE)
              IconButton(
                onPressed: !provider.isSameDay(selectedDate, DateTime.now())
                    ? () => _changeDate(context, 1)
                    : null,
                icon: Icon(Icons.chevron_right),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(
      BuildContext context, DateTime selectedDate, ThemeData theme) {
    final formattedDate = _formatDate(context, selectedDate);
    final emptyText =
        AppLocalizations.of(context)?.noHistoryFound(formattedDate) ??
            "No history found for $formattedDate";

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_toggle_off_rounded,
              size: 80.sp,
              color: theme.colorScheme.primary.withOpacity(0.35),
            ),
            SizedBox(height: 16.h),
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
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryDetailScreen(item: item),
            ),
          );
        }, // Navigates to detail report
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
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
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.3) : theme.colorScheme.shadow.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
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
                                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
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
                    child: Icon(Icons.restaurant, color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
              ),
              SizedBox(width: 16.w),
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
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_fire_department_rounded,
                            color: theme.colorScheme.primary,
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
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
