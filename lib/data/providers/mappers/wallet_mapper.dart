import 'package:simplio_app/data/models/helpers/lockable.dart';
import 'package:simplio_app/data/models/wallet.dart';
import 'package:simplio_app/data/providers/entities/wallet_entity.dart';
import 'package:simplio_app/data/providers/helpers/mapper.dart';

class AccountWalletMapper extends Mapper<AccountWallet, AccountWalletEntity> {
  final AssetWalletMapper _assetWalletMapper = AssetWalletMapper();

  @override
  AccountWallet mapFrom(AccountWalletEntity entity) {
    return AccountWallet(
      entity.uuid,
      entity.accountId,
      entity.updatedAt,
      LockableMnemonic.locked(
        base64Mnemonic: entity.mnemonic,
        isImported: entity.isImported,
        isBackedUp: entity.isBackedUp,
      ),
      AccountWalletTypes.values[entity.walletType],
      Map.fromEntries(entity.wallets.map(
        (e) => MapEntry(
          e.assetId,
          _assetWalletMapper.mapFrom(e),
        ),
      )),
    );
  }

  @override
  AccountWalletEntity mapTo(AccountWallet data) {
    return AccountWalletEntity(
      uuid: data.uuid,
      accountId: data.accountId,
      updatedAt: data.updatedAt,
      mnemonic: data.mnemonic.toString(),
      isBackedUp: data.mnemonic.isBackedUp,
      isImported: data.mnemonic.isImported,
      walletType: data.walletType.index,
      wallets: data.wallets.map(_assetWalletMapper.mapTo).toList(),
    );
  }
}

class AssetWalletMapper extends Mapper<AssetWallet, AssetWalletEntity> {
  final NetworkWalletMapper _networkWalletMapper = NetworkWalletMapper();

  @override
  AssetWallet mapFrom(AssetWalletEntity entity) {
    return AssetWallet(
      entity.uuid,
      entity.assetId,
      Map.fromEntries(entity.wallets.map(
        (e) => MapEntry(
          e.networkId,
          _networkWalletMapper.mapFrom(e),
        ),
      )),
    );
  }

  @override
  AssetWalletEntity mapTo(AssetWallet data) {
    return AssetWalletEntity(
      uuid: data.uuid,
      assetId: data.assetId,
      wallets: data.wallets.map(_networkWalletMapper.mapTo).toList(),
    );
  }
}

class NetworkWalletMapper extends Mapper<NetworkWallet, NetworkWalletEntity> {
  @override
  NetworkWallet mapFrom(NetworkWalletEntity entity) {
    return NetworkWallet(
      uuid: entity.uuid,
      assetId: entity.assetId,
      networkId: entity.networkId,
      address: entity.address,
      cryptoBalance: entity.cryptoBalance,
      fiatBalance: entity.fiatBalance,
      isEnabled: entity.isEnabled,
      preset: NetworkWallet.makePreset(
        assetId: entity.assetId,
        networkId: entity.networkId,
      ),
    );
  }

  @override
  NetworkWalletEntity mapTo(NetworkWallet data) {
    return NetworkWalletEntity(
      uuid: data.uuid,
      assetId: data.assetId,
      networkId: data.networkId,
      address: data.address,
      cryptoBalance: data.cryptoBalance,
      fiatBalance: data.fiatBalance,
      isEnabled: data.isEnabled,
    );
  }
}
