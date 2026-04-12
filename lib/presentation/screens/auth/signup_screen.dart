import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../main_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      final success = await context.read<AuthProvider>().signup(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
          );

      if (!mounted) return;

      if (success) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient
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
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      loc.createYourAccount,
                      style: theme.textTheme.headlineLarge!.copyWith(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // SizedBox(height: 8.h),
                    // Text(
                    //   loc.signup,
                    //   style: theme.textTheme.bodyLarge!.copyWith(
                    //     color: theme.colorScheme.onSurface.withOpacity(0.6),
                    //   ),
                    // ),
                    SizedBox(height: 32.h),

                    // Name Field
                    _GlassTextField(
                      controller: _nameController,
                      label: loc.name,
                      hint: 'John Doe',
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return loc.nameRequired;
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Email Field
                    _GlassTextField(
                      controller: _emailController,
                      label: loc.email,
                      hint: 'example@mail.com',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return loc.emailRequired;
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return loc.emailInvalid;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Password Field
                    _GlassTextField(
                      controller: _passwordController,
                      label: loc.password,
                      hint: '••••••••',
                      isPassword: true,
                      obscureText: _obscurePassword,
                      onToggleVisibility: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return loc.passwordRequired;
                        if (value.length < 6) return loc.passwordTooShort;
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Confirm Password Field
                    _GlassTextField(
                      controller: _confirmPasswordController,
                      label: loc.confirmPassword,
                      hint: '••••••••',
                      isPassword: true,
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return loc.passwordRequired;
                        if (value != _passwordController.text)
                          return loc.passwordsNoMatch;
                        return null;
                      },
                    ),

                    SizedBox(height: 32.h),

                    // Sign Up Button
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return _PrimaryButton(
                          label: loc.signup,
                          isLoading: authProvider.isLoading,
                          onTap: authProvider.isLoading ? null : _handleSignUp,
                        );
                      },
                    ),

                    SizedBox(height: 32.h),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          loc.alreadyHaveAccount,
                          style: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.6)),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                          ),
                          child: Text(
                            loc.login,
                            style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 150.h),
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

class _GlassTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _GlassTextField({
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
          style:
              theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
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
                hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.3)),
                filled: true,
                fillColor: theme.colorScheme.surface.withOpacity(0.1),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                      color: theme.colorScheme.primary.withOpacity(0.1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                      color: theme.colorScheme.primary.withOpacity(0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
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

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;

  const _PrimaryButton({
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          color: onTap == null
              ? theme.colorScheme.primary.withOpacity(0.5)
              : theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            if (onTap != null)
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.3),
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
                      color: Colors.white, strokeWidth: 2.5),
                )
              : Text(
                  label,
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
