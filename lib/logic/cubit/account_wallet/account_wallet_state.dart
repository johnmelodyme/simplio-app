part of 'account_wallet_cubit.dart';

abstract class AccountWalletState extends Equatable {
  const AccountWalletState();

  @override
  List<Object?> get props => [];
}

class AccountWalletInitial extends AccountWalletState {
  const AccountWalletInitial();
}

class AccountWalletLoading extends AccountWalletState {
  const AccountWalletLoading();
}

abstract class AccountWalletProvided extends AccountWalletState {
  final AccountWallet wallet;

  const AccountWalletProvided({
    required this.wallet,
  }) : super();

  @override
  List<Object?> get props => [wallet];
}

class AccountWalletLoaded extends AccountWalletProvided {
  const AccountWalletLoaded({required super.wallet});
}

class AccountWalletLoadedWithError extends AccountWalletState {
  final Exception error;
  const AccountWalletLoadedWithError({required this.error});

  @override
  List<Object?> get props => [error];
}

class AccountWalletChanged extends AccountWalletProvided {
  const AccountWalletChanged({required super.wallet});
}

class AccountWalletChangedWithError extends AccountWalletProvided {
  final Exception error;

  const AccountWalletChangedWithError({
    required super.wallet,
    required this.error,
  });

  @override
  List<Object?> get props => [wallet, error];
}
