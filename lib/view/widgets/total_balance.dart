import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/view/extensions/number_extensions.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

// TODO - rename to InventoryBalanceOverview
class TotalBalance extends StatefulWidget {
  const TotalBalance({
    super.key,
  });

  @override
  State<TotalBalance> createState() => _TotalBalanceState();
}

class _TotalBalanceState extends State<TotalBalance> {
  @override
  Widget build(BuildContext context) {
    double totalBalance = 0;

    // TODO - do not use bloc on widget level.
    return BlocBuilder<AccountWalletCubit, AccountWalletState>(
        buildWhen: (prev, curr) => curr is AccountWalletChanged,
        builder: (context, state) {
          if (state is! AccountWalletProvided) {
            throw Exception('No AccountWallet Provided');
            // todo: add notification for the user when the snackbar task is done
          }

          // TODO - sto_____rk - move this functionality to AccountWallet and AssetWallet model.
          // get total balance of portfolio
          totalBalance = 0;
          for (final wallet in state.wallet.wallets) {
            for (final networkWallet in wallet.wallets) {
              totalBalance += networkWallet.fiatBalance;
            }
          }

          return SliverPadding(
            padding: Paddings.horizontal16,
            sliver: SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                        Radius.circular(RadiusSize.radius20)),
                    color: SioColors.backGradient4Start,
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          SioColors.backGradient4Start,
                          SioColors.softBlack
                        ])),
                child: Padding(
                  padding: Paddings.vertical16,
                  child: Column(children: [
                    Text(
                      context.locale.inventory_screen_inventory_balance,
                      style:
                          SioTextStyles.bodyPrimary.copyWith(height: 1.0).apply(
                                color: SioColors.secondary6,
                              ),
                    ),
                    Gaps.gap5,
                    Text(
                      totalBalance.getThousandValueWithCurrency(
                        currency: 'USD', //TODO.. replace by real currency
                        locale: Intl.getCurrentLocale(),
                      ),
                      style:
                          SioTextStyles.h1.apply(color: SioColors.mentolGreen),
                    ),
                  ]),
                ),
              ),
            ),
          );
        });
  }
}
