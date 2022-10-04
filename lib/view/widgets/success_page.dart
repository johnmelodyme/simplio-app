import 'package:flutter/material.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/success_button.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({
    super.key,
    required this.centerChild,
    required this.doneAction,
    this.option,
    this.optionalAction,
  });

  final Widget centerChild;
  final GestureTapCallback doneAction;
  final Text? option;
  final GestureTapCallback? optionalAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      body: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.tertiary,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            centerChild,
            const Spacer(),
            Padding(
              padding: Paddings.horizontal20,
              child: SuccessButton(
                text: context.locale.common_done,
                onTap: doneAction,
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
          ],
        ),
      ),
    );
  }
}
