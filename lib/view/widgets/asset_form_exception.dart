import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/logic/cubit/asset_exchange_form/asset_exchange_form_cubit.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';

class AssetFormException<B extends StateStreamable<S>,
    S extends AssetFormExceptions> extends StatelessWidget {
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
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.onTertiary,
                          size: Dimensions.padding16,
                        ),
                        Gaps.gap10,
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            state.warnings(context)[formElementIndex],
                            style: SioTextStyles.bodyS.copyWith(
                              color: Theme.of(context).colorScheme.onTertiary,
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
                      left: Dimensions.padding16,
                      top: Dimensions.padding10,
                      bottom: Dimensions.padding5,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.error,
                          size: Dimensions.padding16,
                        ),
                        Gaps.gap5,
                        Text(
                          state.errors(context)[formElementIndex],
                          style: SioTextStyles.bodyS.copyWith(
                            color: Theme.of(context).colorScheme.error,
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
