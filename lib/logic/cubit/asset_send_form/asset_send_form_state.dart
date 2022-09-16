part of 'asset_send_form_cubit.dart';

enum AmountUnit { crypto, fiat }

enum Priority { low, normal, high }

class AssetSendFormState extends Equatable {
  final int assetId;
  final int networkId;
  final String address;
  final String amount;
  final String totalAmount;
  final String cumulativeFee;
  final String networkFee;
  final Priority priority;
  final AmountUnit amountUnit;

  final AssetSendFormResponse? response;

  const AssetSendFormState._({
    required this.assetId,
    required this.networkId,
    required this.address,
    required this.amount,
    required this.totalAmount,
    required this.amountUnit,
    required this.cumulativeFee,
    required this.networkFee,
    required this.priority,
    this.response,
  });

  const AssetSendFormState.init()
      : this._(
          assetId: -1,
          networkId: -1,
          address: '',
          amount: '0',
          totalAmount: '0',
          amountUnit: AmountUnit.crypto,
          cumulativeFee: '0',
          networkFee: '0',
          priority: Priority.normal,
        );

  bool get isValid =>
      assetId >= 0 &&
      networkId >= 0 &&
      address.isNotEmpty &&
      double.parse(amount) > 0;

  @override
  List<Object?> get props => [
        assetId,
        networkId,
        address,
        amount,
        amountUnit.index,
        cumulativeFee,
        networkFee,
        priority,
      ];

  AssetSendFormState copyWith({
    int? assetId,
    int? networkId,
    String? address,
    String? amount,
    String? totalAmount,
    AmountUnit? amountUnit,
    String? cumulativeFee,
    String? networkFee,
    Priority? priority,
    AssetSendFormResponse? response,
  }) {
    return AssetSendFormState._(
      assetId: assetId ?? this.assetId,
      networkId: networkId ?? this.networkId,
      address: address ?? this.address,
      amount: amount ?? this.amount,
      totalAmount: totalAmount ?? this.totalAmount,
      amountUnit: amountUnit ?? this.amountUnit,
      cumulativeFee: cumulativeFee ?? this.cumulativeFee,
      networkFee: networkFee ?? this.networkFee,
      priority: priority ?? this.priority,
      response: response ?? this.response,
    );
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
