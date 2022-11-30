import 'dart:async';
import 'package:crypto_assets/crypto_assets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/data/model/network_wallet.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:simplio_app/data/repositories/swap_repository.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/extensions/number_extensions.dart';

part 'asset_exchange_form_state.dart';

// Price in USD
const double sourcePrice = 293.85;
const double targetPrice = 22.25;
const double swapPrice = 13.2;
const double minAmount = 10;
const double maxAmount = 2300;

class AssetExchangeFormCubit extends Cubit<AssetExchangeFormState> {
  final SwapRepository _swapRepository;

  AssetExchangeFormCubit._(
    this._swapRepository,
  ) : super(AssetExchangeFormState.init());

  AssetExchangeFormCubit({
    required swapRepository,
  }) : this._(swapRepository);

  void changeFormValue({
    String? nextAmountFromDigit,
    String? nextAmountFromFiatDigit,
    String? nextAmountToDigit,
    String? nextAmountToFiatDigit,
  }) {
    if (nextAmountFromDigit != null) {
      return _changeAmountFrom(
        '${state.amountFrom == '0' ? '' : state.amountFrom}$nextAmountFromDigit',
      );
    }
    if (nextAmountFromFiatDigit != null) {
      return _changeAmountFromFiat(
        '${state.amountFromFiat == '0' ? '' : state.amountFromFiat}$nextAmountFromFiatDigit',
      );
    }
    if (nextAmountToDigit != null) {
      return _changeAmountTo(
        '${state.amountTo == '0' ? '' : state.amountTo}$nextAmountToDigit',
      );
    }
    if (nextAmountToFiatDigit != null) {
      return _changeAmountToFiat(
        '${state.amountToFiat == '0' ? '' : state.amountToFiat}$nextAmountToFiatDigit',
      );
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
      // TODO - erase form values to default value!
    ));
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
    final res = double.tryParse(amountFrom);

    if (res != null) {
      return emit(state.copyWith(
        amountFrom: amountFrom,
        amountFromFiat: (res * sourcePrice).toString(),
        amountTo: (res * swapPrice).toString(),
        amountToFiat: ((res * swapPrice) * targetPrice).toString(),
        focusedDirection: FocusedDirection.from,
      ));
    }

    return emit(state.copyWith(
      amountFrom: amountFrom,
      amountToFiat: '',
      amountTo: '',
      amountFromFiat: '',
      focusedDirection: FocusedDirection.from,
    ));
  }

  void _changeAmountFromFiat(String amountFromFiat) {
    final res = double.tryParse(amountFromFiat);

    if (res != null) {
      final a = res / sourcePrice;
      return emit(state.copyWith(
        amountFrom: a.toString(),
        amountFromFiat: amountFromFiat,
        amountTo: (a * swapPrice).toString(),
        amountToFiat: ((a * swapPrice) * targetPrice).toString(),
        focusedDirection: FocusedDirection.from,
      ));
    }

    return emit(state.copyWith(
      amountFrom: '',
      amountFromFiat: amountFromFiat,
      amountTo: '',
      amountToFiat: '',
      focusedDirection: FocusedDirection.from,
    ));
  }

  void _changeAmountTo(String amountTo) {
    final res = double.tryParse(amountTo);

    if (res != null) {
      return emit(state.copyWith(
        amountFrom: (res / swapPrice).toString(),
        amountFromFiat: ((res / swapPrice) * sourcePrice).toString(),
        amountTo: amountTo,
        amountToFiat: (res * targetPrice).toString(),
        focusedDirection: FocusedDirection.to,
      ));
    }

    return emit(state.copyWith(
      amountFrom: '',
      amountFromFiat: '',
      amountTo: amountTo,
      amountToFiat: '',
      focusedDirection: FocusedDirection.to,
    ));
  }

  void _changeAmountToFiat(String amountToFiat) {
    final res = double.tryParse(amountToFiat);

    if (res != null) {
      final a = res / targetPrice;
      return emit(state.copyWith(
        amountFrom: (a / swapPrice).toString(),
        amountFromFiat: ((a / swapPrice) * sourcePrice).toString(),
        amountTo: a.toString(),
        amountToFiat: amountToFiat,
        focusedDirection: FocusedDirection.to,
      ));
    }

    return emit(state.copyWith(
      amountFrom: '',
      amountFromFiat: amountToFiat,
      amountTo: '',
      amountToFiat: amountToFiat,
      focusedDirection: FocusedDirection.to,
    ));
  }

  void changeDirection(FocusedDirection direction) {
    emit(state.copyWith(focusedDirection: direction));
  }

  void eraseAmount() {
    if (state.focusedDirection == FocusedDirection.from) {
      if (state.amountFromUnit == AmountUnit.crypto) return _eraseAmountFrom();
      return _eraseAmountFromFiat();
    }

    if (state.focusedDirection == FocusedDirection.to) {
      if (state.amountToUnit == AmountUnit.crypto) return _eraseAmountTo();
      return _eraseAmountToFiat();
    }
  }

  void _eraseAmountFrom() {
    if (state.amountFrom.isEmpty) return;

    final res = state.amountFrom.substring(0, state.amountFrom.length - 1);

    if (res.isNotEmpty) return _changeAmountFrom(res);
    return _changeAmountFrom(AssetExchangeFormState.init().amountFrom);
  }

  void _eraseAmountFromFiat() {
    if (state.amountFromFiat.isEmpty) return;

    final res =
        state.amountFromFiat.substring(0, state.amountFromFiat.length - 1);

    if (res.isNotEmpty) return _changeAmountFromFiat(res);
    return _changeAmountFromFiat(AssetExchangeFormState.init().amountFromFiat);
  }

  void _eraseAmountTo() {
    if (state.amountTo.isEmpty) return;

    final res = state.amountTo.substring(0, state.amountTo.length - 1);

    if (res.isNotEmpty) return _changeAmountTo(res);
    return _changeAmountTo(AssetExchangeFormState.init().amountTo);
  }

  void _eraseAmountToFiat() {
    if (state.amountToFiat.isEmpty) return;

    final res = state.amountToFiat.substring(0, state.amountToFiat.length - 1);

    if (res.isNotEmpty) return _changeAmountToFiat(res);
    return _changeAmountToFiat(AssetExchangeFormState.init().amountToFiat);
  }

  void addDecimalDotAmountFrom() {
    final s = state;
    if (s.amountFrom.contains('.') || s.amountFrom.isEmpty) return;

    emit(s.copyWith(
      amountFrom: '${s.amountFrom}.',
    ));
  }

  void addDecimalDotAmountFromFiat() {
    final s = state;
    if (s.amountFromFiat.contains('.') || s.amountFromFiat.isEmpty) return;

    emit(s.copyWith(
      amountFromFiat: '${s.amountFromFiat}.',
    ));
  }

  void addDecimalDotAmountTo() {
    final s = state;
    if (s.amountTo.contains('.') || s.amountTo.isEmpty) return;

    emit(s.copyWith(
      amountTo: '${s.amountTo}.',
    ));
  }

  void addDecimalDotAmountToFiat() {
    final s = state;
    if (s.amountToFiat.contains('.') || s.amountToFiat.isEmpty) return;

    emit(s.copyWith(
      amountToFiat: '${s.amountToFiat}.',
    ));
  }

  void minAmountClicked() {
    _changeAmountFrom(minAmount.toString());
  }

  void maxAmountClicked() {
    _changeAmountFrom(maxAmount.toString());
  }

  Future<void> loadAvailableSourcePairs(
    List<AssetWallet> availableWallets,
  ) async {
    try {
      emit(state.copyWith(
        availableFromAssets: [],
        response: const SearchAssetsLoading(),
      ));
      final swapPairs = await _swapRepository.loadSwapRoutes();

      final sourceAssets = swapPairs.map((e) => e.sourceAsset).toList();
      final availableFromAssets = availableWallets.where((wallet) {
        final filteredSourceAssets = sourceAssets.where((e) =>
            e.assetId == wallet.assetId &&
            wallet.getWallet(e.networkId) != null);

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

      if (swapPairs.isEmpty) {
        return emit(state.copyWith(
          sourceAssetWallet: availableFromAssets.first,
          sourceNetworkWallet: availableFromAssets.first.wallets.first,
          availableFromAssets: availableFromAssets,
          response: const SearchAssetsFailure(),
        ));
      }

      final swapPair = swapPairs.where((p) =>
          p.sourceAsset.assetId == sourceAssetWallet.assetId &&
          p.sourceAsset.networkId == networkWallet.networkId);

      if (swapPair.isEmpty) {
        return emit(state.copyWith(
          sourceAssetWallet: availableFromAssets.first,
          sourceNetworkWallet: availableFromAssets.first.wallets.first,
          availableFromAssets: availableFromAssets,
          response: const SearchAssetsFailure(), // todo: add error handling
        ));
      }

      emit(state.copyWith(
        sourceAssetWallet: sourceAssetWallet,
        sourceNetworkWallet: networkWallet,
        availableFromAssets: availableFromAssets,
        response: const SearchAssetsSuccess(),
      ));

      return await loadAvailableTargetPairs(
        availableWallets,
        state.sourceAssetWallet.assetId,
        state.sourceNetworkWallet.networkId,
      );
    } catch (e) {
      emit(AssetExchangeFormState.init().copyWith(
        response: const AmountFromFailure(),
      ));
    }
  }

  Future<void> loadAvailableTargetPairs(
    List<AssetWallet> availableWallets,
    int sourceWalletAssetId,
    int sourceWalletNetworkId,
  ) async {
    try {
      emit(state.copyWith(
        availableTargetAssets: [],
        response: const SearchAssetsLoading(),
      ));
      final swapPairs = await _swapRepository.loadSwapRoutes();

      final availableTargets = swapPairs
          .where((e) =>
              e.sourceAsset.assetId == sourceWalletAssetId &&
              e.sourceAsset.networkId == sourceWalletNetworkId)
          .map((e) => e.targetAsset)
          .fold<Map<int, Set<int>>>({}, (acc, curr) {
            if (acc.containsKey(curr.assetId)) {
              acc[curr.assetId]!.add(curr.networkId);
              return acc;
            }

            return acc
              ..addAll({
                curr.assetId: {curr.networkId}
              });
          })
          .map((key, value) {
            AssetWallet aw = availableWallets.firstWhere(
              (w) => w.assetId == key,
              orElse: () => AssetWallet.builder(assetId: key),
            );

            for (final v in value) {
              if (!aw.containsWallet(v)) {
                aw = aw.addWallet(NetworkWallet.builder(
                  networkId: v,
                  address: '',
                  preset: Assets.getAssetPreset(
                    assetId: key,
                    networkId: v,
                  ),
                ));
              }
            }

            return MapEntry(key, aw);
          })
          .values
          .toList();

      if (availableTargets.isEmpty) {
        return emit(state.copyWith(
          availableTargetAssets: availableTargets,
          response: const SearchAssetsSuccess(),
        ));
      }

      final targetAssetWallet =
          availableTargets.contains(state.targetAssetWallet)
              ? state.targetAssetWallet
              : availableTargets.first;

      final targetNetworkWallet =
          targetAssetWallet.wallets.contains(state.targetNetworkWallet)
              ? state.targetNetworkWallet
              : availableTargets.first.wallets.first;

      emit(state.copyWith(
        targetAssetWallet: targetAssetWallet,
        targetNetworkWallet: targetNetworkWallet,
        availableTargetAssets: availableTargets,
        response: const SearchAssetsSuccess(),
      ));
    } catch (e) {
      emit(AssetExchangeFormState.init().copyWith(
        response: const SearchAssetsFailure(),
      ));
    }
  }

  void clear() {
    emit(AssetExchangeFormState.init());
  }
}
