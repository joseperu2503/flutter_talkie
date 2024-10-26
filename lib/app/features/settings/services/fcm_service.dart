import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging messaging = FirebaseMessaging.instance;

final FcmService fcmService = FcmService();

class FcmService {
  FcmService({
    this.onInit,
    this.handleMessage,
  });

  Function(String token)? onInit;
  Function(RemoteMessage message)? handleMessage;

  _onInit(String token) {
    if (onInit != null) {
      onInit!(token);
    } else {
      (token) {};
    }
  }

  _handleMessage(RemoteMessage message) {
    if (handleMessage != null) {
      handleMessage!(message);
    } else {
      (token) {};
    }
  }

  initNotifications() async {
    final settings = await requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await messaging.getToken();

      if (token == null) {
        throw 'An error occurred while obtaining the token.';
      }

      _onInit(token);
      initListeners();
    } else {
      throw 'Notification permissions not authorized.';
    }
  }

  initListeners() {
    _onForegroundMessage();
    _setupInteractedMessage();
  }

  Future<NotificationSettings> getStatus() async {
    return await messaging.getNotificationSettings();
  }

  void _onForegroundMessage() {
    //cuando la aplicacion esta siendo usada, en primer plano
    FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
  }

  void _handleRemoteMessage(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  }

  static Future<NotificationSettings> requestPermission() async {
    return await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  //configuracion de las interacciones con las notificaciones
  Future<void> _setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  Future<void> deleteToken() async {
    await messaging.deleteToken();
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Si vas a utilizar otros servicios de Firebase en segundo plano, como Firestore,
  // asegúrate de llamar a `initializeApp` antes de usar otros servicios de Firebase.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}
