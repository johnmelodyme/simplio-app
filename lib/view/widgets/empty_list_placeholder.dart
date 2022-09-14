import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';

class EmptyListPlaceholder extends StatelessWidget {
  const EmptyListPlaceholder({
    super.key,
    required this.child,
    this.label,
    this.width = 156,
  });

  final Widget child;
  final String? label;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: width,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                spreadRadius: width / 6,
                blurRadius: width / 4,
                offset: const Offset(1, 1),
              ),
            ]),
            child: child),
        if (label?.isNotEmpty == true) ...{
          Text(
            label!,
            textAlign: TextAlign.center,
            style: SioTextStyles.bodyPrimary.apply(
              color: Theme.of(context).colorScheme.shadow,
            ),
          ),
        }
      ],
    );
  }
}
