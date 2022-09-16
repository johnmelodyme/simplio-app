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
import 'package:simplio_app/view/widgets/headline_text.dart';

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
        final networkDetail = Assets.getNetworkDetail(networkWallet.networkId);

        return Scaffold(
          appBar: AppBar(
            title: HeadlineText(
              '${context.locale.asset_receive_screen_receive_coins_btn} ${assetDetail.name}',
              headlineSize: HeadlineSize.small,
            ),
            elevation: 0,
          ),
          body: SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: Paddings.bottom20,
                    child: Text(
                      '(${networkDetail.name} ${context.locale.asset_receive_screen_network})',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Icon(
                    assetDetail.style.icon,
                    size: 40,
                    color: assetDetail.style.primaryColor,
                  ),
                  Padding(
                    padding: Paddings.vertical20,
                    child: FractionallySizedBox(
                      widthFactor: 0.7,
                      child: ClipRRect(
                        borderRadius: BorderRadiuses.radius6,
                        child: QrImage(
                          data: address,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: Paddings.vertical20,
                    child: Text(
                      context.locale.asset_receive_screen_your_crypto_address(
                          assetDetail.name),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: Paddings.horizontal20,
                    child: GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: address));
                          // todo: add notification for the user when the snackbar task is done
                        },
                        child: Container(
                          padding: Paddings.all20,
                          decoration: BoxDecoration(
                            color: Theme.of(context).highlightColor,
                            borderRadius: BorderRadiuses.radius12,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  address,
                                  style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.fontSize,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: Paddings.left10,
                                child: Icon(
                                  Icons.copy_outlined,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ]),
          ),
        );
      },
    );
  }
}
