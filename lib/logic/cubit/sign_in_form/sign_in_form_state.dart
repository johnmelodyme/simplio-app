part of 'sign_in_form_cubit.dart';

class SignInFormState extends Equatable {
  final ValidatedEmail login;
  final ValidatedPassword password;
  final SignInFormResponse? response;

  const SignInFormState._({
    required this.login,
    required this.password,
    this.response,
  });

  const SignInFormState.init()
      : this._(
          login: const ValidatedEmail(),
          password: const ValidatedPassword(),
          response: null,
        );

  @override
  List<Object?> get props => [
        login,
        password,
        response,
      ];

  SignInFormState copyWith({
    String? login,
    String? password,
    SignInFormResponse? response,
  }) {
    return SignInFormState._(
      login: ValidatedEmail(value: login ?? this.login.toString()),
      password: ValidatedPassword(value: password ?? this.password.toString()),
      response: response,
    );
  }
}

abstract class SignInFormResponse extends Equatable {
  const SignInFormResponse();
}

class SignInFormPending extends SignInFormResponse {
  const SignInFormPending();

  @override
  List<Object?> get props => [];
}

class SignInFormSuccess extends SignInFormResponse {
  final Account account;

  const SignInFormSuccess({required this.account});

  @override
  List<Object?> get props => [account];
}

class SignInFormFailure extends SignInFormResponse {
  final Exception exception;

  const SignInFormFailure({required this.exception});

  @override
  List<Object?> get props => [exception];
}
