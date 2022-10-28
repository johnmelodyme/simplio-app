import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/data/model/network_wallet.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:simplio_app/data/repositories/fee_repository.dart';
import 'package:simplio_app/data/repositories/swap_repository.dart';
import 'package:simplio_app/data/repositories/wallet_repository.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/extensions/double_extensions.dart';
import 'package:simplio_app/view/extensions/number_extensions.dart';

part 'asset_exchange_form_state.dart';

class AssetExchangeFormCubit extends Cubit<AssetExchangeFormState> {
  final SwapRepository _swapRepository;
  final FeeRepository _feeRepository;
  final WalletRepository _walletRepository;

  AssetExchangeFormCubit._(
    this._swapRepository,
    this._feeRepository,
    this._walletRepository,
  ) : super(AssetExchangeFormState.init());

  AssetExchangeFormCubit({
    required swapRepository,
    required feeRepository,
    required walletRepository,
  }) : this._(swapRepository, feeRepository, walletRepository);

  Timer? _apiCallDelayTimer;

  void changeFormValue({
    String? nextAmountFromDigit,
    String? nextAmountFromFiatDigit,
    String? nextAmountToDigit,
    String? nextAmountToFiatDigit,
    String? totalAmount,
  }) {
    final newState = state.copyWith(
      amountFrom: nextAmountFromDigit != null
          ? '${state.amountFrom == '0' ? '' : state.amountFrom}$nextAmountFromDigit'
          : null,
      amountFromFiat: nextAmountFromFiatDigit != null
          ? '${state.amountFromFiat == '0' ? '' : state.amountFromFiat}$nextAmountFromFiatDigit'
          : null,
      amountTo: nextAmountToDigit != null
          ? '${state.amountTo == '0' ? '' : state.amountTo}$nextAmountToDigit'
          : null,
      totalAmount: totalAmount,
    );

    emit(newState);

    if (nextAmountFromDigit != null) {
      _changeAmountFrom(newState.amountFrom);
    }
    if (nextAmountFromFiatDigit != null) {
      _changeAmountFromFiat(newState.amountFromFiat);
    }
    if (nextAmountToDigit != null) {
      _changeAmountTo(newState.amountTo);
    }
    if (nextAmountFromFiatDigit != null) {
      _changeAmountToFiat(newState.amountToFiat);
    }
  }

  void changeAssetWallets({
    AssetWallet? sourceAssetWallet,
    NetworkWallet? sourceNetworkWallet,
    AssetWallet? targetAssetWallet,
    NetworkWallet? targetNetworkWallet,
  }) {
    emit(state.copyWith(
      sourceAssetWallet: sourceAssetWallet,
      sourceNetworkWallet: sourceNetworkWallet,
      targetAssetWallet: targetAssetWallet,
      targetNetworkWallet: targetNetworkWallet,
    ));
    if (state.focusedDirection == FocusedDirection.from &&
        (sourceAssetWallet != null || sourceNetworkWallet != null)) {
      _fetchAmountTo();
    }

    if (state.focusedDirection == FocusedDirection.to &&
        (targetAssetWallet != null || targetNetworkWallet != null)) {
      _fetchAmountFrom();
    }
  }

  void changeAmountUnit({
    AmountUnit? amountFromUnit,
    AmountUnit? amountToUnit,
  }) {
    emit(state.copyWith(
      amountFromUnit: amountFromUnit,
      amountToUnit: amountToUnit,
    ));
  }

  void _changeAmountFrom(String amountFrom) {
    // todo: add correct price
    const price = 19523.2;

    final result = double.tryParse(amountFrom);
    if (result != null) {
      emit(state.copyWith(
        amountFrom: amountFrom,
        amountFromFiat: '${result * price}',
        focusedDirection: FocusedDirection.from,
      ));

      _fetchAmountTo();
    } else {
      emit(state.copyWith(
        amountFrom: amountFrom,
        amountTo: '',
        amountFromFiat: '',
        focusedDirection: FocusedDirection.from,
      ));
    }
  }

  void _changeAmountFromFiat(String amountFromFiat) {
    // todo: add correct price
    const price = 19523.2;

    final result = double.tryParse(amountFromFiat);
    if (result != null) {
      emit(state.copyWith(
        amountFromFiat: amountFromFiat,
        amountFrom: '${result / price}',
        focusedDirection: FocusedDirection.from,
      ));

      _fetchAmountTo();
    } else {
      emit(state.copyWith(
        amountFromFiat: amountFromFiat,
        amountFrom: '',
        amountTo: '',
        focusedDirection: FocusedDirection.from,
      ));
    }
  }

  void _changeAmountTo(String amountTo) {
    final result = double.tryParse(amountTo);
    if (result != null) {
      emit(state.copyWith(
        amountTo: amountTo,
        focusedDirection: FocusedDirection.to,
      ));

      _fetchAmountFrom();
    } else {
      emit(state.copyWith(
        amountFrom: '',
        amountFromFiat: '',
        amountTo: amountTo,
        focusedDirection: FocusedDirection.to,
      ));
    }
  }

  void _changeAmountToFiat(String amountToFiat) {
    // todo: add correct price
    const price = 19523.2;

    final result = double.tryParse(amountToFiat);
    if (result != null) {
      emit(state.copyWith(
        amountToFiat: amountToFiat,
        amountFrom: '${result / price}',
        focusedDirection: FocusedDirection.to,
      ));

      _fetchAmountFrom();
    } else {
      emit(state.copyWith(
        amountFromFiat: amountToFiat,
        amountFrom: '',
        amountTo: '',
        focusedDirection: FocusedDirection.to,
      ));
    }
  }

  void eraseAmountFrom() async {
    if (state.amountFrom.isNotEmpty) {
      String result =
          state.amountFrom.substring(0, state.amountFrom.length - 1);
      if (result.isEmpty) {
        result = AssetExchangeFormState.init().amountFrom;
      }

      _changeAmountFrom(result);
    }
  }

  void eraseAmountFromFiat() async {
    if (state.amountFromFiat.isNotEmpty) {
      String result =
          state.amountFromFiat.substring(0, state.amountFromFiat.length - 1);
      if (result.isEmpty) {
        result = AssetExchangeFormState.init().amountFromFiat;
      }

      _changeAmountFromFiat(result);
    }
  }

  void eraseAmountTo() async {
    if (state.amountTo.isNotEmpty) {
      String result = state.amountTo.substring(0, state.amountTo.length - 1);
      if (result.isEmpty) {
        result = AssetExchangeFormState.init().amountTo;
      }

      _changeAmountTo(result);
    }
  }

  void eraseAmountToFiat() async {
    if (state.amountToFiat.isNotEmpty) {
      String result =
          state.amountToFiat.substring(0, state.amountToFiat.length - 1);
      if (result.isEmpty) {
        result = AssetExchangeFormState.init().amountToFiat;
      }

      _changeAmountToFiat(result);
    }
  }

  void addDecimalDotAmountFrom() async {
    if (state.amountFrom.contains('.')) return;

    var result = double.tryParse(state.amountFrom);
    result ??= 0;

    emit(state.copyWith(
      amountFrom: result.lastChar, // need to remove 0 char in the end
    ));
  }

  void addDecimalDotAmountFromFiat() async {
    if (state.amountFromFiat.contains('.')) return;

    var result = double.tryParse(state.amountFromFiat);
    result ??= 0;

    emit(state.copyWith(
      amountFromFiat: result.lastChar, // need to remove 0 char in the end
    ));
  }

  void addDecimalDotAmountTo() async {
    if (state.amountTo.contains('.')) return;

    var result = double.tryParse(state.amountTo);
    result ??= 0;

    emit(state.copyWith(
      amountTo: result.lastChar, // need to remove 0 char in the end
    ));
  }

  void addDecimalDotAmountToFiat() async {
    if (state.amountToFiat.contains('.')) return;

    var result = double.tryParse(state.amountToFiat);
    result ??= 0;

    emit(state.copyWith(
      amountToFiat: result.lastChar, // need to remove 0 char in the end
    ));
  }

  void _fetchAmountTo() {
    emit(state.copyWith(response: const AmountToPending()));
    if (_apiCallDelayTimer != null) {
      _apiCallDelayTimer!.cancel();
    }
    _apiCallDelayTimer = Timer(const Duration(milliseconds: 300), () async {
      if (state.amountFrom.isNotEmpty && double.parse(state.amountFrom) > 0) {
        final swapParams = await _swapRepository.getSwapData(
          sourceAmount: doubleStringToBigInt(
            state.amountFrom,
            state.sourceNetworkWallet.preset.decimalPlaces,
          ),
          sourceAssetId: state.sourceAssetWallet.assetId,
          sourceNetworkId: state.sourceNetworkWallet.networkId,
          targetAssetId: state.targetAssetWallet.assetId,
          targetNetworkId: state.targetNetworkWallet.networkId,
        );

        emit(
          state.copyWith(
            response: const AmountToSuccess(),
            amountTo:
                swapParams.targetGuaranteedWithdrawalAmount.toDecimalString(
              decimalOffset: state.targetNetworkWallet.preset.decimalPlaces,
            ),
          ),
        );
      } else {
        emit(state.copyWith(
          amountToFiat: '0',
          amountTo: '0',
          response: const AmountToSuccess(),
        ));
      }
    });
  }

  void _fetchAmountFrom() {
    emit(state.copyWith(response: const AmountFromPending()));
    if (_apiCallDelayTimer != null) _apiCallDelayTimer!.cancel();
    _apiCallDelayTimer = Timer(const Duration(milliseconds: 300), () async {
      if (state.amountTo.isNotEmpty && double.parse(state.amountTo) > 0) {
        final swapParams = await _swapRepository.getSwapData(
          sourceAmount: doubleStringToBigInt(
            state.amountTo,
            state.targetNetworkWallet.preset.decimalPlaces,
          ),
          sourceAssetId: state.targetAssetWallet.assetId,
          sourceNetworkId: state.targetNetworkWallet.networkId,
          targetAssetId: state.sourceAssetWallet.assetId,
          targetNetworkId: state.sourceNetworkWallet.networkId,
        );

        emit(
          state.copyWith(
            response: const AmountFromSuccess(),
            amountFrom:
                swapParams.targetGuaranteedWithdrawalAmount.toDecimalString(
              decimalOffset: state.sourceNetworkWallet.preset.decimalPlaces,
            ),
            // TODO: add this fiat calculation when backend provide the value in swapParams
            amountFromFiat: '',
          ),
        );
      } else {
        emit(state.copyWith(
          amountFromFiat: '0',
          amountFrom: '0',
          response: const AmountFromSuccess(),
        ));
      }
    });
  }

  void minAmountClicked() async {
    final swapParams = await _swapRepository.getSwapData(
      sourceAmount: BigInt.from(1000000),
      sourceAssetId: state.sourceAssetWallet.assetId,
      sourceNetworkId: state.sourceNetworkWallet.networkId,
      targetAssetId: state.targetAssetWallet.assetId,
      targetNetworkId: state.targetNetworkWallet.networkId,
    );

    emit(
      state.copyWith(
        amountFrom: (swapParams.sourceMinDepositAmount).getFormattedBalance(
          state.sourceNetworkWallet.preset.decimalPlaces,
        ),
      ),
    );

    _fetchAmountTo();
  }

  void maxAmountClicked() async {
    emit(
      state.copyWith(
        amountFrom: state.sourceNetworkWallet.balance.getFormattedBalance(
          state.sourceNetworkWallet.preset.decimalPlaces,
        ),
      ),
    );

    _fetchAmountTo();
  }

  Future<void> summaryPageReadyState(String accountWalletId) async {
    emit(state.copyWith(response: const FetchingFeesPending()));

    final swapPairs = await _swapRepository.loadSwapRoutes();
    emit(state.copyWith(
      sourceDepositAddress: swapPairs
          .firstWhere((e) =>
              e.sourceAsset.assetId == state.sourceAssetWallet.assetId &&
              e.sourceAsset.networkId == state.sourceNetworkWallet.networkId &&
              e.targetAsset.assetId == state.targetAssetWallet.assetId &&
              e.targetAsset.networkId == state.targetNetworkWallet.networkId)
          .sourceDepositAddress,
    ));

    if (state.sourceDepositAddress == '') {
      throw Exception('Empty source deposit address');
    }

    final targetAddressIsValid = _walletRepository.isValidAddress(
      address: state.sourceDepositAddress,
      networkId: state.sourceNetworkWallet.networkId,
    );

    if (!targetAddressIsValid) {
      throw Exception('Source deposit address is not valid');
    }

    final swapParams = await _swapRepository.getSwapData(
      sourceAmount: doubleStringToBigInt(
        state.amountFrom,
        state.sourceNetworkWallet.preset.decimalPlaces,
      ),
      sourceAssetId: state.sourceAssetWallet.assetId,
      sourceNetworkId: state.sourceNetworkWallet.networkId,
      targetAssetId: state.targetAssetWallet.assetId,
      targetNetworkId: state.targetNetworkWallet.networkId,
    );

    final fees = await _feeRepository.loadFees(
      assetId: state.sourceAssetWallet.assetId,
      networkId: state.sourceNetworkWallet.networkId,
    );

    final WalletTransaction tx = await _walletRepository.signTransaction(
      accountWalletId,
      networkId: state.sourceNetworkWallet.networkId,
      toAddress: state.sourceDepositAddress,
      amount: BigInt.zero,
      feeAmount: fees.highFee,
      gasLimit: fees.gasLimit,
      assetDecimals: state.sourceNetworkWallet.preset.decimalPlaces,
      contractAddress: state.sourceNetworkWallet.preset.contractAddress,
    );

    final totalSwapFee = swapParams.totalSwapFee + tx.networkFee;
    final sourceTransactionFee =
        swapParams.sourceTransactionFee + tx.networkFee;
    emit(
      state.copyWith(
        totalSwapFee: totalSwapFee,
        sourceTransactionFee: sourceTransactionFee,
        targetTransactionFee: swapParams.targetTransactionFee,
        swapFee: swapParams.swapFee,
        baseNetworkFee: fees.highFee,
        networkFee: tx.networkFee,
        gasLimit: fees.gasLimit,
        amountToAfterFee: swapParams.targetGuaranteedWithdrawalAmount,
        response: FetchingFeesSuccess(
          totalSwapFee: totalSwapFee.getFormattedBalance(
            state.sourceNetworkWallet.preset.decimalPlaces,
          ),
        ),
      ),
    );
  }

  void submitForm(String accountWalletId) async {
    if (state.sourceNetworkWallet.isNotToken) {
      if (state.amountToSend < BigInt.zero) {
        throw Exception('Amount to send can\'t be negative');
      }
    }

    final amount = state.sourceNetworkWallet.isNotToken
        ? state.amountToSend
        : doubleStringToBigInt(
            state.amountFrom,
            state.sourceNetworkWallet.preset.decimalPlaces,
          );

    final WalletTransaction tx = await _walletRepository.signTransaction(
      accountWalletId,
      networkId: state.sourceNetworkWallet.networkId,
      toAddress: state.sourceDepositAddress,
      amount: amount,
      feeAmount: state.baseNetworkFee,
      gasLimit: state.gasLimit,
      assetDecimals: state.sourceNetworkWallet.preset.decimalPlaces,
      contractAddress: state.sourceNetworkWallet.preset.contractAddress,
    );

    final String txHash = await _walletRepository.broadcastTransaction(tx);

    await _swapRepository.startSwap(
      sourceTxHash: txHash,
      targetAddress: state.targetNetworkWallet.address,
      refundAddress: state.sourceNetworkWallet.address,
      userAgreedAmount: amount,
      sourceAssetId: state.sourceAssetWallet.assetId,
      sourceNetworkId: state.sourceNetworkWallet.networkId,
      targetAssetId: state.targetAssetWallet.assetId,
      targetNetworkId: state.targetNetworkWallet.networkId,
      slippage: 1,
    );

    emit(state.copyWith(
      response: const AssetExchangeFormPending(),
    ));
  }

  @override
  Future<void> close() async {
    if (_apiCallDelayTimer != null) _apiCallDelayTimer!.cancel();
    super.close();
  }

  Future<void> loadAvailableSourcePairs(
    List<AssetWallet> availableWallets,
  ) async {
    emit(state.copyWith(
      availableFromAssets: [],
      response: const SearchAssetsLoading(),
    ));
    final swapPairs = await _swapRepository.loadSwapRoutes();

    final sourceAssets = swapPairs.map((e) => e.sourceAsset).toList();
    final availableFromAssets = availableWallets.where((wallet) {
      final filteredSourceAssets = sourceAssets.where((e) =>
          e.assetId == wallet.assetId && wallet.getWallet(e.networkId) != null);

      return filteredSourceAssets.isNotEmpty;
    }).toList();

    final sourceAssetWallet = availableWallets
            .any((e) => e.assetId == state.sourceAssetWallet.assetId)
        ? state.sourceAssetWallet
        : availableWallets.first;

    final networkWallet = availableWallets.any((e) => e.wallets
            .any((ee) => ee.networkId == state.sourceNetworkWallet.networkId))
        ? state.sourceNetworkWallet
        : availableWallets.first.wallets.first;

    if (swapPairs.isNotEmpty) {
      final swapPair = swapPairs.where((e) =>
          e.sourceAsset.assetId == sourceAssetWallet.assetId &&
          e.sourceAsset.networkId == networkWallet.networkId);

      if (swapPair.isNotEmpty) {
        emit(
          state.copyWith(
            sourceAssetWallet: sourceAssetWallet,
            sourceNetworkWallet: networkWallet,
            availableFromAssets: availableFromAssets,
            response: const SearchAssetsSuccess(),
          ),
        );
      } else {
        // in case current asset is not supported select the first in the list
        emit(
          state.copyWith(
            sourceAssetWallet: availableFromAssets.first,
            sourceNetworkWallet: availableFromAssets.first.wallets.first,
            availableFromAssets: availableFromAssets,
            response: const SearchAssetsFailure(), // todo: add error handling
          ),
        );
      }

      loadAvailableTargetPairs(availableWallets,
          state.sourceAssetWallet.assetId, state.sourceNetworkWallet.networkId);
    } else {
      emit(
        state.copyWith(
          sourceAssetWallet: availableFromAssets.first,
          sourceNetworkWallet: availableFromAssets.first.wallets.first,
          availableFromAssets: availableFromAssets,
          response: const SearchAssetsFailure(),
        ),
      );
    }
  }

  Future<void> loadAvailableTargetPairs(
    List<AssetWallet> availableWallets,
    int sourceWalletAssetId,
    int sourceWalletNetworkId,
  ) async {
    emit(state.copyWith(
      availableTargetAssets: [],
      response: const SearchAssetsLoading(),
    ));
    final swapPairs = await _swapRepository.loadSwapRoutes();

    final targetAssets = swapPairs
        .where((e) =>
            e.sourceAsset.assetId == sourceWalletAssetId &&
            e.sourceAsset.networkId == sourceWalletNetworkId)
        .map((e) => e.targetAsset)
        .toList();
    final availableTargetAssets = availableWallets.where((wallet) {
      final filteredTargetAssets = targetAssets.where((e) =>
          e.assetId == wallet.assetId && wallet.getWallet(e.networkId) != null);
      return filteredTargetAssets.isNotEmpty;
    }).toList();

    if (availableTargetAssets.isNotEmpty) {
      final targetAssetWallet =
          availableTargetAssets.contains(state.targetAssetWallet)
              ? state.targetAssetWallet
              : availableTargetAssets.first;

      final targetNetworkWallet =
          targetAssetWallet.wallets.contains(state.targetNetworkWallet)
              ? state.targetNetworkWallet
              : availableTargetAssets.first.wallets.first;

      emit(
        state.copyWith(
          targetAssetWallet: targetAssetWallet,
          targetNetworkWallet: targetNetworkWallet,
          availableTargetAssets: availableTargetAssets,
          response: const SearchAssetsSuccess(),
        ),
      );
    } else {
      emit(
        state.copyWith(
          availableTargetAssets: availableTargetAssets,
          response: const SearchAssetsSuccess(),
        ),
      );
    }
  }

  void clear() {
    emit(AssetExchangeFormState.init());
  }
}
