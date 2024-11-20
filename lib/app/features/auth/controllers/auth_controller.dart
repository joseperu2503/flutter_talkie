import 'dart:async';

import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/auth/models/auth_user.dart';
import 'package:talkie/app/features/auth/services/auth_service.dart';
import 'package:talkie/app/features/chat/controllers/chat_controller.dart';
import 'package:talkie/app/shared/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AuthController extends GetxController {
  Rx<AuthUser?> user = Rx<AuthUser?>(null);

  Future<void> getUser() async {
    final (validToken, _) = await AuthService.verifyToken();
    if (!validToken) return;
    try {
      final AuthUser user = await AuthService.getUser();

      setuser(user);
    } catch (e) {
      SnackbarService.show('Ocurrio un error');
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
    _cancelTimer();

    final (validToken, timeRemainingInSeconds) =
        await AuthService.verifyToken();

    if (validToken) {
      if (timeRemainingInSeconds > 3600) {
        _timer = Timer(const Duration(seconds: 3600), () {
          initAutoLogout();
        });
      } else {
        _timer = Timer(Duration(seconds: timeRemainingInSeconds), () {
          logout();
        });
      }
    }
  }

  logout() async {
    await StorageService.remove(StorageKeys.token);
    _cancelTimer();
    final ChatController chatController = Get.find<ChatController>();
    chatController.socket?.disconnect();
    rootNavigatorKey.currentContext!.go('/');
  }
}
