import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class AssetFormGradientLabel extends StatelessWidget {
  final Widget child;
  const AssetFormGradientLabel({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              SioColors.backGradient4Start,
              SioColors.softBlack,
            ],
          ),
          borderRadius: BorderRadii.radius20,
        ),
        padding: Paddings.all20,
        child: child);
  }
}
