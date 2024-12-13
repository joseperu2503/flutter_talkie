import 'package:flutter/material.dart';
import 'package:mask_input_formatter/mask_input_formatter.dart';
import 'package:reactive_forms/reactive_forms.dart';
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
import 'package:talkie/app/shared/services/ip_service.dart';
import 'package:talkie/app/shared/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class LoginController extends GetxController {
  initData() {
    form.patchValue({
      'email': '',
      'phone': '',
      'password': '',
    });

    form.markAsUntouched();
  }

  final form = FormGroup({
    'email': FormControl<String>(validators: [
      Validators.required,
      Validators.email,
    ]),
    'phone': FormControl<String>(validators: [Validators.required]),
    'password': FormControl<String>(validators: [Validators.required]),
  });

  Rx<bool> rememberMe = false.obs;

  Rx<AuthMethod> authMethod = AuthMethod.email.obs;

  resetPassword() {
    form.patchValue({
      'password': '',
    });

    form.control('password').markAsUntouched();
  }

  toggleAuthMethod() {
    authMethod.value = authMethod.value == AuthMethod.email
        ? AuthMethod.phone
        : AuthMethod.email;

    form.patchValue({
      'email': '',
      'phone': '',
    });
  }

  login() async {
    FocusManager.instance.primaryFocus?.unfocus();

    form.markAllAsTouched();

    if (!validateAccount()) return;
    if (form.control('password').invalid) return;

    try {
      final LoginResponse loginResponse = await AuthService.login(
        email: authMethod.value == AuthMethod.email
            ? form.control('email').value
            : null,
        phone: authMethod.value == AuthMethod.phone
            ? PhoneRequest(
                number: form.control('phone').value,
                countryId: country.value!.id,
              )
            : null,
        password: form.control('password').value,
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
      await StorageService.set<String>(
        StorageKeys.email,
        form.control('email').value,
      );
    }
    await StorageService.set<bool>(StorageKeys.rememberMe, rememberMe.value);
  }

  RxList<Country> countries = <Country>[].obs;

  List<Country> get filteredCountries {
    final searchQuery = search.value?.trim().toLowerCase() ?? '';
    return countries.where((c) {
      return c.name.toLowerCase().contains(searchQuery);
    }).toList();
  }

  final search = FormControl<String>();

  Rx<Country?> country = Rx<Country?>(null);

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

  bool validateAccount() {
    if (authMethod.value == AuthMethod.phone) {
      if (form.control('phone').invalid) return false;
      if (country.value == null) return false;
    }
    if (authMethod.value == AuthMethod.email) {
      if (form.control('email').invalid) return false;
    }

    return true;
  }

  verifyAccount() async {
    FocusManager.instance.primaryFocus?.unfocus();

    form.markAllAsTouched();

    if (!validateAccount()) return;

    try {
      final VerifyAccountResponse response = await AuthService.verifyAccount(
        email: authMethod.value == AuthMethod.email
            ? form.control('email').value
            : null,
        phone: authMethod.value == AuthMethod.phone
            ? PhoneRequest(
                number: form.control('phone').value,
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
