import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/model/validated_pin.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account/account_cubit.dart';
import 'package:simplio_app/logic/cubit/pin_setup_form/pin_setup_cubit.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/widgets/headline_text.dart';
import 'package:simplio_app/view/widgets/keypad.dart';
import 'package:simplio_app/view/widgets/pin_digits.dart';

class PinSetupScreen extends StatelessWidget {
  const PinSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      key: const ValueKey('pin-setup-screen'),
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Column(children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HeadlineText(
                    context.locale.accountCreationBeforePinSetup,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(context.locale.setPinLabel),
                  ),
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
                              AuthenticatedRouter.accountSetup,
                            ));
                  }
                },
                buildWhen: (previous, current) =>
                    previous.isValid != current.isValid,
                builder: (context, state) {
                  return Numpad(
                    onTap: (value) {
                      context.read<PinSetupFormCubit>().changeFormValue(value);
                    },
                    onErase: () {
                      context.read<PinSetupFormCubit>().eraseLastValue();
                    },
                    onProceed: () {
                      final s = context.read<AccountCubit>().state;
                      if (s is AccountProvided) {
                        context.read<PinSetupFormCubit>().submitForm(s.account);
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
