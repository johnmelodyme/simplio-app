import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/themed_text.dart';

class GradientTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool enabled;

  const GradientTextButton(
    this.text, {
    super.key,
    required this.onPressed,
    this.enabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onPressed : () => {},
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            height: Constants.buttonHeight,
            width: double.infinity,
            decoration: enabled
                ? BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomRight,
                      colors: [
                        SioColors.highlight1,
                        SioColors.vividBlue,
                      ],
                    ),
                    borderRadius: BorderRadii.radius30,
                  )
                : BoxDecoration(
                    color: SioColors.backGradient3Start,
                    borderRadius: BorderRadii.radius30,
                  ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadii.radius12,
            ),
            child: ThemedText(
              text,
              inverseColor: enabled,
              style: TextStyle(
                color: !enabled ? SioColors.secondary6 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
