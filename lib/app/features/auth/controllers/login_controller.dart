import 'package:flutter/material.dart';
import 'package:mask_input_formatter/mask_input_formatter.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/auth/controllers/auth_controller.dart';
import 'package:talkie/app/features/auth/controllers/register_controller.dart';
import 'package:talkie/app/features/auth/models/auth_user.dart';
import 'package:talkie/app/features/auth/models/country.dart';
import 'package:talkie/app/features/auth/models/login_response.dart';
import 'package:talkie/app/features/auth/models/phone_request.dart';
import 'package:talkie/app/features/auth/models/verify_account_response.dart';
import 'package:talkie/app/features/auth/services/auth_service.dart';
import 'package:talkie/app/features/auth/services/countries_service.dart';
import 'package:talkie/app/shared/plugins/formx/formx.dart';
import 'package:talkie/app/shared/services/ip_service.dart';
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

  Rx<bool> rememberMe = false.obs;
  Rx<AuthMethod> authMethod = AuthMethod.email.obs;

  initData() {
    email.value = email.value.unTouch().updateValue('');
    phone.value = phone.value.unTouch().updateValue('');
    password.value = password.value.unTouch().updateValue('');
  }

  resetPassword() {
    password.value = password.value.unTouch().updateValue('');
  }

  changeEmail(FormxInput<String> value) {
    email.value = value;
  }

  toggleAuthMethod() {
    authMethod.value = authMethod.value == AuthMethod.email
        ? AuthMethod.phone
        : AuthMethod.email;

    email.value = email.value.unTouch().updateValue('');
    phone.value = phone.value.unTouch().updateValue('');
  }

  changePassword(FormxInput<String> value) {
    password.value = value;
  }

  login() async {
    FocusManager.instance.primaryFocus?.unfocus();

    phone.value = phone.value.touch();
    email.value = email.value.touch();

    if (authMethod.value == AuthMethod.phone) {
      if (!Formx.validate([phone.value])) return;
      if (country.value == null) return;
    }
    if (authMethod.value == AuthMethod.email) {
      if (!Formx.validate([email.value])) return;
    }

    try {
      final LoginResponse loginResponse = await AuthService.login(
        email: email.value.value,
        phone: PhoneRequest(
          number: phone.value.value,
          countryId: country.value!.id,
        ),
        password: password.value.value,
        type: authMethod.value,
      );

      await StorageService.set<String>(StorageKeys.token, loginResponse.token);
      await StorageService.set<AuthUser>(StorageKeys.user, loginResponse.user);

      _setRemember();
      rootNavigatorKey.currentContext!.go('/chats');

      final AuthController authController = Get.find<AuthController>();

      authController.onLogin();
    } on ServiceException catch (e) {
      SnackbarService.show(e.message, type: SnackbarType.error);
    }
  }

  _setRemember() async {
    if (rememberMe.value) {
      await StorageService.set<String>(StorageKeys.email, email.value.value);
    }
    await StorageService.set<bool>(StorageKeys.rememberMe, rememberMe.value);
  }

  Rx<FormxInput<String>> search = const FormxInput<String>(
    value: '',
  ).obs;

  changeSearch(FormxInput<String> value) {
    search.value = value;
  }

  RxList<Country> countries = <Country>[].obs;

  List<Country> get filteredCountries {
    final searchQuery = search.value.value.trim().toLowerCase();
    return countries.where((c) {
      return c.name.toLowerCase().contains(searchQuery);
    }).toList();
  }

  Rx<Country?> country = Rx<Country?>(null);

  Rx<FormxInput<String>> phone = FormxInput<String>(
    value: '',
    validators: [Validators.required<String>()],
  ).obs;

  Rx<MaskInputFormatter> phoneFormatter =
      Rx<MaskInputFormatter>(MaskInputFormatter(
    mask: '#######################',
  ));

  void changeCountry(Country? newCountry) {
    country.value = newCountry;

    if (newCountry != null) {
      phoneFormatter.value = MaskInputFormatter(
        mask: newCountry.mask.replaceAll('9', '#'),
      );
    }
  }

  changePhone(FormxInput<String> value) {
    phone.value = value;
  }

  getCountries() async {
    try {
      countries.value = await CountriesService.getCountries();

      final String? countryCode = await IpService.getCountryFromIP();

      if (countryCode != null) {
        final country = countries.firstWhereOrNull((Country country) {
          return country.code == countryCode;
        });

        changeCountry(country);
      }
    } on ServiceException catch (e) {
      SnackbarService.show(e.message, type: SnackbarType.error);
    }
  }

  verifyAccount() async {
    FocusManager.instance.primaryFocus?.unfocus();

    phone.value = phone.value.touch();
    email.value = email.value.touch();

    if (authMethod.value == AuthMethod.phone) {
      if (!Formx.validate([phone.value])) return;
      if (country.value == null) return;
    }
    if (authMethod.value == AuthMethod.email) {
      if (!Formx.validate([email.value])) return;
    }

    try {
      final VerifyAccountResponse response = await AuthService.verifyAccount(
        email: authMethod.value == AuthMethod.email ? email.value.value : null,
        phone: authMethod.value == AuthMethod.phone
            ? PhoneRequest(
                number: phone.value.value,
                countryId: country.value!.id,
              )
            : null,
        type: authMethod.value,
      );

      if (response.exists) {
        rootNavigatorKey.currentContext!.push('/password');
      } else {
        final registerController = Get.find<RegisterController>();

        registerController.sendVerificationCode();
        rootNavigatorKey.currentContext!.push('/verify-code');
      }
    } on ServiceException catch (e) {
      SnackbarService.show(e.message);
    }
  }
}
