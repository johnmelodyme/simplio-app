import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/tap_bar/tap_bar_cubit.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/widgets/tap_bar.dart';
import 'package:simplio_app/view/widgets/tap_bar_item.dart';

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
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        widget.child,
        BlocBuilder<TapBarCubit, TapBarState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            return state.isDisplayed
                ? TapBar(
                    activeItem: state.selectedItem,
                    items: [
                      TapBarItem(
                          key: const ValueKey(AuthenticatedRouter.discovery),
                          tapBarItemType: TapTabItemType.button,
                          icon: Icons.assistant_navigation,
                          label: context.locale.discoveryTapBarLabel,
                          onTap: (context, key) {
                            GoRouter.of(context)
                                .goNamed(AuthenticatedRouter.discovery);
                          }),
                      TapBarItem(
                          key: const ValueKey(AuthenticatedRouter.games),
                          tapBarItemType: TapTabItemType.button,
                          icon: Icons.sports_esports_outlined,
                          label: context.locale.gamesTapBarLabel,
                          onTap: (context, key) {
                            GoRouter.of(context)
                                .goNamed(AuthenticatedRouter.games);
                          }),
                      TapBarItem(
                          key: const ValueKey(AuthenticatedRouter.inventory),
                          tapBarItemType: TapTabItemType.button,
                          icon: Icons.pie_chart_outline,
                          label: context.locale.inventoryTapBarLabel,
                          onTap: (context, key) {
                            GoRouter.of(context)
                                .goNamed(AuthenticatedRouter.inventory);
                          }),
                      TapBarItem(
                          key: const ValueKey(AuthenticatedRouter.findDapps),
                          tapBarItemType: TapTabItemType.button,
                          icon: Icons.language,
                          label: context.locale.findDappsTapBarLabel,
                          onTap: (context, key) {
                            GoRouter.of(context)
                                .goNamed(AuthenticatedRouter.findDapps);
                          }),
                    ],
                    height: 70.0,
                  )
                : Container();
          },
        ),
      ],
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
