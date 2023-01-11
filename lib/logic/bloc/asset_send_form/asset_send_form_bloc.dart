import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/model/helpers/big_decimal.dart';
import 'package:simplio_app/data/model/wallet.dart';
import 'package:simplio_app/data/repositories/wallet_repository.dart';
import 'package:simplio_app/logic/errors/validation_error.dart';
import 'package:simplio_app/logic/mixins/bigdecimal_value_updater_mixin.dart';
import 'package:simplio_app/view/widgets/keypad.dart';

part 'asset_send_form_event.dart';
part 'asset_send_form_state.dart';

class AssetSendFormBloc extends Bloc<AssetSendFormEvent, AssetSendFormState>
    with BigDecimalValueUpdaterMixin {
  AssetSendFormBloc({
    required WalletRepository walletRepository,
  }) : this._();

  AssetSendFormBloc._() : super(const SendFormInitial()) {
    on<PriceLoaded>(_onPriceLoaded);
    on<ValueUpdated>(_onValueUpdated);
    on<ValueSwitched>(_onValueSwitched);
    on<AddressUpdated>(_onAddressUpdated);
    on<MaxValueRequested>(_onMaxValueRequested);
  }

  void _onPriceLoaded(
    PriceLoaded event,
    Emitter<AssetSendFormState> emit,
  ) {
    // TODO - calculate price from cryptoBalance and fiatBalance.
    // TODO - if wallet does not have any balance emit error state.
    emit(SendFormConverted(
      currencyType: SendCurrencyType.crypto,
      assetId: event.assetId,
      wallet: event.wallet,
      cryptoAmount: const BigDecimal.zero(),
      fiatAmount: const BigDecimal.zero(),
      price: const BigDecimal.zero(),
      validation: SendFormValidation(
          amountValidationErrors: _validateAmount(
            const BigDecimal.zero(),
            wallet: event.wallet,
          ),
          addressValidationErrors: _validateAddress(
            '',
            wallet: event.wallet,
          )),
    ));
  }

  void _onValueSwitched(
    ValueSwitched event,
    Emitter<AssetSendFormState> emit,
  ) {
    final s = state;
    if (s is! SendFormConverted) return;

    final currencyType = s.currencyType == SendCurrencyType.crypto
        ? SendCurrencyType.fiat
        : SendCurrencyType.crypto;

    emit(s.copyWith(
      currencyType: currencyType,
    ));
  }

  void _onValueUpdated(
    ValueUpdated event,
    Emitter<AssetSendFormState> emit,
  ) {
    final s = state;
    if (s is! SendFormConverted) return;

    if (s.currencyType == SendCurrencyType.crypto) {
      return _updateCryptoValue(s, event, emit);
    }

    return _updateFiatValue(s, event, emit);
  }

  Set<ValidationError> _validateAmount(
    BigDecimal amount, {
    required NetworkWallet wallet,
  }) {
    return {
      if (amount.isZero)
        const ValidationError(
          code: ValidationErrorCodes.insufficientValue,
          message: 'Invalid amount',
        ),
      if (amount.toBigInt() > wallet.balance)
        const ValidationError(
          code: ValidationErrorCodes.invalidValue,
          message: 'Invalid amount',
        ),
    };
  }

  void _updateCryptoValue(
    SendFormConverted s,
    ValueUpdated event,
    Emitter<AssetSendFormState> emit,
  ) {
    final cryptoAmount = updateBigDecimalValue(
      s.cryptoAmount,
      modifier: event.value,
    );
    final fiatAmount = cryptoAmount * s.price;

    emit(s.copyWith(
      cryptoAmount: cryptoAmount,
      fiatAmount: fiatAmount,
      validation: s.validation.copyWith(
        amountValidationErrors: _validateAmount(
          cryptoAmount,
          wallet: s.wallet,
        ),
      ),
    ));
  }

  void _updateFiatValue(
    SendFormConverted s,
    ValueUpdated event,
    Emitter<AssetSendFormState> emit,
  ) {
    final fiatAmount = updateBigDecimalValue(
      s.fiatAmount,
      modifier: event.value,
    );
    final cryptoAmount = fiatAmount / s.price;

    emit(s.copyWith(
      cryptoAmount: cryptoAmount,
      fiatAmount: fiatAmount,
      validation: s.validation.copyWith(
        amountValidationErrors: _validateAmount(
          cryptoAmount,
          wallet: s.wallet,
        ),
      ),
    ));
  }

  // TODO - this could be also a validator mixin. Think if it'd be reused.
  Set<ValidationError> _validateAddress(
    String address, {
    required NetworkWallet wallet,
  }) {
    final isValid = WalletRepository.validateAddress(
      address,
      networkId: wallet.networkId,
    );

    return {
      if (address.isEmpty)
        const ValidationError(
          code: ValidationErrorCodes.insufficientValue,
          message: 'Invalid address',
        ),
      if (!isValid)
        const ValidationError(
          code: ValidationErrorCodes.invalidFormat,
          message: 'Invalid address',
        ),
    };
  }

  void _onAddressUpdated(
    AddressUpdated event,
    Emitter<AssetSendFormState> emit,
  ) {
    final s = state;
    if (s is! SendFormConverted) return;

    final address = event.address?.trim() ?? '';

    emit(s.copyWith(
      address: address,
      validation: s.validation.copyWith(
        addressValidationErrors: _validateAddress(
          address,
          wallet: s.wallet,
        ),
      ),
    ));
  }

  void _onMaxValueRequested(
    MaxValueRequested event,
    Emitter<AssetSendFormState> emit,
  ) {
    final s = state;
    if (s is! SendFormConverted) return;

    final cryptoAmount = BigDecimal.fromBigInt(s.wallet.balance);
    final fiatAmount = cryptoAmount * s.price;

    emit(s.copyWith(
      cryptoAmount: cryptoAmount,
      fiatAmount: fiatAmount,
      validation: s.validation.copyWith(
        amountValidationErrors: _validateAmount(
          cryptoAmount,
          wallet: s.wallet,
        ),
      ),
    ));
  }
}
