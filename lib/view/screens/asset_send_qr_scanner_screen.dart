import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/asset_send_form/asset_send_form_cubit.dart';
import 'package:simplio_app/view/screens/mixins/popup_dialog_mixin.dart';

import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/themes/sio_colors_dark.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/qr_address_field.dart';
import 'package:simplio_app/view/widgets/qr_code_horizontal_line_animation.dart';
import 'package:simplio_app/view/widgets/qr_code_mask.dart';
import 'package:simplio_app/view/widgets/qr_code_mask_painter.dart';
import 'package:simplio_app/view/widgets/qr_code_scanner.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';
import 'package:sio_glyphs/sio_icons.dart';

class AssetSendQrScannerScreen extends StatefulWidget {
  const AssetSendQrScannerScreen({super.key});

  @override
  State<AssetSendQrScannerScreen> createState() =>
      _AssetSendQrScannerScreenState();
}

class _AssetSendQrScannerScreenState extends State<AssetSendQrScannerScreen>
    with PopupDialogMixin {
  String? address;

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
              firstPart: context.locale.asset_send_qr_scanner_screen_scan,
              secondPart:
                  context.locale.asset_send_qr_scanner_screen_address_lc,
              actionType: ActionType.close,
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
                              context
                                  .read<AssetSendFormCubit>()
                                  .changeFormValue(toAddress: value);

                              setState(() {
                                address = value;
                              });

                              showPopup(
                                context,
                                message:
                                    context.locale.asset_screens_address_copied,
                                icon: const Icon(
                                  SioIcons.verified,
                                  size: 50,
                                  color: SioColorsDark.softBlack,
                                ),
                                hideAfter: const Duration(milliseconds: 1500),
                                afterHideAction: () =>
                                    GoRouter.of(context).pop(),
                              );
                            },
                            closedCallback: () {},
                            errorCallback: () {
                              // todo: display error for the user
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
                Gaps.gap20,
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
