import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/model/network_wallet.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:simplio_app/data/repositories/fee_repository.dart';
import 'package:simplio_app/data/repositories/wallet_repository.dart';
import 'package:simplio_app/logic/extensions/double_extensions.dart';
import 'package:simplio_app/view/extensions/number_extensions.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/asset_exchange_form/asset_exchange_form_cubit.dart';

part 'asset_send_form_state.dart';

class AssetSendFormCubit extends Cubit<AssetSendFormState> {
  final FeeRepository _feeRepository;
  final WalletRepository _walletRepository;

  AssetSendFormCubit._(
    this._feeRepository,
    this._walletRepository,
  ) : super(AssetSendFormState.init());

  AssetSendFormCubit.builder({
    required FeeRepository feeRepository,
    required WalletRepository walletRepository,
  }) : this._(
          feeRepository,
          walletRepository,
        );

  void changeFormValue({
    AssetWallet? sourceAssetWallet,
    NetworkWallet? sourceNetworkWallet,
    String? toAddress,
    String? nextAmountDigit,
    String? nextAmountFiatDigit,
    String? totalAmount,
    AmountUnit? amountUnit,
  }) {
    final newState = state.copyWith(
      sourceAssetWallet: sourceAssetWallet,
      sourceNetworkWallet: sourceNetworkWallet,
      toAddress: toAddress,
      amount: nextAmountDigit != null
          ? '${state.amount == '0' ? '' : state.amount}$nextAmountDigit'
          : null,
      amountFiat: nextAmountFiatDigit != null
          ? '${state.amountFiat == '0' ? '' : state.amountFiat}$nextAmountFiatDigit'
          : null,
      totalAmount: totalAmount,
      amountUnit: amountUnit,
    );

    emit(newState);

    if (nextAmountDigit != null) {
      changeAmount(newState.amount);
    }
    if (nextAmountFiatDigit != null) {
      changeAmountFiat(newState.amountFiat);
    }
  }

  void changePriority(Priority priority) {
    if (priority != state.priority) {
      emit(state.copyWith(
        priority: priority,
      ));
    }
  }

  void changeAmountUnit(AmountUnit amountUnit) {
    if (amountUnit != state.amountUnit) {
      emit(state.copyWith(
        amountUnit: amountUnit,
      ));
    }
  }

  void clearAmount() {
    emit(state.copyWith(
      amount: AssetSendFormState.init().amount,
      amountFiat: AssetSendFormState.init().amountFiat,
    ));
  }

  void eraseAmount() async {
    if (state.amount.isNotEmpty) {
      String result = state.amount.substring(0, state.amount.length - 1);
      if (result.isEmpty) {
        result = AssetSendFormState.init().amount;
      }

      emit(state.copyWith(
        amount: result,
      ));
    }
  }

  void eraseAmountFiat() async {
    if (state.amountFiat.isNotEmpty) {
      String result =
          state.amountFiat.substring(0, state.amountFiat.length - 1);
      if (result.isEmpty) {
        result = AssetSendFormState.init().amountFiat;
      }

      changeAmountFiat(result);
    }
  }

  void addDecimalDot() async {
    if (state.amount.contains('.')) return;

    var result = double.tryParse(state.amount);
    result ??= 0;

    emit(state.copyWith(
      amount: result.lastChar, // need to remove 0 char in the end
    ));
  }

  void addDecimalDotFiat() async {
    if (state.amountFiat.contains('.')) return;

    var result = double.tryParse(state.amountFiat);
    result ??= 0;

    emit(state.copyWith(
      amountFiat: result.lastChar, // need to remove 0 char in the end
    ));
  }

  void changeAmount(String amountFrom) {
    // todo: add correct price
    const price = 19523.2;

    final result = double.tryParse(amountFrom);
    if (result != null) {
      emit(state.copyWith(
        amount: amountFrom,
        amountFiat: '${result * price}',
      ));
    } else {
      emit(state.copyWith(
        amount: amountFrom,
        amountFiat: '',
      ));
    }
  }

  void changeAmountFiat(String amountFromFiat) {
    // todo: add correct price
    const price = 19523.2;

    final result = double.tryParse(amountFromFiat);
    if (result != null) {
      emit(state.copyWith(
        amountFiat: amountFromFiat,
        amount: '${result / price}',
      ));
    } else {
      emit(state.copyWith(
        amountFiat: amountFromFiat,
        amount: '',
      ));
    }
  }

  Future<List<AssetWallet>> loadSearchInitialData(
      List<AssetWallet> availableWallets) {
    emit(state.copyWith(response: const AssetSearchPending()));

    // todo: load all enabled send assets from api
    return Future.delayed(const Duration(milliseconds: 500), () {
      emit(
        state.copyWith(
          response: AssetSearchSuccess(
            availableWallets: availableWallets,
          ),
        ),
      );

      return availableWallets;
    });
  }

  void maxAmountClicked() async {
    emit(
      state.copyWith(
        amount: state.sourceNetworkWallet.balance.getFormattedBalance(
          state.sourceNetworkWallet.preset.decimalPlaces,
        ),
      ),
    );
  }

  Future<void> builtTxState(String accountWalletId) async {
    emit(state.copyWith(response: const FetchingFeesPending()));

    if (state.toAddress == '') throw Exception('Empty target address');

    final targetAddressIsValid = _walletRepository.isValidAddress(
      address: state.toAddress,
      networkId: state.sourceNetworkWallet.networkId,
    );

    if (!targetAddressIsValid) throw Exception('Target address is not valid');

    final fees = await _feeRepository.loadFees(
      assetId: state.sourceAssetWallet.assetId,
      networkId: state.sourceNetworkWallet.networkId,
    );

    BigInt fee = BigInt.zero;

    switch (state.priority) {
      case Priority.low:
        fee = fees.lowFee;
        break;
      case Priority.normal:
        fee = fees.regularFee;
        break;
      case Priority.high:
        fee = fees.highFee;
        break;
    }
    final WalletTransaction tx = await _walletRepository.signTransaction(
      accountWalletId,
      networkId: state.sourceNetworkWallet.networkId,
      toAddress: state.toAddress,
      amount: BigInt.zero,
      feeAmount: fee,
      gasLimit: fees.gasLimit,
      assetDecimals: state.sourceNetworkWallet.preset.decimalPlaces,
      contractAddress: state.sourceNetworkWallet.preset.contractAddress,
    );
    // TODO: handle FetchingFeesFailure

    final networkFee = tx.networkFee.getFormattedBalance(
      state.sourceNetworkWallet.preset.decimalPlaces,
    );
    emit(state.copyWith(
      baseNetworkFee: fee,
      gasLimit: fees.gasLimit,
      networkFee: networkFee,
      totalAmount: state.amount,
      response: FetchingFeesSuccess(networkFee: networkFee),
    ));
  }

  Future<void> submitForm(String accountWalletId) async {
    if (state.sourceNetworkWallet.isNotToken) {
      if (state.amountToSend < BigInt.zero) {
        throw Exception('Amount to send can\'t be negative');
      }
    }

    final amount = state.sourceNetworkWallet.isNotToken
        ? state.amountToSend
        : doubleStringToBigInt(
            state.amount,
            state.sourceNetworkWallet.preset.decimalPlaces,
          );

    final WalletTransaction tx = await _walletRepository.signTransaction(
      accountWalletId,
      networkId: state.sourceNetworkWallet.networkId,
      toAddress: state.toAddress,
      amount: amount,
      feeAmount: state.baseNetworkFee,
      gasLimit: state.gasLimit,
      assetDecimals: state.sourceNetworkWallet.preset.decimalPlaces,
      contractAddress: state.sourceNetworkWallet.preset.contractAddress,
    );

    final String txHash = await _walletRepository.broadcastTransaction(tx);

    emit(state.copyWith(
      txHash: txHash,
      response: const AssetSendFormPending(),
    ));
  }

  void clear() {
    emit(AssetSendFormState.init());
  }
}
