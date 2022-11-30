import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';

class DappsScreen extends StatelessWidget {
  const DappsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomGap = MediaQuery.of(context).viewPadding.bottom +
        Constants.coinsBottomTabBarHeight;

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
                slivers: [
                  SliverGap(MediaQuery.of(context).viewPadding.top +
                      Constants.appBarHeight),
                  const SliverGap(Dimensions.padding20),
                  SliverToBoxAdapter(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '${context.locale.find_dapps_screen_discover}\n',
                            style: SioTextStyles.h1.apply(
                              color: SioColors.whiteBlue,
                            ),
                          ),
                          TextSpan(
                            text: '${context.locale.find_dapps_screen_dapps} ',
                            style: SioTextStyles.h1
                                .apply(color: SioColors.mentolGreen),
                          ),
                          TextSpan(
                            text: context.locale.find_dapps_screen_world,
                            style: SioTextStyles.h1
                                .apply(color: SioColors.whiteBlue),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverGap(Dimensions.padding5),
                  SliverToBoxAdapter(
                    child: Text(
                      context.locale.find_dapps_screen_description,
                      textAlign: TextAlign.center,
                      style: SioTextStyles.s1.apply(
                        color: SioColors.secondary7,
                      ),
                    ),
                  ),
                  const SliverGap(Dimensions.padding20),
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/find_dapps_coming_soon.png',
                          alignment: Alignment.centerRight,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 1,
                          right: 23,
                          child: SizedBox(
                            width: 180,
                            child: Image.asset(
                              'assets/images/simpliona_dapps.png',
                            ),
                          ),
                        ),
                      ],
                    ),
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
