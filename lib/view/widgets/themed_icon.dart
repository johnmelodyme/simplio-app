import 'package:flutter/material.dart';

class ThemedIcon extends StatelessWidget {
  final IconData icon;
  final double size;

  const ThemedIcon(this.icon, {super.key, this.size = 18.0});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: Theme.of(context).colorScheme.onPrimary,
    );
  }
}
