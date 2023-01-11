import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/expansion_list/expansion_list_cubit.dart';
import 'package:simplio_app/view/extensions/number_extensions.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/asset_search_item.dart';
import 'package:simplio_app/view/widgets/network_wallet_search_item.dart';
import 'package:simplio_app/view/widgets/sio_expansion_radio_panel.dart';

class CryptoAssetExpansionList extends StatefulWidget {
  final List<CryptoAssetData> children;
  final void Function(NetworkData data, AssetAction assetAction) onTap;
  final bool withoutPadding;

  const CryptoAssetExpansionList({
    super.key,
    this.children = const <CryptoAssetData>[],
    required this.onTap,
    this.withoutPadding = false,
  });

  @override
  State<StatefulWidget> createState() => _CryptoAssetExpansionList();
}

class _CryptoAssetExpansionList extends State<CryptoAssetExpansionList> {
  AssetAction selectedAssetAction = AssetAction.addToInventory;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountWalletCubit, AccountWalletState>(
        buildWhen: (prev, curr) => curr is AccountWalletChanged,
        builder: (context, accountWalletState) {
          if (accountWalletState is! AccountWalletProvided) {
            throw Exception('No asset wallet found');
          }
          return SioExpansionRadioPanel(
            animationDuration: const Duration(milliseconds: 500),
            children: widget.children.map(
              (a) {
                final asset = Assets.getAssetDetail(a.assetId);

                final expansionPanel = ExpansionPanelRadio(
                  backgroundColor: SioColors.softBlack,
                  value: UniqueKey(),
                  headerBuilder: (context, _) {
                    return Padding(
                      padding: widget.withoutPadding
                          ? EdgeInsets.zero
                          : const EdgeInsets.only(
                              top: Dimensions.padding10,
                              left: Dimensions.padding16,
                              right: Dimensions.padding16,
                            ),
                      child: AssetSearchItem(
                        label: a.name,
                        priceLabel: a.price.getThousandValueWithCurrency(
                          currency: 'USD', //TODO.. replace by real currency
                          locale: Intl.getCurrentLocale(),
                        ),
                        assetIcon: asset.style.icon,
                        assetAction: a.networks.length == 1 &&
                                !accountWalletState.wallet
                                    .isNetworkWalletEnabled(
                                        assetId: a.assetId,
                                        networkId: a.networks.first.networkId)
                            ? [AssetAction.buy, AssetAction.addToInventory]
                            : [AssetAction.buy],
                        onActionPressed: (AssetAction assetAction) {
                          setState(() {
                            selectedAssetAction = assetAction;
                          });
                          if (a.networks.length > 1) {
                            final isSelected = widget.children.indexOf(a) ==
                                context
                                    .read<ExpansionListCubit>()
                                    .state
                                    .selectedIndex;

                            if (!isSelected) {
                              context.read<ExpansionListCubit>().selectValue(
                                  isSelected ? -1 : widget.children.indexOf(a));
                            }
                            // TODO - do not use else unless it is necessary. Flatten the indentation.
                            else {
                              widget.onTap(
                                  a.networks.first, selectedAssetAction);
                            }
                          } else {
                            widget.onTap(a.networks.first, selectedAssetAction);
                          }
                        },
                      ),
                    );
                  },
                  body: a.networks.length > 1
                      ? Column(
                          children: a.networks.map((n) {
                            final network =
                                Assets.getNetworkDetail(n.networkId);
                            if (network == SystemAssetDetails.notFound) {
                              // display only supported networks
                              return const SizedBox.shrink();
                            }

                            return Padding(
                              padding: widget.withoutPadding
                                  ? const EdgeInsets.only(
                                      top: Dimensions.padding4)
                                  : const EdgeInsets.only(
                                      top: Dimensions.padding4,
                                      left: Dimensions.padding16,
                                      right: Dimensions.padding16),
                              child: NetworkWalletSearchItem(
                                icon: SizedBox(
                                  height: 30,
                                  child: asset.style.icon,
                                ),
                                title: network.name,
                                subTitle: network.ticker,
                                selectedAssetAction: selectedAssetAction,
                                onTap: () =>
                                    widget.onTap(n, selectedAssetAction),
                              ),
                            );
                          }).toList(),
                        )
                      : const SizedBox.shrink(),
                );

                return expansionPanel;
              },
            ).toList(),
          );
        });
  }
}
