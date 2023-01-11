part of 'asset_send_form_bloc.dart';

abstract class AssetSendFormEvent extends Equatable {
  const AssetSendFormEvent();

  @override
  List<Object?> get props => [];
}

// TODO - rename to SendFormLoaded or something like that.
class PriceLoaded extends AssetSendFormEvent {
  final AssetId assetId;
  final NetworkWallet wallet;

  const PriceLoaded({
    required this.assetId,
    required this.wallet,
  });

  @override
  List<Object?> get props => [assetId, wallet];
}

class ValueUpdated extends AssetSendFormEvent {
  final NumpadValue value;

  const ValueUpdated(this.value);

  @override
  List<Object?> get props => [value];
}

class ValueSwitched extends AssetSendFormEvent {
  final SendCurrencyType currencyType;

  const ValueSwitched({
    required this.currencyType,
  });

  @override
  List<Object?> get props => [currencyType];
}

class AddressUpdated extends AssetSendFormEvent {
  final String? address;
  final NetworkId networkId;

  const AddressUpdated({
    this.address,
    required this.networkId,
  });

  @override
  List<Object?> get props => [address, networkId];
}

class MaxValueRequested extends AssetSendFormEvent {
  const MaxValueRequested();
}
