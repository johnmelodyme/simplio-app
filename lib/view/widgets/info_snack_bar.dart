import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';

class InfoSnackBar extends StatelessWidget {
  final String text;

  const InfoSnackBar(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Paddings.horizontal20,
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize),
            ),
          ),
          Icon(
            color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            Icons.info_outline,
          )
        ],
      ),
    );
  }
}
