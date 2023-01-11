import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:sio_glyphs/sio_icons.dart';

// TODO - remove this widget after refactoring.
class AssetFormException<B extends StateStreamable<S>, S extends dynamic>
    extends StatelessWidget {
  final int formElementIndex;

  const AssetFormException({
    super.key,
    this.formElementIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      BlocBuilder<B, S>(
          buildWhen: (prev, curr) => prev.hasWarnings != curr.hasWarnings,
          builder: (context, state) {
            bool displayWarning = state.hasWarnings[formElementIndex];

            return displayWarning && state.hasWarnings[formElementIndex]
                ? Padding(
                    padding: const EdgeInsets.only(
                      top: Dimensions.padding10,
                      bottom: Dimensions.padding5,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          SioIcons.info_outline,
                          color: SioColors.highlight,
                          size: Dimensions.padding16,
                        ),
                        Gaps.gap10,
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            state.warnings(context)[formElementIndex],
                            style: SioTextStyles.bodyS.copyWith(
                              color: SioColors.highlight,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : const SizedBox.shrink();
          }),
      BlocBuilder<B, S>(
          buildWhen: (prev, curr) => prev.hasErrors != curr.hasErrors,
          builder: (context, state) {
            bool displayError = state.hasErrors[formElementIndex];

            return displayError && state.hasErrors[formElementIndex]
                ? Padding(
                    padding: const EdgeInsets.only(
                      top: Dimensions.padding10,
                      bottom: Dimensions.padding5,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          SioIcons.info_outline,
                          color: SioColors.attention,
                          size: Dimensions.padding16,
                        ),
                        Gaps.gap5,
                        Text(
                          state.errors(context)[formElementIndex],
                          style: SioTextStyles.bodyS.copyWith(
                            color: SioColors.attention,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink();
          }),
    ]);
  }
}
