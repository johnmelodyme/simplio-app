import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class SearchBarPlaceholder extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const SearchBarPlaceholder({
    super.key,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(),
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              height: Constants.searchBarHeight,
              decoration: BoxDecoration(
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
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(
                      Icons.search,
                      size: 20.0,
                      color: SioColors.secondary6,
                    ),
                  ),
                  Text(
                    label,
                    style: SioTextStyles.bodyPrimary
                        .copyWith(height: 1.0)
                        .apply(color: SioColors.secondary7),
                  ),
                ],
              ),
            ),
          ),
          Gaps.gap16,
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.all(Radius.circular(RadiusSize.radius10)),
              color: SioColors.backGradient4Start,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [SioColors.backGradient4Start, SioColors.softBlack],
              ),
            ),
            child: IconButton(
                onPressed: () {
                  //TODO.. show filters
                },
                icon: Center(
                  child: Icon(
                    Icons.tune,
                    color: SioColors.secondary6,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
