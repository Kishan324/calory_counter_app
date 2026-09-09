import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_padding.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_space.dart';

/// Reusable glassmorphic Date Picker widget across the application.
class AppGlassDatePicker extends StatelessWidget {
  final String label;
  final String hint;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final IconData prefixIcon;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;

  const AppGlassDatePicker({
    super.key,
    required this.label,
    required this.hint,
    required this.selectedDate,
    required this.onDateSelected,
    this.prefixIcon = Icons.cake_rounded,
    this.firstDate,
    this.lastDate,
    this.initialDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = selectedDate != null
        ? DateFormat('dd MMM yyyy').format(selectedDate!)
        : hint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600),
        ),
        const VSpace8(),
        ClipRRect(
          borderRadius: AppRadius.border16,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? initialDate ?? DateTime(2000, 1, 1),
                  firstDate: firstDate ?? DateTime(1920),
                  lastDate: lastDate ?? DateTime.now(),
                );
                if (picked != null) {
                  onDateSelected(picked);
                }
              },
              borderRadius: AppRadius.border16,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.padding20,
                  vertical: AppPadding.padding18,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.1),
                  borderRadius: AppRadius.border16,
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      prefixIcon,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 20.sp,
                    ),
                    const HSpace14(),
                    Expanded(
                      child: Text(
                        dateStr,
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: selectedDate != null
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                          fontWeight: selectedDate != null
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.calendar_month_rounded,
                      color: theme.colorScheme.primary,
                      size: 20.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
