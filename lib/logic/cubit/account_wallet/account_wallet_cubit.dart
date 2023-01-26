import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/models/error.dart';
import 'package:simplio_app/data/models/transaction.dart';
import 'package:simplio_app/data/models/wallet.dart';
import 'package:simplio_app/data/repositories/interfaces/wallet_repository.dart';

part 'account_wallet_state.dart';

class AccountWalletCubit extends Cubit<AccountWalletState> {
  final WalletRepository _walletRepository;

  AccountWalletCubit._(
    this._walletRepository,
  ) : super(const AccountWalletInitial());

  AccountWalletCubit({
    required WalletRepository walletRepository,
  }) : this._(walletRepository);

  Future<void> loadWallet(
    String accountId, {
    required String key,
  }) async {
    emit(const AccountWalletLoading());

    try {
      final w = await _walletRepository.loadAccountWallet(
        accountId,
        key: key,
      );

      emit(AccountWalletLoaded(wallet: w));
    } on BaseError catch (e) {
      emit(AccountWalletLoadedWithError(e));
    }
  }

  Future<void> enableNetworkWallet({
    required AssetId assetId,
    required NetworkId networkId,
  }) async {
    final s = state;
    if (s is! AccountWalletProvided) return;

    final w = await _walletRepository.enableNetworkWallet(
      s.wallet,
      assetId: assetId,
      networkId: networkId,
    );

    emit(AccountWalletUpdated(wallet: w));
  }

  Future<void> disableNetworkWallet({
    required AssetId assetId,
    required NetworkId networkId,
  }) async {
    final s = state;
    if (s is! AccountWalletProvided) return;

    final w = await _walletRepository.disableNetworkWallet(
      s.wallet,
      assetId: assetId,
      networkId: networkId,
    );

    emit(AccountWalletUpdated(wallet: w));
  }

  Future<void> updateAccountWalletBalance({
    required String currency,
  }) async {
    final s = state;
    if (s is! AccountWalletProvided) return;

    try {
      final w = await _walletRepository.updateAccountWalletBalance(
        s.wallet,
        currency: currency,
      );

      emit(AccountWalletUpdated(wallet: w));
    } on BaseError catch (e) {
      emit(AccountWalletUpdatedWithError(e, wallet: s.wallet));
    } catch (_) {
      return;
    }
  }

  Future<void> updateNetworkWalletBalance(
    NetworkWallet networkWallet,
  ) {
    throw UnimplementedError();
  }
}
