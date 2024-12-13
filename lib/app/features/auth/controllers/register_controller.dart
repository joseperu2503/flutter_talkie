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
  final loginController = Get.put<LoginController>(LoginController());

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
    'password': FormControl<String>(validators: [
      Validators.required,
      Validators.minLength(6),
      Validators.maxLength(50),
      Validators.pattern(
        r'(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*',
        validationMessage: 'Invalid password',
      ),
    ]),
  });

  _verifyForm() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (verificationCodeId == null) return false;
    if (otp.text.length != 4) return false;

    if (!validateLoginForm()) return false;

    if (form.invalid) return false;

    return true;
  }

  validateLoginForm() {
    return loginController.validateAccount();
  }

  register() async {
    if (!_verifyForm()) return;

    try {
      final LoginResponse loginResponse = await AuthService.register(
        email: loginController.authMethod.value == AuthMethod.email
            ? loginController.form.control('email').value
            : null,
        phone: loginController.authMethod.value == AuthMethod.phone
            ? PhoneRequest(
                number: loginController.form.control('phone').value,
                countryId: loginController.country.value!.id,
              )
            : null,
        password: form.control('password').value,
        name: form.control('name').value,
        surname: form.control('surname').value,
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
    if (!validateLoginForm()) return;
    otp.text = '';

    try {
      final response = await AuthService.sendVerificationCode(
        email: loginController.authMethod.value == AuthMethod.email
            ? loginController.form.control('email').value
            : null,
        phone: loginController.authMethod.value == AuthMethod.phone
            ? PhoneRequest(
                number: loginController.form.control('phone').value,
                countryId: loginController.country.value!.id,
              )
            : null,
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
