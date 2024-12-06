import 'package:dio/dio.dart';

class IpService {
  static Future<String?> getCountryFromIP() async {
    final dio = Dio();
    const url = 'http://ip-api.com/json';

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        String country = data['country'];
        String countryCode = data['countryCode'];
        print('País: $country, Código: $countryCode');
        return countryCode;
      } else {
        print('Error al obtener el país: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
