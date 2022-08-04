part of 'sign_up_form_cubit.dart';

class SignUpFormState extends Equatable {
  final ValidatedEmail login;
  final ValidatedPassword password;
  final SignUpFormResponse? response;

  const SignUpFormState._({
    required this.login,
    required this.password,
    this.response,
  });

  const SignUpFormState.init()
      : this._(
          login: const ValidatedEmail(),
          password: const ValidatedPassword(),
          response: null,
        );

  bool get isValid => login.isValid && password.isValid;

  @override
  List<Object?> get props => [
        login,
        password,
        response,
      ];

  SignUpFormState copyWith({
    String? login,
    String? password,
    SignUpFormResponse? response,
  }) {
    return SignUpFormState._(
      login: ValidatedEmail(value: login ?? this.login.toString()),
      password: ValidatedPassword(value: password ?? this.password.toString()),
      response: response,
    );
  }
}

abstract class SignUpFormResponse extends Equatable {
  const SignUpFormResponse();
}

class SignUpFormPending extends SignUpFormResponse {
  const SignUpFormPending();

  @override
  List<Object?> get props => [];
}

class SignUpFormSuccess extends SignUpFormResponse {
  final Account account;

  const SignUpFormSuccess({required this.account});

  @override
  List<Object?> get props => [account];
}

class SignUpFormFailure extends SignUpFormResponse {
  final Exception exception;

  const SignUpFormFailure({required this.exception});

  @override
  List<Object?> get props => [exception];
}
