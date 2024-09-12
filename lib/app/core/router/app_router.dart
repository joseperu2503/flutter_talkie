import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/features/auth/services/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_talkie/app/features/auth/screens/login_screen.dart';
import 'package:flutter_talkie/app/features/chat/screens/chats_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

Future<String?> unprotectedRoute(
    BuildContext context, GoRouterState state) async {
  final (validToken, _) = await AuthService.verifyToken();

  if (validToken) {
    return '/chats';
  }

  return null;
}

Future<String?> protectedRoute(
    BuildContext context, GoRouterState state) async {
  final (validToken, _) = await AuthService.verifyToken();

  if (!validToken) {
    return '/';
  }

  return null;
}

GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
      parentNavigatorKey: rootNavigatorKey,
      redirect: unprotectedRoute,
    ),
    GoRoute(
      path: '/chats',
      builder: (context, state) => const ChatsScreen(),
      parentNavigatorKey: rootNavigatorKey,
      redirect: protectedRoute,
    ),
  ],
);
