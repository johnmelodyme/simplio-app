import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class ListLoading extends StatelessWidget {
  const ListLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 35,
      height: 35,
      child: CircularProgressIndicator(
        strokeWidth: Dimensions.padding2,
        color: SioColors.secondary4,
        backgroundColor: SioColors.secondary2,
      ),
    );
  }
}
