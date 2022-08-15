part of 'pin_verify_cubit.dart';

class PinVerifyFormState extends Equatable {
  final Account account;
  final ValidatedPin pin;
  final PinVerifyFormResponse? response;

  const PinVerifyFormState._({
    required this.account,
    required this.pin,
    this.response,
  });

  const PinVerifyFormState.init(Account account)
      : this._(account: account, pin: const ValidatedPin());

  bool get isValid => pin.isValid;

  @override
  List<Object?> get props => [
        account,
        pin,
        response,
      ];

  PinVerifyFormState copyWith({
    ValidatedPin? pin,
    Account? account,
    PinVerifyFormResponse? response,
  }) {
    return PinVerifyFormState._(
      account: account ?? this.account,
      pin: pin ?? this.pin,
      response: response ?? this.response,
    );
  }
}

abstract class PinVerifyFormResponse extends Equatable {
  const PinVerifyFormResponse();

  @override
  List<Object?> get props => [];
}

class PinVerifyFormPending extends PinVerifyFormResponse {
  const PinVerifyFormPending();
}

class PinVerifyFormSuccess extends PinVerifyFormResponse {
  final Account account;
  final String secret;

  const PinVerifyFormSuccess({
    required this.account,
    required this.secret,
  });
}

class PinVerifyFormFailure extends PinVerifyFormResponse {
  final Exception exception;

  const PinVerifyFormFailure({
    required this.exception,
  });

  @override
  List<Object?> get props => [exception];
}

class PinVerifyFormInvalid extends PinVerifyFormResponse {
  const PinVerifyFormInvalid();
}
