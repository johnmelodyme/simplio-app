import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/themes/Constants.dart';
import 'package:simplio_app/view/themes/simplio_colors.dart';
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF062333),
              Color(0xFF031017),
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
                        top: PaddingSize.padding16,
                        left: PaddingSize.padding16,
                        bottom: PaddingSize.padding16,
                        child: QrCodeMask(maskSide: MaskSide.left),
                      ),
                      const Positioned(
                        top: PaddingSize.padding16,
                        right: PaddingSize.padding16,
                        bottom: PaddingSize.padding16,
                        child: QrCodeMask(maskSide: MaskSide.right),
                      ),
                      const Positioned(
                          top: PaddingSize.padding32,
                          right: PaddingSize.padding32,
                          left: PaddingSize.padding32,
                          bottom: PaddingSize.padding32,
                          child: QrCodeHorizontalLineAnimation()),
                    ],
                  ),
                ),
                const Gap(PaddingSize.padding20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: PaddingSize.padding16,
                  ),
                  child: QrAddressField(
                    address: address,
                  ),
                )
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
