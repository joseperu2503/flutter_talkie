import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/auth/models/auth_user.dart';
import 'package:talkie/app/features/auth/services/countries_service.dart';
import 'package:talkie/app/shared/plugins/formx/formx.dart';
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

  getCountries() async {
    try {
      countries.value = await CountriesService.getCountries();
    } on ServiceException catch (e) {
      SnackbarService.show(e.message, type: SnackbarType.error);
    }
  }
}
