import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class AvatarWithShadov extends StatelessWidget {
  const AvatarWithShadov({
    Key? key,
    this.child,
    this.backgroundColor = SioColors.white,
    this.size = 40,
  }) : super(key: key);

  final Widget? child;
  final Color backgroundColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(size / 2)),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(55, 255, 198, 0.35),
              spreadRadius: size / 6,
              blurRadius: size / 2,
              offset: const Offset(1, 1),
            ),
            const BoxShadow(
              color: Color.fromRGBO(55, 255, 198, 0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: SizedBox(
          width: size,
          height: size,
          child: child != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(size / 2),
                  child: child,
                )
              : null,
        ));
  }
}
