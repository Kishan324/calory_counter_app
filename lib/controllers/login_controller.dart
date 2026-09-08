import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';
import '../presentation/screens/main_screen.dart';

/// Manages form controllers, obscure text toggle, and submission for LoginScreen.
class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool obscurePassword = true.obs;

  void toggleObscurePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> handleLogin() async {
    if (formKey.currentState!.validate()) {
      final authCtrl = Get.find<AuthController>();
      final success = await authCtrl.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (success) {
        Get.offAll(() => const MainScreen());
      }
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
