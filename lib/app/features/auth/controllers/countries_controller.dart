import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/auth/models/country.dart';
import 'package:talkie/app/features/auth/services/countries_service.dart';
import 'package:talkie/app/shared/plugins/formx/formx.dart';
import 'package:talkie/app/shared/services/ip_service.dart';
import 'package:talkie/app/shared/widgets/snackbar.dart';
import 'package:get/get.dart';

class CountriesController extends GetxController {
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

  void changeCountry(Country? newCountry) {
    country.value = newCountry;
  }

  getCountries() async {
    try {
      countries.value = await CountriesService.getCountries();

      final String? countryCode = await IpService.getCountryFromIP();

      if (countryCode != null) {
        country.value = countries.firstWhereOrNull((Country country) {
          return country.code == countryCode;
        });
      }
    } on ServiceException catch (e) {
      SnackbarService.show(e.message, type: SnackbarType.error);
    }
  }
}
