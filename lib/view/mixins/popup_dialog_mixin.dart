import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/popup_dialog.dart';
import 'package:simplio_app/view/widgets/popup_error.dart';
import 'package:sio_glyphs/sio_icons.dart';

// TODO -remove this implementation of dialog and use modal bottom sheet instead.
mixin PopupDialogMixin {
  Future<void> showPopup(
    final BuildContext context, {
    required String message,
    required Widget icon,
    Duration hideAfter = const Duration(seconds: 3),
    Function? afterHideAction,
  }) async {
    bool popupIsActive = true;
    Timer? timer;

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      useRootNavigator: true,
      builder: (context) => PopupDialog(
        icon: icon,
        message: message,
        onCancel: () {
          afterHideAction != null ? afterHideAction() : null;

          if (popupIsActive) {
            Navigator.of(context).pop();
          }
          if (timer != null) timer.cancel();
          popupIsActive = false;
        },
      ),
    );

    timer = Timer(hideAfter, () {
      if (popupIsActive) {
        if (Navigator.maybeOf(context) != null &&
            Navigator.canPop(context) == true) {
          Navigator.of(context).pop();
        }
        afterHideAction != null ? afterHideAction() : null;
        if (timer != null) timer.cancel();
        popupIsActive = false;
      }
    });
  }

  // TODO - use Scaffold snack bar message with a custom widget instead.
  Future<void> showError(
    final BuildContext context, {
    required String message,
    Duration hideAfter = const Duration(seconds: 3),
    Function? afterHideAction,
  }) async {
    bool popupIsActive = true;
    Timer? timer;

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      useRootNavigator: true,
      builder: (context) => PopupError(
        icon: Icon(
          SioIcons.error_outline,
          size: 40,
          color: SioColors.whiteBlue,
        ),
        message: message,
        onCancel: () {
          afterHideAction != null ? afterHideAction() : null;

          if (popupIsActive) {
            Navigator.of(context).pop();
          }
          if (timer != null) timer.cancel();
          popupIsActive = false;
        },
      ),
    );

    timer = Timer(hideAfter, () {
      if (popupIsActive) {
        if (Navigator.maybeOf(context) != null && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
        afterHideAction != null ? afterHideAction() : null;
        if (timer != null) timer.cancel();
        popupIsActive = false;
      }
    });
  }
}
