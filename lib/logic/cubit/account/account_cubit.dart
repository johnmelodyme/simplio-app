import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:simplio_app/data/models/account.dart';
import 'package:simplio_app/data/repositories/account_repository.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final AccountRepository _accountRepository;

  AccountCubit._(
    this._accountRepository,
  ) : super(const AccountInitial());

  AccountCubit({
    required AccountRepository accountRepository,
  }) : this._(accountRepository);

  void loadAccount(Account account) {
    emit(AccountLocked(
      account: account,
    ));
  }

  Future<void> updateAccount(Account account) async {
    final updatedAccount = await _accountRepository.save(account);

    final s = state;
    if (s is! AccountProvided) return;

    emit(s.copyWith(
      account: updatedAccount,
    ));
  }

  Future<void> unlockAccount(Account account, String secret) async {
    final updatedAccount = await _accountRepository.save(account);

    emit(AccountUnlocked(
      account: updatedAccount,
      secret: secret,
    ));
  }

  Future<void> updateLanguage(String languageCode) async {
    final s = state;
    if (s is! AccountProvided) return;

    final updatedAccount = await _accountRepository.updateLanguage(
      s.account,
      languageCode: languageCode,
    );

    emit(s.copyWith(
      account: updatedAccount,
    ));
  }

  Future<void> updateTheme(ThemeMode theme) async {
    final s = state;
    if (s is! AccountProvided) return;

    final updatedAccount = await _accountRepository.updateTheme(
      s.account,
      themeMode: theme,
    );

    emit(s.copyWith(
      account: updatedAccount,
    ));
  }
}
