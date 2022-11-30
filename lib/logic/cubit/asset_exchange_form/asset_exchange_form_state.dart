part of 'asset_exchange_form_cubit.dart';

enum AmountUnit { crypto, fiat }

enum FocusedDirection { from, to }

abstract class AssetFormState {
  abstract final AssetWallet sourceAssetWallet;
  abstract final NetworkWallet sourceNetworkWallet;

  Map<String, dynamic> toMap();
}

abstract class AssetFormExceptions {
  List<bool> get hasWarnings;
  List<bool> get hasErrors;

  List<String> warnings(BuildContext context);
  List<String> errors(BuildContext context);
}

class AssetExchangeFormState extends Equatable
    implements AssetFormExceptions, AssetFormState {
  @override
  final AssetWallet sourceAssetWallet;
  @override
  final NetworkWallet sourceNetworkWallet;
  final AssetWallet targetAssetWallet;
  final NetworkWallet targetNetworkWallet;
  final String amountFrom;
  final String amountFromFiat;
  final String amountTo;
  final String amountToFiat;
  final AmountUnit amountFromUnit;
  final AmountUnit amountToUnit;
  final List<AssetWallet> availableFromAssets;
  final List<AssetWallet> availableTargetAssets;
  final FocusedDirection focusedDirection;

  final AssetExchangeFormResponse? response;

  const AssetExchangeFormState._({
    required this.sourceAssetWallet,
    required this.sourceNetworkWallet,
    required this.targetAssetWallet,
    required this.targetNetworkWallet,
    required this.amountFrom,
    required this.amountFromFiat,
    required this.amountTo,
    required this.amountToFiat,
    required this.amountFromUnit,
    required this.amountToUnit,
    required this.focusedDirection,
    required this.availableFromAssets,
    required this.availableTargetAssets,
    this.response,
  });

  AssetExchangeFormState.init([
    int sourceAssetId = -1,
    int sourceNetworkId = -1,
    int targetAssetId = -1,
    int targetNetworkId = -1,
  ]) : this._(
          sourceAssetWallet: AssetWallet.builder(assetId: sourceAssetId),
          sourceNetworkWallet: NetworkWallet.builder(
            networkId: sourceNetworkId,
            address: '',
            preset: NetworkWallet.makePreset(
              assetId: sourceAssetId,
              networkId: sourceNetworkId,
            ),
          ),
          targetAssetWallet: AssetWallet.builder(assetId: targetAssetId),
          targetNetworkWallet: NetworkWallet.builder(
            networkId: targetNetworkId,
            address: '',
            preset: NetworkWallet.makePreset(
              assetId: targetAssetId,
              networkId: targetNetworkId,
            ),
          ),
          amountFrom: '',
          amountFromFiat: '',
          amountTo: '',
          amountToFiat: '',
          amountFromUnit: AmountUnit.crypto,
          amountToUnit: AmountUnit.crypto,
          availableFromAssets: const [],
          availableTargetAssets: const [],
          focusedDirection: FocusedDirection.from,
        );

  bool get isValid =>
      sourceAssetWallet.assetId >= 0 &&
      sourceNetworkWallet.networkId >= 0 &&
      targetAssetWallet.assetId >= 0 &&
      targetNetworkWallet.networkId >= 0 &&
      amountFrom.isNotEmpty &&
      amountTo.isNotEmpty &&
      double.parse(amountFrom) >= minAmount &&
      double.parse(amountFrom) <= maxAmount &&
      double.parse(amountTo) > 0;

  BigInt get amountToSend => doubleStringToBigInt(
        amountFrom,
        sourceNetworkWallet.preset.decimalPlaces,
      );

  int get networkAssetId {
    return AssetRepository.assetId(networkId: sourceNetworkWallet.networkId);
  }

  @override
  List<Object?> get props => [
        sourceAssetWallet,
        sourceNetworkWallet,
        targetAssetWallet,
        targetNetworkWallet,
        amountFrom,
        amountFromFiat,
        amountTo,
        amountToFiat,
        amountFromUnit,
        amountToUnit,
        response,
        availableFromAssets,
        availableTargetAssets,
        focusedDirection,
      ];

  AssetExchangeFormState copyWith({
    AssetWallet? sourceAssetWallet,
    NetworkWallet? sourceNetworkWallet,
    AssetWallet? targetAssetWallet,
    NetworkWallet? targetNetworkWallet,
    String? amountFrom,
    String? amountFromFiat,
    String? amountTo,
    String? amountToFiat,
    AmountUnit? amountFromUnit,
    AmountUnit? amountToUnit,
    AssetExchangeFormResponse? response,
    List<AssetWallet>? availableFromAssets,
    List<AssetWallet>? availableTargetAssets,
    FocusedDirection? focusedDirection,
  }) {
    return AssetExchangeFormState._(
      sourceAssetWallet: sourceAssetWallet ?? this.sourceAssetWallet,
      sourceNetworkWallet: sourceNetworkWallet ?? this.sourceNetworkWallet,
      targetAssetWallet: targetAssetWallet ?? this.targetAssetWallet,
      targetNetworkWallet: targetNetworkWallet ?? this.targetNetworkWallet,
      amountFrom: amountFrom ?? this.amountFrom,
      amountFromFiat: amountFromFiat ?? this.amountFromFiat,
      amountTo: amountTo ?? this.amountTo,
      amountToFiat: amountToFiat ?? this.amountToFiat,
      amountFromUnit: amountFromUnit ?? this.amountFromUnit,
      amountToUnit: amountToUnit ?? this.amountToUnit,
      response: response ?? this.response,
      availableFromAssets: availableFromAssets ?? this.availableFromAssets,
      availableTargetAssets:
          availableTargetAssets ?? this.availableTargetAssets,
      focusedDirection: focusedDirection ?? this.focusedDirection,
    );
  }

  @override
  List<String> errors(BuildContext context) => ['', ''];

  @override
  List<bool> get hasErrors => [false, false];

  @override
  List<bool> get hasWarnings {
    return [
      (double.tryParse(amountFrom) != null && double.parse(amountFrom) > 0),
      (double.tryParse(amountTo) != null && double.parse(amountTo) > 0),
    ];
  }

  @override
  List<String> warnings(BuildContext context) {
    return [
      context
          .locale.asset_send_summary_screen_transaction_includes_fees_warning,
      context
          .locale.asset_send_summary_screen_transaction_includes_fees_warning,
    ];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'sourceAssetWallet': sourceAssetWallet,
      'sourceNetworkWallet': sourceNetworkWallet,
      'targetAssetWallet': targetAssetWallet,
      'targetNetworkWallet': targetNetworkWallet,
    };
  }
}

abstract class AssetExchangeFormResponse extends Equatable {
  const AssetExchangeFormResponse();

  @override
  List<Object?> get props => [];
}

class AmountFromPending extends AssetExchangeFormResponse {
  const AmountFromPending();

  @override
  List<Object?> get props => [];
}

class AmountFromSuccess extends AssetExchangeFormResponse {
  const AmountFromSuccess();

  @override
  List<Object?> get props => [];
}

class AmountFromFailure extends AssetExchangeFormResponse {
  const AmountFromFailure();

  @override
  List<Object?> get props => [];
}

class AmountToPending extends AssetExchangeFormResponse {
  const AmountToPending();

  @override
  List<Object?> get props => [];
}

class AmountToSuccess extends AssetExchangeFormResponse {
  const AmountToSuccess();

  @override
  List<Object?> get props => [];
}

class AmountToFailure extends AssetExchangeFormResponse {
  const AmountToFailure();

  @override
  List<Object?> get props => [];
}

class AssetExchangeFormPending extends AssetExchangeFormResponse {
  const AssetExchangeFormPending();

  @override
  List<Object?> get props => [];
}

class AssetExchangeFormSuccess extends AssetExchangeFormResponse {
  const AssetExchangeFormSuccess();

  @override
  List<Object?> get props => [];
}

class AssetExchangeFormFailure extends AssetExchangeFormResponse {
  final Exception exception;

  const AssetExchangeFormFailure({required this.exception});

  @override
  List<Object?> get props => [exception];
}

class FetchingFeesPending extends AssetExchangeFormResponse {
  const FetchingFeesPending();

  @override
  List<Object?> get props => [];
}

class FetchingFeesSuccess extends AssetExchangeFormResponse {
  final String totalSwapFee;

  const FetchingFeesSuccess({required this.totalSwapFee});

  @override
  List<Object?> get props => [];
}

class FetchingFeesFailure extends AssetExchangeFormResponse {
  final Exception exception;

  const FetchingFeesFailure({required this.exception});

  @override
  List<Object?> get props => [exception];
}

class SearchAssetsLoading extends AssetExchangeFormResponse {
  const SearchAssetsLoading();

  @override
  List<Object?> get props => [];
}

class SearchAssetsFailure extends AssetExchangeFormResponse {
  const SearchAssetsFailure();

  @override
  List<Object?> get props => [];
}

class SearchAssetsSuccess extends AssetExchangeFormResponse {
  const SearchAssetsSuccess();

  @override
  List<Object?> get props => [];
}
