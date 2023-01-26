import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/themes/sio_colors_dark.dart';
import 'package:sio_glyphs/sio_icons.dart';

class DialogContent extends StatelessWidget {
  const DialogContent({
    Key? key,
    required this.message,
    required this.icon,
    required this.popupContentType,
  }) : super(key: key);

  final String message;
  final Widget icon;
  final PopupContentType popupContentType;

  factory DialogContent.regular({
    Key? key,
    required String message,
    required Widget icon,
    VoidCallback? onCancel,
  }) {
    return _DialogContent(
      message: message,
      icon: icon,
      popupContentType: PopupContentType.regular,
    );
  }

  factory DialogContent.error({
    Key? key,
    required String message,
    Widget? icon,
    VoidCallback? onCancel,
  }) {
    return _DialogContent(
      message: message,
      icon: icon ??
          Icon(
            SioIcons.error_outline,
            size: 40,
            color: SioColors.whiteBlue,
          ),
      popupContentType: PopupContentType.error,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return _DialogContent(
      message: message,
      icon: icon,
      popupContentType: popupContentType,
    );
  }
}

class _DialogContent extends DialogContent {
  const _DialogContent(
      {required super.message,
      required super.icon,
      required super.popupContentType});

  List<Color> get _gradientColors {
    if (popupContentType == PopupContentType.regular) {
      return [
        SioColors.highlight1,
        SioColors.vividBlue,
      ];
    } else {
      return [
        SioColors.attentionGradient,
        SioColors.attention,
      ];
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: Paddings.all12,
      decoration: BoxDecoration(
        color: SioColors.whiteBlue,
        borderRadius: BorderRadii.radius20,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradientColors,
        ),
      ),
      child: Row(
        children: [
          icon,
          Gaps.gap10,
          Expanded(
            child: Text(
              message,
              style: SioTextStyles.h5.apply(
                color: popupContentType == PopupContentType.regular
                    ? SioColorsDark.softBlack
                    : SioColorsDark.whiteBlue,
              ),
            ),
          ),
          Gaps.gap10,
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              icon: Icon(
                SioIcons.cancel,
                color: popupContentType == PopupContentType.regular
                    ? SioColorsDark.softBlack
                    : SioColorsDark.whiteBlue,
              )),
        ],
      ),
    );
  }
}

enum PopupContentType {
  regular,
  error,
}
