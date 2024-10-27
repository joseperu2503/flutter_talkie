import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static initEnvironment() async {
    await dotenv.load();
  }

  static String baseUrl = dotenv.get('BASE_URL');
  static String firebaseWebPushVapidKey =
      dotenv.get('FIREBASE_WEB_PUSH_VAPID_KEY');
}
