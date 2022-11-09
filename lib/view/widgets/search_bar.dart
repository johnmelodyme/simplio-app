import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:sio_glyphs/sio_icons.dart';

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
          color: SioColors.softBlack.withOpacity(0.4),
          borderRadius: BorderRadius.circular(RadiusSize.radius50),
          border: Border.all(
            width: 1,
            color: SioColors.secondary4,
          ),
          boxShadow: [
            BoxShadow(
              color: SioColors.mentolGreen.withOpacity(0.1),
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
            SioIcons.search,
            size: 20.0,
            color: SioColors.secondary6,
          ),
        ),
        placeholder: widget.searchHint,
        selectionHeightStyle: BoxHeightStyle.includeLineSpacingMiddle,
        placeholderStyle:
            SioTextStyles.bodyPrimary.apply(color: SioColors.secondary7),
        clearButtonMode: OverlayVisibilityMode.never,
        cursorColor: SioColors.whiteBlue,
        style: SioTextStyles.bodyPrimary.apply(color: SioColors.whiteBlue),
        controller: widget.searchController,
      ),
    );
  }
}
