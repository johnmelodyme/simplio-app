import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:sio_glyphs/sio_icons.dart';

class LockWithShadowIcon extends StatelessWidget {
  const LockWithShadowIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: SioColors.mentolGreen.withOpacity(0.08),
          spreadRadius: 4,
          blurRadius: 70 / 2,
          offset: const Offset(0, 0),
        ),
      ]),
      child: Icon(
        SioIcons.lock,
        color: SioColors.mentolGreen,
        size: 70,
      ),
    );
  }
}
