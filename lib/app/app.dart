import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:talkie/app/core/controllers/theme_controller.dart';
import 'package:talkie/app/features/auth/controllers/auth_controller.dart';
import 'package:talkie/app/features/auth/controllers/register_controller.dart';
import 'package:talkie/app/features/auth/services/auth_service.dart';
import 'package:talkie/app/features/chat/controllers/chat_controller.dart';
import 'package:talkie/app/features/settings/controllers/notifications_controller.dart';
import 'package:talkie/app/shared/widgets/snackbar.dart';
import 'package:get/get.dart';

class App extends StatefulWidget {
  const App({
    super.key,
    required this.child,
  });

  final Widget? child;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    initServices();

    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  initServices() async {
    final themeController = Get.put<ThemeController>(ThemeController());
    final AuthController authController =
        Get.put<AuthController>(AuthController());

    Get.put<ChatController>(ChatController());
    Get.put<NotificationsController>(NotificationsController());
    Get.put(RegisterController());

    await themeController.getThemeModeFromStorage();
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        FlutterNativeSplash.remove();
      },
    );

    final (validToken, timeRemainingInSeconds) =
        await AuthService.verifyToken();

    if (validToken) {
      authController.onLogin();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final chatController = Get.find<ChatController>();
    if (state == AppLifecycleState.resumed) {
      chatController.socket?.updateDeviceConnectionStatus(isConnected: true);
      // print('App en primer plano');
    }

    if (state == AppLifecycleState.paused) {
      chatController.socket?.updateDeviceConnectionStatus(isConnected: false);
      // print('App en segundo plano');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child == null) return Container();

    return SnackbarProvider(
      child: widget.child!,
    );
  }
}
