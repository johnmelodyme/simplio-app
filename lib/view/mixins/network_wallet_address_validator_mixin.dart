import 'package:simplio_app/data/models/wallet.dart';
import 'package:simplio_app/data/repositories/hd_wallet_repository.dart';

mixin NetworkWalletAddressValidatorMixin {
  bool Function(String) validateAddress({
    required NetworkId networkId,
  }) {
    return (String address) => HDWalletRepository.validateAddress(
          address,
          networkId: networkId,
        );
  }
}
