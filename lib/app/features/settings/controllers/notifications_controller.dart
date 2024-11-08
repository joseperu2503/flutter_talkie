import 'package:talkie/app/core/core.dart';
import 'package:talkie/app/features/settings/services/fcm_service.dart';
import 'package:talkie/app/features/settings/services/notifications_service.dart';
import 'package:talkie/app/shared/widgets/snackbar.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  init() {
    fcmService.onInit = (token) {
      createFcmToken(token);
    };
    fcmService.initNotifications();
  }

  createFcmToken(String token) async {
    try {
      await NotificationsService.createFcmToken(token);
    } on ServiceException catch (e) {
      SnackbarService.show(e.message, type: SnackbarType.error);
    }
  }
}
