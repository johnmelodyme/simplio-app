import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/qr_address_field.dart';
import 'package:simplio_app/view/widgets/qr_code_horizontal_line_animation.dart';
import 'package:simplio_app/view/widgets/qr_code_mask.dart';
import 'package:simplio_app/view/widgets/qr_code_mask_painter.dart';
import 'package:simplio_app/view/widgets/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QrCodeScannerScreen extends StatefulWidget {
  const QrCodeScannerScreen({
    super.key,
  });

  @override
  State<QrCodeScannerScreen> createState() => _QrCodeScannerScreenState();
}

class _QrCodeScannerScreenState extends State<QrCodeScannerScreen> {
  String? address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.onPrimaryContainer,
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: Column(
          children: [
            ColorizedAppBar(
              firstPart: context.locale.qr_code_scanner_screen_connect,
              secondPart: context.locale.qr_code_scanner_screen_wallet,
              actionType: ActionType.close,
              onBackTap: () => Navigator.pop(context),
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
                            qrCodeCallback: (String value) async {
                              try {
                                await launchUrl(
                                  Uri.parse(value),
                                  mode: LaunchMode.externalApplication,
                                );
                              } catch (e) {
                                debugPrint('Couldn\'t open the link: $e');
                              }

                              setState(() {
                                address = value;
                              });
                            },
                            closedCallback: () {},
                            errorCallback: () {},
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
                const Gap(Dimensions.padding20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.padding16,
                  ),
                  child: QrAddressField(
                    address: address,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
