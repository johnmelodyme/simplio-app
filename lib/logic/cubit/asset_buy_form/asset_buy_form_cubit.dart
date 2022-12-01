import 'dart:async';
import 'package:crypto_assets/crypto_assets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/http/services/buy_service.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/data/model/network_wallet.dart';
import 'package:simplio_app/logic/cubit/asset_exchange_form/asset_exchange_form_cubit.dart';

part 'asset_buy_form_state.dart';

const assetPrice = 30;

class AssetBuyFormCubit extends Cubit<AssetBuyFormState> {
  AssetBuyFormCubit._() : super(AssetBuyFormState.init());

  AssetBuyFormCubit.builder() : this._();

  Timer? _apiCallDelayTimer;
  Timer? _statusCheckTimer;

  void changeFormValue({
    AssetWallet? sourceAssetWallet,
    NetworkWallet? sourceNetworkWallet,
    String? nextAmountDigit,
    String? nextAmountFiatDigit,
    String? totalAmount,
    AmountUnit? amountUnit,
    // CryptoFiatPair? selectedPair,
  }) {
    final newState = state.copyWith(
      sourceAssetWallet: sourceAssetWallet,
      sourceNetworkWallet: sourceNetworkWallet,
      amount: nextAmountDigit != null
          ? '${state.amount == '0' ? '' : state.amount}$nextAmountDigit'
          : null,
      amountFiat: nextAmountFiatDigit != null
          ? '${state.amountFiat == '0' ? '' : state.amountFiat}$nextAmountFiatDigit'
          : null,
      totalAmount: totalAmount,
      amountUnit: amountUnit,
      // selectedPair: selectedPair,
    );

    emit(newState);

    if (nextAmountDigit != null) {
      changeAmount(newState.amount);
    }
    if (nextAmountFiatDigit != null) {
      changeAmountFiat(newState.amountFiat);
    }
  }

  void changeAmountUnit(AmountUnit amountUnit) {
    if (amountUnit != state.amountUnit) {
      emit(state.copyWith(
        amountUnit: amountUnit,
      ));
    }
  }

  void changeAmount(String amount) async {
    final result = double.tryParse(amount);
    if (result != null) {
      emit(state.copyWith(
        amount: amount,
        amountFiat: (result * assetPrice).toString(),
      ));
    } else {
      emit(state.copyWith(
        amount: amount,
        amountFiat: '',
      ));
    }
  }

  void changeAmountFiat(String amountFiat) async {
    final result = double.tryParse(amountFiat);
    if (result != null) {
      emit(state.copyWith(
        amount: (result / assetPrice).toString(),
        amountFiat: amountFiat,
      ));
    } else {
      emit(state.copyWith(
        amountFiat: amountFiat,
        amount: '',
      ));
    }
  }

  void eraseAmount() async {
    if (state.amount.isNotEmpty) {
      String result = state.amount.substring(0, state.amount.length - 1);
      if (result.isEmpty) {
        result = AssetBuyFormState.init().amount;
      }

      changeAmount(result);
    }
  }

  void eraseAmountFiat() async {
    if (state.amountFiat.isNotEmpty) {
      String result =
          state.amountFiat.substring(0, state.amountFiat.length - 1);
      if (result.isEmpty) {
        result = AssetBuyFormState.init().amountFiat;
      }

      changeAmountFiat(result);
    }
  }

  void addDecimalDotAmount() async {
    if (state.amount.contains('.')) return;

    var result = double.tryParse(state.amount);
    result ??= 0;

    emit(state.copyWith(
      amount: result.toString().substring(
          0, result.toString().length - 1), // need to remove 0 char in the end
    ));
  }

  void addDecimalDotAmountFiat() async {
    if (state.amountFiat.contains('.')) return;

    var result = double.tryParse(state.amountFiat);
    result ??= 0;

    emit(state.copyWith(
      amountFiat: result.toString().substring(
          0, result.toString().length - 1), // need to remove 0 char in the end
    ));
  }

  void submitForm({
    required String walletAddress,
  }) async {
    emit(state.copyWith(response: const AssetBuyFormSuccess()));
  }

  void navigateToSuccessPage() {
    emit(state.copyWith(response: const AssetBuyFormSuccess()));
  }

  Future<void> loadAvailableAssetsToBuy({
    required int assetId,
    required int networkId,
    required List<AssetWallet> availableWallets,
  }) async {
    emit(
      state.copyWith(response: const AssetSearchLoading()),
    );

    final assetWallet = availableWallets.firstWhere(
      (a) => a.assetId == assetId,
      orElse: () => AssetWallet.builder(
        assetId: assetId,
        wallets: {
          networkId: NetworkWallet.builder(
            networkId: networkId,
            address: '',
            preset: Assets.getAssetPreset(
              assetId: assetId,
              networkId: networkId,
            ),
          ),
        },
      ),
    );

    if (!assetWallet.containsWallet(networkId)) {
      assetWallet.addWallet(
        NetworkWallet.builder(
          networkId: networkId,
          address: '',
          preset: Assets.getAssetPreset(
            assetId: assetId,
            networkId: networkId,
          ),
        ),
      );
    }

    final List<BuyPairResponseItem> pairs = [];

    emit(
      state.copyWith(
        sourceAssetWallet: assetWallet,
        sourceNetworkWallet: state.sourceNetworkWallet,
        response: AssetSearchLoaded(pairs: pairs),
      ),
    );
  }

  void clearTimers() {
    if (_apiCallDelayTimer != null) _apiCallDelayTimer!.cancel();
    if (_statusCheckTimer != null) _statusCheckTimer!.cancel();
  }

  void clear() {
    emit(AssetBuyFormState.init());
  }
}
