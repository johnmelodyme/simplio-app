part of 'asset_buy_form_cubit.dart';

enum PaymentMethod { debitCard, payPal, applePay, googlePay }

enum DebitCardType { visa, masterCard }

class CryptoFiatPair {
  final PairFiatAsset fiatAsset;
  final PairCryptoAsset cryptoAsset;

  const CryptoFiatPair({
    required this.fiatAsset,
    required this.cryptoAsset,
  });
}

class AssetBuyFormState extends Equatable
    implements AssetFormExceptions, AssetFormState {
  @override
  final AssetWallet sourceAssetWallet;
  @override
  final NetworkWallet sourceNetworkWallet;
  final String amount;
  final String amountFiat;
  final AmountUnit amountUnit;
  final PaymentMethod paymentMethod;
  // final BuyConvertResponse buyConvertResponse;
  // final CryptoFiatPair selectedPair;
  final DebitCardType? debitCardType;
  final String paymentGatewayUrl;
  final String orderId;
  // final Map<AssetWallet, CryptoFiatPair> availableWallets;

  final AssetBuyFormResponse? response;

  const AssetBuyFormState._({
    required this.sourceAssetWallet,
    required this.sourceNetworkWallet,
    required this.amount,
    required this.amountFiat,
    required this.amountUnit,
    required this.paymentMethod,
    // required this.buyConvertResponse,
    // required this.selectedPair,
    // required this.availableWallets,
    this.response,
    this.paymentGatewayUrl = '',
    this.orderId = '',
    this.debitCardType,
  });

  AssetBuyFormState.init([
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
            ),
          ),
          amount: '',
          amountFiat: '',
          amountUnit: AmountUnit.crypto,
          paymentMethod: PaymentMethod
              .debitCard, // we will support only debit cards in the beginning
          // buyConvertResponse: BuyConvertResponse(
          //     fiatAsset: FiatAsset(assetId: 'USD', amount: 0),
          //     cryptoAsset: CryptoAsset(
          //         assetId: sourceAssetId,
          //         networkId: sourceNetworkId,
          //         amount: 0),
          //     targetAmount: FeeAsset(assetId: 'USD', amount: 0)),
          // selectedPair: CryptoFiatPair(
          //     fiatAsset: PairFiatAsset(
          //       assetId: '',
          //       decimalPlaces: -1,
          //       minimum: double.infinity,
          //       maximum: -1,
          //     ),
          //     cryptoAsset: PairCryptoAsset(
          //       assetId: -1,
          //       networkId: -1,
          //     )),
          paymentGatewayUrl: '',
          // availableWallets: {},
        );

  bool get isValid =>
      !hasErrors.contains(true) &&
      double.tryParse(amount) != null &&
      double.parse(amount) > 0;

  @override
  List<Object?> get props => [
        sourceAssetWallet,
        sourceNetworkWallet,
        amount,
        amountFiat,
        amountUnit.index,
        paymentMethod,
        debitCardType,
        paymentGatewayUrl,
        orderId,
        // buyConvertResponse,
        // selectedPair,
        // availableWallets,
        response,
        hasErrors,
        hasWarnings,
      ];

  AssetBuyFormState copyWith({
    AssetWallet? sourceAssetWallet,
    NetworkWallet? sourceNetworkWallet,
    String? amount,
    String? amountFiat,
    String? totalAmount,
    AmountUnit? amountUnit,
    // BuyConvertResponse? buyConvertResponse,
    PaymentMethod? paymentMethod,
    DebitCardType? debitCardType,
    AssetBuyFormResponse? response,
    // CryptoFiatPair? selectedPair,
    // Map<AssetWallet, CryptoFiatPair>? availableWallets,
    String? paymentGatewayUrl,
    String? orderId,
  }) {
    return AssetBuyFormState._(
      sourceAssetWallet: sourceAssetWallet ?? this.sourceAssetWallet,
      sourceNetworkWallet: sourceNetworkWallet ?? this.sourceNetworkWallet,
      amount: amount ?? this.amount,
      amountFiat: amountFiat ?? this.amountFiat,
      amountUnit: amountUnit ?? this.amountUnit,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      // buyConvertResponse: buyConvertResponse ?? this.buyConvertResponse,
      debitCardType: debitCardType ?? this.debitCardType,
      response: response ?? this.response,
      // selectedPair: selectedPair ?? this.selectedPair,
      // availableWallets: availableWallets ?? this.availableWallets,
      paymentGatewayUrl: paymentGatewayUrl ?? this.paymentGatewayUrl,
      orderId: orderId ?? this.orderId,
    );
  }

  @override
  List<String> errors(BuildContext context) => [
        // context.locale.asset_buy_screen_range_exception(
        //     selectedPair.fiatAsset.minimum.toString(),
        //     selectedPair.fiatAsset.maximum.toString())
      ];

  @override
  List<bool> get hasErrors => [
        false,
        // double.tryParse(amountFiat) != null &&
        //     (double.parse(amountFiat) > selectedPair.fiatAsset.maximum ||
        //         double.parse(amountFiat) < selectedPair.fiatAsset.minimum),
      ];

  @override
  List<bool> get hasWarnings => [false];

  @override
  List<String> warnings(BuildContext context) => [];

  @override
  Map<String, dynamic> toMap() {
    return {
      'sourceAssetWallet': sourceAssetWallet,
      'sourceNetworkWallet': sourceNetworkWallet,
    };
  }

  double get finalAmount => double.tryParse(amount) ?? 0;
  double get finalFiatAmount => double.tryParse(amountFiat) ?? 0;

  // double get estimatedPrice =>
  //     buyConvertResponse.fiatAsset.amount /
  //     buyConvertResponse.cryptoAsset.amount;

  // double get totalAmountToPayInFiat =>
  //     buyConvertResponse.fiatAsset.amount +
  //     buyConvertResponse.targetAmount.amount;
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
  const AssetBuyFormPriceRefreshSuccess();

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

class AssetSearchLoading extends AssetBuyFormResponse {
  const AssetSearchLoading();

  @override
  List<Object?> get props => [];
}

class AssetSearchFailure extends AssetBuyFormResponse {
  final String error;
  const AssetSearchFailure({required this.error});

  @override
  List<Object?> get props => [];
}

class AssetSearchLoaded extends AssetBuyFormResponse {
  final List<BuyPairResponseItem> pairs;

  const AssetSearchLoaded({
    required this.pairs,
  });

  @override
  List<Object?> get props => [pairs];
}
