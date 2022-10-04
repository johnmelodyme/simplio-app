part of 'asset_exchange_form_cubit.dart';

abstract class AssetFormState {
  abstract final int assetId;
  abstract final int networkId;

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
  final int assetId;
  @override
  final int networkId;
  final int targetAssetId;
  final int targetNetworkId;
  final String amountFrom;
  final String amountFromFiat;
  final String amountTo;
  final String totalAmount;
  final String totalSwapFee;
  final String sourceTransactionFee;
  final String targetTransactionFee;
  final String swapFee;
  final AmountUnit amountUnit;

  final AssetExchangeFormResponse? response;

  const AssetExchangeFormState._({
    required this.assetId,
    required this.networkId,
    required this.targetAssetId,
    required this.targetNetworkId,
    required this.amountFrom,
    required this.amountFromFiat,
    required this.amountTo,
    required this.totalAmount,
    required this.amountUnit,
    required this.totalSwapFee,
    required this.sourceTransactionFee,
    required this.targetTransactionFee,
    required this.swapFee,
    this.response,
  });

  const AssetExchangeFormState.init()
      : this._(
          assetId: -1,
          networkId: -1,
          targetAssetId: -1,
          targetNetworkId: -1,
          amountFrom: '',
          amountFromFiat: '',
          amountTo: '',
          totalAmount: '0',
          amountUnit: AmountUnit.crypto,
          totalSwapFee: '0',
          sourceTransactionFee: '0',
          targetTransactionFee: '0',
          swapFee: '0',
        );

  bool get isValid =>
      amountFrom.isNotEmpty &&
      amountTo.isNotEmpty &&
      double.parse(amountFrom) > 0 &&
      double.parse(amountTo) > 0;

  @override
  List<Object?> get props => [
        assetId,
        networkId,
        targetAssetId,
        targetNetworkId,
        amountFrom,
        amountFromFiat,
        amountTo,
        amountUnit.index,
        totalSwapFee,
        sourceTransactionFee,
        targetTransactionFee,
        swapFee,
        response,
      ];

  AssetExchangeFormState copyWith({
    int? assetId,
    int? networkId,
    int? targetAssetId,
    int? targetNetworkId,
    String? address,
    String? amountFrom,
    String? amountFromFiat,
    String? amountTo,
    String? totalAmount,
    AmountUnit? amountUnit,
    String? totalSwapFee,
    String? sourceTransactionFee,
    String? targetTransactionFee,
    String? swapFee,
    AssetExchangeFormResponse? response,
  }) {
    return AssetExchangeFormState._(
      assetId: assetId ?? this.assetId,
      networkId: networkId ?? this.networkId,
      targetAssetId: targetAssetId ?? this.targetAssetId,
      targetNetworkId: targetNetworkId ?? this.targetNetworkId,
      amountFrom: amountFrom ?? this.amountFrom,
      amountFromFiat: amountFromFiat ?? this.amountFromFiat,
      amountTo: amountTo ?? this.amountTo,
      totalAmount: totalAmount ?? this.totalAmount,
      amountUnit: amountUnit ?? this.amountUnit,
      totalSwapFee: totalSwapFee ?? this.totalSwapFee,
      sourceTransactionFee: sourceTransactionFee ?? this.sourceTransactionFee,
      targetTransactionFee: targetTransactionFee ?? this.targetTransactionFee,
      swapFee: swapFee ?? this.swapFee,
      response: response ?? this.response,
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
      'assetId': assetId,
      'networkId': networkId,
      'targetAssetId': targetAssetId,
      'targetNetworkId': targetNetworkId,
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

class AssetSearchFromPending extends AssetExchangeFormResponse {
  const AssetSearchFromPending();

  @override
  List<Object?> get props => [];
}

class AssetSearchFromFailure extends AssetExchangeFormResponse {
  const AssetSearchFromFailure();

  @override
  List<Object?> get props => [];
}

class AssetSearchFromSuccess extends AssetExchangeFormResponse {
  final List<AssetWallet> availableWallets;

  const AssetSearchFromSuccess({required this.availableWallets});

  @override
  List<Object?> get props => [availableWallets];
}
