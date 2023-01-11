import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/model/wallet.dart';
import 'package:simplio_app/data/repositories/inventory_repository.dart';
import 'package:simplio_app/data/repositories/swap_repository.dart';
import 'package:simplio_app/data/repositories/wallet_repository.dart';

part 'account_wallet_state.dart';

class AccountWalletCubit extends Cubit<AccountWalletState> {
  final WalletRepository _walletRepository;
  final InventoryRepository _inventoryRepository;
  final SwapRepository _swapRepository;

  AccountWalletCubit._(
    this._walletRepository,
    this._inventoryRepository,
    this._swapRepository,
  ) : super(const AccountWalletInitial());

  AccountWalletCubit.builder({
    required WalletRepository walletRepository,
    required InventoryRepository inventoryRepository,
    required SwapRepository swapRepository,
  }) : this._(
          walletRepository,
          inventoryRepository,
          swapRepository,
        );

  Future<void> loadWallet(
    String accountId, {
    required String key,
  }) async {
    emit(const AccountWalletLoading());

    try {
      final accountWallet = await _walletRepository.loadAccountWallet(
        accountId,
        key: key,
      );

      emit(AccountWalletLoaded(wallet: accountWallet));
    } on Exception catch (e) {
      emit(AccountWalletLoadedWithError(error: e));
    }
  }

  Future<void> enableNetworkWallet({
    required int assetId,
    required int networkId,
  }) async {
    final s = state;
    if (s is! AccountWalletProvided) return;

    _swapRepository.clearSwapRoutesCache();

    try {
      final accountWallet = await _walletRepository.enableNetworkWallet(
        s.wallet,
        assetId: assetId,
        networkId: networkId,
      );

      emit(AccountWalletChanged(wallet: accountWallet));
    } on Exception catch (e) {
      emit(AccountWalletChangedWithError(wallet: s.wallet, error: e));
    }
  }

  Future<void> disableNetworkWallet({
    required int assetId,
    required int networkId,
  }) async {
    final s = state;
    if (s is! AccountWalletProvided) return;

    try {
      final accountWallet = await _walletRepository.disableNetworkWallet(
        s.wallet,
        assetId: assetId,
        networkId: networkId,
      );

      emit(AccountWalletChanged(wallet: accountWallet));
    } on Exception catch (e) {
      emit(AccountWalletChangedWithError(wallet: s.wallet, error: e));
    }
  }

  Future<void> refreshAccountWalletBalance({
    bool forceUpdate = false,
  }) async {
    final s = state;
    if (s is! AccountWalletProvided) return;

    if (s.wallet.isValid && !forceUpdate) return;

    try {
      final wallet = await _inventoryRepository.refreshAccountWalletBalance(
        accountWallet: s.wallet,
        fiatAssetId: 'USD', // todo: use correct fiat
      );

      emit(AccountWalletChanged(wallet: wallet));
    } on Exception catch (e) {
      emit(AccountWalletChangedWithError(wallet: s.wallet, error: e));
    }
  }

  Future<void> refreshNetworkWalletBalance(
    NetworkWallet networkWallet, {
    bool forceUpdate = false,
  }) async {
    final s = state;
    if (s is! AccountWalletProvided) return;

    if (s.wallet.isValid && !forceUpdate) return;

    try {
      final wallet = await _walletRepository.refreshNetworkWalletBalance(
        s.wallet,
        networkWallet: networkWallet,
      );

      emit(AccountWalletChanged(wallet: wallet));
    } on Exception catch (e) {
      emit(AccountWalletChangedWithError(wallet: s.wallet, error: e));
    }
  }
}
