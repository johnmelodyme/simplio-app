import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/asset_exchange_form/asset_exchange_form_cubit.dart';
import 'package:simplio_app/logic/cubit/asset_send_form/asset_send_form_cubit.dart';

part 'asset_buy_form_state.dart';

class AssetBuyFormCubit extends Cubit<AssetBuyFormState> {
  AssetBuyFormCubit._({AssetBuyFormState? initialState})
      : super(initialState ?? const AssetBuyFormState.init());

  AssetBuyFormCubit.builder({AssetBuyFormState? initialState})
      : this._(initialState: initialState);

  void changeFormValue({
    int? assetId,
    int? networkId,
    String? nextAmountDigit,
    String? nextAmountFiatDigit,
    String? totalAmount,
    AmountUnit? amountUnit,
  }) {
    final newState = state.copyWith(
      assetId: assetId,
      networkId: networkId,
      amountFrom: nextAmountDigit != null
          ? '${state.amount == '0' ? '' : state.amount}$nextAmountDigit'
          : null,
      amountFromFiat: nextAmountFiatDigit != null
          ? '${state.amountFiat == '0' ? '' : state.amountFiat}$nextAmountFiatDigit'
          : null,
      totalAmount: totalAmount,
      amountUnit: amountUnit,
    );

    emit(newState);

    if (nextAmountDigit != null) {
      changeAmountFrom(newState.amount);
    }
    if (nextAmountFiatDigit != null) {
      changeAmountFromFiat(newState.amountFiat);
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
    } else {
      emit(state.copyWith(
        amountFrom: amountFrom,
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
    } else {
      emit(state.copyWith(
        amountFromFiat: amountFromFiat,
        amountFrom: '',
      ));
    }
  }

  void eraseAmountFrom() async {
    if (state.amount.isNotEmpty) {
      String result = state.amount.substring(0, state.amount.length - 1);
      if (result.isEmpty) {
        result = const AssetBuyFormState.init().amount;
      }

      changeAmountFrom(result);
    }
  }

  void eraseAmountFromFiat() async {
    if (state.amountFiat.isNotEmpty) {
      String result =
          state.amountFiat.substring(0, state.amountFiat.length - 1);
      if (result.isEmpty) {
        result = const AssetBuyFormState.init().amountFiat;
      }

      changeAmountFromFiat(result);
    }
  }

  void addDecimalDotAmountFrom() async {
    if (state.amount.contains('.')) return;

    var result = double.tryParse(state.amount);
    result ??= 0;

    emit(state.copyWith(
      amountFrom: result.toString().substring(
          0, result.toString().length - 1), // need to remove 0 char in the end
    ));
  }

  void addDecimalDotAmountFromFiat() async {
    if (state.amountFiat.contains('.')) return;

    var result = double.tryParse(state.amountFiat);
    result ??= 0;

    emit(state.copyWith(
      amountFromFiat: result.toString().substring(
          0, result.toString().length - 1), // need to remove 0 char in the end
    ));
  }

  void submitForm({bool testSubmit = false}) async {
    //todo: add logic for checking new prices
    if (!testSubmit) {
      refreshPrice();
    } else {
      // todo: Connect to buying logic
      emit(state.copyWith(
        response: const AssetBuyFormPending(),
        paymentGatewayUrl: 'https://www.rpaygateway.com/images/top-banner.png',
      ));

      // todo: remove this when payment gateway is implemented
      Future.delayed(
        const Duration(seconds: 5),
        () => emit(
          state.copyWith(
            response: const AssetBuyFormSuccess(),
          ),
        ),
      );
    }
  }

  void refreshPrice() async {
    // todo: Connect to logic
    emit(state.copyWith(response: const AssetBuyFormPriceRefreshPending()));

    return Future.delayed(const Duration(milliseconds: 1000), () {
      emit(
        state.copyWith(
          response: const AssetBuyFormPriceRefreshSuccess(
            confirmationNeeded: true,
            newTotalAmount: '5.265',
            newTotalAmountFiat: '25.78',
          ),
        ),
      );
    });
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

  void clear() {
    emit(const AssetBuyFormState.init());
  }
}
