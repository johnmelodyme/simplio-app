import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';

enum BodySize { large, medium, small }

class BodyText extends StatelessWidget {
  final String data;
  final BodySize bodySize;
  final double? width;
  final TextAlign? textAlign;
  final TextStyle? style;

  const BodyText(
    this.data, {
    super.key,
    this.bodySize = BodySize.medium,
    this.width,
    this.textAlign = TextAlign.left,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle? style;
    switch (bodySize) {
      case BodySize.large:
        style = Theme.of(context).textTheme.bodyLarge;
        break;
      case BodySize.medium:
        style = Theme.of(context).textTheme.bodyMedium;
        break;
      case BodySize.small:
        style = Theme.of(context).textTheme.bodySmall;
        break;
    }

    return SizedBox(
      width: width,
      child: Padding(
        padding: Paddings.vertical10,
        child: Text(
          data,
          key: key,
          style: this.style != null ? style!.merge(this.style) : style,
          textAlign: textAlign,
        ),
      ),
    );
  }
}
