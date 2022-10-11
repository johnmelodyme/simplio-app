import 'package:flutter/material.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';
import 'package:simplio_app/view/widgets/bordered_text_button.dart';
import 'package:simplio_app/view/widgets/success_button.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({
    super.key,
    required this.centerChild,
    required this.successAction,
    this.option,
    this.successLabel,
    this.optionalAction,
    this.goBack = false,
    this.goBackAction,
  });

  final Widget centerChild;
  final GestureTapCallback successAction;
  final Text? option;
  final String? successLabel;
  final GestureTapCallback? optionalAction;
  final bool goBack;
  final VoidCallback? goBackAction;

  @override
  Widget build(BuildContext context) {
    return SioScaffold(
      backgroundColor: SioColors.mentolGreen,
      body: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              SioColors.highlight1,
              SioColors.highlight2,
            ],
            stops: const [0, 1],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Spacer(),
            centerChild,
            const Spacer(),
            Padding(
              padding: Paddings.horizontal20,
              child: SuccessButton(
                text: successLabel ?? context.locale.common_done,
                onTap: successAction,
              ),
            ),
            if (option != null && optionalAction != null)
              Padding(
                padding: Paddings.vertical20,
                child: GestureDetector(
                  onTap: optionalAction,
                  child: option,
                ),
              ),
            if (goBack) ...{
              Gaps.gap10,
              Container(
                width: double.infinity,
                padding: Paddings.horizontal20,
                child: BorderedTextButton(
                  onPressed: goBackAction,
                  label: context.locale.common_go_back,
                  backgroundColor: Colors.transparent,
                  borderColor: SioColors.softBlack,
                  labelColor: SioColors.softBlack,
                ),
              ),
              Gaps.gap30,
            },
          ],
        ),
      ),
    );
  }
}
