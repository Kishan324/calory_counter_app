import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_padding.dart';
import '../../../core/theme/app_space.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/signup_controller.dart';
import '../../widgets/app_glass_text_field.dart';
import '../../widgets/app_primary_button.dart';
import 'login_screen.dart';

/// User registration screen using GetX SignUpController and design system tokens.
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    final controller = Get.put(SignUpController());
    final authController = Get.find<AuthController>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: theme.colorScheme.onSurface),
          onPressed: () => Get.back(),
        ),
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
                          theme.colorScheme.primary.withOpacity(0.15),
                          theme.scaffoldBackgroundColor,
                        ]
                      : [
                          theme.colorScheme.primary.withOpacity(0.08),
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
                    const VSpace20(),
                    Text(
                      loc.createYourAccount,
                      style: theme.textTheme.headlineLarge!.copyWith(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const VSpace32(),
                    AppGlassTextField(
                      controller: controller.nameController,
                      label: loc.name,
                      hint: 'John Doe',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return loc.nameRequired;
                        }
                        return null;
                      },
                    ),
                    const VSpace16(),
                    AppGlassTextField(
                      controller: controller.emailController,
                      label: loc.email,
                      hint: 'example@mail.com',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return loc.emailRequired;
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return loc.emailInvalid;
                        }
                        return null;
                      },
                    ),
                    const VSpace16(),
                    Obx(
                      () => AppGlassTextField(
                        controller: controller.passwordController,
                        label: loc.password,
                        hint: '••••••••',
                        isPassword: true,
                        obscureText: controller.obscurePassword.value,
                        onToggleVisibility: controller.toggleObscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return loc.passwordRequired;
                          }
                          if (value.length < 6) return loc.passwordTooShort;
                          return null;
                        },
                      ),
                    ),
                    const VSpace16(),
                    Obx(
                      () => AppGlassTextField(
                        controller: controller.confirmPasswordController,
                        label: loc.confirmPassword,
                        hint: '••••••••',
                        isPassword: true,
                        obscureText: controller.obscurePassword.value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return loc.passwordRequired;
                          }
                          if (value != controller.passwordController.text) {
                            return loc.passwordsNoMatch;
                          }
                          return null;
                        },
                      ),
                    ),
                    const VSpace32(),
                    Obx(
                      () => AppPrimaryButton(
                        label: loc.signup,
                        isLoading: authController.isLoading,
                        onTap: authController.isLoading ? null : controller.handleSignUp,
                      ),
                    ),
                    const VSpace32(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          loc.alreadyHaveAccount,
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Get.off(() => const LoginScreen()),
                          child: Text(
                            loc.login,
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
