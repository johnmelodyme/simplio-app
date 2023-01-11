import 'package:simplio_app/data/model/wallet.dart';
import 'package:simplio_app/data/repositories/wallet_repository.dart';

mixin NetworkWalletAddressValidatorMixin {
  bool Function(String) validateAddress({
    required NetworkId networkId,
  }) {
    return (String address) => WalletRepository.validateAddress(
          address,
          networkId: networkId,
        );
  }
}
