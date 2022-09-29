import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';

enum SmallButtonType { solid, highlighted, bordered }

class SmallButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final SmallButtonType type;
  final String label;
  final Color labelColor;
  final Color? borderColor;

  const SmallButton({
    super.key,
    this.onPressed,
    required this.type,
    required this.label,
    required this.labelColor,
    this.borderColor,
  }) : assert(
          type != SmallButtonType.bordered ||
              (type == SmallButtonType.bordered && borderColor != null),
          'If type is bordered , then specify borderColor !',
        );

  @override
  Widget build(BuildContext context) {
    Widget child = Padding(
      padding: Paddings.horizontal16,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: SioTextStyles.buttonSmall.copyWith(
          height: 1.0,
          color: labelColor,
        ),
      ),
    );

    if (type == SmallButtonType.highlighted) {
      child = Ink(
        height: Constants.smallButtonHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.tertiary,
            ],
          ),
          borderRadius: BorderRadiuses.radius30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            child,
          ],
        ),
      );
    }

    return ConstrainedBox(
      constraints:
          const BoxConstraints.tightFor(height: Constants.smallButtonHeight),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            type == SmallButtonType.bordered
                ? Colors.transparent
                : Theme.of(context).colorScheme.primaryContainer,
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.zero,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadiuses.radius30,
            side: type == SmallButtonType.bordered
                ? BorderSide(
                    width: 0.5,
                    color: borderColor!,
                  )
                : BorderSide.none,
          )),
          elevation: MaterialStateProperty.all<double>(0),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
