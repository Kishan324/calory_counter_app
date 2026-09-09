import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_padding.dart';
import '../../../core/theme/app_space.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/login_controller.dart';
import '../../widgets/app_glass_text_field.dart';
import '../../widgets/app_primary_button.dart';
import '../../widgets/app_back_button.dart';
import 'signup_screen.dart';

/// User login screen using GetX LoginController and design system tokens.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    final controller = Get.put(LoginController());
    final authController = Get.find<AuthController>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: const AppBackButton(),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          theme.colorScheme.primary.withValues(alpha: 0.15),
                          theme.scaffoldBackgroundColor,
                        ]
                      : [
                          theme.colorScheme.primary.withValues(alpha: 0.08),
                          theme.scaffoldBackgroundColor,
                        ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: AppPadding.symmetricH24,
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VSpace40(),
                    Text(
                      loc.welcomeBack,
                      style: theme.textTheme.headlineLarge!.copyWith(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const VSpace8(),
                    Text(
                      loc.login,
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const VSpace48(),
                    AppGlassTextField(
                      controller: controller.emailController,
                      label: loc.email,
                      hint: 'example@mail.com',
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return loc.emailRequired;
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value.trim())) {
                          return loc.emailInvalid;
                        }
                        return null;
                      },
                    ),
                    const VSpace20(),
                    Obx(
                      () => AppGlassTextField(
                        controller: controller.passwordController,
                        label: loc.password,
                        hint: '••••••••',
                        isPassword: true,
                        obscureText: controller.obscurePassword.value,
                        onToggleVisibility: controller.toggleObscurePassword,
                        inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return loc.passwordRequired;
                          }
                          if (value.trim().length < 6) return loc.passwordTooShort;
                          return null;
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          loc.forgotPassword,
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const VSpace32(),
                    Obx(
                      () => AppPrimaryButton(
                        label: loc.login,
                        isLoading: authController.isLoading,
                        onTap: authController.isLoading ? null : controller.handleLogin,
                      ),
                    ),
                    const VSpace32(),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                          ),
                        ),
                        Padding(
                          padding: AppPadding.symmetricH16,
                          child: Text(
                            loc.orContinueWith,
                            style: theme.textTheme.bodySmall!.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                          ),
                        ),
                      ],
                    ),
                    const VSpace24(),
                    Center(
                      child: Container(
                        padding: AppPadding.all12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                          ),
                          color: theme.colorScheme.surface.withValues(alpha: 0.3),
                        ),
                        child: Icon(Icons.g_mobiledata_rounded,
                            size: 40.sp, color: theme.colorScheme.onSurface),
                      ),
                    ),
                    const VSpace40(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          loc.dontHaveAccount,
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Get.off(() => const SignUpScreen()),
                          child: Text(
                            loc.signup,
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const VSpace150(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
