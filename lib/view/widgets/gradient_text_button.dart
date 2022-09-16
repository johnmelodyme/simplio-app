import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';

// todo: correct background from design needs to be applied
class GradientTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final bool highlighted;
  final ButtonStyle? style;

  const GradientTextButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.highlighted,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Opacity(
            opacity: 0.2,
            child: Container(
              height: 30,
              width: 55,
              decoration: highlighted
                  ? BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.tertiary,
                        ],
                      ),
                      borderRadius: BorderRadiuses.radius12,
                    )
                  : null,
            ),
          ),
          TextButton(
            onPressed: onPressed,
            style: style ??
                ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadiuses.radius12,
                  ),
                )),
            child: child,
          ),
        ],
      ),
    );
  }
}
