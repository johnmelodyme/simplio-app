part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class Authenticating extends AuthState {
  const Authenticating();

  @override
  List<Object?> get props => [];
}

class Unauthenticated extends AuthState {
  final Exception? error;

  const Unauthenticated({this.error});

  @override
  List<Object?> get props => [error];
}

class Authenticated extends AuthState {
  final Account account;

  const Authenticated({required this.account});

  @override
  List<Object?> get props => [account];
}
