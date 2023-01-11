part of 'asset_swap_form_bloc.dart';

abstract class AssetSwapFormEvent extends Equatable {
  const AssetSwapFormEvent();

  @override
  List<Object?> get props => [];
}

class ValueUpdated extends AssetSwapFormEvent {
  final NumpadValue value;

  const ValueUpdated(this.value);

  @override
  List<Object?> get props => [value];
}

class ValueConverted extends AssetSwapFormEvent {
  final BigDecimal sourceAmount;
  final int sourceAssetId;
  final int sourceNetworkId;
  final int targetAssetId;
  final int targetNetworkId;

  const ValueConverted({
    required this.sourceAmount,
    required this.sourceAssetId,
    required this.sourceNetworkId,
    required this.targetAssetId,
    required this.targetNetworkId,
  });

  @override
  List<Object?> get props => [
        sourceAmount,
        sourceAssetId,
        sourceNetworkId,
        targetAssetId,
        targetNetworkId,
      ];
}

class RoutesLoaded extends AssetSwapFormEvent {
  final int assetId;
  final int networkId;

  const RoutesLoaded({
    required this.assetId,
    required this.networkId,
  });

  @override
  List<Object?> get props => [assetId, networkId];
}

// TODO - unify naming as ValueUpdated
class RouteUpdated extends AssetSwapFormEvent {
  final SwapAsset target;
  final List<SwapRoute> routes;

  const RouteUpdated({
    required this.target,
    required this.routes,
  });

  @override
  List<Object?> get props => [target, routes];
}

class ValueSelected extends AssetSwapFormEvent {
  final SwapDirection direction;

  const ValueSelected({required this.direction});

  @override
  List<Object?> get props => [direction];
}

class ValueSwitched extends AssetSwapFormEvent {
  final SwapDirection direction;
  final SwapCurrencyType currencyType;

  const ValueSwitched({
    required this.direction,
    required this.currencyType,
  });

  @override
  List<Object?> get props => [direction, currencyType];
}

class MinValueRequested extends AssetSwapFormEvent {
  const MinValueRequested();
}

class MaxValueRequested extends AssetSwapFormEvent {
  final BigDecimal balance;

  const MaxValueRequested({
    this.balance = const BigDecimal.zero(),
  });

  @override
  List<Object?> get props => [balance];
}
