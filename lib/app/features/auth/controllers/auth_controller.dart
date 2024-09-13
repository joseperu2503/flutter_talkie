import 'dart:async';

import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/features/auth/models/auth_user.dart';
import 'package:flutter_talkie/app/features/auth/services/auth_service.dart';
import 'package:flutter_talkie/app/shared/services/snackbar_service.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  Rx<AuthUser?> user = Rx<AuthUser?>(null);

  Future<void> getUser() async {
    try {
      final (validToken, _) = await AuthService.verifyToken();
      if (!validToken) return;

      final AuthUser user = await AuthService.getUser();

      setuser(user);
    } catch (e) {
      SnackBarService.show(e);
    }
  }

  setuser(AuthUser? value) {
    user.value = value;
  }

  Timer? _timer;

  _cancelTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  initAutoLogout() async {
    getUser();
    _cancelTimer();
    final (validToken, timeRemainingInSeconds) =
        await AuthService.verifyToken();

    if (validToken) {
      _timer = Timer(Duration(seconds: timeRemainingInSeconds), () {
        logout();
      });
    }
  }

  logout() async {
    await StorageService.remove(StorageKeys.token);
    _cancelTimer();
    appRouter.go('/');
  }
}
