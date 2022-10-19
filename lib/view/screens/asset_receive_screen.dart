import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/data/model/network_wallet.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/view/screens/mixins/wallet_utils_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';
import 'package:sio_glyphs/sio_icons.dart';

class AssetReceiveScreen extends StatelessWidget with WalletUtilsMixin {
  final String? assetId;
  final String? networkId;

  const AssetReceiveScreen({
    super.key,
    required this.assetId,
    required this.networkId,
  });

  @override
  Widget build(BuildContext context) {
    final AssetWallet? assetWallet = getAssetWallet(context, assetId!);
    final NetworkWallet? networkWallet =
        getNetwork(context, assetId!, networkId!);

    return BlocBuilder<AccountWalletCubit, AccountWalletState>(
      builder: (context, state) {
        if (state is! AccountWalletProvided) {
          throw Exception('No AccountWallet Provided');
          // todo: add notification for the user when the snackbar task is done
        }

        if (assetWallet == null) {
          throw Exception('No AssetWallet Provided');
        }

        if (networkWallet == null) {
          throw Exception('No Network Provided');
        }

        final address = getAddress(context, assetId!, networkId) ?? '';
        final assetDetail = Assets.getAssetDetail(assetWallet.assetId);

        return SioScaffold(
          body: CustomScrollView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: ColorizedAppBar(
                  firstPart:
                      context.locale.asset_receive_screen_receive_coins_btn,
                  secondPart: assetDetail.name,
                  actionType: ActionType.close,
                  onBackTap: () => Navigator.pop(context),
                  onShareTap: () {},
                ),
              ),
              SliverToBoxAdapter(
                child: Stack(children: [
                  Padding(
                    padding: Paddings.horizontal16,
                    child: GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: address));
                          // todo: add notification for the user when the snackbar task is done
                        },
                        child: Container(
                          margin: Paddings.top30,
                          padding: Paddings.all30,
                          decoration: BoxDecoration(
                            color: SioColors.secondary1,
                            borderRadius: BorderRadii.radius20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Gaps.gap30,
                              FractionallySizedBox(
                                widthFactor: 0.7,
                                child: ClipRRect(
                                  borderRadius: BorderRadii.radius20,
                                  child: QrImage(
                                    data: address,
                                    foregroundColor: SioColors.black,
                                    backgroundColor: SioColors.whiteBlue,
                                  ),
                                ),
                              ),
                              Gaps.gap35,
                              Text(
                                context.locale
                                    .asset_receive_screen_your_crypto_address(
                                  assetDetail.name,
                                ),
                                style: SioTextStyles.bodyL.apply(
                                  color: SioColors.secondary7,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Gaps.gap12,
                              Text(
                                address,
                                textAlign: TextAlign.center,
                                style: SioTextStyles.bodyPrimary.apply(
                                  color: SioColors.mentolGreen,
                                ),
                              ),
                              Gaps.gap17,
                              Icon(
                                SioIcons.copy,
                                color: SioColors.vividBlue,
                              ),
                            ],
                          ),
                        )),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: assetDetail.style.icon,
                    ),
                  ),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
