import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class GradientButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final TextStyle? textStyle;
  final Gradient? gradient;
  final BorderRadiusGeometry? borderRadius;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool isExpanded;
  final MainAxisAlignment mainAxisAlignment;

  const GradientButton({
    super.key,
    required this.label,
    this.icon,
    this.textStyle,
    this.gradient,
    this.borderRadius,
    this.constraints,
    this.padding,
    this.onTap,
    this.isExpanded = true,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final ts = textStyle ??
        SioTextStyles.bodyL.copyWith(
          color: SioColors.mentolGreen,
        );

    final content = Container(
      constraints: constraints ??
          const BoxConstraints(
            minHeight: 60,
          ),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadii.radius16,
        gradient: gradient ??
            LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                SioColors.backGradient3Start.withOpacity(0.5),
                SioColors.backGradient3End.withOpacity(0.5),
              ],
            ),
      ),
      child: Material(
        color: Colors.transparent,
        elevation: 0,
        child: InkWell(
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      right: Dimensions.padding10,
                    ),
                    child: Icon(
                      icon,
                      color: SioColors.mentolGreen,
                      size: (ts.fontSize ?? 16) + 4,
                    ),
                  ),
                Text(
                  label,
                  style: ts,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return isExpanded ? Flexible(child: content) : content;
  }
}
