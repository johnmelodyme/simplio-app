import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:sio_glyphs/sio_icons.dart';

class PasswordRulesRow extends StatelessWidget {
  final String text;
  final bool passed;

  const PasswordRulesRow({super.key, required this.text, required this.passed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  passed ? SioIcons.done : SioIcons.cancel,
                  size: 20,
                  color: passed ? SioColors.vividBlue : SioColors.attention,
                ),
              ),
            ),
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  text,
                  style: TextStyle(
                      color: passed ? SioColors.whiteBlue : SioColors.attention,
                      fontSize:
                          Theme.of(context).textTheme.titleMedium?.fontSize),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
