import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_padding.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_space.dart';

/// Reusable glassmorphic text field widget for auth inputs.
class AppGlassTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const AppGlassTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleVisibility,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              validator: validator,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: theme.textTheme.bodyLarge!.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                ),
                filled: true,
                fillColor: theme.colorScheme.surface.withOpacity(0.1),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppPadding.padding20,
                  vertical: AppPadding.padding18,
                ),
                border: OutlineInputBorder(
                  borderRadius: AppRadius.border16,
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppRadius.border16,
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadius.border16,
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                          obscureText
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        onPressed: onToggleVisibility,
                      )
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
