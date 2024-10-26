import 'package:talkie/app/core/core.dart';

class NotificationsService {
  static Future<void> createFcmToken(String fcmToken) async {
    try {
      Map<String, dynamic> data = {
        "fcmToken": fcmToken,
      };
      await Api.post('/notifications/fcm-token', data: data);
    } catch (e) {
      throw ServiceException('An error occurred', e);
    }
  }
}
