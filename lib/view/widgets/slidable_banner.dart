import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/slidable_banner_indicator.dart';

class SlidableBanner extends StatefulWidget {
  const SlidableBanner({super.key});

  @override
  State<SlidableBanner> createState() => _SlidableBannerState();
}

class _SlidableBannerState extends State<SlidableBanner> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  static const List<String> images = [
    "assets/images/game_mines_of_dalarnia.png",
    "assets/images/game_vault_hill.png",
    "assets/images/game_alpha_league_racing.png",
    "assets/images/game_tiny_world.png",
    "assets/images/game_castles.png",
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _timer = Timer.periodic(
        const Duration(
            milliseconds: Constants.slidableBannerItemSwapTimeMillis),
        (Timer timer) {
      _pageController.animateToPage(
        _pageController.page!.toInt() + 1,
        duration: const Duration(
          milliseconds: Constants.slidableBannerSwapItemAnimationTimeTimeMillis,
        ),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: Paddings.horizontal16,
      sliver: SliverToBoxAdapter(
        child: ClipRRect(
          borderRadius: BorderRadii.radius20,
          child: SizedBox(
            height: Constants.slidableBannerHeight,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                PageView.builder(
                    itemCount: 100000,
                    pageSnapping: true,
                    controller: _pageController,
                    onPageChanged: (page) {
                      setState(() {
                        _currentPage = page % images.length;
                      });
                    },
                    itemBuilder: (context, pagePosition) {
                      return ClipRRect(
                        borderRadius: BorderRadii.radius20,
                        child: Image.asset(
                          images[pagePosition % images.length],
                          fit: BoxFit.cover,
                        ),
                      );
                    }),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: Paddings.bottom10,
                    child: SlidableBannerIndicator(
                      pagesCount: images.length,
                      currentPage: _currentPage,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _pageController.dispose();
  }
}
