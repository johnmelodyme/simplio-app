import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/routes/settings/application_settings.dart';

mixin PageBuilderMixin {
  GoRouterPageBuilder pageBuilder({
    required Widget Function(GoRouterState state) builder,
    ApplicationSettings? settings,
    bool withTransition = true,
  }) {
    return (context, state) => withTransition
        ? MaterialPage(
            key: state.pageKey,
            child: builder(state),
            arguments: settings,
          )
        : NoTransitionPage(
            key: state.pageKey,
            child: builder(state),
            arguments: settings,
          );
  }
}
