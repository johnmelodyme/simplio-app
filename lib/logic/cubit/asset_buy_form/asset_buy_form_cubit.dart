import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/http/errors/bad_request_http_error.dart';
import 'package:simplio_app/data/http/services/buy_service.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/data/repositories/buy_repository.dart';
import 'package:simplio_app/data/model/network_wallet.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/asset_exchange_form/asset_exchange_form_cubit.dart';

part 'asset_buy_form_state.dart';

class AssetBuyFormCubit extends Cubit<AssetBuyFormState> {
  final BuyRepository _buyRepository;

  AssetBuyFormCubit._(this._buyRepository) : super(AssetBuyFormState.init());

  AssetBuyFormCubit.builder({required BuyRepository buyRepository})
      : this._(buyRepository);

  Timer? _apiCallDelayTimer;
  Timer? _statusCheckTimer;

  void changeFormValue({
    AssetWallet? sourceAssetWallet,
    NetworkWallet? sourceNetworkWallet,
    String? nextAmountDigit,
    String? nextAmountFiatDigit,
    String? totalAmount,
    AmountUnit? amountUnit,
    CryptoFiatPair? selectedPair,
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
      selectedPair: selectedPair,
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
      ));

      _fetchFiatAmount();
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
        amountFiat: amountFiat,
      ));

      _fetchAmount();
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

    // try {
    //   final buyOrderResponse = await _buyRepository.buy(
    //     convertResponse: state.buyConvertResponse,
    //     walletAddress: walletAddress,
    //   );
    //   _checkPaymentStatus();

    //   emit(state.copyWith(
    //     response: const AssetBuyFormPending(),
    //     paymentGatewayUrl: buyOrderResponse.paymentUrl,
    //     orderId: buyOrderResponse.orderId,
    //   ));
    // } catch (err) {
    //   if (err is BadRequestHttpError) {
    //     _refreshPrice();
    //   }
    // }
  }

  void navigateToSuccessPage() {
    emit(state.copyWith(response: const AssetBuyFormSuccess()));
  }

  // void _checkPaymentStatus() async {
  //   _statusCheckTimer =
  //       Timer.periodic(const Duration(seconds: 1), (timer) async {
  //     final orderStatus = await _buyRepository.status(state.orderId);

  //     if (orderStatus.status == 'COMPLETED') {
  //       _statusCheckTimer!.cancel();
  //       navigateToSuccessPage();
  //     } else if (orderStatus.status == 'FAILED') {
  //       _statusCheckTimer!.cancel();
  //       emit(
  //         state.copyWith(
  //           response: AssetBuyFormFailure(
  //             exception: Exception('Payment failed'),
  //           ),
  //         ),
  //       );
  //     }
  //   });
  // }

  // void _refreshPrice() async {
  //   emit(state.copyWith(response: const AssetBuyFormPriceRefreshPending()));

  //   try {
  //     final convertResult = await _buyRepository.convert(
  //       fiatAssetId: state.buyConvertResponse.fiatAsset.assetId,
  //       cryptoAssetId: state.buyConvertResponse.cryptoAsset.assetId,
  //       cryptoNetworkId: state.buyConvertResponse.cryptoAsset.networkId,
  //       amount: state.buyConvertResponse.cryptoAsset.amount,
  //       fromCrypto: true,
  //     );

  //     emit(
  //       state.copyWith(
  //         buyConvertResponse: convertResult,
  //         response: const AssetBuyFormPriceRefreshSuccess(),
  //       ),
  //     );
  //   } catch (_) {
  //     emit(state.copyWith(
  //         response: AssetBuyFormFailure(exception: Exception())));
  //   }
  // }

  void _fetchAmount() async {
    emit(state.copyWith(response: const AmountPending()));
    if (_apiCallDelayTimer != null) _apiCallDelayTimer!.cancel();

    _apiCallDelayTimer = Timer(
      const Duration(milliseconds: 300),
      () async {
        if (!state.hasErrors.contains(true)) {
          try {
            final convertResult = await _buyRepository.convert(
              fiatAssetId: 'USD', // todo: fill correct fiat
              cryptoAssetId: state.sourceAssetWallet.assetId,
              cryptoNetworkId: state.sourceNetworkWallet.networkId,
              amount: double.parse(state.amountFiat), fromCrypto: false,
            );

            emit(state.copyWith(
              amount: convertResult.cryptoAsset.amount.toString(),
              buyConvertResponse: convertResult,
              response: const AmountSuccess(),
            ));
          } catch (e) {
            emit(state.copyWith(
              response: const AmountFailure(),
            ));
          }
        } else {
          emit(state.copyWith(
            response: const AmountSuccess(),
          ));
        }
      },
    );
  }

  void _fetchFiatAmount() async {
    emit(state.copyWith(response: const AmountPending()));
    if (_apiCallDelayTimer != null) _apiCallDelayTimer!.cancel();

    _apiCallDelayTimer = Timer(const Duration(milliseconds: 300), () async {
      if (!state.hasErrors.contains(true)) {
        final convertResult = await _buyRepository.convert(
          fiatAssetId: 'USD', // todo: fill correct fiat
          cryptoAssetId: state.sourceAssetWallet.assetId,
          cryptoNetworkId: state.sourceNetworkWallet.networkId,
          amount: double.parse(state.amount), fromCrypto: true,
        );

        emit(state.copyWith(
          amountFiat: convertResult.fiatAsset.amount.toString(),
          buyConvertResponse: convertResult,
          response: const AmountSuccess(),
        ));
      } else {
        emit(state.copyWith(
          response: const AmountSuccess(),
        ));
      }
    });
  }

  Future<void> loadAvailableAssetsToBuy({
    required List<AssetWallet> availableWallets,
    required String fiat,
  }) async {
    emit(
      state.copyWith(response: const AssetSearchLoading()),
    );

    try {
      final pairs = await _buyRepository.pairs();
      final pairsForSelectedFiat =
          pairs.where((e) => e.fiatAsset.assetId == fiat);

      final availableAssetIdsToBuy =
          pairsForSelectedFiat.map((e) => e.cryptoAsset.assetId);

      final results = availableWallets
          .where((e) => availableAssetIdsToBuy.contains(e.assetId))
          .toList();

      if (results.isNotEmpty) {
        final availableWalletsMap = {
          for (final e in results)
            e: CryptoFiatPair(
              fiatAsset: pairsForSelectedFiat
                  .firstWhere((ee) => ee.cryptoAsset.assetId == e.assetId)
                  .fiatAsset,
              cryptoAsset: pairsForSelectedFiat
                  .firstWhere((ee) => ee.cryptoAsset.assetId == e.assetId)
                  .cryptoAsset,
            )
        };

        final sourceAssetWallet = results
            .firstWhere((e) => e.assetId == state.sourceAssetWallet.assetId);

        final sourceNetworkWallet = sourceAssetWallet.wallets.firstWhere(
            (e) => e.networkId == state.sourceNetworkWallet.networkId);

        final selectedPair = availableWalletsMap.values.firstWhere((e) =>
            e.cryptoAsset.assetId == sourceAssetWallet.assetId &&
            e.cryptoAsset.networkId == sourceNetworkWallet.networkId);

        emit(
          state.copyWith(
            sourceAssetWallet: sourceAssetWallet,
            sourceNetworkWallet: sourceNetworkWallet,
            response: const AssetSearchLoaded(),
            availableWallets: availableWalletsMap,
            selectedPair: selectedPair,
          ),
        );
      } else {
        emit(state.copyWith(
            response: const AssetSearchFailure(error: 'List is empty')));
      }
    } on BadRequestHttpError catch (err) {
      emit(state.copyWith(
        response: AssetSearchFailure(error: err.message),
      ));
    }
  }

  void clearTimers() {
    if (_apiCallDelayTimer != null) _apiCallDelayTimer!.cancel();
    if (_statusCheckTimer != null) _statusCheckTimer!.cancel();
  }

  @override
  Future<void> close() async {
    clearTimers();
    super.close();
  }

  void clear() {
    emit(AssetBuyFormState.init());
  }
}
