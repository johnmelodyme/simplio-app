part of 'pin_setup_cubit.dart';

class PinSetupFormState extends Equatable {
  final ValidatedPin pin;
  final PinFormResponse? response;

  const PinSetupFormState._({
    required this.pin,
    this.response,
  });

  const PinSetupFormState.init() : this._(pin: const ValidatedPin());

  bool get isValid => pin.isValid;

  @override
  List<Object?> get props => [pin, response];

  PinSetupFormState copyWith({
    ValidatedPin? pin,
    PinFormResponse? response,
  }) {
    return PinSetupFormState._(
      pin: pin ?? this.pin,
      response: response ?? this.response,
    );
  }
}

abstract class PinFormResponse extends Equatable {
  const PinFormResponse();
}

class PinSetupFormPending extends PinFormResponse {
  const PinSetupFormPending();

  @override
  List<Object?> get props => [];
}

class PinSetupFormSuccess extends PinFormResponse {
  final Account account;

  const PinSetupFormSuccess({required this.account});

  @override
  List<Object?> get props => [account];
}

class PinSetupFormFailure extends PinFormResponse {
  final Exception exception;

  const PinSetupFormFailure({required this.exception});

  @override
  List<Object?> get props => [exception];
}
