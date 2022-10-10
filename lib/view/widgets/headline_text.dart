import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

enum HeadlineSize { large, medium, small }

//TODO.. remove this class and using text style from SioTextStyles
class HeadlineText extends StatelessWidget {
  final String data;
  final HeadlineSize headlineSize;
  final double? width;

  const HeadlineText(
    this.data, {
    super.key,
    this.headlineSize = HeadlineSize.medium,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle? style;
    switch (headlineSize) {
      case HeadlineSize.large:
        style = Theme.of(context).textTheme.headlineLarge;
        break;
      case HeadlineSize.medium:
        style = Theme.of(context).textTheme.headlineMedium;
        break;
      case HeadlineSize.small:
        style = Theme.of(context).textTheme.headlineSmall;
        break;
    }

    return SizedBox(
      width: width,
      child: Text(
        data,
        key: key,
        style: style?.apply(color: SioColors.whiteBlue),
        textAlign: TextAlign.center,
      ),
    );
  }
}
