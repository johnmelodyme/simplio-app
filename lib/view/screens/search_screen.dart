import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/fixed_item_height_delegate.dart';
import 'package:simplio_app/view/widgets/search_bar.dart';
import 'package:simplio_app/view/widgets/two_lines_app_bar.dart';

enum AppBarStyle {
  twoLined,
  multiColored,
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.firstPart,
    required this.secondPart,
    required this.searchHint,
    required this.child,
    required this.searchController,
    required this.appBarStyle,
    this.autoFocusSearch = false,
  });

  final String firstPart;
  final String secondPart;
  final String searchHint;
  final Widget child;
  final TextEditingController searchController;
  final AppBarStyle appBarStyle;
  final bool autoFocusSearch;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.center,
          colors: [
            Theme.of(context).colorScheme.onPrimaryContainer,
            Theme.of(context).colorScheme.background,
          ],
        ),
      ),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: FixedHeightItemDelegate(
              fixedHeight: Constants.appBarHeight +
                  MediaQuery.of(context).viewPadding.top,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: widget.appBarStyle == AppBarStyle.twoLined
                      ? TwoLinesAppBar(
                          firstPart: widget.firstPart,
                          secondPart: widget.secondPart,
                          actionType: ActionType.close,
                          onBackTap: () => Navigator.of(context).pop(),
                        )
                      : ColorizedAppBar(
                          firstPart: widget.firstPart,
                          secondPart: widget.secondPart,
                          actionType: ActionType.close,
                          onBackTap: () => Navigator.of(context).pop(),
                        ),
                ),
              ),
            ),
          ),
          const SliverGap(Dimensions.padding20),
          SliverPadding(
            padding: Paddings.horizontal16,
            sliver: SliverPersistentHeader(
              floating: true,
              delegate: FixedHeightItemDelegate(
                fixedHeight: Constants.searchBarHeight,
                child: SearchBar(
                  searchHint: widget.searchHint,
                  searchController: widget.searchController,
                  autoFocus: widget.autoFocusSearch,
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
