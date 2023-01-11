import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/wallet_connect/wallet_connect_cubit.dart';
import 'package:simplio_app/view/mixins/wallet_connect_uri_validator_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/qr_code_horizontal_line_animation.dart';
import 'package:simplio_app/view/widgets/qr_code_mask.dart';
import 'package:simplio_app/view/widgets/qr_code_mask_painter.dart';
import 'package:simplio_app/view/widgets/qr_code_scanner.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';

class WalletConnectQrScannerScreen extends StatelessWidget
    with WalletConnectUriValidatorMixin {
  const WalletConnectQrScannerScreen({super.key});

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
              title: context.locale.qr_code_scanner_screen_title,
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
                            validator: validateWalletConnectUri,
                            onScan: (String value) async {
                              final s =
                                  context.read<AccountWalletCubit>().state;
                              if (s is! AccountWalletProvided) return;

                              context
                                  .read<WalletConnectCubit>()
                                  .openRequestedSession(
                                    s.wallet.uuid,
                                    uri: value,
                                  );

                              GoRouter.of(context).pop();
                            },
                            // TODO - display error message. Popup causes a bug.
                            onError: (error) {
                              GoRouter.of(context).pop();
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
                        child: QrCodeHorizontalLineAnimation(),
                      ),
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
