import 'package:flutter/material.dart';
import 'package:talkie/app/core/controllers/theme_controller.dart';
import 'package:talkie/app/features/auth/controllers/auth_controller.dart';
import 'package:talkie/app/features/chat/controllers/chat_controller.dart';
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
    final authController = Get.put<AuthController>(AuthController());

    final chatController = Get.put<ChatController>(ChatController());
    final themeController = Get.put<ThemeController>(ThemeController());

    authController.initAutoLogout();
    chatController.connectSocket();
    chatController.getChats();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      themeController.getThemeModeFromStorage();
    });
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final chatController = Get.find<ChatController>();
    if (state == AppLifecycleState.resumed) {
      chatController.socket?.updateUserStatus(isConnected: true);
      // print('App en primer plano');
    } else if (state == AppLifecycleState.paused) {
      chatController.socket?.updateUserStatus(isConnected: false);
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
