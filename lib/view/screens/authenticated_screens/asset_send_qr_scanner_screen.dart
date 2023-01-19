import 'package:flutter/material.dart';
import 'package:simplio_app/data/models/wallet.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/view/mixins/network_wallet_address_validator_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/qr_code_horizontal_line_animation.dart';
import 'package:simplio_app/view/widgets/qr_code_mask.dart';
import 'package:simplio_app/view/widgets/qr_code_mask_painter.dart';
import 'package:simplio_app/view/widgets/qr_code_scanner.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';

class AssetSendQrScannerScreenArguments {
  final NetworkId networkId;
  final void Function(
    String address,
  )? onScan;
  final void Function(
    Exception error,
  )? onError;

  const AssetSendQrScannerScreenArguments({
    required this.networkId,
    this.onScan,
    this.onError,
  });
}

class AssetSendQrScannerScreen extends StatelessWidget
    with NetworkWalletAddressValidatorMixin {
  final AssetSendQrScannerScreenArguments arguments;

  const AssetSendQrScannerScreen({
    super.key,
    required this.arguments,
  });

  @override
  Widget build(BuildContext context) {
    return SioScaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              SioColors.backGradient4Start,
              SioColors.softBlack,
            ],
          ),
        ),
        child: Column(
          children: [
            ColorizedAppBar(
              title: context.locale.asset_send_qr_scanner_screen_title,
              actionType: ActionType.close,
              // TODO - double check if this is the correct way to pop the screen.
              onBackTap: Navigator.of(context).pop,
            ),
            Column(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          color: SioColors.secondary5,
                          child: QrCodeScanner(
                            validator: validateAddress(
                              networkId: arguments.networkId,
                            ),
                            onScan: (String value) {
                              arguments.onScan?.call(value.trim());
                            },
                            onError: (_) {
                              // TODO - should get the error type with a message or code.
                              arguments.onError?.call(
                                Exception('Error while scanning QR code'),
                              );
                            },
                          ),
                        ),
                      ),
                      const Positioned(
                        top: Dimensions.padding16,
                        left: Dimensions.padding16,
                        bottom: Dimensions.padding16,
                        child: QrCodeMask(maskSide: MaskSide.left),
                      ),
                      const Positioned(
                        top: Dimensions.padding16,
                        right: Dimensions.padding16,
                        bottom: Dimensions.padding16,
                        child: QrCodeMask(maskSide: MaskSide.right),
                      ),
                      const Positioned(
                          top: Dimensions.padding32,
                          right: Dimensions.padding32,
                          left: Dimensions.padding32,
                          bottom: Dimensions.padding32,
                          child: QrCodeHorizontalLineAnimation()),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
