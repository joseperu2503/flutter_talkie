import 'package:flutter/material.dart';
import 'package:talkie/app/core/constants/breakpoints.dart';
import 'package:talkie/app/features/auth/screens/home_screen.dart';
import 'package:talkie/app/features/auth/screens/otp_screen.dart';
import 'package:talkie/app/features/auth/screens/password_screen.dart';
import 'package:talkie/app/features/auth/screens/auth_screen.dart';
import 'package:talkie/app/features/auth/screens/register_screen.dart';
import 'package:talkie/app/features/auth/services/auth_service.dart';
import 'package:talkie/app/features/chat/screens/chat_screen.dart';
import 'package:talkie/app/features/contacts/screens/contacts_screen.dart';
import 'package:talkie/app/features/settings/screens/settings_screen.dart';
import 'package:talkie/app/shared/layouts/internal_layout.dart';
import 'package:go_router/go_router.dart';
import 'package:talkie/app/features/auth/screens/login_screen.dart';
import 'package:talkie/app/features/chat/screens/chats_screen.dart';

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

enum RouterType { mobile, desktop }

appRouterMobile(String initialLocation, RouterType routerType) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
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
        path: '/phone',
        builder: (context, state) => const AuthScreen(),
        parentNavigatorKey: rootNavigatorKey,
        redirect: unprotectedRoute,
      ),
      GoRoute(
        path: '/password',
        builder: (context, state) => const PasswordScreen(),
        parentNavigatorKey: rootNavigatorKey,
        redirect: unprotectedRoute,
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
        parentNavigatorKey: rootNavigatorKey,
        redirect: unprotectedRoute,
      ),
      GoRoute(
        path: '/verify-code',
        builder: (context, state) => const OtpScreen(),
        parentNavigatorKey: rootNavigatorKey,
        redirect: unprotectedRoute,
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
              ShellRoute(
                builder: (context, state, child) {
                  if (Breakpoints.isMdDown(context)) {
                    return child;
                  }
                  return Scaffold(
                    appBar: AppBar(
                      toolbarHeight: 0,
                      scrolledUnderElevation: 0,
                    ),
                    backgroundColor: Colors.transparent,
                    body: Row(
                      children: [
                        SizedBox(
                          width: Breakpoints.isMdUp(context) ? 450 : null,
                          child: const ChatsScreen(),
                        ),
                        Expanded(child: child),
                      ],
                    ),
                  );
                },
                routes: [
                  GoRoute(
                      path: '/chats',
                      builder: (context, state) {
                        if (Breakpoints.isMdDown(context)) {
                          return const ChatsScreen();
                        }
                        return Container();
                      },
                      redirect: protectedRoute,
                      routes: [
                        GoRoute(
                          path: ':chatId',
                          parentNavigatorKey: routerType == RouterType.mobile
                              ? rootNavigatorKey
                              : null,
                          builder: (context, state) {
                            final chatId =
                                state.pathParameters['chatId'] ?? 'no-chatId';

                            return ChatScreen(chatId: chatId);
                          },
                          redirect: protectedRoute,
                        ),
                      ]),
                ],
              )
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
}
