import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Page 4 — Collects user's gender, birth date, weight, and height.
/// All state is owned by the parent [OnboardingScreen] and passed down
/// via callbacks to keep this widget purely presentational.
class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({
    Key? key,
    required this.selectedGender,
    required this.selectedDate,
    required this.weightController,
    required this.heightController,
    required this.formError,
    required this.onGenderSelected,
    required this.onDateSelected,
  }) : super(key: key);

  final String selectedGender;
  final DateTime? selectedDate;
  final TextEditingController weightController;
  final TextEditingController heightController;
  final String? formError;
  final ValueChanged<String> onGenderSelected;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h),
            Text(
              loc.enterDetailsTitle,
              style: theme.textTheme.headlineLarge!.copyWith(fontSize: 26.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              loc.enterDetailsSubtitle,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            SizedBox(height: 32.h),

            // ── Gender ────────────────────
            Text(loc.gender, style: theme.textTheme.titleLarge),
            SizedBox(height: 12.h),
            Row(
              children: [
                _GenderChip(
                  label: loc.male,
                  isSelected: selectedGender == 'Male',
                  theme: theme,
                  onTap: () => onGenderSelected('Male'),
                ),
                SizedBox(width: 10.w),
                _GenderChip(
                  label: loc.female,
                  isSelected: selectedGender == 'Female',
                  theme: theme,
                  onTap: () => onGenderSelected('Female'),
                ),
                SizedBox(width: 10.w),
                _GenderChip(
                  label: loc.other,
                  isSelected: selectedGender == 'Other',
                  theme: theme,
                  onTap: () => onGenderSelected('Other'),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // ── Birth Date ───────────────
            Text(loc.birthDate, style: theme.textTheme.titleLarge),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime(1995, 1, 1),
                  firstDate: DateTime(1930),
                  lastDate: DateTime.now().subtract(
                    const Duration(days: 365 * 5),
                  ),
                  builder: (ctx, child) =>
                      Theme(data: theme, child: child!),
                );
                if (picked != null) onDateSelected(picked);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: theme.colorScheme.onSurface.withOpacity(0.12),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        color: theme.colorScheme.primary, size: 20.sp),
                    SizedBox(width: 12.w),
                    Text(
                      selectedDate != null
                          ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                          : loc.selectDate,
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: selectedDate != null
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // ── Weight & Height ──────────
            Row(
              children: [
                Expanded(
                  child: _InfoField(
                    label: loc.weight,
                    controller: weightController,
                    theme: theme,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _InfoField(
                    label: loc.height,
                    controller: heightController,
                    theme: theme,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                    ],
                  ),
                ),
              ],
            ),

            if (formError != null) ...[
              SizedBox(height: 12.h),
              Text(
                formError!,
                style:
                    theme.textTheme.bodySmall!.copyWith(color: Colors.red),
              ),
            ],
            SizedBox(height: 120.h),
          ],
        ),
      ),
    );
  }
}

// ─── Reusable sub-widgets ────────────────────────────────

class _GenderChip extends StatelessWidget {
  const _GenderChip({
    required this.label,
    required this.isSelected,
    required this.theme,
    required this.onTap,
  });
  final String label;
  final bool isSelected;
  final ThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.12),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge!.copyWith(
              color:
                  isSelected ? Colors.white : theme.colorScheme.onSurface,
              fontWeight:
                  isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({
    required this.label,
    required this.controller,
    required this.theme,
    required this.keyboardType,
    required this.inputFormatters,
  });
  final String label;
  final TextEditingController controller;
  final ThemeData theme;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.titleLarge),
        SizedBox(height: 10.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w, vertical: 14.h),
            filled: true,
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(
                color: theme.colorScheme.onSurface.withOpacity(0.12),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(
                color: theme.colorScheme.onSurface.withOpacity(0.12),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
