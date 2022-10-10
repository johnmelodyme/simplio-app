import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class AvatarWithShadow extends StatelessWidget {
  const AvatarWithShadow({
    Key? key,
    this.child,
    this.size = 40,
  }) : super(key: key);

  final Widget? child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(size / 2)),
        boxShadow: [
          BoxShadow(
            color: SioColors.mentolGreen.withOpacity(0.2),
            spreadRadius: size / 6,
            blurRadius: size / 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: child,
      ),
    );
  }
}
