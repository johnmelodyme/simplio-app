import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/data/model/network_wallet.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_exchange_form/asset_exchange_form_cubit.dart';
import 'package:simplio_app/view/extensions/number_extensions.dart';
import 'package:simplio_app/view/screens/mixins/wallet_utils_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/asset_wallet_item.dart';

class AssetFormAssetItem<B extends StateStreamable<S>, S extends AssetFormState>
    extends StatelessWidget with WalletUtilsMixin {
  final String label;
  final bool highlighted;
  final String sourceAssetWalletPropertyName;
  final String sourceNetworkWalletPropertyName;
  final GestureTapCallback? onTap;
  final bool isLoading;

  AssetFormAssetItem({
    required this.label,
    this.highlighted = false,
    this.sourceAssetWalletPropertyName = 'sourceAssetWallet',
    this.sourceNetworkWalletPropertyName = 'sourceNetworkWallet',
    this.isLoading = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Paddings.vertical10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: SioTextStyles.bodyL.apply(
              color: highlighted ? SioColors.mentolGreen : SioColors.secondary7,
            ),
          ),
          Gaps.gap5,
          BlocBuilder<B, S>(
            buildWhen: (prev, curr) =>
                prev.toMap()[sourceAssetWalletPropertyName] !=
                    curr.toMap()[sourceAssetWalletPropertyName] ||
                prev.toMap()[sourceNetworkWalletPropertyName] !=
                    curr.toMap()[sourceNetworkWalletPropertyName],
            builder: (context, state) {
              final AssetWallet assetWallet =
                  state.toMap()[sourceAssetWalletPropertyName];
              final NetworkWallet networkWallet =
                  state.toMap()[sourceNetworkWalletPropertyName];

              AssetDetail assetDetail =
                  Assets.getAssetDetail(assetWallet.assetId);
              AssetDetail networkDetail =
                  Assets.getNetworkDetail(networkWallet.networkId);

              // final assetId = context.read<B>().state.sourceAssetWallet.assetId;
              // final networkId =
              //     context.read<B>().state.sourceNetworkWallet.networkId;
              // NetworkWallet? networkWallet =
              // getNetwork(context, assetId.toString(), networkId.toString());

              // int assetId =
              //     context.read<B>().state.toMap()[assetIdPropertyName];
              // int networkId =
              //     context.read<B>().state.toMap()[networkIdPropertyName];

              // initial values during loading
              // if (assetId == -1 || networkId == -1) {
              //   assetId = context.read<B>().state.toMap()['assetId'];
              //   networkId = context.read<B>().state.toMap()['networkId'];
              // }
              // NetworkWallet? networkWallet =
              //     getNetwork(context, assetId.toString(), networkId.toString());

              return BlocBuilder<AccountWalletCubit, AccountWalletState>(
                buildWhen: (prev, state) => state is AccountWalletChanged,
                builder: (context, state) => Stack(
                  children: [
                    Opacity(
                      opacity: isLoading ? 0.2 : 1,
                      child: AssetWalletItem(
                        title: assetDetail.name,
                        balance: networkWallet.balance.getFormattedBalance(
                          networkWallet.preset.decimalPlaces,
                        ),
                        volume: networkWallet.fiatBalance
                            .getThousandValueWithCurrency(
                          locale: Intl.getCurrentLocale(),
                          currency: 'USD', // todo: use correct fiat
                        ),
                        subTitle: context.locale
                            .asset_receive_screen_crypto_chain(
                                networkDetail.name),
                        assetStyle: assetDetail.style,
                        assetType: AssetType.network,
                        onTap: isLoading ? null : onTap,
                      ),
                    ),
                    if (isLoading)
                      SizedBox(
                        height: getHeightByType(AssetType.network),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              context.locale.common_loading_with_dots,
                              style: SioTextStyles.bodyS.copyWith(
                                color: SioColors.highlight1,
                              ),
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
