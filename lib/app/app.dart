import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/features/auth/controllers/auth_controller.dart';
import 'package:flutter_talkie/app/features/chat/controllers/chat_controller.dart';
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

class _AppState extends State<App> {
  @override
  void initState() {
    final authController = Get.put<AuthController>(AuthController());

    final chatController = Get.put<ChatController>(ChatController());

    authController.initAutoLogout();
    chatController.connectSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child == null) return Container();

    return widget.child!;
  }
}
