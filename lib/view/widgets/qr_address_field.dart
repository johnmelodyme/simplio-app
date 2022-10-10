import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class QrAddressField extends StatelessWidget {
  const QrAddressField({
    super.key,
    this.address,
  });

  final String? address;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20),
        decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.all(Radius.circular(RadiusSize.radius20)),
          color: SioColors.backGradient4Start,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                address ?? '-',
                style: SioTextStyles.bodyL.apply(
                    color: address?.isNotEmpty == true
                        ? SioColors.whiteBlue
                        : SioColors.secondary6),
              ),
            ),
            Gaps.gap5,
            IconButton(
              onPressed: () {
                if (address?.isNotEmpty == true) {
                  Clipboard.setData(
                    ClipboardData(text: address!),
                  );
                }
              },
              icon: Icon(
                Icons.copy,
                color: address?.isNotEmpty == true
                    ? SioColors.highlight2
                    : SioColors.secondary6,
              ),
            )
          ],
        ));
  }
}
