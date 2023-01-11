import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/routers/authenticated_routes/inventory_route.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/button/drag_button.dart';
import 'package:simplio_app/view/widgets/gradient/gradient_container.dart';
import 'package:simplio_app/view/widgets/back_gradient4.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/fixed_item_height_delegate.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/view/widgets/button/highlighted_elevated_button.dart';
import 'package:simplio_app/view/widgets/list/detail_row.dart';
import 'package:sio_glyphs/sio_icons.dart';

class AssetSwapSummaryScreen extends StatelessWidget {
  // TODO - create a custom arguments type with only the required fields.
  const AssetSwapSummaryScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackGradient4(
        child: DragButton(
          icon: SioIcons.rocket_swipe,
          label: context.locale.asset_swap_summary_screen_submit,
          onDrag: () async {
            // TODO - implement drag action.
          },
          children: [
            Flexible(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: FixedHeightItemDelegate(
                      fixedHeight: Constants.appBarHeight +
                          MediaQuery.of(context).viewPadding.top,
                      child: ColorizedAppBar(
                        title: context.locale.asset_swap_summary_screen_title,
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        DetailRow.value(
                          // TODO - rename locale key to asset_swap_screen_exchange_from
                          title: context.locale.asset_swap_screen_exchange_from,
                          primaryValue: '0.00000000 TINC',
                          secondaryValue: '\$175.40',
                        ),
                        Gaps.gap6,
                        DetailRow.value(
                          title: context
                              .locale.asset_swap_summary_screen_choose_fee,
                          primaryValue: '0.0000001 TINC',
                          secondaryValue: '\$175.40',
                        ),
                        Gaps.gap6,
                        DetailRow(
                          title:
                              context.locale.asset_swap_screen_exchange_summary,
                          child: Padding(
                            padding: Paddings.horizontal20,
                            child: GradientContainer(
                              borderRadius: BorderRadii.radius16,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      '0.00000000 TINC',
                                      style: SioTextStyles.s1.copyWith(
                                        color: SioColors.mentolGreen,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      '\$175.40',
                                      style: SioTextStyles.s1.copyWith(
                                        color: SioColors.secondary6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          child: WillPopScope(
            onWillPop: () => Future.value(false),
            child: FutureBuilder(
              future: Future.delayed(const Duration(seconds: 2)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return const _SuccessContent();
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessContent extends StatelessWidget {
  const _SuccessContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Done!\n Your transaction is in progress.',
                style: SioTextStyles.h2,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: Paddings.all20,
            child: HighlightedElevatedButton.secondary(
              label: 'Done',
              icon: SioIcons.done,
              onPressed: () {
                GoRouter.of(context).goNamed(
                  InventoryRoute.name,
                );
              },
              // child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }
}
