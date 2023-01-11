part of 'asset_swap_form_bloc.dart';

enum SwapCurrencyType {
  crypto,
  fiat,
}

enum SwapDirection {
  source,
  target,
}

abstract class AssetSwapFormState extends Equatable {
  const AssetSwapFormState();

  @override
  List<Object?> get props => [];
}

class SwapFormInitial extends AssetSwapFormState {
  const SwapFormInitial();
}

// TODO - provide swap routes only to `SwapRoutesLoadedSuccess` state
abstract class SwapRoutesLoaded extends AssetSwapFormState {
  final List<SwapRoute> routes;
  final SwapDirection direction;

  const SwapRoutesLoaded({
    required this.routes,
    required this.direction,
  });

  @override
  List<Object?> get props => [routes, direction];

  // TODO - does it have to be always present?
  SwapRoutesLoaded copyWith({
    List<SwapRoute>? routes,
    SwapDirection? direction,
  });
}

class SwapRoutesLoadedSuccess extends SwapRoutesLoaded {
  const SwapRoutesLoadedSuccess({
    required super.routes,
    required super.direction,
  });

  @override
  SwapRoutesLoaded copyWith({
    List<SwapRoute>? routes,
    SwapDirection? direction,
  }) {
    return SwapRoutesLoadedSuccess(
      routes: routes ?? this.routes,
      direction: direction ?? this.direction,
    );
  }
}

class SwapRoutesLoadedFailure extends SwapRoutesLoaded {
  final Exception error;
  final AssetId assetId;
  final NetworkId networkId;

  const SwapRoutesLoadedFailure(
    this.error, {
    super.routes = const [],
    super.direction = SwapDirection.source,
    required this.assetId,
    required this.networkId,
  });

  @override
  SwapRoutesLoaded copyWith({
    Exception? error,
    List<SwapRoute>? routes,
    SwapDirection? direction,
  }) {
    return SwapRoutesLoadedFailure(
      error ?? this.error,
      assetId: assetId,
      networkId: networkId,
    );
  }
}

class SwapSourceConverting extends SwapRoutesLoaded {
  final SwapValue source;
  final SwapAsset target;

  const SwapSourceConverting({
    super.routes = const [],
    super.direction = SwapDirection.source,
    required this.source,
    required this.target,
  });

  @override
  List<Object?> get props => [
        routes,
        direction,
        source,
        target,
      ];

  @override
  SwapSourceConverting copyWith({
    List<SwapRoute>? routes,
    SwapDirection? direction,
    SwapValue? source,
    SwapAsset? target,
  }) {
    return SwapSourceConverting(
      routes: this.routes,
      direction: this.direction,
      source: source ?? this.source,
      target: target ?? this.target,
    );
  }
}

class SwapTargetConverting extends SwapRoutesLoaded {
  final SwapAsset source;
  final SwapValue target;

  const SwapTargetConverting({
    super.routes = const [],
    super.direction = SwapDirection.target,
    required this.source,
    required this.target,
  });

  @override
  List<Object?> get props => [
        routes,
        direction,
        source,
        target,
      ];

  @override
  SwapTargetConverting copyWith({
    List<SwapRoute>? routes,
    SwapDirection? direction,
    SwapAsset? source,
    SwapValue? target,
  }) {
    return SwapTargetConverting(
      routes: this.routes,
      direction: this.direction,
      source: source ?? this.source,
      target: target ?? this.target,
    );
  }
}

class SwapConverted extends SwapRoutesLoaded {
  final SwapValue source;
  final SwapValue target;
  final SwapConvertResponse response;

  const SwapConverted({
    super.routes = const [],
    super.direction = SwapDirection.source,
    required this.source,
    required this.target,
    required this.response,
  });

  @override
  List<Object?> get props => [
        direction,
        routes,
        source,
        target,
        response,
      ];

  @override
  SwapConverted copyWith({
    List<SwapRoute>? routes,
    SwapDirection? direction,
    SwapValue? source,
    SwapValue? target,
    SwapConvertResponse? response,
  }) {
    return SwapConverted(
      routes: this.routes,
      direction: direction ?? this.direction,
      source: source ?? this.source,
      target: target ?? this.target,
      response: response ?? this.response,
    );
  }
}

class SwapValue extends Equatable {
  final SwapAsset asset;
  final BigDecimal cryptoAmount;
  final BigDecimal fiatAmount;
  final BigDecimal price;
  final SwapCurrencyType currencyType;

  const SwapValue({
    required this.asset,
    required this.cryptoAmount,
    required this.fiatAmount,
    required this.price,
    this.currencyType = SwapCurrencyType.crypto,
  });

  @override
  List<Object?> get props => [
        asset,
        cryptoAmount,
        fiatAmount,
        price,
        currencyType,
      ];
  SwapValue copyWith({
    BigDecimal? cryptoAmount,
    BigDecimal? fiatAmount,
    BigDecimal? price,
    SwapCurrencyType? currencyType,
  }) {
    return SwapValue(
      cryptoAmount: cryptoAmount ?? this.cryptoAmount,
      fiatAmount: fiatAmount ?? this.fiatAmount,
      price: price ?? this.price,
      asset: asset,
      currencyType: currencyType ?? this.currencyType,
    );
  }
}

abstract class AssetSwapFormResponse extends Equatable {
  const AssetSwapFormResponse();

  @override
  List<Object?> get props => [];
}

class SwapFormPendingResponse extends AssetSwapFormResponse {}

abstract class AssetSwapLoadingFormState extends Equatable {
  const AssetSwapLoadingFormState();

  @override
  List<Object?> get props => [];
}

abstract class SwapConvertResponse extends Equatable {
  const SwapConvertResponse();

  @override
  List<Object?> get props => [];
}

class SwapConvertSuccessResponse extends SwapConvertResponse {
  final SwapConversion value;

  const SwapConvertSuccessResponse(this.value);

  @override
  List<Object?> get props => [value];
}

class SwapConvertFailureResponse extends SwapConvertResponse {
  final HttpError error;

  const SwapConvertFailureResponse(this.error);

  @override
  List<Object?> get props => [error];
}
