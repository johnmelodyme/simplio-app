import 'package:flutter/material.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';

enum ButtonType { min, max }

class AssetMinMaxButton extends StatelessWidget {
  final VoidCallback onTap;
  final ButtonType buttonType;

  const AssetMinMaxButton({
    super.key,
    required this.onTap,
    required this.buttonType,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          alignment: Alignment.centerLeft),
      onPressed: onTap,
      child: Text(
        buttonType == ButtonType.min
            ? context.locale.common_min_label_uc
            : context.locale.common_max_label_uc,
        style: TextStyle(
          color: Theme.of(context).colorScheme.shadow,
        ),
      ),
    );
  }
}
