import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/wallet_connect_request_item.dart';

class WalletConnectRequestList extends StatelessWidget {
  final List<WalletConnectRequestItem> children;

  const WalletConnectRequestList({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SioColors.black.withAlpha(220),
      width: double.infinity,
      height: double.infinity,
      child: SafeArea(
        bottom: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 396,
              child: PageView.builder(
                itemCount: children.length,
                controller: PageController(viewportFraction: 0.86),
                itemBuilder: (context, index) => Padding(
                  padding: Paddings.all10,
                  child: children[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
