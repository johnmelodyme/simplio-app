import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/logic/helpers/validated_pin.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account/account_cubit.dart';
import 'package:simplio_app/logic/cubit/pin_setup_form/pin_setup_cubit.dart';
import 'package:simplio_app/view/routers/authenticated_routes/account_setup_success_route.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors_dark.dart';
import 'package:simplio_app/view/widgets/account_created_icon.dart';
import 'package:simplio_app/view/widgets/keypad.dart';
import 'package:simplio_app/view/widgets/pin_digits.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';

class PinSetupScreen extends StatelessWidget {
  const PinSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      key: const ValueKey('pin-setup-screen'),
      onWillPop: () async => false,
      child: SioScaffold(
        body: SafeArea(
          child: Column(children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AccountCreatedIcon(),
                  Gaps.gap20,
                  Text(
                    context.locale.pin_setup_screen_account_creation_title,
                    textAlign: TextAlign.center,
                    style: SioTextStyles.h1.apply(
                      color: SioColorsDark.whiteBlue,
                    ),
                  ),
                  Gaps.gap12,
                  Text(
                    context.locale.pin_setup_screen_account_creation_subtitle,
                    textAlign: TextAlign.center,
                    style: SioTextStyles.bodyPrimary.apply(
                      color: SioColorsDark.secondary7,
                    ),
                  ),
                  Gaps.gap60,
                  BlocBuilder<PinSetupFormCubit, PinSetupFormState>(
                    builder: (context, state) {
                      return PinDigits(
                        duration: const Duration(milliseconds: 600),
                        pinLength: ValidatedPin.length,
                        pin: state.pin.value,
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: BlocConsumer<PinSetupFormCubit, PinSetupFormState>(
                listener: (context, state) {
                  final res = state.response;
                  if (res is PinSetupFormSuccess) {
                    context
                        .read<AccountCubit>()
                        .unlockAccount(res.account, res.secret)
                        .then((_) => GoRouter.of(context).goNamed(
                              AccountSetupSuccessRoute.name,
                            ));
                  }
                },
                buildWhen: (previous, current) =>
                    previous.isValid != current.isValid,
                builder: (context, state) {
                  return Numpad(
                    onTap: (value) {
                      if (value.value < numpadBehaviorRange) {
                        context
                            .read<PinSetupFormCubit>()
                            .changeFormValue(value.value);
                      }

                      if (value == NumpadValue.erase) {
                        context.read<PinSetupFormCubit>().eraseLastValue();
                      }

                      if (value == NumpadValue.proceed) {
                        final s = context.read<AccountCubit>().state;
                        if (s is AccountProvided) {
                          context
                              .read<PinSetupFormCubit>()
                              .submitForm(s.account);
                        }
                      }
                    },
                    displayEraseButton: true,
                    displayProceedButton: state.isValid,
                  );
                },
              ),
            )
          ]),
        ),
      ),
    );
  }
}
