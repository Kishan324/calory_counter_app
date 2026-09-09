import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/utils/haptic_helper.dart';

/// Custom reusable primary action button used across auth and form screens.
class AppPrimaryButton extends StatelessWidget {
  final String? label;
  final String? text;
  final VoidCallback? onTap;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AppPrimaryButton({
    super.key,
    this.label,
    this.text,
    this.onTap,
    this.onPressed,
    this.isLoading = false,
  });

  String get _buttonText => label ?? text ?? '';
  VoidCallback? get _buttonAction => onTap ?? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: _buttonAction == null
          ? null
          : () {
              HapticHelper.lightImpact();
              _buttonAction!();
            },
      child: Container(
        width: double.infinity,
        height: AppSizes.buttonHeight,
        decoration: BoxDecoration(
          color: _buttonAction == null
              ? theme.colorScheme.primary.withValues(alpha: 0.5)
              : theme.colorScheme.primary,
          borderRadius: AppRadius.border16,
          boxShadow: [
            BoxShadow(
              color: _buttonAction != null
                  ? theme.colorScheme.primary.withValues(alpha: 0.3)
                  : AppColors.transparent,
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: const CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  _buttonText,
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
