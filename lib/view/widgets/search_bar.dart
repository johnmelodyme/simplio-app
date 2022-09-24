import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    super.key,
    required this.searchHint,
    required this.searchController,
    this.autoFocus = false,
  });

  final String searchHint;
  final TextEditingController? searchController;
  final bool autoFocus;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final FocusNode _searchBoxNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.autoFocus) {
        FocusScope.of(context).requestFocus(_searchBoxNode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          const BoxConstraints.tightFor(height: Constants.searchBarHeight),
      child: CupertinoTextField(
        focusNode: _searchBoxNode,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background.withOpacity(0.2),
          borderRadius: BorderRadius.circular(RadiusSize.radius50),
          border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.outline,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  Theme.of(context).colorScheme.inverseSurface.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 1,
              blurStyle: BlurStyle.outer,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        prefix: Padding(
          padding: Paddings.left16,
          child: Icon(
            Icons.search,
            size: 20.0,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        placeholder: widget.searchHint,
        selectionHeightStyle: BoxHeightStyle.includeLineSpacingMiddle,
        placeholderStyle: SioTextStyles.bodyPrimary
            .apply(color: Theme.of(context).colorScheme.shadow),
        clearButtonMode: OverlayVisibilityMode.never,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
        style: SioTextStyles.bodyPrimary
            .apply(color: Theme.of(context).colorScheme.onPrimary),
        controller: widget.searchController,
      ),
    );
  }
}
