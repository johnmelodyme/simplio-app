import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/themes/sio_colors_dark.dart';
import 'package:sio_glyphs/sio_icons.dart';

class PopupDialog extends StatelessWidget {
  const PopupDialog({
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
    return Material(
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
                    SioColors.highlight1,
                    SioColors.vividBlue,
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
                          .apply(color: SioColorsDark.softBlack),
                    ),
                  ),
                  Gaps.gap10,
                  IconButton(
                      onPressed: () {
                        onCancel?.call();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(SioIcons.cancel)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
