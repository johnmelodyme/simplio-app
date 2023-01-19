part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class GotAuthenticated extends AuthEvent {
  final Account account;

  const GotAuthenticated({required this.account});

  @override
  List<Object?> get props => [account];
}

class GotUnauthenticated extends AuthEvent {
  final Exception? error;

  const GotUnauthenticated({this.error});

  @override
  List<Object?> get props => [error];
}

class GotLastAuthenticated extends AuthEvent {
  @override
  List<Object?> get props => [];
}
