import 'package:flutter/material.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/auth/controllers/auth_controller.dart';
import 'package:talkie/app/features/auth/models/auth_user.dart';
import 'package:talkie/app/features/auth/models/login_response.dart';
import 'package:talkie/app/features/auth/services/auth_service.dart';
import 'package:talkie/app/features/chat/controllers/chat_controller.dart';
import 'package:talkie/app/features/settings/controllers/notifications_controller.dart';
import 'package:talkie/app/shared/enums/loading_status.dart';
import 'package:talkie/app/shared/plugins/formx/formx.dart';
import 'package:talkie/app/shared/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class LoginController extends GetxController {
  Rx<FormxInput<String>> email = FormxInput<String>(
    value: '',
    validators: [Validators.required<String>(), Validators.email()],
  ).obs;

  Rx<FormxInput<String>> password = FormxInput<String>(
    value: '',
    validators: [Validators.required()],
  ).obs;

  Rx<LoadingStatus> loading = LoadingStatus.none.obs;
  Rx<bool> rememberMe = false.obs;

  initData() {
    email.value = email.value.unTouch().updateValue('');
    password.value = password.value.unTouch().updateValue('');
  }

  changeEmail(FormxInput<String> value) {
    email.value = value;
  }

  changePassword(FormxInput<String> value) {
    password.value = value;
  }

  login() async {
    FocusManager.instance.primaryFocus?.unfocus();

    email.value = email.value.touch();
    password.value = password.value.touch();

    if (!Formx.validate([email.value, password.value])) return;
    loading.value = LoadingStatus.loading;

    try {
      final LoginResponse loginResponse = await AuthService.login(
        email: email.value.value,
        password: password.value.value,
      );

      await StorageService.set<String>(StorageKeys.token, loginResponse.token);
      await StorageService.set<AuthUser>(StorageKeys.user, loginResponse.user);

      _setRemember();
      rootNavigatorKey.currentContext!.go('/chats');

      final AuthController authController = Get.find<AuthController>();
      final ChatController chatController = Get.find<ChatController>();
      final NotificationsController notificationsController =
          Get.find<NotificationsController>();

      authController.initAutoLogout();
      chatController.connectSocket();
      chatController.getChats();
      notificationsController.init();

      loading.value = LoadingStatus.success;
    } on ServiceException catch (e) {
      loading.value = LoadingStatus.error;

      SnackbarService.show(e.message, type: SnackbarType.error);
    }
  }

  _setRemember() async {
    if (rememberMe.value) {
      await StorageService.set<String>(StorageKeys.email, email.value.value);
    }
    await StorageService.set<bool>(StorageKeys.rememberMe, rememberMe.value);
  }
}
