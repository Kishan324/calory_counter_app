import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../data/services/biometric_service.dart';

/// Manages bottom navigation bar indexing and app lifecycle security lock in MainScreen.
class MainController extends GetxController with GetSingleTickerProviderStateMixin {
  final RxInt currentIndex = 0.obs;
  final RxBool isLocked = false.obs;

  bool _hasCheckedOnce = false;
  bool _isAuthenticating = false;

  void changeTab(int index) {
    if (currentIndex.value != index) {
      currentIndex.value = index;
    }
  }

  void handleAppResume(BuildContext context) {
    if (!_hasCheckedOnce) {
      _hasCheckedOnce = true;
      return;
    }
    checkLock(context);
  }

  Future<void> checkLock(BuildContext context) async {
    if (_isAuthenticating) return;

    final localizedReason =
        AppLocalizations.of(context)?.authenticateToUnlock ??
            "Authenticate to unlock app";

    final bioService = BiometricService();
    if (await bioService.isAppLockEnabled() &&
        await bioService.isBiometricAvailable()) {
      _isAuthenticating = true;
      isLocked.value = true;

      final authenticated = await bioService.authenticate(
        localizedReason: localizedReason,
      );

      _isAuthenticating = false;

      if (authenticated) {
        isLocked.value = false;
      }
    }
  }
}
