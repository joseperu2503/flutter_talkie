import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/auth/models/auth_user.dart';

class CountriesService {
  static Future<List<Country>> getCountries() async {
    try {
      final response = await Api.get('/countries');

      return List<Country>.from(response.data.map((x) => Country.fromJson(x)));
    } catch (e) {
      throw ServiceException('An error occurred while load countries', e);
    }
  }
}
