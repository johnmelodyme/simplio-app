import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/repositories/wallet_connect_repository.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/tab_bar/tab_bar_cubit.dart';
import 'package:simplio_app/logic/cubit/wallet_connect/wallet_connect_cubit.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/bottom_tab_bar.dart';
import 'package:simplio_app/view/widgets/list_loading.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';
import 'package:simplio_app/view/widgets/tab_bar_item.dart';
import 'package:simplio_app/view/widgets/wallet_connect_request_item.dart';
import 'package:simplio_app/view/widgets/wallet_connect_request_list.dart';
import 'package:sio_glyphs/sio_icons.dart';

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
    return SioScaffold(
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
                              selectedColor: SioColors.mentolGreen,
                              icon: SioIcons.gridview,
                              label: context.locale
                                  .application_screen_discovery_tabbar_label,
                              onTap: (context, key) {
                                GoRouter.of(context)
                                    .goNamed(AuthenticatedRouter.discovery);
                              }),
                          TabBarItem(
                              key: const ValueKey(AuthenticatedRouter.games),
                              tabBarItemType: TabItemType.button,
                              selectedColor: SioColors.games,
                              icon: SioIcons.sports_esports,
                              label: context
                                  .locale.application_screen_games_tabbar_label,
                              onTap: (context, key) {
                                GoRouter.of(context)
                                    .goNamed(AuthenticatedRouter.games);
                              }),
                          TabBarItem(
                              key:
                                  const ValueKey(AuthenticatedRouter.inventory),
                              tabBarItemType: TabItemType.button,
                              selectedColor: SioColors.coins,
                              icon: SioIcons.inventory,
                              label: context.locale
                                  .application_screen_inventory_tabbar_label,
                              onTap: (context, key) {
                                GoRouter.of(context)
                                    .goNamed(AuthenticatedRouter.inventory);
                              }),
                          TabBarItem(
                              key:
                                  const ValueKey(AuthenticatedRouter.findDapps),
                              tabBarItemType: TabItemType.button,
                              selectedColor: SioColors.coins,
                              icon: SioIcons.world,
                              label: context.locale
                                  .application_screen_find_dapps_tabbar_label,
                              onTap: (context, key) {
                                GoRouter.of(context)
                                    .goNamed(AuthenticatedRouter.findDapps);
                              }),
                        ],
                        height: 70.0,
                      ))
                  : const SizedBox.shrink();
            },
          ),
          BlocBuilder<WalletConnectCubit, WalletConnectState>(
            buildWhen: (prev, curr) => prev != curr,
            builder: (context, state) => state.isModal
                ? WalletConnectRequestList(
                    children: state.requests.values
                        .map<WalletConnectRequestItem>((r) {
                      if (r is WalletConnectSessionRequest) {
                        return WalletConnectSessionRequestItem(
                          request: r,
                          onApprove: (networkId) {
                            context
                                .read<WalletConnectCubit>()
                                .approveSessionRequest(r, networkId: networkId);
                          },
                          onReject: () {
                            context
                                .read<WalletConnectCubit>()
                                .rejectSessionRequest(r);
                          },
                        );
                      }

                      if (r is WalletConnectSignatureRequest) {
                        return WalletConnectSignatureRequestItem(
                          request: r,
                          onApprove: () {
                            context
                                .read<WalletConnectCubit>()
                                .approveSignatureRequest(r);
                          },
                          onReject: () {
                            context.read<WalletConnectCubit>().rejectRequest(r);
                          },
                        );
                      }

                      if (r is WalletConnectTransactionRequest) {
                        return WalletConnectTransactionRequestItem(
                          request: r,
                          onApprove: () async {
                            await context
                                .read<WalletConnectCubit>()
                                .approveTransactionRequest(r);
                          },
                          onReject: () async {
                            context.read<WalletConnectCubit>().rejectRequest(r);
                          },
                        );
                      }

                      return WalletConnectUnknownEventItem(request: r);
                    }).toList(),
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}

class ApplicationLoadingScreen extends StatelessWidget {
  const ApplicationLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SioScaffold(
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
                      style: TextStyle(color: SioColors.attention),
                    );
                  }
                  return const ListLoading();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
