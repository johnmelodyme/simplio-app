part of 'account_cubit.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {
  const AccountInitial();
}

class AccountLoading extends AccountState {
  const AccountLoading();
}

abstract class AccountProvided extends AccountState {
  final Account account;

  const AccountProvided({required this.account});

  @override
  List<Object?> get props => [account];

  AccountProvided copyWith({Account? account});
}

class AccountLocked extends AccountProvided {
  const AccountLocked({required super.account});

  @override
  AccountLocked copyWith({Account? account}) {
    return AccountLocked(account: account ?? this.account);
  }
}

class AccountUnlocked extends AccountProvided {
  final String secret;

  const AccountUnlocked({
    required super.account,
    required this.secret,
  });

  @override
  List<Object?> get props => [account, secret];

  @override
  AccountUnlocked copyWith({
    Account? account,
    String? secret,
  }) {
    return AccountUnlocked(
      account: account ?? this.account,
      secret: secret ?? this.secret,
    );
  }
}
