import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/core/routes/app_router.dart';
import 'package:flutter_talkie/app/core/theme/app_theme.dart';

void main() {
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
    );
  }
}
