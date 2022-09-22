import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/model/account.dart';
import 'package:simplio_app/data/model/helpers/validated_pin.dart';
import 'package:simplio_app/data/repositories/account_repository.dart';

part 'pin_verify_state.dart';

class PinVerifyFormCubit extends Cubit<PinVerifyFormState> {
  final AccountRepository _accountRepository;

  PinVerifyFormCubit._(
    this._accountRepository,
    Account account,
  ) : super(PinVerifyFormState.init(account));

  PinVerifyFormCubit.builder({
    required AccountRepository accountRepository,
    required Account account,
  }) : this._(accountRepository, account);

  void changeFormValue(int value) {
    final pin = state.pin;

    final List<int> val = List.from(pin.value)..add(value);

    emit(state.copyWith(
      pin: pin.copyWith(value: val),
    ));

    if (state.isValid) {
      submitForm();
    }
  }

  void eraseLastValue() {
    final pin = state.pin;

    if (pin.value.isEmpty) return;

    final List<int> val = List.from(pin.value)..removeLast();

    emit(state.copyWith(
      pin: pin.copyWith(value: val),
    ));
  }

  void submitForm() async {
    emit(state.copyWith(response: const PinVerifyFormPending()));

    final res = _accountRepository.verifyPin(
      state.account,
      state.pin.toString(),
    );

    if (res.secret != null) {
      return emit(state.copyWith(
        account: res.account,
        response: PinVerifyFormSuccess(
          account: res.account,
          secret: res.secret!,
        ),
      ));
    }

    if (res.account.securityAttempts > 0) {
      return emit(state.copyWith(
        account: res.account,
        pin: const ValidatedPin(),
        response: const PinVerifyFormInvalid(),
      ));
    }

    return emit(state.copyWith(
      account: res.account,
      response: PinVerifyFormFailure(
        exception: Exception('Pin is incorrect'),
      ),
    ));
  }
}
