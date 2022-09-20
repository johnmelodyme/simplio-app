import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
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
      children: [
        Stack(children: [
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 105,
                width: 105,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                      Radius.circular(RadiusSize.radius186)),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .tertiary
                          .withOpacity(0.1),
                      spreadRadius: RadiusSize.radius186 / 2,
                      blurRadius: RadiusSize.radius186,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: width,
              child: Container(
                child: child,
              ),
            ),
          ),
        ]),
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
