import 'package:flutter/material.dart';
import 'package:mask_input_formatter/mask_input_formatter.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/auth/models/country.dart';
import 'package:talkie/app/features/auth/models/verify_phone.dart';
import 'package:talkie/app/features/auth/services/auth_service.dart';
import 'package:talkie/app/features/auth/services/countries_service.dart';
import 'package:talkie/app/shared/plugins/formx/formx.dart';
import 'package:talkie/app/shared/services/ip_service.dart';
import 'package:talkie/app/shared/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class PhoneController extends GetxController {
  Rx<FormxInput<String>> search = const FormxInput<String>(
    value: '',
  ).obs;

  changeSearch(FormxInput<String> value) {
    search.value = value;
  }

  RxList<Country> countries = <Country>[].obs;

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

  verifyPhone() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (country.value == null) return;

    phone.value = phone.value.touch();
    if (!Formx.validate([phone.value])) return;

    try {
      final VerifyPhoneResponse response = await AuthService.verifyPhone(
        number: phone.value.value,
        countryId: country.value!.id,
      );

      if (response.exists) {
        rootNavigatorKey.currentContext!.push('/password');
      }
    } on ServiceException catch (e) {
      SnackbarService.show(e.message);
    }
  }
}
