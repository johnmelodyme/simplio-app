import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account/account_cubit.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/button/bordered_press_button.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';
import 'package:sio_glyphs/sio_icons.dart';

class BackupInventoryScreen extends StatefulWidget {
  const BackupInventoryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _BackupInventoryScreen();
}

class _BackupInventoryScreen extends State<BackupInventoryScreen> {
  bool hidden = true;

  @override
  Widget build(BuildContext context) {
    final s = context.read<AccountWalletCubit>().state;
    if (s is! AccountWalletProvided) throw Exception('No asset wallet found');

    final accountState = context.read<AccountCubit>().state;
    if (accountState is! AccountUnlocked) {
      throw Exception('Account is in incorrect state');
    }

    final mnemonic =
        s.wallet.mnemonic.unlock(accountState.secret).split(' ').asMap();

    return SioScaffold(
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ColorizedAppBar(
                key: const Key('backup-inventory-screen'),
                title: context.locale.backup_inventory_screen_appbar_title,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: SioColors.mentolGreen.withOpacity(0.1),
                        spreadRadius: 70 / 6,
                        blurRadius: 70 / 2,
                        offset: const Offset(0, 0),
                      ),
                    ]),
                    child: Icon(
                      SioIcons.locked_account_outline, //TODO.. change icon
                      color: SioColors.coins,
                      size: 70,
                    ),
                  ),
                ],
              ),
              Gaps.gap14,
              Align(
                alignment: Alignment.center,
                child: Text(
                  context.locale.backup_inventory_screen_your_secret,
                  style: SioTextStyles.h3.apply(
                    color: SioColors.whiteBlue,
                  ),
                ),
              ),
              Gaps.gap4,
              Padding(
                padding: Paddings.horizontal16,
                child: Text(
                  context.locale.backup_inventory_screen_write_down_your_secret,
                  style: SioTextStyles.bodyPrimary.apply(
                    color: SioColors.secondary7,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Gaps.gap10,
              Padding(
                padding: Paddings.horizontal16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...mnemonic.entries
                        .map(
                          (e) => e.key < 6
                              ? _HidableRow(
                                  index: e.key,
                                  mnemonic: mnemonic,
                                  hidden: hidden,
                                )
                              : const SizedBox.shrink(),
                        )
                        .toList(),
                    Padding(
                      padding: const EdgeInsets.all(Dimensions.padding16),
                      child: SizedBox(
                        width: double.infinity,
                        child: BorderedPressButton(
                          onLongPress: () {
                            setState(() {
                              hidden = !hidden;
                            });
                          },
                          label: context
                              .locale.backup_inventory_screen_button_label,
                          icon: SioIcons.eye,
                          pressed: !hidden,
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          SioIcons.info_outline,
                          color: SioColors.highlight,
                          size: Dimensions.padding16,
                        ),
                        Gaps.gap10,
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            context.locale.backup_inventory_screen_warning,
                            style: SioTextStyles.bodyS.copyWith(
                              color: SioColors.highlight,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HidableWord extends StatelessWidget {
  final Map<int, String> mnemonic;
  final int index;
  final bool hidden;

  const _HidableWord(
      {required this.mnemonic, required this.index, required this.hidden});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Text(
              '${index + 1}',
              style: SioTextStyles.bodyL.apply(
                color: SioColors.secondary7,
              ),
            ),
          ),
          const WidgetSpan(
            child: SizedBox(
              width: Dimensions.padding20, // your of space
            ),
          ),
          hidden
              ? WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Text(
                    '⦁⦁⦁⦁',
                    style: TextStyle(
                      fontSize: 26,
                      color: SioColors.secondary4,
                    ),
                  ),
                )
              : WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Text(
                    mnemonic[index]!,
                    style: SioTextStyles.bodyL.copyWith(
                      color: SioColors.mentolGreen,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class _HidableRow extends StatelessWidget {
  final Map<int, String> mnemonic;
  final int index;
  final bool hidden;

  const _HidableRow(
      {required this.mnemonic, required this.index, required this.hidden});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Paddings.bottom8,
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              height: Dimensions.padding40,
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.padding12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadii.radius20,
                color: SioColors.backGradient2,
              ),
              child: _HidableWord(
                mnemonic: mnemonic,
                index: index,
                hidden: hidden,
              ),
            ),
          ),
          Gaps.gap14,
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              height: Dimensions.padding40,
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.padding12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadii.radius20,
                color: SioColors.backGradient2,
              ),
              child: _HidableWord(
                mnemonic: mnemonic,
                index: index + 6,
                hidden: hidden,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
