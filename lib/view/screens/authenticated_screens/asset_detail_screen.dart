import 'dart:ui';
import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/models/wallet.dart';
import 'package:simplio_app/logic/bloc/asset_send_form/asset_send_form_bloc.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/view/dialogs/dialog_content.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/view/mixins/currency_getter_mixin.dart';
import 'package:simplio_app/view/mixins/snackbar_mixin.dart';
import 'package:simplio_app/view/mixins/wallet_utils_mixin.dart';
import 'package:simplio_app/view/routers/authenticated_routes/asset_send_form_route.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/asset_balance_overview.dart';
import 'package:simplio_app/view/widgets/back_gradient4.dart';
import 'package:simplio_app/view/widgets/button/highlighted_elevated_button.dart';
import 'package:simplio_app/view/widgets/button/outlined_sio_button.dart';
import 'package:simplio_app/view/widgets/scrollable_bottom_panel.dart';
import 'package:simplio_app/view/widgets/button/bottom_panel_button.dart';
import 'package:simplio_app/view/widgets/fixed_item_height_delegate.dart';
import 'package:simplio_app/view/widgets/transactions_content.dart';
import 'package:simplio_app/view/widgets/two_lines_app_bar.dart';
import 'package:sio_big_decimal/sio_big_decimal.dart';
import 'package:sio_glyphs/sio_icons.dart';

class AssetDetailScreen extends StatelessWidget
    with WalletUtilsMixin, CurrencyGetter, SnackBarMixin {
  final String? assetId;
  final String? networkId;

  const AssetDetailScreen({
    super.key,
    required this.assetId,
    required this.networkId,
  });

  @override
  Widget build(BuildContext context) {
    final bottomGap = MediaQuery.of(context).viewPadding.bottom +
        Constants.coinsBottomTabBarHeight;

    final AssetWallet? assetWallet = getAssetWallet(context, assetId!);
    final NetworkWallet? networkWallet =
        getNetwork(context, assetId!, networkId!);

    if (assetWallet == null) {
      throw Exception('No AssetWallet Provided');
    }

    if (networkWallet == null) {
      throw Exception('No Network Provided');
    }

    final assetDetail = Assets.getAssetDetail(assetWallet.assetId);
    final networkDetail = Assets.getNetworkDetail(networkWallet.networkId);

    return Scaffold(
      body: Stack(
        children: [
          BackGradient4(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: FixedHeightItemDelegate(
                      fixedHeight: Constants.appBarHeight +
                          MediaQuery.of(context).viewPadding.top,
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: TwoLinesAppBar(
                            firstPart: networkDetail.name,
                            secondPart: networkDetail.ticker,
                          ),
                        ),
                      )),
                ),
                SliverPadding(
                  padding: Paddings.horizontal16,
                  sliver: SliverToBoxAdapter(
                    child: BlocBuilder<AccountWalletCubit, AccountWalletState>(
                      buildWhen: (previous, current) => previous != current,
                      builder: (context, state) {
                        final networkWallet =
                            getNetwork(context, assetId!, networkId!);

                        if (networkWallet == null) {
                          throw Exception('No Network Provided');
                        }

                        return AssetBalanceOverview(
                          currency: getCurrency(context),
                          assetDetail: assetDetail,
                          networkWallet: networkWallet,
                          children: [
                            if (networkWallet.cryptoBalance ==
                                const BigDecimal.zero())
                              if (networkWallet.isEnabled)
                                OutlinedSioButton(
                                  label: context.locale
                                      .coin_detail_screen_remove_from_inventory_button,
                                  icon: Icon(
                                    SioIcons.cancel_outline,
                                    color: SioColors.secondary6,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<AccountWalletCubit>()
                                        .disableNetworkWallet(
                                          assetId: assetWallet.assetId,
                                          networkId: networkWallet.networkId,
                                        );

                                    showSnackBar(
                                      context,
                                      content: DialogContent.regular(
                                        message: context.locale
                                            .coin_detail_screen_asset_removed(
                                                networkDetail.name),
                                        icon: Image.asset(
                                          'assets/icon/simpliona_icon.png',
                                          height: 50,
                                          width: 50,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              else
                                HighlightedElevatedButton(
                                  label: context.locale
                                      .coin_detail_screen_add_to_inventory_button,
                                  icon: SioIcons.plus_rounded,
                                  onPressed: () {
                                    context
                                        .read<AccountWalletCubit>()
                                        .enableNetworkWallet(
                                          assetId: assetWallet.assetId,
                                          networkId: networkWallet.networkId,
                                        );

                                    showSnackBar(
                                      context,
                                      content: DialogContent.regular(
                                        message: context.locale
                                            .coin_detail_screen_asset_added(
                                                networkDetail.name),
                                        icon: Image.asset(
                                          'assets/icon/simpliona_icon.png',
                                          height: 50,
                                          width: 50,
                                        ),
                                      ),
                                    );
                                  },
                                )
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SliverGap(Dimensions.padding16),
                const TransactionsContent(),
                SliverGap(bottomGap)
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ScrollableBottomPanel(
              children: [
                BottomPanelButton(
                  label: context.locale.coin_menu_buy_coin,
                  icon: SioIcons.basket,
                  onTap: () {},
                ),
                BottomPanelButton(
                  label: context.locale.coin_menu_exchange,
                  icon: SioIcons.swap,
                  onTap: () {},
                ),
                BottomPanelButton(
                  label: context.locale.coin_menu_receive,
                  icon: SioIcons.vertical_align_bottom,
                  onTap: () {},
                ),
                BottomPanelButton(
                  label: context.locale.coin_menu_send,
                  icon: SioIcons.vertical_align_top,
                  onTap: networkWallet.cryptoBalance.isNotZero
                      ? () {
                          GoRouter.of(context).pushNamed(
                            AssetSendFormRoute.name,
                            extra: PriceLoaded(
                              assetId: int.parse(assetId!),
                              wallet: networkWallet,
                            ),
                          );
                        }
                      : null,
                ),
                BottomPanelButton(
                  label: context.locale.coin_menu_earn,
                  icon: SioIcons.north_east,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
