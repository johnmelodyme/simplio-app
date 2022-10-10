import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SioScaffold(
        body: Center(
          child: Text(
            'GamesScreen screen placeholder',
            style: SioTextStyles.bodyStyle.apply(color: SioColors.whiteBlue),
          ),
        ),
      ),
    );
  }
}
