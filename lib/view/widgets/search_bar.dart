import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simplio_app/view/routes/guards/protected_guard.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';

class SearchBar<T> extends StatelessWidget {
  final SearchDelegate<T> delegate;
  final String label;
  final BuildContextCallback? onTap;

  const SearchBar({
    super.key,
    required this.delegate,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              onTap?.call(context);
              showSearch(
                context: context,
                delegate: delegate,
              );
            },
            child: Container(
              alignment: Alignment.centerLeft,
              height: Constants.searchBarHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(RadiusSize.radius50),
                border: Border.all(
                  width: 1,
                  color: Theme.of(context).colorScheme.outline,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .inverseSurface
                        .withOpacity(0.1),
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
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                  Text(
                    label,
                    style: SioTextStyles.bodyPrimary
                        .copyWith(height: 1.0)
                        .apply(color: Theme.of(context).colorScheme.shadow),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Gap(Dimensions.padding16),
        Container(
          width: 41,
          height: 41,
          decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.all(Radius.circular(RadiusSize.radius10)),
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.onPrimaryContainer,
                Theme.of(context).colorScheme.background
              ],
            ),
          ),
          child: IconButton(
              onPressed: () {
                //TODO.. show filters
              },
              icon: Center(
                child: Icon(
                  Icons.tune,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              )),
        )
      ],
    );
  }
}
