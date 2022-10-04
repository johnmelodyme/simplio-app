import 'package:flutter/material.dart';

mixin Scroll {
  void scrollTo(GlobalKey key, double alignment) {
    if (key.currentContext != null) {
      Future.delayed(
        const Duration(milliseconds: 100),
        () => Scrollable.ensureVisible(
          key.currentContext!,
          alignment: alignment,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeIn,
        ),
      );
    }
  }
}
