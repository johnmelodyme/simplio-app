import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

enum ValidationTextType {
  info(Icons.info_outline),
  warning(Icons.warning_outlined),
  error(Icons.error_outline);

  final IconData icon;

  const ValidationTextType(this.icon);
}

class ValidationText extends StatelessWidget {
  final IconData? icon;
  final String data;
  final ValidationTextType type;
  final bool displayIcon;

  const ValidationText(
    this.data, {
    super.key,
    this.type = ValidationTextType.info,
    this.icon,
    this.displayIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final i = icon ?? type.icon;
    final s = _getStyle(type);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (displayIcon)
          Padding(
            padding: const EdgeInsets.only(
              right: Dimensions.padding6,
              top: Dimensions.padding2,
            ),
            child: Icon(
              i,
              color: s.color,
              size: 16,
            ),
          ),
        Flexible(
          child: Text(
            data,
            style: s,
            overflow: TextOverflow.ellipsis,
            maxLines: 6,
          ),
        ),
      ],
    );
  }

  TextStyle _getStyle(ValidationTextType type) {
    final baseStyle = SioTextStyles.bodyS;
    switch (type) {
      case ValidationTextType.error:
        return baseStyle.copyWith(
          color: SioColors.attention,
        );
      case ValidationTextType.warning:
        return baseStyle.copyWith(
          color: SioColors.highlight,
        );
      default:
        return baseStyle.copyWith(
          color: SioColors.whiteBlue,
        );
    }
  }
}
