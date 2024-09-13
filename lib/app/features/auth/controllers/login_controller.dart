import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/features/auth/controllers/auth_controller.dart';
import 'package:flutter_talkie/app/features/auth/models/login_response.dart';
import 'package:flutter_talkie/app/features/auth/services/auth_service.dart';
import 'package:flutter_talkie/app/shared/enums/loading_status.dart';
import 'package:flutter_talkie/app/shared/plugins/formx/formx.dart';
import 'package:flutter_talkie/app/shared/services/snackbar_service.dart';
import 'package:get/get.dart';

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

      _setRemember();
      appRouter.go('/chats');

      final AuthController authController = Get.find<AuthController>();
      authController.initAutoLogout();

      loading.value = LoadingStatus.success;
    } on ServiceException catch (e) {
      loading.value = LoadingStatus.error;

      SnackBarService.show(e.message);
    }
  }

  _setRemember() async {
    if (rememberMe.value) {
      await StorageService.set<String>(StorageKeys.email, email.value.value);
    }
    await StorageService.set<bool>(StorageKeys.rememberMe, rememberMe.value);
  }
}
