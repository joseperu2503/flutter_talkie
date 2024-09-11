import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/core/router/app_router.dart';

class SnackBarService {
  static void show(
    message, {
    Duration duration = const Duration(milliseconds: 3000),
  }) {
    if (rootNavigatorKey.currentContext == null) return;
    ScaffoldMessenger.of(rootNavigatorKey.currentContext!)
        .hideCurrentSnackBar();
    ScaffoldMessenger.of(rootNavigatorKey.currentContext!)
        .showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: Colors.black54,
      duration: duration,
    ));
  }
}
