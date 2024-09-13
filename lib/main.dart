import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/app.dart';
import 'package:flutter_talkie/app/core/constants/environment.dart';
import 'package:flutter_talkie/app/core/router/app_router.dart';
import 'package:flutter_talkie/app/core/theme/app_theme.dart';

void main() async {
  await Environment.initEnvironment();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Talkie',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(),
      routerConfig: appRouter,
      builder: (context, child) => App(
        child: child,
      ),
    );
  }
}
