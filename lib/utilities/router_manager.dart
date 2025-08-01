import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:walletsolana/screens/login_screen.dart';
import 'package:walletsolana/screens/main_screen.dart';
import 'package:walletsolana/screens/mnemonic_screen.dart';
import 'package:walletsolana/screens/register_screen.dart';
import 'package:walletsolana/screens/start_screen.dart';
import 'package:walletsolana/screens/transfer_screen.dart';

class RouterManager {
  static GoRouter router() {
    return GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const StartScreen();
          },
          routes: <RouteBase>[
            GoRoute(
              path: 'login',
              builder: (BuildContext context, GoRouterState state) {
                return const LogInScreen();
              },
            ),
            GoRoute(
              path: 'register',
              builder: (BuildContext context, GoRouterState state) {
                return const RegisterScreen();
              },
            ),
            GoRoute(
              path: 'main',
              builder: (BuildContext context, GoRouterState state) {
                return const MainScreen();
              },
            ),
            GoRoute(
              path: 'mnemonic',
              builder: (BuildContext context, GoRouterState state) {
                return const MnemonicScreen();
              },
            ),

            GoRoute(
              path: 'transfer',
              builder: (BuildContext context, GoRouterState state) {
                final pk = state.extra as Map<String, dynamic>;
                return TransferScreen(pk: pk['q']);
              },
            ),
          ],
        ),
      ],
    );
  }
}
