import 'package:crypto_assets/crypto_assets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simplio_app/data/http/errors/http_error.dart';
import 'package:simplio_app/data/model/helpers/big_decimal.dart';
import 'package:simplio_app/data/model/wallet.dart';
import 'package:simplio_app/data/repositories/swap_repository.dart';
import 'package:simplio_app/logic/mixins/bigdecimal_value_updater_mixin.dart';
import 'package:simplio_app/view/widgets/keypad.dart';

part 'asset_swap_form_event.dart';
part 'asset_swap_form_state.dart';

// TODO - remove duplications!!!!

class AssetSwapFormBloc extends Bloc<AssetSwapFormEvent, AssetSwapFormState>
    with BigDecimalValueUpdaterMixin {
  final SwapRepository _swapRepository;

  AssetSwapFormBloc({
    required SwapRepository swapRepository,
  }) : this._(swapRepository);

  AssetSwapFormBloc._(this._swapRepository) : super(const SwapFormInitial()) {
    /// Delaying requests on type
    on<ValueConverted>(
      _onValueConverted,
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 450))
          .distinct()
          .switchMap(mapper),
    );
    on<ValueUpdated>(_onValueUpdated);
    on<ValueSelected>(_onValueSelected);
    on<ValueSwitched>(_onValueSwitched);
    on<RoutesLoaded>(_onRoutesLoaded);
    on<RouteUpdated>(_onRouteUpdated);
    on<MinValueRequested>(_onMinValueRequested);
    on<MaxValueRequested>(_onMaxValueRequested);
  }

  void _updateSwapConvertedState(
    SwapConverted s, {
    required ValueUpdated event,
    required Emitter<AssetSwapFormState> emit,
  }) {
    if (s.direction == SwapDirection.source) {
      if (s.source.currencyType == SwapCurrencyType.crypto) {
        final cryptoAmount = updateBigDecimalValue(
          s.source.cryptoAmount,
          modifier: event.value,
        );
        emit(SwapSourceConverting(
          routes: s.routes,
          source: s.source.copyWith(
            cryptoAmount: cryptoAmount,
            fiatAmount: cryptoAmount * s.source.price,
          ),
          target: s.target.asset,
        ));

        return add(ValueConverted(
          sourceAmount: cryptoAmount,
          sourceAssetId: s.source.asset.assetId,
          sourceNetworkId: s.source.asset.networkId,
          targetAssetId: s.target.asset.assetId,
          targetNetworkId: s.target.asset.networkId,
        ));
      }

      if (s.source.currencyType == SwapCurrencyType.fiat) {
        final fiatAmount = updateBigDecimalValue(
          s.source.fiatAmount,
          modifier: event.value,
        );
        emit(SwapSourceConverting(
          routes: s.routes,
          source: s.source.copyWith(
            cryptoAmount: fiatAmount / s.source.price,
            fiatAmount: fiatAmount,
          ),
          target: s.target.asset,
        ));

        return add(ValueConverted(
          sourceAmount: fiatAmount / s.source.price,
          sourceAssetId: s.source.asset.assetId,
          sourceNetworkId: s.source.asset.networkId,
          targetAssetId: s.target.asset.assetId,
          targetNetworkId: s.target.asset.networkId,
        ));
      }
    }

    if (s.direction == SwapDirection.target) {
      if (s.source.currencyType == SwapCurrencyType.crypto) {
        final cryptoAmount = updateBigDecimalValue(
          s.target.cryptoAmount,
          modifier: event.value,
        );
        emit(SwapTargetConverting(
          routes: s.routes,
          target: s.target.copyWith(
            cryptoAmount: cryptoAmount,
            fiatAmount: cryptoAmount * s.target.price,
          ),
          source: s.source.asset,
        ));

        return add(ValueConverted(
          sourceAmount: cryptoAmount,
          sourceAssetId: s.target.asset.assetId,
          sourceNetworkId: s.target.asset.networkId,
          targetAssetId: s.source.asset.assetId,
          targetNetworkId: s.source.asset.networkId,
        ));
      }

      if (s.source.currencyType == SwapCurrencyType.fiat) {
        final fiatAmount = updateBigDecimalValue(
          s.target.fiatAmount,
          modifier: event.value,
        );
        emit(SwapTargetConverting(
          routes: s.routes,
          target: s.target.copyWith(
            cryptoAmount: fiatAmount / s.target.price,
            fiatAmount: fiatAmount,
          ),
          source: s.source.asset,
        ));

        return add(ValueConverted(
          sourceAmount: fiatAmount / s.target.price,
          sourceAssetId: s.target.asset.assetId,
          sourceNetworkId: s.target.asset.networkId,
          targetAssetId: s.source.asset.assetId,
          targetNetworkId: s.source.asset.networkId,
        ));
      }
    }
  }

  void _updateSwapSourceConvertingState(
    SwapSourceConverting s, {
    required ValueUpdated event,
    required Emitter<AssetSwapFormState> emit,
  }) {
    if (s.source.currencyType == SwapCurrencyType.crypto) {
      final cryptoAmount = updateBigDecimalValue(
        s.source.cryptoAmount,
        modifier: event.value,
      );
      emit(s.copyWith(
        source: s.source.copyWith(
          cryptoAmount: cryptoAmount,
          fiatAmount: cryptoAmount * s.source.price,
        ),
      ));

      return add(ValueConverted(
        sourceAmount: cryptoAmount,
        sourceAssetId: s.source.asset.assetId,
        sourceNetworkId: s.source.asset.networkId,
        targetAssetId: s.target.assetId,
        targetNetworkId: s.target.networkId,
      ));
    }

    if (s.source.currencyType == SwapCurrencyType.fiat) {
      final fiatAmount = updateBigDecimalValue(
        s.source.fiatAmount,
        modifier: event.value,
      );
      emit(s.copyWith(
        source: s.source.copyWith(
          cryptoAmount: fiatAmount / s.source.price,
          fiatAmount: fiatAmount,
        ),
      ));

      return add(ValueConverted(
        sourceAmount: fiatAmount / s.source.price,
        sourceAssetId: s.source.asset.assetId,
        sourceNetworkId: s.source.asset.networkId,
        targetAssetId: s.target.assetId,
        targetNetworkId: s.target.networkId,
      ));
    }
  }

  void _updateSwapTargetConvertingState(
    SwapTargetConverting s, {
    required ValueUpdated event,
    required Emitter<AssetSwapFormState> emit,
  }) {
    if (s.target.currencyType == SwapCurrencyType.crypto) {
      final cryptoAmount = updateBigDecimalValue(
        s.target.cryptoAmount,
        modifier: event.value,
      );
      emit(s.copyWith(
        target: s.target.copyWith(
          cryptoAmount: cryptoAmount,
          fiatAmount: cryptoAmount * s.target.price,
        ),
      ));

      return add(ValueConverted(
        sourceAmount: cryptoAmount,
        sourceAssetId: s.target.asset.assetId,
        sourceNetworkId: s.target.asset.networkId,
        targetAssetId: s.source.assetId,
        targetNetworkId: s.source.networkId,
      ));
    }

    if (s.target.currencyType == SwapCurrencyType.fiat) {
      final fiatAmount = updateBigDecimalValue(
        s.target.fiatAmount,
        modifier: event.value,
      );
      emit(s.copyWith(
        target: s.target.copyWith(
          cryptoAmount: fiatAmount / s.target.price,
          fiatAmount: fiatAmount,
        ),
      ));

      return add(ValueConverted(
        sourceAmount: fiatAmount / s.target.price,
        sourceAssetId: s.target.asset.assetId,
        sourceNetworkId: s.target.asset.networkId,
        targetAssetId: s.source.assetId,
        targetNetworkId: s.source.networkId,
      ));
    }
  }

  void _onValueUpdated(
    ValueUpdated event,
    Emitter<AssetSwapFormState> emit,
  ) {
    final s = state;
    if (s is SwapConverted) {
      return _updateSwapConvertedState(s, event: event, emit: emit);
    }

    if (s is SwapSourceConverting) {
      return _updateSwapSourceConvertingState(s, event: event, emit: emit);
    }

    if (s is SwapTargetConverting) {
      return _updateSwapTargetConvertingState(s, event: event, emit: emit);
    }
  }

  bool _shouldBlockSourceValueConversion(SwapSourceConverting s) {
    final curr = state;
    if (curr is! SwapSourceConverting) return false;

    if (s.source.cryptoAmount != curr.source.cryptoAmount ||
        s.source.fiatAmount != curr.source.fiatAmount) return true;

    return false;
  }

  bool _shouldBlockTargetValueConversion(SwapTargetConverting s) {
    final curr = state;
    if (curr is! SwapTargetConverting) return false;

    if (s.target.cryptoAmount != curr.target.cryptoAmount ||
        s.target.fiatAmount != curr.target.fiatAmount) return true;

    return false;
  }

  Future<void> _convertSourceValue(
    SwapSourceConverting s, {
    required ValueConverted event,
    required Emitter<AssetSwapFormState> emit,
  }) async {
    try {
      final res = await _swapRepository.convert(
        sourceAmount: event.sourceAmount,
        sourceAssetId: event.sourceAssetId,
        sourceNetworkId: event.sourceNetworkId,
        sourceAssetPrecision: Assets.getAssetPreset(
          assetId: s.target.assetId,
          networkId: s.target.networkId,
        ).decimalPlaces,
        targetAssetId: event.targetAssetId,
        targetNetworkId: event.targetNetworkId,
      );

      if (_shouldBlockSourceValueConversion(s)) return;

      emit(SwapConverted(
        routes: s.routes,
        direction: SwapDirection.source,
        source: s.source.copyWith(),
        target: SwapValue(
          cryptoAmount: res.withdrawalAmount,
          fiatAmount: res.withdrawalAmount * s.target.price,
          asset: s.target,
          currencyType: SwapCurrencyType.crypto,
          price: s.target.price,
        ),
        response: SwapConvertSuccessResponse(res),
      ));
    } on HttpError catch (e) {
      final cryptoAmount = BigDecimal.zero(
        precision: Assets.getAssetPreset(
          assetId: s.target.assetId,
          networkId: s.target.networkId,
        ).decimalPlaces,
      );

      emit(SwapConverted(
        routes: s.routes,
        direction: SwapDirection.source,
        source: s.source.copyWith(),
        target: SwapValue(
          cryptoAmount: cryptoAmount,
          fiatAmount: cryptoAmount * s.target.price,
          asset: s.target,
          currencyType: SwapCurrencyType.crypto,
          price: s.target.price,
        ),
        response: SwapConvertFailureResponse(e),
      ));
    }
  }

  Future<void> _convertTargetValue(
    SwapTargetConverting s, {
    required ValueConverted event,
    required Emitter<AssetSwapFormState> emit,
  }) async {
    try {
      final res = await _swapRepository.convert(
        sourceAmount: event.sourceAmount,
        sourceAssetId: event.sourceAssetId,
        sourceNetworkId: event.sourceNetworkId,
        sourceAssetPrecision: Assets.getAssetPreset(
          assetId: s.source.assetId,
          networkId: s.source.networkId,
        ).decimalPlaces,
        targetAssetId: event.targetAssetId,
        targetNetworkId: event.targetNetworkId,
      );

      if (_shouldBlockTargetValueConversion(s)) return;

      emit(SwapConverted(
        routes: s.routes,
        direction: SwapDirection.target,
        source: SwapValue(
          cryptoAmount: res.withdrawalAmount,
          fiatAmount: res.withdrawalAmount * s.source.price,
          asset: s.source,
          currencyType: SwapCurrencyType.crypto,
          price: s.source.price,
        ),
        target: s.target.copyWith(),
        response: SwapConvertSuccessResponse(res),
      ));
    } on HttpError catch (e) {
      final cryptoAmount = BigDecimal.zero(
        precision: Assets.getAssetPreset(
          assetId: s.source.assetId,
          networkId: s.source.networkId,
        ).decimalPlaces,
      );

      emit(SwapConverted(
        routes: s.routes,
        direction: SwapDirection.source,
        source: SwapValue(
          cryptoAmount: cryptoAmount,
          fiatAmount: cryptoAmount * s.source.price,
          asset: s.source,
          currencyType: SwapCurrencyType.crypto,
          price: s.source.price,
        ),
        target: s.target.copyWith(),
        response: SwapConvertFailureResponse(e),
      ));
    }
  }

  Future<void> _onValueConverted(
    ValueConverted event,
    Emitter<AssetSwapFormState> emit,
  ) async {
    final s = state;
    if (s is SwapSourceConverting) {
      return _convertSourceValue(s, event: event, emit: emit);
    }
    if (s is SwapTargetConverting) {
      return _convertTargetValue(s, event: event, emit: emit);
    }
  }

  // TODO - add 0 convertion at the beggining to catch the minimum value
  Future<void> _onRoutesLoaded(
    RoutesLoaded event,
    Emitter<AssetSwapFormState> emit,
  ) async {
    emit(const SwapFormInitial());

    final List<SwapRoute> routes = [];

    try {
      routes.addAll(await _getRoutes(event));
    } catch (e) {
      return emit(SwapRoutesLoadedFailure(
        Exception('Swap routes could not be added because ${e.toString()}'),
        assetId: event.assetId,
        networkId: event.networkId,
      ));
    }

    if (routes.isEmpty) {
      return emit(SwapRoutesLoadedFailure(
        Exception('Swap routes of assetId ${event.assetId} are empty'),
        assetId: event.assetId,
        networkId: event.networkId,
      ));
    }

    try {
      final initialValue = BigDecimal.zero(
        precision: Assets.getAssetPreset(
          assetId: routes.first.sourceAsset.assetId,
          networkId: routes.first.sourceAsset.networkId,
        ).decimalPlaces,
      );

      final res = await _swapRepository.convert(
        sourceAmount: initialValue,
        sourceAssetId: routes.first.sourceAsset.assetId,
        sourceNetworkId: routes.first.sourceAsset.networkId,
        sourceAssetPrecision: initialValue.precision,
        targetAssetId: routes.first.targetAsset.assetId,
        targetNetworkId: routes.first.targetAsset.networkId,
      );

      return emit(SwapConverted(
        source: SwapValue(
          asset: routes.first.sourceAsset,
          cryptoAmount: initialValue,
          fiatAmount: initialValue * routes.first.sourceAsset.price,
          price: routes.first.sourceAsset.price,
        ),
        target: SwapValue(
          asset: routes.first.targetAsset,
          cryptoAmount: res.withdrawalAmount,
          fiatAmount: res.withdrawalAmount * routes.first.targetAsset.price,
          price: routes.first.targetAsset.price,
        ),
        routes: routes,
        response: SwapConvertSuccessResponse(res),
      ));
    } on HttpError catch (e) {
      return emit(SwapConverted(
        source: SwapValue(
          asset: routes.first.sourceAsset,
          cryptoAmount: BigDecimal.zero(
            precision: Assets.getAssetPreset(
              assetId: routes.first.sourceAsset.assetId,
              networkId: routes.first.sourceAsset.networkId,
            ).decimalPlaces,
          ),
          fiatAmount: BigDecimal.zero(
            precision: routes.first.sourceAsset.price.precision,
          ),
          price: routes.first.sourceAsset.price,
        ),
        target: SwapValue(
          asset: routes.first.targetAsset,
          cryptoAmount: BigDecimal.zero(
            precision: Assets.getAssetPreset(
              assetId: routes.first.targetAsset.assetId,
              networkId: routes.first.targetAsset.networkId,
            ).decimalPlaces,
          ),
          fiatAmount: BigDecimal.zero(
            precision: routes.first.targetAsset.price.precision,
          ),
          price: routes.first.targetAsset.price,
        ),
        routes: routes,
        response: SwapConvertFailureResponse(e),
      ));
    }
  }

  void _onRouteUpdated(
    RouteUpdated event,
    Emitter<AssetSwapFormState> emit,
  ) {
    final s = state;
    if (s is! SwapRoutesLoaded) return;

    final routes = s.routes;
    if (routes.isEmpty) return;

    final source = routes.first.sourceAsset;
    if (source == event.target) return;

    final initialValue = BigDecimal.zero(
      precision: Assets.getAssetPreset(
        assetId: source.assetId,
        networkId: source.networkId,
      ).decimalPlaces,
    );

    emit(SwapSourceConverting(
      routes: s.routes,
      source: SwapValue(
        asset: source,
        cryptoAmount: initialValue,
        fiatAmount: initialValue * source.price,
        price: source.price,
      ),
      target: event.target,
    ));

    return add(ValueConverted(
      sourceAmount: initialValue,
      sourceAssetId: source.assetId,
      sourceNetworkId: source.networkId,
      targetAssetId: event.target.assetId,
      targetNetworkId: event.target.networkId,
    ));
  }

  Future<List<SwapRoute>> _getRoutes(RoutesLoaded e) async {
    try {
      final routes = await _swapRepository.loadRoutes();

      return routes
          .where((route) =>
              route.sourceAsset.assetId == e.assetId &&
              route.sourceAsset.networkId == e.networkId)
          .toList();
    } catch (e) {
      return const <SwapRoute>[];
    }
  }

  void _onValueSelected(
    ValueSelected event,
    Emitter<AssetSwapFormState> emit,
  ) {
    final s = state;
    if (s is! SwapConverted) return;
    if (s.direction == event.direction) return;

    emit(s.copyWith(
      direction: event.direction,
      source: s.source.copyWith(currencyType: SwapCurrencyType.crypto),
      target: s.target.copyWith(currencyType: SwapCurrencyType.crypto),
    ));
  }

  void _onValueSwitched(
    ValueSwitched event,
    Emitter<AssetSwapFormState> emit,
  ) {
    final s = state;
    if (s is! SwapConverted) return;

    if (s.direction == SwapDirection.source) {
      emit(s.copyWith(
        source: s.source.copyWith(currencyType: event.currencyType),
      ));
    }

    if (s.direction == SwapDirection.target) {
      emit(s.copyWith(
        target: s.target.copyWith(currencyType: event.currencyType),
      ));
    }
  }

  void _onMinValueRequested(
    MinValueRequested event,
    Emitter<AssetSwapFormState> emit,
  ) {
    // TODO - implement min value request.
  }

  void _onMaxValueRequested(
    MaxValueRequested event,
    Emitter<AssetSwapFormState> emit,
  ) {
    final s = state;
    if (s is! SwapConverted) return;

    emit(SwapSourceConverting(
      routes: s.routes,
      source: s.source.copyWith(
        cryptoAmount: event.balance,
        fiatAmount: event.balance * s.source.price,
      ),
      target: s.target.asset,
    ));

    return add(ValueConverted(
      sourceAmount: event.balance,
      sourceAssetId: s.source.asset.assetId,
      sourceNetworkId: s.source.asset.networkId,
      targetAssetId: s.target.asset.assetId,
      targetNetworkId: s.target.asset.networkId,
    ));
  }
}
