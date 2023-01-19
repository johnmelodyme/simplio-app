import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/models/account.dart';
import 'package:simplio_app/data/repositories/account_repository.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/account/account_cubit.dart';
import 'package:simplio_app/logic/cubit/pin_verify_form/pin_verify_cubit.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/themes/sio_colors_dark.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/keypad.dart';
import 'package:simplio_app/view/widgets/pin_digits.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';

typedef BuildContextCallback = void Function(BuildContext context);

class ProtectedGuard extends StatefulWidget {
  final bool Function(AccountProvided state)? protectWhen;
  final WidgetBuilder protectedBuilder;
  final BuildContextCallback onPrevent;
  final Widget icon;
  final String title;
  final String? subtitle;
  final bool displayAppBar;

  const ProtectedGuard({
    super.key,
    this.protectWhen,
    required this.protectedBuilder,
    required this.onPrevent,
    required this.icon,
    required this.title,
    this.subtitle,
    this.displayAppBar = true,
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
              icon: widget.icon,
              title: widget.title,
              subtitle: widget.subtitle,
              displayAppBar: widget.displayAppBar,
              onFailure: (context, account) {
                return context
                    .read<AccountCubit>()
                    .updateAccount(account)
                    .then((_) => widget.onPrevent(context));
              },
              onInvalid: (context, account) {
                return context.read<AccountCubit>().updateAccount(account);
              },
              onSuccess: (context, response) {
                return context
                    .read<AccountCubit>()
                    .unlockAccount(response.account, response.secret)
                    .then((_) => setState(() => isVerified = true));
              },
            ),
          );
  }
}

class _Protection extends StatelessWidget {
  final Future<void> Function(
    BuildContext context,
    PinVerifyFormSuccess response,
  ) onSuccess;
  final Future<void> Function(
    BuildContext context,
    Account account,
  ) onInvalid;
  final Future<void> Function(
    BuildContext context,
    Account account,
  ) onFailure;
  final Widget icon;
  final String title;
  final String? subtitle;
  final bool displayAppBar;

  const _Protection({
    required this.onSuccess,
    required this.onInvalid,
    required this.onFailure,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.displayAppBar,
  });

  @override
  Widget build(BuildContext context) {
    return SioScaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            if (displayAppBar)
              const ColorizedAppBar(
                title: '',
              ),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  Gaps.gap20,
                  Text(title,
                      textAlign: TextAlign.center,
                      style: SioTextStyles.h1.apply(
                        color: SioColorsDark.whiteBlue,
                      )),
                  if (subtitle != null) ...[
                    Gaps.gap12,
                    Text(
                      subtitle!,
                      textAlign: TextAlign.center,
                      style: SioTextStyles.bodyPrimary.apply(
                        color: SioColorsDark.secondary7,
                      ),
                    ),
                  ],
                  Gaps.gap20,
                  BlocConsumer<PinVerifyFormCubit, PinVerifyFormState>(
                    listenWhen: (p, c) => p.response != c.response,
                    listener: (context, state) async {
                      final res = state.response;

                      if (res is PinVerifyFormSuccess) {
                        return onSuccess(context, res);
                      }

                      if (res is PinVerifyFormInvalid) {
                        return onInvalid(context, state.account);
                      }

                      if (res is PinVerifyFormFailure) {
                        return onFailure(context, state.account);
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
                  Gaps.gap16,
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
                  if (value == NumpadValue.erase) {
                    context.read<PinVerifyFormCubit>().eraseLastValue();
                  }

                  if (value.value < numpadBehaviorRange) {
                    context
                        .read<PinVerifyFormCubit>()
                        .changeFormValue(value.value);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
