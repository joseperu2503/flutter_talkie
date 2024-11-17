import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:talkie/app/app.dart';
import 'package:talkie/app/core/constants/breakpoints.dart';
import 'package:talkie/app/core/constants/environment.dart';
import 'package:talkie/app/core/router/app_router.dart';
import 'package:talkie/app/core/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:talkie/app/features/auth/screens/home_screen.dart';
import 'package:talkie/firebase_options.dart';

void main() async {
  await Environment.initEnvironment();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = Breakpoints.isMdDown(context) ? appRouter : appRouterDesktop;

    return GetMaterialApp.router(
      title: 'Talkie',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: ThemeMode.system,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      builder: (context, child) => App(
        child: child,
      ),
      // getPages: [
      //   GetPage(
      //     name: '/',
      //     page: () => HomeScreen(),
      //   )
      // ],
    );
  }
}
