import 'package:flutter/material.dart';
import 'package:flutter_talkie/app/features/auth/screens/home_screen.dart';
import 'package:flutter_talkie/app/features/auth/services/auth_service.dart';
import 'package:flutter_talkie/app/features/contacts/screens/contacts_screen.dart';
import 'package:flutter_talkie/app/features/settings/screens/settings_screen.dart';
import 'package:flutter_talkie/app/shared/layouts/internal_layout.dart';
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
    return '/login';
  }

  return null;
}

GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
      parentNavigatorKey: rootNavigatorKey,
      redirect: unprotectedRoute,
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
      parentNavigatorKey: rootNavigatorKey,
      redirect: unprotectedRoute,
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatsScreen(),
      parentNavigatorKey: rootNavigatorKey,
      redirect: protectedRoute,
    ),
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state, navigationShell) {
        return InternalLayout(
          navigationShell: navigationShell,
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/chats',
              builder: (context, state) => const ChatsScreen(),
              redirect: protectedRoute,
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/contacts',
              builder: (context, state) => const ContactsScreen(),
              redirect: protectedRoute,
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
              redirect: protectedRoute,
            ),
          ],
        ),
      ],
    ),
  ],
);
