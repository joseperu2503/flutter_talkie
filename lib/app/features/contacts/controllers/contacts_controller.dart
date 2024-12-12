import 'package:flutter/material.dart';
import 'package:mask_input_formatter/mask_input_formatter.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/auth/models/country.dart';
import 'package:talkie/app/features/auth/models/phone_request.dart';
import 'package:talkie/app/features/auth/services/auth_service.dart';
import 'package:talkie/app/features/auth/services/countries_service.dart';
import 'package:talkie/app/features/contacts/services/contacts_service.dart';
import 'package:talkie/app/shared/plugins/formx/formx.dart';
import 'package:talkie/app/shared/services/ip_service.dart';
import 'package:talkie/app/shared/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ContactsController extends GetxController {
  Rx<FormxInput<String>> email = FormxInput<String>(
    value: '',
    validators: [Validators.required<String>(), Validators.email()],
  ).obs;

  RxList<Country> countries = <Country>[].obs;

  Rx<Country?> country = Rx<Country?>(null);

  Rx<FormxInput<String>> phone = FormxInput<String>(
    value: '',
    validators: [Validators.required<String>()],
  ).obs;

  Rx<AuthMethod> authMethod = AuthMethod.phone.obs;

  Rx<FormxInput<String>> search = const FormxInput<String>(
    value: '',
  ).obs;

  resetUsername() {
    email.value = email.value.unTouch().updateValue('');
    phone.value = phone.value.unTouch().updateValue('');
    getCountries();
  }

  changeEmail(FormxInput<String> value) {
    email.value = value;
  }

  changeSearch(FormxInput<String> value) {
    search.value = value;
  }

  changePhone(FormxInput<String> value) {
    phone.value = value;
  }

  toggleAuthMethod() {
    authMethod.value = authMethod.value == AuthMethod.email
        ? AuthMethod.phone
        : AuthMethod.email;

    email.value = email.value.unTouch().updateValue('');
    phone.value = phone.value.unTouch().updateValue('');
  }

  addContact() async {
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
      final response = await ContactsService.addContact(
        email: email.value.value,
        phone: PhoneRequest(
          number: phone.value.value,
          countryId: country.value!.id,
        ),
        type: authMethod.value,
      );
      SnackbarService.show(response.message, type: SnackbarType.success);
      rootNavigatorKey.currentContext!.pop();
    } on ServiceException catch (e) {
      SnackbarService.show(e.message, type: SnackbarType.error);
    }
  }

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
}
