import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'asset_send_form_state.dart';

class AssetSendFormCubit extends Cubit<AssetSendFormState> {
  AssetSendFormCubit._({AssetSendFormState? initialState})
      : super(initialState ?? const AssetSendFormState.init());

  AssetSendFormCubit.builder({AssetSendFormState? initialState})
      : this._(initialState: initialState);

  void changeFormValue({
    int? assetId,
    int? networkId,
    String? address,
    String? amount,
    String? totalAmount,
    AmountUnit? amountUnit,
  }) {
    emit(state.copyWith(
      assetId: assetId,
      networkId: networkId,
      address: address,
      amount: amount != null
          ? '${state.amount == '0' ? '' : state.amount}$amount'
          : null,
      totalAmount: totalAmount,
      amountUnit: amountUnit,
    ));
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

  void eraseAmount() async {
    if (state.amount.isNotEmpty) {
      var result = state.amount.substring(0, state.amount.length - 1);
      if (result.isEmpty) {
        result = const AssetSendFormState.init().amount;
      }

      emit(state.copyWith(
        amount: result,
      ));
    }
  }

  void addDecimalDot() async {
    var result = '${double.tryParse(state.amount)}';

    emit(state.copyWith(
      amount: result.substring(
          0, result.length - 1), // need to remove 0 char in the end
    ));
  }

  // todo: add logic
  void minAmountClicked() async {
    debugPrint('minAmountClicked - NEEDS TO BE IMPLEMENTED');
  }

  // todo: add logic
  void maxAmountClicked() async {
    debugPrint('maxAmountClicked - NEEDS TO BE IMPLEMENTED');
  }

  // todo: Connect to sending coins logic
  void submitForm() async {
    emit(state.copyWith(
      response: const AssetSendFormPending(),
    ));
  }
}
