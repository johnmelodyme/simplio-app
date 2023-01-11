import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/routers/authenticated_routes/discovery_route.dart';
import 'package:simplio_app/view/screens/authenticated_screens/discovery_screen.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/empty_list_placeholder.dart';
import 'package:simplio_app/view/widgets/button/highlighted_elevated_button.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';

// TODO - put content into the screen as a pricate widget.
class InventoryNftContent extends StatelessWidget {
  const InventoryNftContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          EmptyListPlaceholder(
            label: context.locale.inventory_screen_nft_empty_list_label,
            child: Image.asset(
              'assets/images/empty_transactions_placeholder.png',
            ),
          ),
          Gaps.gap20,
          SizedBox(
            width: 234,
            child: HighlightedElevatedButton.primary(
              label: context.locale.inventory_screen_discover_new_nft,
              onPressed: () {
                GoRouter.of(context).goNamed(
                  DiscoveryRoute.name,
                  extra: DiscoveryTab.nft,
                );
              },
            ),
          )
        ],
      ),
    );
    // return Container();
  }
}
