part of 'asset_buy_form_cubit.dart';

enum PaymentMethod { debitCard, payPal, applePay, googlePay }

enum DebitCardType { visa, masterCard }

class AssetBuyFormState extends Equatable
    implements AssetFormExceptions, AssetFormState {
  @override
  final AssetWallet sourceAssetWallet;
  @override
  final NetworkWallet sourceNetworkWallet;
  final String amount;
  final String amountFiat;
  final String totalAmountToBuy;
  final String fee;
  final String price;
  final AmountUnit amountUnit;
  final PaymentMethod paymentMethod;
  final DebitCardType? debitCardType;
  final String? paymentGatewayUrl;

  final AssetBuyFormResponse? response;

  const AssetBuyFormState._({
    required this.sourceAssetWallet,
    required this.sourceNetworkWallet,
    required this.amount,
    required this.amountFiat,
    required this.totalAmountToBuy,
    required this.amountUnit,
    required this.fee,
    required this.price,
    required this.paymentMethod,
    this.response,
    this.paymentGatewayUrl,
    this.debitCardType,
  });

  AssetBuyFormState.init([
    int sourceAssetId = -1,
    int sourceNetworkId = -1,
  ]) : this._(
          sourceAssetWallet: AssetWallet.builder(assetId: sourceAssetId),
          sourceNetworkWallet: NetworkWallet.builder(
              networkId: sourceNetworkId, address: '', decimalPlaces: -1),
          amount: '',
          amountFiat: '',
          totalAmountToBuy: '0',
          amountUnit: AmountUnit.crypto,
          paymentMethod: PaymentMethod
              .debitCard, // we will support only debit cards in the beginning
          fee: '0',
          price: '0',
          paymentGatewayUrl: '',
        );

  bool get isValid => amount.isNotEmpty && double.parse(amount) > 0;

  @override
  List<Object?> get props => [
        sourceAssetWallet,
        sourceNetworkWallet,
        amount,
        amountFiat,
        amountUnit.index,
        fee,
        price,
        paymentMethod,
        debitCardType,
        paymentGatewayUrl,
        response,
      ];

  AssetBuyFormState copyWith({
    AssetWallet? sourceAssetWallet,
    NetworkWallet? sourceNetworkWallet,
    String? amountFrom,
    String? amountFromFiat,
    String? totalAmount,
    AmountUnit? amountUnit,
    String? fee,
    String? price,
    PaymentMethod? paymentMethod,
    DebitCardType? debitCardType,
    AssetBuyFormResponse? response,
    String? paymentGatewayUrl,
  }) {
    return AssetBuyFormState._(
      sourceAssetWallet: sourceAssetWallet ?? this.sourceAssetWallet,
      sourceNetworkWallet: sourceNetworkWallet ?? this.sourceNetworkWallet,
      amount: amountFrom ?? amount,
      amountFiat: amountFromFiat ?? amountFiat,
      totalAmountToBuy: totalAmount ?? totalAmountToBuy,
      amountUnit: amountUnit ?? this.amountUnit,
      fee: fee ?? this.fee,
      price: price ?? this.price,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      debitCardType: debitCardType ?? this.debitCardType,
      response: response ?? this.response,
      paymentGatewayUrl: paymentGatewayUrl ?? this.paymentGatewayUrl,
    );
  }

  @override
  List<String> errors(BuildContext context) => [
        '',
      ];

  @override
  List<bool> get hasErrors => [
        false,
      ];

  @override
  List<bool> get hasWarnings {
    return [
      (double.tryParse(amount) != null && double.parse(amount) > 0),
    ];
  }

  @override
  List<String> warnings(BuildContext context) {
    return [
      context
          .locale.asset_send_summary_screen_transaction_includes_fees_warning,
    ];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'sourceAssetWallet': sourceAssetWallet,
      'sourceNetworkWallet': sourceNetworkWallet,
    };
  }
}

abstract class AssetBuyFormResponse extends Equatable {
  const AssetBuyFormResponse();

  @override
  List<Object?> get props => [];
}

class AmountPending extends AssetBuyFormResponse {
  const AmountPending();

  @override
  List<Object?> get props => [];
}

class AmountSuccess extends AssetBuyFormResponse {
  const AmountSuccess();

  @override
  List<Object?> get props => [];
}

class AmountFailure extends AssetBuyFormResponse {
  const AmountFailure();

  @override
  List<Object?> get props => [];
}

class AssetBuyFormPending extends AssetBuyFormResponse {
  const AssetBuyFormPending();

  @override
  List<Object?> get props => [];
}

class AssetBuyFormPriceRefreshPending extends AssetBuyFormResponse {
  const AssetBuyFormPriceRefreshPending();

  @override
  List<Object?> get props => [];
}

class AssetBuyFormPriceRefreshSuccess extends AssetBuyFormResponse {
  final bool confirmationNeeded;
  final String? newTotalAmount;
  final String? newTotalAmountFiat;

  const AssetBuyFormPriceRefreshSuccess({
    required this.confirmationNeeded,
    required this.newTotalAmount,
    required this.newTotalAmountFiat,
  });

  @override
  List<Object?> get props => [];
}

class AssetBuyFormPriceRefreshFailure extends AssetBuyFormResponse {
  final Exception exception;

  const AssetBuyFormPriceRefreshFailure({required this.exception});

  @override
  List<Object?> get props => [];
}

class AssetBuyFormSuccess extends AssetBuyFormResponse {
  const AssetBuyFormSuccess();

  @override
  List<Object?> get props => [];
}

class AssetBuyFormFailure extends AssetBuyFormResponse {
  final Exception exception;

  const AssetBuyFormFailure({required this.exception});

  @override
  List<Object?> get props => [exception];
}

class AssetSearchFromPending extends AssetBuyFormResponse {
  const AssetSearchFromPending();

  @override
  List<Object?> get props => [];
}

class AssetSearchFromFailure extends AssetBuyFormResponse {
  const AssetSearchFromFailure();

  @override
  List<Object?> get props => [];
}

class AssetSearchFromSuccess extends AssetBuyFormResponse {
  final List<AssetWallet> availableWallets;

  const AssetSearchFromSuccess({required this.availableWallets});

  @override
  List<Object?> get props => [availableWallets];
}
