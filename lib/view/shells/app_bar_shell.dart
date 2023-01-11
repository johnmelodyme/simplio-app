import 'package:flutter/material.dart';
import 'package:simplio_app/view/widgets/avatar_app_bar_blured.dart';

class AppBarShell extends StatelessWidget {
  final Widget child;

  const AppBarShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        const AvatarAppBarBlured(),
      ],
    );
  }
}
