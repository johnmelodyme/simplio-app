import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/model/account.dart';
import 'package:simplio_app/data/repositories/account_repository.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account/account_cubit.dart';
import 'package:simplio_app/logic/cubit/pin_verify_form/pin_verify_cubit.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/themes/sio_colors_dark.dart';
import 'package:simplio_app/view/widgets/keypad.dart';
import 'package:simplio_app/view/widgets/pin_digits.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';

typedef BuildContextCallback = void Function(BuildContext context);

class ProtectedGuard extends StatefulWidget {
  final bool Function(AccountProvided state)? protectWhen;
  final WidgetBuilder protectedBuilder;
  final BuildContextCallback onPrevent;

  const ProtectedGuard({
    super.key,
    this.protectWhen,
    required this.protectedBuilder,
    required this.onPrevent,
  });

  @override
  State<ProtectedGuard> createState() => _ProtectedGuardState();
}

class _ProtectedGuardState extends State<ProtectedGuard> {
  bool isVerified = false;

  @override
  Widget build(BuildContext context) {
    final s = context.read<AccountCubit>().state;

    if (s is! AccountProvided) {
      widget.onPrevent(context);
      return const SizedBox.shrink();
    }

    bool shouldProtect = widget.protectWhen?.call(s) ?? true;
    if (!shouldProtect) return Builder(builder: widget.protectedBuilder);

    return isVerified
        ? Builder(builder: widget.protectedBuilder)
        : BlocProvider(
            create: (context) => PinVerifyFormCubit.builder(
              accountRepository:
                  RepositoryProvider.of<AccountRepository>(context),
              account: s.account,
            ),
            child: _Protection(
              onFailure: (context, account) async {
                context
                    .read<AccountCubit>()
                    .updateAccount(account)
                    .then((_) => widget.onPrevent(context));
              },
              onSuccess: (context, response) {
                context
                    .read<AccountCubit>()
                    .unlockAccount(response.account, response.secret)
                    .then((_) => setState(() => isVerified = true));
              },
            ),
          );
  }
}

class _Protection extends StatelessWidget {
  final Function(BuildContext context, PinVerifyFormSuccess) onSuccess;
  final Function(BuildContext context, Account account) onFailure;

  const _Protection({
    required this.onSuccess,
    required this.onFailure,
  });

  @override
  Widget build(BuildContext context) {
    return SioScaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(context.locale.protected_guard_enter_pin_code,
                      style: SioTextStyles.bodyPrimary.apply(
                        color: SioColorsDark.whiteBlue,
                      )),
                  Padding(
                    padding: Paddings.vertical20,
                    child: BlocConsumer<PinVerifyFormCubit, PinVerifyFormState>(
                      listenWhen: (p, c) => p.response != c.response,
                      listener: (context, state) {
                        final res = state.response;
                        if (res is PinVerifyFormSuccess) {
                          onSuccess(context, res);
                        }

                        if (res is PinVerifyFormFailure) {
                          onFailure(context, state.account);
                        }
                      },
                      buildWhen: (prev, curr) => prev.pin != curr.pin,
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
                    buildWhen: (prev, curr) =>
                        prev.account.securityAttempts !=
                        curr.account.securityAttempts,
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
                              ? "${context.locale.protected_guard_remaining_attempts} $attempts"
                              : context.locale.protected_guard_last_chance,
                          style: TextStyle(color: SioColors.attention),
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
