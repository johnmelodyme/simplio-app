import 'package:simplio_app/data/models/helpers/lockable.dart';
import 'package:simplio_app/data/models/wallet.dart';
import 'package:simplio_app/data/providers/entities/wallet_entity.dart';
import 'package:sio_big_decimal/sio_big_decimal.dart';

extension AccountWalletMapperExtension on AccountWallet {
  AccountWalletEntity toEntity() {
    return AccountWalletEntity(
      uuid: uuid,
      accountId: accountId,
      updatedAt: updatedAt,
      mnemonic: mnemonic.toString(),
      isBackedUp: mnemonic.isBackedUp,
      isImported: mnemonic.isImported,
      walletType: walletType.index,
      wallets: wallets.map((a) => a.toEntity()).toList(),
    );
  }
}

extension AssetWalletMapperExtension on AssetWallet {
  AssetWalletEntity toEntity() {
    return AssetWalletEntity(
      uuid: uuid,
      assetId: assetId,
      wallets: wallets.map((n) => n.toEntity()).toList(),
    );
  }
}

extension NetworkWalletMapperExtension on NetworkWallet {
  NetworkWalletEntity toEntity() {
    return NetworkWalletEntity(
      uuid: uuid,
      assetId: assetId,
      networkId: networkId,
      walletAddress: walletAddress,
      cryptoBalance: cryptoBalance.toBigInt(),
      fiatBalance: fiatBalance.toBigInt(),
      isEnabled: isEnabled,
    );
  }
}

extension AccountWalletEntityMapperExtension on AccountWalletEntity {
  AccountWallet toModel() {
    return AccountWallet(
      uuid,
      accountId,
      updatedAt,
      LockableMnemonic.locked(
        base64Mnemonic: mnemonic,
        isImported: isImported,
        isBackedUp: isBackedUp,
      ),
      AccountWalletTypes.values[walletType],
      Map.fromEntries(wallets.map(
        (e) => MapEntry(
          e.assetId,
          e.toModel(),
        ),
      )),
    );
  }
}

extension AssetWalletEntityMapperExtension on AssetWalletEntity {
  AssetWallet toModel() {
    return AssetWallet(
      uuid,
      assetId,
      Map.fromEntries(wallets.map(
        (e) => MapEntry(
          e.networkId,
          e.toModel(),
        ),
      )),
    );
  }
}

extension NetworkWalletEntityMapperExtension on NetworkWalletEntity {
  NetworkWallet toModel() {
    final preset = NetworkWallet.makePreset(
      assetId: assetId,
      networkId: networkId,
    );

    return NetworkWallet(
      uuid: uuid,
      assetId: assetId,
      networkId: networkId,
      walletAddress: walletAddress,
      cryptoBalance: BigDecimal.fromBigInt(
        cryptoBalance,
        precision: preset.decimalPlaces,
      ),
      fiatBalance: BigDecimal.fromBigInt(
        fiatBalance,
        precision: preset.decimalPlaces,
      ),
      isEnabled: isEnabled,
      preset: preset,
    );
  }
}
