import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/model/account.dart';
import 'package:simplio_app/data/repositories/account_repository.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account/account_cubit.dart';
import 'package:simplio_app/logic/cubit/pin_verify_form/pin_verify_cubit.dart';
import 'package:simplio_app/view/themes/common_theme.dart';
import 'package:simplio_app/view/widgets/keypad.dart';
import 'package:simplio_app/view/widgets/pin_digits.dart';

class ProtectedGuard extends StatefulWidget {
  final bool Function(Account account)? protectWhen;
  final Widget protectedChild;
  final Function(BuildContext context) onPrevent;

  const ProtectedGuard({
    super.key,
    this.protectWhen,
    required this.protectedChild,
    required this.onPrevent,
  });

  @override
  State<ProtectedGuard> createState() => _ProtectedGuardState();
}

class _ProtectedGuardState extends State<ProtectedGuard> {
  bool isVerified = false;

  @override
  Widget build(BuildContext context) {
    final Account account = context.read<AccountCubit>().state.account!;
    final shouldProtect = widget.protectWhen?.call(account) ?? true;
    if (!shouldProtect) return widget.protectedChild;

    return isVerified
        ? widget.protectedChild
        : BlocProvider(
            create: (context) => PinVerifyFormCubit.builder(
              accountRepository:
                  RepositoryProvider.of<AccountRepository>(context),
              account: account,
            ),
            child: _Protection(
              onFailure: (context, account) async {
                context
                    .read<AccountCubit>()
                    .updateAccount(account)
                    .then((_) => widget.onPrevent(context));
              },
              onSuccess: (_, account) async {
                context
                    .read<AccountCubit>()
                    .updateAccount(account)
                    .then((_) => setState(() => isVerified = true));
              },
            ),
          );
  }
}

class _Protection extends StatelessWidget {
  final Function(BuildContext context, Account account) onSuccess;
  final Function(BuildContext context, Account account) onFailure;

  const _Protection({
    required this.onSuccess,
    required this.onFailure,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(context.locale.protectedLabel),
                  Padding(
                    padding: CommonTheme.verticalPadding,
                    child: BlocConsumer<PinVerifyFormCubit, PinVerifyFormState>(
                      listenWhen: (previous, current) =>
                          previous.response != current.response,
                      listener: (context, state) {
                        if (state.response is PinVerifyFormSuccess) {
                          onSuccess(context, state.account);
                        }

                        if (state.response is PinVerifyFormFailure) {
                          onFailure(context, state.account);
                        }
                      },
                      buildWhen: (previous, current) =>
                          previous.pin != current.pin,
                      builder: (context, state) {
                        return PinDigits(
                          pin: state.pin.value,
                          pinDigitStyle: PinDigitStyle.hideAllAfterTime,
                          duration: const Duration(seconds: 1),
                        );
                      },
                    ),
                  ),
                  BlocBuilder<PinVerifyFormCubit, PinVerifyFormState>(
                    buildWhen: (previous, current) =>
                        previous.account.securityAttempts !=
                        current.account.securityAttempts,
                    builder: (context, state) {
                      final attempts = state.account.securityAttempts;
                      return Visibility(
                        visible: attempts < securityAttemptsLimit,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainInteractivity: true,
                        maintainSemantics: true,
                        maintainState: true,
                        child: Text(
                          attempts > 1
                              ? "${context.locale.protectedErrorRemaining} $attempts"
                              : context.locale.protectedErrorLast,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Numpad(
                key: const Key('protected-screen-numpad'),
                displayEraseButton: true,
                onTap: (value) async {
                  context.read<PinVerifyFormCubit>().changeFormValue(value);
                },
                onErase: () {
                  context.read<PinVerifyFormCubit>().eraseLastValue();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
