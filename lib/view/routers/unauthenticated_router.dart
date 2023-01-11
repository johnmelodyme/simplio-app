import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/routers/unauthenticated_routes/password_reset_route.dart';
import 'package:simplio_app/view/routers/unauthenticated_routes/sign_in_route.dart';
import 'package:simplio_app/view/routers/unauthenticated_routes/sign_up_route.dart';
import 'package:simplio_app/view/routers/unauthenticated_routes/welcome_route.dart';

class UnauthenticatedRouter {
  final navRoot = GlobalKey<NavigatorState>();

  UnauthenticatedRouter();

  GoRouter get router => GoRouter(
        navigatorKey: navRoot,
        initialLocation: '/welcome',
        routes: [
          WelcomeRoute(
            navigator: navRoot,
          ).route,
          GoRoute(
            path: '/auth',
            parentNavigatorKey: navRoot,
            redirect: (context, __) => '/auth/sign-in',
            routes: [
              SignInRoute(
                navigator: navRoot,
              ).route,
              SignUpRoute(
                navigator: navRoot,
              ).route,
              PasswordResetRoute(
                navigator: navRoot,
              ).route,
            ],
          ),
        ],
      );
}
