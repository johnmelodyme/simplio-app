import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';

mixin SnackBarMixin {
  Future<void> showSnackBar(
    final BuildContext context, {
    required Widget content,
    Duration duration = const Duration(seconds: 3),
    double elevation = 0,
    Color backgroundColor = Colors.transparent,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    EdgeInsetsGeometry margin = Paddings.all16,
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: content,
        margin: margin,
        behavior: behavior,
        backgroundColor: backgroundColor,
        duration: duration,
        elevation: elevation,
      ),
    );
  }
}
