import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class ApplicationRoute {
  final GlobalKey<NavigatorState> navigator;
  final List<RouteBase> routes;
  final FutureOr<String?> Function(
    BuildContext context,
    GoRouterState state,
  )? redirect;

  const ApplicationRoute({
    required this.navigator,
    this.redirect,
    this.routes = const <RouteBase>[],
  });

  GoRoute get route;
}
