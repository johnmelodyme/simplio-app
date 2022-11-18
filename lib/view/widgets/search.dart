import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/back_gradient4.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/fixed_item_height_delegate.dart';
import 'package:simplio_app/view/widgets/search_bar.dart';
import 'package:simplio_app/view/widgets/two_lines_app_bar.dart';

enum AppBarStyle {
  twoLined,
  multiColored,
}

class Search extends StatefulWidget {
  const Search({
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
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(
        -(Constants.appBarHeight +
            MediaQuery.of(context).viewPadding.top +
            Constants.searchBarHeight +
            Dimensions.padding20),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackGradient4(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        onVerticalDragDown: (_) =>
            FocusManager.instance.primaryFocus?.unfocus(),
        child: CustomScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: FixedHeightItemDelegate(
                fixedHeight: Constants.appBarHeight +
                    MediaQuery.of(context).viewPadding.top +
                    Constants.searchBarHeight +
                    Dimensions.padding20,
                child: ClipRect(
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Column(
                        children: [
                          widget.appBarStyle == AppBarStyle.twoLined
                              ? TwoLinesAppBar(
                                  firstPart: widget.firstPart,
                                  secondPart: widget.secondPart,
                                  actionType: ActionType.close,
                                )
                              : ColorizedAppBar(
                                  firstPart: widget.firstPart,
                                  secondPart: widget.secondPart,
                                  actionType: ActionType.close,
                                ),
                          Padding(
                            padding: Paddings.horizontal16,
                            child: SearchBar(
                              searchHint: widget.searchHint,
                              searchController: widget.searchController,
                              autoFocus: widget.autoFocusSearch,
                            ),
                          ),
                          Gaps.gap20,
                        ],
                      )),
                ),
              ),
            ),
            SliverFillRemaining(
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}
