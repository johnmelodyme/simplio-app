import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/asset_send_form/asset_send_form_cubit.dart';
import 'package:simplio_app/logic/extensions/double_extensions.dart';

part 'asset_exchange_form_state.dart';

class AssetExchangeFormCubit extends Cubit<AssetExchangeFormState> {
  AssetExchangeFormCubit._({AssetExchangeFormState? initialState})
      : super(initialState ?? const AssetExchangeFormState.init());

  AssetExchangeFormCubit.builder({AssetExchangeFormState? initialState})
      : this._(initialState: initialState);

  Timer? _apiCallDelayTimer;

  void changeFormValue({
    int? assetId,
    int? networkId,
    int? targetAssetId,
    int? targetNetworkId,
    String? nextAmountFromDigit,
    String? nextAmountFromFiatDigit,
    String? nextAmountToDigit,
    String? totalAmount,
    AmountUnit? amountUnit,
  }) {
    final newState = state.copyWith(
      assetId: assetId,
      networkId: networkId,
      targetAssetId: targetAssetId,
      targetNetworkId: targetNetworkId,
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
      amountUnit: amountUnit,
    );

    emit(newState);

    if (nextAmountFromDigit != null) {
      changeAmountFrom(newState.amountFrom);
    }
    if (nextAmountFromFiatDigit != null) {
      changeAmountFromFiat(newState.amountFromFiat);
    }
    if (nextAmountToDigit != null) {
      changeAmountTo(newState.amountTo);
    }
  }

  void changeAmountUnit(AmountUnit amountUnit) {
    if (amountUnit != state.amountUnit) {
      emit(state.copyWith(
        amountUnit: amountUnit,
      ));
    }
  }

  void changeAmountFrom(String amountFrom) {
    // todo: add correct price
    const price = 19523.2;

    final result = double.tryParse(amountFrom);
    if (result != null) {
      emit(state.copyWith(
        amountFrom: amountFrom,
        amountFromFiat: '${result * price}',
      ));

      fetchAmountTo();
    } else {
      emit(state.copyWith(
        amountFrom: amountFrom,
        amountTo: '',
        amountFromFiat: '',
      ));
    }
  }

  void changeAmountFromFiat(String amountFromFiat) {
    // todo: add correct price
    const price = 19523.2;

    final result = double.tryParse(amountFromFiat);
    if (result != null) {
      emit(state.copyWith(
        amountFromFiat: amountFromFiat,
        amountFrom: '${result / price}',
      ));

      fetchAmountTo();
    } else {
      emit(state.copyWith(
        amountFromFiat: amountFromFiat,
        amountFrom: '',
        amountTo: '',
      ));
    }
  }

  void changeAmountTo(String amountTo) {
    final result = double.tryParse(amountTo);
    if (result != null) {
      emit(state.copyWith(
        amountTo: amountTo,
      ));

      fetchAmountFrom();
    } else {
      emit(state.copyWith(
        amountFrom: '',
        amountFromFiat: '',
        amountTo: amountTo,
      ));
    }
  }

  void eraseAmountFrom() async {
    if (state.amountFrom.isNotEmpty) {
      String result =
          state.amountFrom.substring(0, state.amountFrom.length - 1);
      if (result.isEmpty) {
        result = const AssetExchangeFormState.init().amountFrom;
      }

      changeAmountFrom(result);
    }
  }

  void eraseAmountFromFiat() async {
    if (state.amountFromFiat.isNotEmpty) {
      String result =
          state.amountFromFiat.substring(0, state.amountFromFiat.length - 1);
      if (result.isEmpty) {
        result = const AssetExchangeFormState.init().amountFromFiat;
      }

      changeAmountFromFiat(result);
    }
  }

  void eraseAmountTo() async {
    if (state.amountTo.isNotEmpty) {
      String result = state.amountTo.substring(0, state.amountTo.length - 1);
      if (result.isEmpty) {
        result = const AssetExchangeFormState.init().amountTo;
      }

      changeAmountTo(result);
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

  void fetchAmountTo() {
    emit(state.copyWith(response: const AmountToPending()));

    if (_apiCallDelayTimer != null) _apiCallDelayTimer!.cancel();
    _apiCallDelayTimer = Timer(const Duration(milliseconds: 300), () async {
      // todo: add logic for correct swapRate calculation
      const swapRate = 1.69;

      // todo: replace with api call
      Future.delayed(const Duration(milliseconds: 1000), () {
        final result = double.tryParse(state.amountFrom);
        emit(state.copyWith(
          response: const AmountToSuccess(),
          amountTo: result != null
              ? '${double.parse(state.amountFrom) * swapRate}'
              : '',
        ));
      });
    });
  }

  void fetchAmountFrom() async {
    emit(state.copyWith(response: const AmountFromPending()));

    if (_apiCallDelayTimer != null) _apiCallDelayTimer!.cancel();
    _apiCallDelayTimer = Timer(const Duration(milliseconds: 300), () {
      // todo: add correct price
      const price = 19523.2;
      // todo: add logic for correct swapRate calculation
      const swapRate = 1.69;

      // todo: replace with api call
      Future.delayed(const Duration(milliseconds: 1000), () {
        final result = double.tryParse(state.amountTo);
        emit(state.copyWith(
          response: const AmountFromSuccess(),
          amountFrom: result != null
              ? '${double.parse(state.amountTo) / swapRate}'
              : '',
          amountFromFiat: result != null
              ? '${(result * 10000 * price / swapRate).roundToDouble() / 10000}'
              : '',
        ));
      });
    });
  }

  // todo: add logic
  void minAmountClicked() async {
    debugPrint('minAmountClicked - NEEDS TO BE IMPLEMENTED');
  }

  // todo: add logic
  void maxAmountClicked() async {
    debugPrint('maxAmountClicked - NEEDS TO BE IMPLEMENTED');
  }

  // todo: Connect to logic
  void submitForm() async {
    emit(state.copyWith(
      response: const AssetExchangeFormPending(),
    ));
  }

  @override
  Future<void> close() async {
    if (_apiCallDelayTimer != null) _apiCallDelayTimer!.cancel();
    super.close();
  }

  Future<List<AssetWallet>> loadFromSearchInitialData(
      List<AssetWallet> availableWallets) {
    emit(state.copyWith(response: const AssetSearchFromPending()));

    // todo: load all enabled swap assets from api
    return Future.delayed(const Duration(milliseconds: 500), () {
      emit(
        state.copyWith(
          response: AssetSearchFromSuccess(
            availableWallets: availableWallets,
          ),
        ),
      );

      return availableWallets;
    });
  }

  Future<List<AssetWallet>> loadTargetSearchInitialData(
      List<AssetWallet> availableWallets) {
    // todo: load all enabled swap targets assets from api
    return loadFromSearchInitialData(availableWallets).then((wallets) =>
        wallets.where((element) => element.assetId != state.assetId).toList());
  }

  void onFromAssetChange(
      {required int assetId,
      required int networkId,
      required List<AssetWallet> availableWallets}) {
    // update target value with new options
    loadTargetSearchInitialData(availableWallets).then(
      (wallets) => emit(
        state.copyWith(
          targetAssetId: wallets.first.assetId,
          targetNetworkId: wallets.first.wallets.first.networkId,
        ),
      ),
    );
  }

  void clear() {
    emit(const AssetExchangeFormState.init());
  }
}
