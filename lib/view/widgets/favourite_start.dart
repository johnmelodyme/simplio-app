import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

// TODO - BUG - is has wrong spelling
class FavouriteStar extends StatelessWidget {
  const FavouriteStar({
    super.key,
    required this.isFilled,
  });

  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
          color: SioColors.softBlack,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(
              RadiusSize.radius10,
            ),
            topRight: Radius.circular(
              RadiusSize.radius10,
            ),
          )),
      child: Padding(
        padding: Paddings.all4,
        child: Icon(
          isFilled ? Icons.star : Icons.star_border_outlined,
          color: SioColors.mentolGreen,
        ),
      ),
    );
  }
}
