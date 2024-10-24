import 'package:flutter/material.dart';
import 'package:talkie/app/app.dart';
import 'package:talkie/app/core/constants/environment.dart';
import 'package:talkie/app/core/router/app_router.dart';
import 'package:talkie/app/core/theme/app_theme.dart';
import 'package:get/get.dart';

void main() async {
  await Environment.initEnvironment();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      title: 'Talkie',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: ThemeMode.system,
      routeInformationParser: appRouter.routeInformationParser,
      routerDelegate: appRouter.routerDelegate,
      routeInformationProvider: appRouter.routeInformationProvider,
      builder: (context, child) => App(
        child: child,
      ),
    );
  }
}
