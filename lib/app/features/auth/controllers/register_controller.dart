import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/core/core.dart';
import 'package:flutter_talkie/app/features/auth/controllers/auth_controller.dart';
import 'package:flutter_talkie/app/features/auth/models/auth_user.dart';
import 'package:flutter_talkie/app/features/auth/models/login_response.dart';
import 'package:flutter_talkie/app/features/auth/services/auth_service.dart';
import 'package:flutter_talkie/app/shared/enums/loading_status.dart';
import 'package:flutter_talkie/app/shared/plugins/formx/formx.dart';
import 'package:flutter_talkie/app/shared/widgets/snackbar.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  Rx<FormxInput<String>> name = FormxInput<String>(
    value: '',
    validators: [Validators.required()],
  ).obs;

  Rx<FormxInput<String>> surname = FormxInput<String>(
    value: '',
    validators: [Validators.required()],
  ).obs;

  Rx<FormxInput<String>> email = FormxInput<String>(
    value: '',
    validators: [Validators.required<String>(), Validators.email()],
  ).obs;

  Rx<FormxInput<String>> password = FormxInput<String>(
    value: '',
    validators: [Validators.required()],
  ).obs;

  Rx<FormxInput<String>> phone = FormxInput<String>(
    value: '',
    validators: [Validators.required<String>()],
  ).obs;

  Rx<FormxInput<String>> username = FormxInput<String>(
    value: '',
    validators: [Validators.required<String>()],
  ).obs;

  Rx<LoadingStatus> loading = LoadingStatus.none.obs;

  changeEmail(FormxInput<String> value) {
    email.value = value;
  }

  changePassword(FormxInput<String> value) {
    password.value = value;
  }

  changeName(FormxInput<String> value) {
    name.value = value;
  }

  changeSurname(FormxInput<String> value) {
    surname.value = value;
  }

  changePhone(FormxInput<String> value) {
    phone.value = value;
  }

  changeUsername(FormxInput<String> value) {
    username.value = value;
  }

  register() async {
    FocusManager.instance.primaryFocus?.unfocus();

    email.value = email.value.touch();
    password.value = password.value.touch();

    if (!Formx.validate([email.value, password.value])) return;
    loading.value = LoadingStatus.loading;

    try {
      final LoginResponse loginResponse = await AuthService.register(
        email: email.value.value,
        password: password.value.value,
        name: name.value.value,
        surname: surname.value.value,
        phone: phone.value.value,
        username: username.value.value,
      );

      await StorageService.set<String>(StorageKeys.token, loginResponse.token);
      await StorageService.set<AuthUser>(StorageKeys.user, loginResponse.user);

      appRouter.go('/chats');

      final AuthController authController = Get.find<AuthController>();
      authController.initAutoLogout();

      loading.value = LoadingStatus.success;
    } on ServiceException catch (e) {
      loading.value = LoadingStatus.error;

      SnackbarService.show(e.message);
    }
  }
}
