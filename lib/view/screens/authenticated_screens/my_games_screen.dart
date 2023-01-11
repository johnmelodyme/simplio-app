import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/my_games_content.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';

class MyGamesScreen extends StatelessWidget {
  const MyGamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final bottomGap = MediaQuery.of(context).viewPadding.bottom +
        Constants.bottomTabBarHeight;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SioScaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                controller: scrollController,
                slivers: [
                  SliverGap(MediaQuery.of(context).viewPadding.top +
                      Constants.appBarHeight),
                  const SliverGap(Dimensions.padding20),
                  MyGamesContent(
                    onCoinAdd: (int assetId, int networkId) {
                      // TODO - add when buy asset is implemented.
                    },
                  ),
                  SliverGap(bottomGap)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
