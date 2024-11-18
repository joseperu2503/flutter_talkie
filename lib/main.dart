import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talkie/app/app.dart';
import 'package:talkie/app/core/constants/breakpoints.dart';
import 'package:talkie/app/core/constants/environment.dart';
import 'package:talkie/app/core/router/app_router.dart';
import 'package:talkie/app/core/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
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

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  RouterType _previousRouterType = RouterType.mobile;

  GoRouter router = appRouterMobile('/', RouterType.mobile);

  RouterType get routerType {
    RouterType currentRouterType;

    // Determina el tipo de router según el tamaño de la pantalla
    if (Breakpoints.isMdDown(context)) {
      currentRouterType = RouterType.mobile;
    } else {
      currentRouterType = RouterType.desktop;
    }

    if (currentRouterType != _previousRouterType) {
      _previousRouterType = currentRouterType;

      String currentRoute =
          router.routerDelegate.currentConfiguration.uri.toString();

      setState(() {
        router = appRouterMobile(currentRoute, currentRouterType);
      });
    }

    return currentRouterType;
  }

  @override
  Widget build(BuildContext context) {
    routerType;

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
    );
  }
}
