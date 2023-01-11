import 'package:flutter/material.dart';

mixin RouteBuilderMixin {
  PageRoute<T> routeBuilder<T>({
    required Widget Function(BuildContext context) builder,
    bool withTransition = true,
  }) {
    return withTransition
        ? MaterialPageRoute<T>(
            builder: builder,
          )
        : PageRouteBuilder(
            pageBuilder: (context, _, __) => builder(context),
          );
  }
}
