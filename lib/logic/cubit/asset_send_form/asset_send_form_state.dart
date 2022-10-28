part of 'asset_send_form_cubit.dart';

enum AmountUnit { crypto, fiat }

enum Priority { low, normal, high }

class AssetSendFormState extends Equatable
    implements AssetFormState, AssetFormExceptions {
  @override
  final AssetWallet sourceAssetWallet;
  @override
  final NetworkWallet sourceNetworkWallet;
  final String toAddress;
  final String amount;
  final String amountFiat;
  final String totalAmount;
  final BigInt baseNetworkFee;
  final BigInt gasLimit;
  final String networkFee;
  final Priority priority;
  final String txHash;
  final AmountUnit amountUnit;

  final AssetSendFormResponse? response;

  const AssetSendFormState._({
    required this.sourceAssetWallet,
    required this.sourceNetworkWallet,
    required this.toAddress,
    required this.amount,
    required this.amountFiat,
    required this.totalAmount,
    required this.amountUnit,
    required this.baseNetworkFee,
    required this.gasLimit,
    required this.networkFee,
    required this.txHash,
    required this.priority,
    this.response,
  });

  AssetSendFormState.init([
    int sourceAssetId = -1,
    int sourceNetworkId = -1,
  ]) : this._(
          sourceAssetWallet: AssetWallet.builder(assetId: sourceAssetId),
          sourceNetworkWallet: NetworkWallet.builder(
              networkId: sourceNetworkId,
              address: '',
              preset: NetworkWallet.makePreset(
                assetId: sourceAssetId,
                networkId: sourceNetworkId,
              )),
          toAddress: '',
          amount: '',
          amountFiat: '',
          totalAmount: '0',
          amountUnit: AmountUnit.crypto,
          baseNetworkFee: BigInt.zero,
          gasLimit: BigInt.zero,
          networkFee: '0',
          txHash: '',
          priority: Priority.normal,
        );

  bool get isValid =>
      sourceAssetWallet.assetId >= 0 &&
      sourceNetworkWallet.networkId >= 0 &&
      toAddress.isNotEmpty &&
      double.tryParse(amount) != null &&
      double.parse(amount) > 0;

  BigInt get amountToSend =>
      doubleStringToBigInt(amount, sourceNetworkWallet.preset.decimalPlaces) -
      doubleStringToBigInt(
          networkFee, sourceNetworkWallet.preset.decimalPlaces);

  int get networkAssetId {
    return AssetRepository.assetId(networkId: sourceNetworkWallet.networkId);
  }

  @override
  List<Object?> get props => [
        sourceAssetWallet,
        sourceNetworkWallet,
        toAddress,
        amount,
        amountFiat,
        amountUnit,
        totalAmount,
        baseNetworkFee,
        gasLimit,
        networkFee,
        txHash,
        priority,
        response,
      ];

  AssetSendFormState copyWith({
    AssetWallet? sourceAssetWallet,
    NetworkWallet? sourceNetworkWallet,
    String? toAddress,
    String? amount,
    String? amountFiat,
    String? totalAmount,
    AmountUnit? amountUnit,
    BigInt? baseNetworkFee,
    BigInt? gasLimit,
    String? networkFee,
    String? txHash,
    Priority? priority,
    AssetSendFormResponse? response,
  }) {
    return AssetSendFormState._(
      sourceAssetWallet: sourceAssetWallet ?? this.sourceAssetWallet,
      sourceNetworkWallet: sourceNetworkWallet ?? this.sourceNetworkWallet,
      toAddress: toAddress ?? this.toAddress,
      amount: amount ?? this.amount,
      amountFiat: amountFiat ?? this.amountFiat,
      totalAmount: totalAmount ?? this.totalAmount,
      amountUnit: amountUnit ?? this.amountUnit,
      baseNetworkFee: baseNetworkFee ?? this.baseNetworkFee,
      networkFee: networkFee ?? this.networkFee,
      gasLimit: gasLimit ?? this.gasLimit,
      txHash: txHash ?? this.txHash,
      priority: priority ?? this.priority,
      response: response ?? this.response,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'sourceAssetWallet': sourceAssetWallet,
      'sourceNetworkWallet': sourceNetworkWallet,
    };
  }

  @override
  List<String> errors(BuildContext context) => ['', ''];

  @override
  List<bool> get hasErrors => [false, false];

  @override
  List<bool> get hasWarnings {
    return [
      (double.tryParse(amount) != null && double.parse(amount) > 0),
      priority == Priority.low
    ];
  }

  @override
  List<String> warnings(BuildContext context) {
    return [
      context
          .locale.asset_send_summary_screen_transaction_includes_fees_warning,
      context.locale.asset_send_summary_screen_low_fees_warning,
    ];
  }
}

abstract class AssetSendFormResponse extends Equatable {
  const AssetSendFormResponse();
}

class AssetSendFormPending extends AssetSendFormResponse {
  const AssetSendFormPending();

  @override
  List<Object?> get props => [];
}

class AssetSendFormSuccess extends AssetSendFormResponse {
  const AssetSendFormSuccess();

  @override
  List<Object?> get props => [];
}

class AssetSendFormFailure extends AssetSendFormResponse {
  final Exception exception;

  const AssetSendFormFailure({required this.exception});

  @override
  List<Object?> get props => [exception];
}

class FetchingFeesPending extends AssetSendFormResponse {
  const FetchingFeesPending();

  @override
  List<Object?> get props => [];
}

class FetchingFeesSuccess extends AssetSendFormResponse {
  final String networkFee;

  const FetchingFeesSuccess({required this.networkFee});

  @override
  List<Object?> get props => [];
}

class FetchingFeesFailure extends AssetSendFormResponse {
  final Exception exception;

  const FetchingFeesFailure({required this.exception});

  @override
  List<Object?> get props => [exception];
}

class AssetSearchPending extends AssetSendFormResponse {
  const AssetSearchPending();

  @override
  List<Object?> get props => [];
}

class AssetSearchFailure extends AssetSendFormResponse {
  const AssetSearchFailure();

  @override
  List<Object?> get props => [];
}

class AssetSearchSuccess extends AssetSendFormResponse {
  final List<AssetWallet> availableWallets;

  const AssetSearchSuccess({required this.availableWallets});

  @override
  List<Object?> get props => [availableWallets];
}
