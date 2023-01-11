import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/logic/bloc/auth/auth_bloc.dart';
import 'package:simplio_app/logic/cubit/account/account_cubit.dart';
import 'package:simplio_app/logic/cubit/wallet_connect/wallet_connect_cubit.dart';
import 'package:simplio_app/view/routers/authenticated_routes/configuration_security_route.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';
import 'package:sio_glyphs/sio_icons.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SioScaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: ColorizedAppBar(
              title: context.locale.configuration_screen_title,
              actionType: ActionType.close,
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
                context.locale.configuration_screen_security,
                style: SioTextStyles.bodyStyle.apply(
                  color: SioColors.whiteBlue,
                ),
              ),
              onTap: () {
                GoRouter.of(context).pushNamed(
                  ConfigurationSecurityRoute.name,
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: ListTile(
              title: Text(context.locale.configuration_screen_sign_out,
                  style: SioTextStyles.bodyStyle.apply(
                    color: SioColors.whiteBlue,
                  )),
              onTap: () {
                context.read<AuthBloc>().add(const GotUnauthenticated());
              },
            ),
          ),
          if (!const bool.fromEnvironment('IS_PROD'))
            SliverToBoxAdapter(
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        context.locale.common_configuration_dark_mode(
                            globalThemeMode == ThemeMode.dark),
                        style: SioTextStyles.bodyStyle.apply(
                          color: SioColors.whiteBlue,
                        )),
                    Switch(
                      onChanged: (bool isDarkMode) async {
                        await context.read<AccountCubit>().updateTheme(
                            isDarkMode ? ThemeMode.dark : ThemeMode.light);
                      },
                      value: globalThemeMode == ThemeMode.dark,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
