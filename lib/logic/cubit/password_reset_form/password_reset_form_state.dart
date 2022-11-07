part of 'password_reset_form_cubit.dart';

class PasswordResetFormState extends Equatable {
  final ValidatedEmail email;
  final PasswordResetFormResponse? response;

  const PasswordResetFormState(
    this.email,
    this.response,
  );
  const PasswordResetFormState.init() : this(const ValidatedEmail(), null);

  @override
  List<Object?> get props => [email, response, isValid];

  PasswordResetFormState copyWith({
    String? email,
    PasswordResetFormResponse? response,
  }) {
    return PasswordResetFormState(
      ValidatedEmail(value: email ?? this.email.toString()),
      response,
    );
  }

  bool get isValid => email.isValid;
}

abstract class PasswordResetFormResponse extends Equatable {
  const PasswordResetFormResponse();
}

class PasswordResetFormPending extends PasswordResetFormResponse {
  const PasswordResetFormPending();

  @override
  List<Object?> get props => [];
}

class PasswordResetFormSuccess extends PasswordResetFormResponse {
  const PasswordResetFormSuccess(this.resend);

  final bool resend;

  @override
  List<Object?> get props => [resend];
}

class PasswordResetFormFailure extends PasswordResetFormResponse {
  final Exception exception;

  const PasswordResetFormFailure({required this.exception});

  @override
  List<Object?> get props => [exception];
}
