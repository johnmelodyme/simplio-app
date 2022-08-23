import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/tab_bar/tab_bar_cubit.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/widgets/bottom_tab_bar.dart';
import 'package:simplio_app/view/widgets/tab_bar_item.dart';

class ApplicationScreen extends StatefulWidget {
  final Widget child;

  const ApplicationScreen({
    super.key,
    required this.child,
  });

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          widget.child,
          BlocBuilder<TabBarCubit, TabBarState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              return state.isDisplayed
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: BottomTabBar(
                        activeItem: state.selectedItem,
                        items: [
                          TabBarItem(
                              key:
                                  const ValueKey(AuthenticatedRouter.discovery),
                              tabBarItemType: TabItemType.button,
                              selectedColor:
                                  Theme.of(context).colorScheme.inverseSurface,
                              icon: Icons.assistant_navigation,
                              label: context.locale.discoveryTabBarLabel,
                              onTap: (context, key) {
                                GoRouter.of(context)
                                    .goNamed(AuthenticatedRouter.discovery);
                              }),
                          TabBarItem(
                              key: const ValueKey(AuthenticatedRouter.games),
                              tabBarItemType: TabItemType.button,
                              selectedColor:
                                  Theme.of(context).colorScheme.onBackground,
                              icon: Icons.sports_esports_outlined,
                              label: context.locale.gamesTabBarLabel,
                              onTap: (context, key) {
                                GoRouter.of(context)
                                    .goNamed(AuthenticatedRouter.games);
                              }),
                          TabBarItem(
                              key:
                                  const ValueKey(AuthenticatedRouter.inventory),
                              tabBarItemType: TabItemType.button,
                              selectedColor:
                                  Theme.of(context).colorScheme.surface,
                              icon: Icons.pie_chart_outline,
                              label: context.locale.inventoryTabBarLabel,
                              onTap: (context, key) {
                                GoRouter.of(context)
                                    .goNamed(AuthenticatedRouter.inventory);
                              }),
                          TabBarItem(
                              key:
                                  const ValueKey(AuthenticatedRouter.findDapps),
                              tabBarItemType: TabItemType.button,
                              selectedColor:
                                  Theme.of(context).colorScheme.surface,
                              icon: Icons.language,
                              label: context.locale.findDappsTabBarLabel,
                              onTap: (context, key) {
                                GoRouter.of(context)
                                    .goNamed(AuthenticatedRouter.findDapps);
                              }),
                        ],
                        height: 70.0,
                      ))
                  : Container();
            },
          ),
        ],
      ),
    );
  }
}

class ApplicationLoadingScreen extends StatelessWidget {
  const ApplicationLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: BlocBuilder<AccountWalletCubit, AccountWalletState>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, state) {
                  if (state is AccountWalletLoadedWithError) {
                    return Text(
                      state.error.toString(),
                      style: TextStyle(color: Theme.of(context).errorColor),
                    );
                  }
                  return CircularProgressIndicator(
                    strokeWidth: 2.0,
                    backgroundColor: Theme.of(context).indicatorColor,
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
