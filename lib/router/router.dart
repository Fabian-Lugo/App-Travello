import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travell_app/layout/layout_scaffold.dart';
import 'package:travell_app/router/app_routes.dart';
import 'package:travell_app/screens/custom_splash_screen.dart';
import 'package:travell_app/screens/home_screen.dart';
import 'package:travell_app/screens/login_screen.dart';
import 'package:travell_app/screens/profile_screen.dart';
import 'package:travell_app/screens/register_screen.dart';
import 'package:travell_app/screens/slider_screen.dart';
import 'package:travell_app/screens/verification_register.dart';
import 'package:travell_app/screens/settings_screen.dart';
import 'package:travell_app/session/app_session.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const CustomSplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.slider,
      builder: (context, state) => const SliderScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScren(),
    ),
    GoRoute(
      path: AppRoutes.verification,
      builder: (context, state) {
        final email = state.extra as String? ?? '';
        return VerificationRegisterScreen(email: email);
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => 
        LayoutScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => HomeScreen(name: currentAppUser?.name),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: AppRoutes.settings,
                  builder: (context, state) => const SettingsScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    )
  ],
);