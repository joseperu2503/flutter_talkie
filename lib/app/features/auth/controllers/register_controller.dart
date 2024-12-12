import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/auth/controllers/auth_controller.dart';
import 'package:talkie/app/features/auth/controllers/login_controller.dart';
import 'package:talkie/app/features/auth/models/auth_user.dart';
import 'package:talkie/app/features/auth/models/login_response.dart';
import 'package:talkie/app/features/auth/models/phone_request.dart';
import 'package:talkie/app/features/auth/models/verification_code_request.dart';
import 'package:talkie/app/features/auth/services/auth_service.dart';
import 'package:talkie/app/shared/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class RegisterController extends GetxController {
  String? verificationCodeId;
  TextEditingController otp = TextEditingController();

  initData() {
    form.patchValue({
      'name': '',
      'surname': '',
      'password': '',
    });
  }

  final form = FormGroup({
    'name': FormControl<String>(validators: [Validators.required]),
    'surname': FormControl<String>(validators: [Validators.required]),
    'password': FormControl<String>(validators: [Validators.required]),
  });

  _verifyForm() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (verificationCodeId == null) return false;
    if (otp.text.length != 4) return false;

    if (!_verifyForm2()) return false;

    if (form.invalid) return false;

    return true;
  }

  _verifyForm2() {
    // final loginController = Get.find<LoginController>();

    // if (loginController.authMethod.value == AuthMethod.phone) {
    //   if (!Formx.validate([loginController.phone.value])) return false;
    //   if (loginController.country.value == null) return false;
    // }
    // if (loginController.authMethod.value == AuthMethod.email) {
    //   if (!Formx.validate([loginController.email.value])) return false;
    // }

    return true;
  }

  register() async {
    if (!_verifyForm()) return;
    final loginController = Get.find<LoginController>();

    try {
      final LoginResponse loginResponse = await AuthService.register(
        email: loginController.email.value.value,
        password: form.control('password').value,
        name: form.control('name').value,
        surname: form.control('surname').value,
        phone: PhoneRequest(
          number: loginController.phone.value.value,
          countryId: loginController.country.value!.id,
        ),
        type: loginController.authMethod.value,
        verificationCode: VerificationCodeRequest(
          id: verificationCodeId!,
          code: otp.text,
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
    if (!_verifyForm2()) return;
    final loginController = Get.find<LoginController>();
    otp.text = '';

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
    } on ServiceException catch (e) {
      SnackbarService.show(e.message);
      rethrow;
    }
  }

  verifyCode() async {
    try {
      await AuthService.verifyCode(
        verificationCode: VerificationCodeRequest(
          id: verificationCodeId!,
          code: otp.text,
        ),
      );

      rootNavigatorKey.currentContext!.pushReplacement('/register');
    } on ServiceException catch (e) {
      SnackbarService.show(e.message);
    }
  }
}
