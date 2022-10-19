import 'package:flutter/material.dart';
import 'package:simplio_app/view/widgets/popup_dialog.dart';

mixin PopupDialogMixin {
  Future<void> showPopup(
    final BuildContext context, {
    required String message,
    required Widget icon,
    Duration? hideAfter = const Duration(seconds: 3),
  }) async {
    bool popupIsActive = true;

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      useRootNavigator: true,
      builder: (context) => PopupDialog(
        icon: icon,
        message: message,
        onCancel: () {
          popupIsActive = false;
        },
      ),
    );

    if (hideAfter != null) {
      Future.delayed(hideAfter, () {
        if (popupIsActive) {
          Navigator.of(context).pop();
        }
      });
    }
  }
}
