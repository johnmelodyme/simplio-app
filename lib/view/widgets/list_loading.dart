import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class ListLoading extends StatelessWidget {
  const ListLoading({
    Key? key,
    this.activeColor,
    this.backgroundColor,
  }) : super(key: key);

  final Color? activeColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 35,
      height: 35,
      child: CircularProgressIndicator(
        strokeWidth: Dimensions.padding2,
        color: activeColor ?? SioColors.secondary4,
        backgroundColor: backgroundColor ?? SioColors.secondary2,
      ),
    );
  }
}
