import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/wallet_connect/wallet_connect_cubit.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';
import 'package:sio_glyphs/sio_icons.dart';

class ConfigurationSecurityScreen extends StatelessWidget {
  const ConfigurationSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SioScaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: ColorizedAppBar(
              firstPart: '',
              secondPart: context.locale.configuration_screen_security,
              actionType: ActionType.back,
            ),
          ),
          SliverToBoxAdapter(
              child: ListView(
                  shrinkWrap: true,
                  padding: Paddings.vertical20,
                  children: [
                ...context
                    .watch<WalletConnectCubit>()
                    .state
                    .sessions
                    .entries
                    .map<Widget>(
                      (e) => ListTile(
                        minVerticalPadding: 20.0,
                        title: Text(
                          e.value.name,
                          style: SioTextStyles.bodyStyle.apply(
                            color: SioColors.whiteBlue,
                          ),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            context
                                .read<WalletConnectCubit>()
                                .closeSessionByTopicId(e.key);
                          },
                          child: const Icon(SioIcons.link_broken),
                        ),
                      ),
                    )
                    .toList()
              ])),
          SliverToBoxAdapter(
            child: ListTile(
              title: Text(
                'Backup your inventory',
                style: SioTextStyles.bodyStyle.apply(
                  color: SioColors.whiteBlue,
                ),
              ),
              onTap: () {
                GoRouter.of(context)
                    .pushNamed(AuthenticatedRouter.backupInventory);
              },
            ),
          ),
          SliverToBoxAdapter(
            child: ListTile(
              title: Text(
                context.locale.configuration_screen_change_password,
                style: SioTextStyles.bodyStyle.apply(
                  color: SioColors.whiteBlue,
                ),
              ),
              onTap: () {
                GoRouter.of(context)
                    .pushNamed(AuthenticatedRouter.passwordChange);
              },
            ),
          ),
        ],
      ),
    );
  }
}
