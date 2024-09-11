import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_talkie/app/features/auth/screens/login_screen.dart';
import 'package:flutter_talkie/app/features/chat/screens/chats_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
      parentNavigatorKey: rootNavigatorKey,
    ),
    GoRoute(
      path: '/chats',
      builder: (context, state) => const ChatsScreen(),
      parentNavigatorKey: rootNavigatorKey,
    ),
  ],
);
