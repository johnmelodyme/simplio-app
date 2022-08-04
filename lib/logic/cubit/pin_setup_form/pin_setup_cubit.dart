import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/model/account.dart';
import 'package:simplio_app/data/model/validated_pin.dart';
import 'package:simplio_app/data/repositories/account_repository.dart';

part 'pin_setup_state.dart';

class PinSetupFormCubit extends Cubit<PinSetupFormState> {
  final AccountRepository _accountRepository;

  PinSetupFormCubit._(
    this._accountRepository,
  ) : super(const PinSetupFormState.init());

  PinSetupFormCubit.builder({
    required AccountRepository accountRepository,
  }) : this._(accountRepository);

  void changeFormValue(int value) {
    final currVal = state.pin;

    if (currVal.value.length == ValidatedPin.length) return;

    final List<int> val = List.from(currVal.value)..add(value);

    emit(state.copyWith(
      pin: currVal.copyWith(value: val),
    ));
  }

  void eraseLastValue() {
    final currVal = state.pin;

    if (currVal.value.isEmpty) return;

    final List<int> val = List.from(currVal.value)..removeLast();

    emit(state.copyWith(
      pin: currVal.copyWith(value: val),
    ));
  }

  Future<void> submitForm(Account account) async {
    final pin = state.pin;

    emit(state.copyWith(
      response: const PinSetupFormPending(),
    ));

    try {
      final acc = await _accountRepository.updateSecret(
        account,
        key: pin.toString(),
      );

      emit(state.copyWith(
        response: PinSetupFormSuccess(account: acc),
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        response: PinSetupFormFailure(exception: e),
      ));
    }
  }
}
