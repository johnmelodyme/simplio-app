import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SioScaffold(
        body: Center(
      child: Text(
        context.locale.not_found_screen_title,
        style: SioTextStyles.h2.copyWith(
          color: SioColors.whiteBlue,
        ),
      ),
    ));
  }
}
