part of 'password_change_form_cubit.dart';

class PasswordChangeFormState extends Equatable {
  final ValidatedPassword oldPassword;
  final ValidatedPassword newPassword;
  final ValidatedPassword newConfirmedPassword;
  final PasswordChangeFormResponse? response;

  const PasswordChangeFormState._({
    required this.oldPassword,
    required this.newPassword,
    required this.newConfirmedPassword,
    this.response,
  });

  const PasswordChangeFormState.init()
      : this._(
          oldPassword: const ValidatedPassword(),
          newPassword: const ValidatedPassword(),
          newConfirmedPassword: const ValidatedPassword(),
        );

  @override
  List<Object?> get props => [
        oldPassword,
        newPassword,
        response,
      ];

  PasswordChangeFormState copyWith({
    String? oldPassword,
    String? newPassword,
    String? newConfirmedPassword,
    PasswordChangeFormResponse? response,
  }) {
    return PasswordChangeFormState._(
      oldPassword: ValidatedPassword(
        value: oldPassword ?? this.oldPassword.toString(),
      ),
      newPassword: ValidatedPassword(
        value: newPassword ?? this.newPassword.toString(),
      ),
      newConfirmedPassword: ValidatedPassword(
        value: newConfirmedPassword ?? this.newConfirmedPassword.toString(),
      ),
      response: response ?? this.response,
    );
  }
}

abstract class PasswordChangeFormResponse extends Equatable {
  const PasswordChangeFormResponse();
}

class PasswordChangeFormPending extends PasswordChangeFormResponse {
  const PasswordChangeFormPending();

  @override
  List<Object?> get props => [];
}

class PasswordChangeFormSuccess extends PasswordChangeFormResponse {
  const PasswordChangeFormSuccess();

  @override
  List<Object?> get props => [];
}

class PasswordChangeFormFailure extends PasswordChangeFormResponse {
  final Exception exception;

  const PasswordChangeFormFailure({required this.exception});

  @override
  List<Object?> get props => [exception];
}
