import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/shared/plugins/formx/formx.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  Rx<FormxInput<String>> email = FormxInput<String>(
    value: '',
    validators: [Validators.required<String>(), Validators.email()],
  ).obs;

  Rx<FormxInput<String>> password = FormxInput<String>(
    value: '',
    validators: [Validators.required()],
  ).obs;

  Rx<bool> loading = false.obs;
  Rx<bool> rememberMe = false.obs;

  changeEmail(FormxInput<String> value) {
    email.value = value;
  }

  changePassword(FormxInput<String> value) {
    password.value = value;
  }

  login() async {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
