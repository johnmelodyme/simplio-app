import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/themes/sio_colors_dark.dart';
import 'package:sio_glyphs/sio_icons.dart';

// todo: change this when design for errors is done
class PopupError extends StatelessWidget {
  const PopupError({
    Key? key,
    required this.message,
    required this.icon,
    this.onCancel,
  }) : super(key: key);

  final String message;
  final Widget icon;
  final VoidCallback? onCancel;

  @override
  Widget build(final BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (onCancel != null) onCancel!();
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
          ),
        ),
        Material(
          type: MaterialType.transparency,
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: Paddings.all16,
                  padding: Paddings.all12,
                  decoration: BoxDecoration(
                    color: SioColors.whiteBlue,
                    borderRadius: BorderRadii.radius20,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        SioColors.attentionGradient,
                        SioColors.attention,
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      icon,
                      Gaps.gap10,
                      Expanded(
                        child: Text(
                          message,
                          style: SioTextStyles.h5
                              .apply(color: SioColorsDark.whiteBlue),
                        ),
                      ),
                      Gaps.gap10,
                      IconButton(
                        onPressed: () {
                          onCancel?.call();
                        },
                        icon: const Icon(
                          SioIcons.cancel,
                          color: SioColorsDark.whiteBlue,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
