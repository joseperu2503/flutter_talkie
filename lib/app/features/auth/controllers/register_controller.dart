import 'package:flutter/material.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/auth/controllers/auth_controller.dart';
import 'package:talkie/app/features/auth/controllers/login_controller.dart';
import 'package:talkie/app/features/auth/models/auth_user.dart';
import 'package:talkie/app/features/auth/models/login_response.dart';
import 'package:talkie/app/features/auth/models/phone_request.dart';
import 'package:talkie/app/features/auth/models/verification_code_request.dart';
import 'package:talkie/app/features/auth/services/auth_service.dart';
import 'package:talkie/app/shared/plugins/formx/formx.dart';
import 'package:talkie/app/shared/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class RegisterController extends GetxController {
  Rx<FormxInput<String>> name = FormxInput<String>(
    value: '',
    validators: [Validators.required()],
  ).obs;

  Rx<FormxInput<String>> surname = FormxInput<String>(
    value: '',
    validators: [Validators.required()],
  ).obs;

  Rx<FormxInput<String>> password = FormxInput<String>(
    value: '',
    validators: [Validators.required()],
  ).obs;

  String? verificationCodeId;

  initData() {
    name.value = name.value.unTouch().updateValue('');
    surname.value = surname.value.unTouch().updateValue('');
    password.value = password.value.unTouch().updateValue('');
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

  verifyForm() {
    FocusManager.instance.primaryFocus?.unfocus();

    final loginController = Get.find<LoginController>();

    if (loginController.authMethod.value == AuthMethod.phone) {
      if (!Formx.validate([loginController.phone.value])) return false;
      if (loginController.country.value == null) return false;
    }
    if (loginController.authMethod.value == AuthMethod.email) {
      if (!Formx.validate([loginController.email.value])) return false;
    }

    name.value = name.value.touch();
    password.value = password.value.touch();
    surname.value = surname.value.touch();

    if (!Formx.validate([name.value, surname.value, password.value])) {
      return false;
    }

    return true;
  }

  register(String verificationCode) async {
    if (!verifyForm()) return;
    if (verificationCodeId == null) return;
    final loginController = Get.find<LoginController>();

    try {
      final LoginResponse loginResponse = await AuthService.register(
        email: loginController.email.value.value,
        password: password.value.value,
        name: name.value.value,
        surname: surname.value.value,
        phone: PhoneRequest(
          number: loginController.phone.value.value,
          countryId: loginController.country.value!.id,
        ),
        type: loginController.authMethod.value,
        verificationCode: VerificationCodeRequest(
          id: verificationCodeId!,
          code: verificationCode,
        ),
      );

      await StorageService.set<String>(StorageKeys.token, loginResponse.token);
      await StorageService.set<AuthUser>(StorageKeys.user, loginResponse.user);

      rootNavigatorKey.currentContext!.go('/chats');

      final AuthController authController = Get.find<AuthController>();

      authController.onLogin();
    } on ServiceException catch (e) {
      SnackbarService.show(e.message);
    }
  }

  sendVerificationCode() async {
    if (!verifyForm()) return;
    final loginController = Get.find<LoginController>();

    try {
      final response = await AuthService.sendVerificationCode(
        email: loginController.email.value.value,
        phone: PhoneRequest(
          number: loginController.phone.value.value,
          countryId: loginController.country.value!.id,
        ),
        type: loginController.authMethod.value,
      );

      verificationCodeId = response.data.verificationCodeId;

      rootNavigatorKey.currentContext!.push('/verify-code');
    } on ServiceException catch (e) {
      SnackbarService.show(e.message);
    }
  }
}
