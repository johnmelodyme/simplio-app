import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/logic/bloc/crypto_asset/crypto_asset_bloc.dart';
import 'package:simplio_app/logic/bloc/crypto_asset/crypto_asset_bloc_event.dart';
import 'package:simplio_app/logic/bloc/games/game_bloc_event.dart';
import 'package:simplio_app/logic/bloc/games/games_bloc.dart';
import 'package:simplio_app/logic/bloc/nft/nft_bloc.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/discover_coins_content.dart';
import 'package:simplio_app/view/widgets/discover_games_content.dart';
import 'package:simplio_app/view/widgets/discovery_nft_content.dart';
import 'package:simplio_app/view/widgets/navigation_tab_bar.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';
import 'package:simplio_app/view/widgets/slidable_banner.dart';
import 'package:sio_glyphs/sio_icons.dart';

enum DiscoveryTab { games, coins, nft }

class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({
    super.key,
    this.tab = DiscoveryTab.games,
  });

  final DiscoveryTab tab;

  @override
  Widget build(BuildContext context) {
    return SioScaffold(
      body: NavigationTabBar(
        currentTab: tab.index,
        tabs: [
          NavigationBarTabItem(
            label: context.locale.discovery_tab_games,
            onRefresh: () async {
              context.read<GamesBloc>().add(const ReloadGamesEvent());
            },
            // searchBar: SearchBarPlaceholder(
            //   onTap: () {
            //     GoRouter.of(context).pushNamed(
            //       AuthenticatedRouter.gamesSearch,
            //     );
            //   },
            //   label: context.locale.discovery_screen_search_and_add_games,
            // ),
            iconData: SioIcons.sports_esports,
            iconColor: SioColors.games,
            topSlivers: [
              const SliverGap(Dimensions.padding16),
              const SlidableBanner(),
              const SliverGap(Dimensions.padding20),
            ],
            bottomSlivers: [
              const SliverGap(Dimensions.padding20),
              const DiscoverGamesContent(),
            ],
          ),
          NavigationBarTabItem(
            label: context.locale.discovery_tab_coins,
            onRefresh: () async {
              context
                  .read<CryptoAssetBloc>()
                  .add(const ReloadCryptoAssetsEvent());
            },
            // searchBar: SearchBarPlaceholder(
            //   label: context.locale.discovery_screen_search_and_add_coins,
            //   onTap: () {
            //     GoRouter.of(context).pushNamed(
            //       AuthenticatedRouter.assetSearch,
            //     );
            //   },
            // ),
            iconData: SioIcons.coins,
            iconColor: SioColors.coins,
            topSlivers: [
              const SliverGap(Dimensions.padding16),
              const SlidableBanner(),
              const SliverGap(Dimensions.padding20),
            ],
            bottomSlivers: [
              const SliverGap(Dimensions.padding20),
              const DiscoverCoinsContent(),
            ],
          ),
          NavigationBarTabItem(
            label: context.locale.discovery_tab_nft,
            onRefresh: () async {
              context.read<NftBloc>().add(const NftRefreshed());
            },
            // searchBar: SearchBarPlaceholder(
            //   label: context.locale.discovery_screen_search_nft,
            // ),
            iconData: SioIcons.nft,
            iconColor: SioColors.nft,
            topSlivers: [
              const SliverGap(Dimensions.padding16),
              const SlidableBanner(),
              const SliverGap(Dimensions.padding20),
            ],
            bottomSlivers: [
              const SliverGap(Dimensions.padding20),
              const DiscoveryNftContent(),
            ],
          )
        ],
      ),
    );
  }
}
