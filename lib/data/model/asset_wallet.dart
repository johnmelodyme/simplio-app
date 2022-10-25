import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:simplio_app/data/model/network_wallet.dart';
import 'package:uuid/uuid.dart';

part 'asset_wallet.g.dart';

class AssetWallet extends Equatable {
  final String uuid;
  final int assetId;
  final Map<int, NetworkWallet> _wallets;

  const AssetWallet(
    this.uuid,
    this.assetId,
    this._wallets,
  );

  AssetWallet.builder({
    String? uuid,
    required int assetId,
    Map<int, NetworkWallet> wallets = const {},
  }) : this(
          uuid ?? const Uuid().v4(),
          assetId,
          wallets,
        );

  List<NetworkWallet> get wallets => _wallets.values.toList();

  @override
  List<Object?> get props => [
        assetId,
        wallets,
      ];

  NetworkWallet? getWallet(int networkId) {
    return _wallets[networkId];
  }

  AssetWallet addWallet(NetworkWallet wallet) {
    final Map<int, NetworkWallet> m = Map.from(_wallets);
    m[wallet.networkId] = wallet;
    return copyWith(wallets: m);
  }

  bool containsWallet(int networkId) {
    return _wallets.containsKey(networkId);
  }

  AssetWallet updateWalletsFromIterable(Iterable<NetworkWallet> wallets) {
    final Map<int, NetworkWallet> walletsMap =
        wallets.fold({}, (acc, curr) => acc..addAll({curr.networkId: curr}));

    return updateWalletsFrom(walletsMap);
  }

  AssetWallet updateWalletsFrom(Map<int, NetworkWallet> wallets) {
    final Map<int, NetworkWallet> walletsMap = Map.from(_wallets)
      ..updateAll((networkId, networkWallet) {
        final wallet = wallets[networkId] ?? networkWallet;
        return findWallet(wallet.uuid) != null ? wallet : networkWallet;
      });

    return copyWith(wallets: walletsMap);
  }

  AssetWallet updateNetworkWallet(NetworkWallet wallet) {
    final index = wallets.indexOf(wallet);
    List<NetworkWallet> updateWallets = wallets;
    updateWallets[index] = wallet;

    return updateWalletsFromIterable(updateWallets);
  }

  NetworkWallet? findWallet(String uuid) {
    final res = _wallets.values.where((w) => w.uuid == uuid);
    return res.isEmpty ? null : res.first;
  }

  AssetWallet copyWith({
    Map<int, NetworkWallet>? wallets,
  }) {
    return AssetWallet(
      uuid,
      assetId,
      wallets ?? _wallets,
    );
  }
}

@HiveType(typeId: 4)
class AssetWalletLocal extends HiveObject {
  @HiveField(0)
  final String uuid;

  @HiveField(1)
  final int assetId;

  @HiveField(2)
  final List<NetworkWalletLocal> wallets;

  AssetWalletLocal({
    required this.uuid,
    required this.assetId,
    required this.wallets,
  });
}
