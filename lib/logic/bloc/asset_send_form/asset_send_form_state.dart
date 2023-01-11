part of 'asset_send_form_bloc.dart';

enum SendCurrencyType {
  crypto,
  fiat,
}

abstract class AssetSendFormState extends Equatable {
  const AssetSendFormState();

  @override
  List<Object?> get props => [];
}

class SendFormInitial extends AssetSendFormState {
  const SendFormInitial();
}

// TODO - rename to SendFormPriceLoaded
class SendFormConverted extends AssetSendFormState {
  final SendCurrencyType currencyType;
  final AssetId assetId;
  final NetworkWallet wallet;
  final BigDecimal cryptoAmount;
  final BigDecimal fiatAmount;
  final BigDecimal price;
  final String address;
  final SendFormValidation validation;

  const SendFormConverted({
    required this.currencyType,
    required this.assetId,
    required this.wallet,
    required this.cryptoAmount,
    required this.fiatAmount,
    required this.price,
    this.address = '',
    this.validation = const SendFormValidation(),
  });

  @override
  List<Object?> get props => [
        currencyType,
        assetId,
        wallet,
        cryptoAmount,
        fiatAmount,
        price,
        address,
        validation,
      ];

  SendFormConverted copyWith({
    SendCurrencyType? currencyType,
    AssetId? assetId,
    NetworkWallet? wallet,
    BigDecimal? cryptoAmount,
    BigDecimal? fiatAmount,
    BigDecimal? price,
    String? address,
    SendFormValidation? validation,
  }) {
    return SendFormConverted(
      currencyType: currencyType ?? this.currencyType,
      assetId: assetId ?? this.assetId,
      wallet: wallet ?? this.wallet,
      cryptoAmount: cryptoAmount ?? this.cryptoAmount,
      fiatAmount: fiatAmount ?? this.fiatAmount,
      price: price ?? this.price,
      address: address ?? this.address,
      validation: validation ?? this.validation,
    );
  }
}

class SendFormValidation extends Equatable {
  final Set<ValidationError> addressValidationErrors;
  final Set<ValidationError> amountValidationErrors;

  const SendFormValidation({
    this.addressValidationErrors = const {},
    this.amountValidationErrors = const {},
  });

  bool get isValid => [
        addressValidationErrors,
        amountValidationErrors,
      ].every((b) => b.isEmpty);

  @override
  List<Object?> get props => [
        addressValidationErrors,
        amountValidationErrors,
      ];

  SendFormValidation copyWith({
    Set<ValidationError>? addressValidationErrors,
    Set<ValidationError>? amountValidationErrors,
  }) {
    return SendFormValidation(
      addressValidationErrors:
          addressValidationErrors ?? this.addressValidationErrors,
      amountValidationErrors:
          amountValidationErrors ?? this.amountValidationErrors,
    );
  }
}
