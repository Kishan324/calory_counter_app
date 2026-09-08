import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_durations.dart';
import '../../../core/theme/app_padding.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_space.dart';

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
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;

    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            left: AppPadding.padding20,
            right: AppPadding.padding20,
            top: AppPadding.padding12,
            bottom: keyboardVisible ? AppPadding.padding20 : 100.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VSpace50(),

              // Header Title
              Text(
                loc.enterDetailsTitle,
                style: theme.textTheme.headlineLarge!.copyWith(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const VSpace8(),
              Text(
                loc.enterDetailsSubtitle,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.65),
                  fontSize: 14.sp,
                ),
              ),
              const VSpace24(),

              // Crisp Intake Form Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppPadding.padding20),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.white.withOpacity(0.06)
                      : theme.colorScheme.surface,
                  borderRadius: AppRadius.border24,
                  border: Border.all(
                    color: isDark
                        ? AppColors.white.withOpacity(0.12)
                        : AppColors.black.withOpacity(0.08),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(isDark ? 0.2 : 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Gender ────────────────────
                    Text(
                      loc.gender,
                      style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                      ),
                    ),
                    const VSpace12(),
                    Row(
                      children: [
                        _GenderChip(
                          label: loc.male,
                          icon: Icons.male_rounded,
                          isSelected: selectedGender == 'Male',
                          theme: theme,
                          onTap: () => onGenderSelected('Male'),
                        ),
                        const HSpace10(),
                        _GenderChip(
                          label: loc.female,
                          icon: Icons.female_rounded,
                          isSelected: selectedGender == 'Female',
                          theme: theme,
                          onTap: () => onGenderSelected('Female'),
                        ),
                        const HSpace10(),
                        _GenderChip(
                          label: loc.other,
                          icon: Icons.transgender_rounded,
                          isSelected: selectedGender == 'Other',
                          theme: theme,
                          onTap: () => onGenderSelected('Other'),
                        ),
                      ],
                    ),
                    const VSpace20(),

                    // ── Birth Date ───────────────
                    Text(
                      loc.birthDate,
                      style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                      ),
                    ),
                    const VSpace12(),
                    GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? now,
                          firstDate: DateTime(1920),
                          lastDate: now,
                          builder: (ctx, child) => Theme(
                            data: theme,
                            child: child!,
                          ),
                        );
                        if (picked != null) onDateSelected(picked);
                      },
                      child: AnimatedContainer(
                        duration: AppDurations.fast,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppPadding.padding16,
                          vertical: AppPadding.padding14,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.white.withOpacity(0.05)
                              : theme.colorScheme.surface,
                          borderRadius: AppRadius.border14,
                          border: Border.all(
                            color: selectedDate != null
                                ? theme.colorScheme.primary.withOpacity(0.6)
                                : theme.colorScheme.onSurface.withOpacity(0.12),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              color: theme.colorScheme.primary,
                              size: 20.sp,
                            ),
                            const HSpace12(),
                            Text(
                              selectedDate != null
                                  ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                  : loc.selectDate,
                              style: theme.textTheme.bodyLarge!.copyWith(
                                color: selectedDate != null
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.onSurface.withOpacity(0.4),
                                fontWeight: selectedDate != null
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const VSpace20(),

                    // ── Weight & Height ──────────
                    Row(
                      children: [
                        Expanded(
                          child: _InfoField(
                            label: loc.weight,
                            unitLabel: 'kg',
                            controller: weightController,
                            theme: theme,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                            ],
                          ),
                        ),
                        const HSpace12(),
                        Expanded(
                          child: _InfoField(
                            label: loc.height,
                            unitLabel: 'cm',
                            controller: heightController,
                            theme: theme,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (formError != null) ...[
                const VSpace12(),
                Text(
                  formError!,
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              keyboardVisible ? const VSpace20() : const VSpace40(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Reusable sub-widgets ────────────────────────────────

class _GenderChip extends StatelessWidget {
  const _GenderChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.theme,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final ThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          padding: EdgeInsets.symmetric(vertical: AppPadding.padding12),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : isDark
                    ? AppColors.white.withOpacity(0.05)
                    : theme.colorScheme.surface,
            borderRadius: AppRadius.border14,
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.12),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? theme.colorScheme.primary.withOpacity(0.35)
                    : AppColors.transparent,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18.sp,
                color: isSelected ? AppColors.white : theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              SizedBox(width: 4.w),
              Text(
                label,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: isSelected ? AppColors.white : theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 13.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({
    required this.label,
    required this.unitLabel,
    required this.controller,
    required this.theme,
    required this.keyboardType,
    required this.inputFormatters,
  });

  final String label;
  final String unitLabel;
  final TextEditingController controller;
  final ThemeData theme;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 15.sp,
          ),
        ),
        const VSpace10(),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.done,
          inputFormatters: inputFormatters,
          style: theme.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: unitLabel == 'kg' ? 'e.g. 70' : 'e.g. 175',
            hintStyle: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.35),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppPadding.padding14,
              vertical: AppPadding.padding12,
            ),
            filled: true,
            fillColor: isDark ? AppColors.white.withOpacity(0.05) : theme.colorScheme.surface,
            suffixIcon: Container(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.padding10),
              child: Center(
                widthFactor: 1.0,
                child: Text(
                  unitLabel,
                  style: theme.textTheme.labelMedium!.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: AppRadius.border14,
              borderSide: BorderSide(
                color: theme.colorScheme.onSurface.withOpacity(0.12),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.border14,
              borderSide: BorderSide(
                color: theme.colorScheme.onSurface.withOpacity(0.12),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.border14,
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
