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
import 'package:simplio_app/view/themes/common_theme.dart';
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
    AssetWallet? assetWallet = getAssetWallet(context, assetId!);
    NetworkWallet? networkWallet = getNetwork(context, assetId!, networkId!);

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

        var address = getAddress(context, assetId!, networkId) ?? '';
        var assetDetail = Assets.getAssetDetail(assetWallet.assetId);
        var networkDetail = Assets.getNetworkDetail(networkWallet.networkId);

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
                    padding: CommonTheme.bottomPadding,
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
                    padding: CommonTheme.verticalPadding,
                    child: FractionallySizedBox(
                      widthFactor: 0.7,
                      child: ClipRRect(
                        borderRadius: CommonTheme.buttonBorderRadius,
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
                    padding: CommonTheme.verticalPadding,
                    child: Text(
                      'Your ${assetDetail.name} address',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: CommonTheme.horizontalPadding,
                    child: GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: address));
                          // todo: add notification for the user when the snackbar task is done
                        },
                        child: Container(
                          padding: CommonTheme.paddingAll,
                          decoration: BoxDecoration(
                            color: Theme.of(context).highlightColor,
                            borderRadius: CommonTheme.borderRadius,
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
                                padding: CommonTheme.leftPadding,
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
