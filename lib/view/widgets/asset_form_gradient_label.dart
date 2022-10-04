import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';

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
              Theme.of(context).colorScheme.onPrimaryContainer,
              Theme.of(context).colorScheme.background,
            ],
          ),
          borderRadius: BorderRadii.radius20,
        ),
        padding: Paddings.all20,
        child: child);
  }
}
