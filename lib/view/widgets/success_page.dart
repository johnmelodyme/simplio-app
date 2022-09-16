import 'package:flutter/material.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';

// todo: correct background from design needs to be applied
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
      body: SafeArea(
        child: Container(
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
                child: GestureDetector(
                  onTap: doneAction,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).highlightColor,
                      borderRadius: BorderRadiuses.radius20,
                    ),
                    child: Padding(
                      padding: Paddings.all8,
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                context.locale.common_done,
                                style: SioTextStyles.bodyL.apply(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.secondary,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
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
      ),
    );
  }
}
