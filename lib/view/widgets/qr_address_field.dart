import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';

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
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                address ?? '-',
                style: SioTextStyles.bodyL.apply(
                    color: address?.isNotEmpty == true
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSecondaryContainer),
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
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            )
          ],
        ));
  }
}
