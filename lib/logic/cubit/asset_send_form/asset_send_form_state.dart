part of 'asset_send_form_cubit.dart';

enum AmountUnit { crypto, fiat }

enum Priority { low, normal, high }

class AssetSendFormState extends Equatable
    implements AssetFormState, AssetFormExceptions {
  @override
  final int assetId;
  @override
  final int networkId;
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
  final NetworkWallet networkWallet;

  final AssetSendFormResponse? response;

  const AssetSendFormState._({
    required this.assetId,
    required this.networkId,
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
    required this.networkWallet,
    this.response,
  });

  AssetSendFormState.init([
    int assetId = -1,
    int networkId = -1,
  ]) : this._(
            assetId: assetId,
            networkId: networkId,
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
            networkWallet: NetworkWallet.builder(
                networkId: networkId, address: '', decimalPlaces: -1));

  bool get isValid =>
      assetId >= 0 &&
      networkId >= 0 &&
      toAddress.isNotEmpty &&
      double.tryParse(amount) != null &&
      double.parse(amount) > 0;

  BigInt amountToSend(int decimalPlaces) =>
      doubleStringToBigInt(amount, decimalPlaces) -
      doubleStringToBigInt(networkFee, decimalPlaces);

  @override
  List<Object?> get props => [
        assetId,
        networkId,
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
    int? assetId,
    int? networkId,
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
    NetworkWallet? networkWallet,
    AssetSendFormResponse? response,
  }) {
    return AssetSendFormState._(
      assetId: assetId ?? this.assetId,
      networkId: networkId ?? this.networkId,
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
      networkWallet: networkWallet ?? this.networkWallet,
      response: response ?? this.response,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'assetId': assetId,
      'networkId': networkId,
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
