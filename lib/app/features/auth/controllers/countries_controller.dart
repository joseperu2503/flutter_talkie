import 'package:reactive_forms/reactive_forms.dart';
import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/auth/models/country.dart';
import 'package:talkie/app/features/auth/services/countries_service.dart';
import 'package:talkie/app/shared/widgets/snackbar.dart';
import 'package:get/get.dart';

class CountriesController extends GetxController {
  RxList<Country> countries = <Country>[].obs;

  final search = FormControl<String>();

  initData() {
    search.updateValue('');
  }

  getCountries() async {
    try {
      countries.value = await CountriesService.getCountries();
    } on ServiceException catch (e) {
      SnackbarService.show(e.message, type: SnackbarType.error);
      rethrow;
    }
  }

  List<Country> get filteredCountries {
    final searchQuery = search.value?.trim().toLowerCase() ?? '';
    return countries.where((c) {
      return c.name.toLowerCase().contains(searchQuery);
    }).toList();
  }
}
