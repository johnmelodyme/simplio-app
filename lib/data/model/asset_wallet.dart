import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:simplio_app/data/model/network_wallet.dart';
import 'package:uuid/uuid.dart';

part 'asset_wallet.g.dart';

class AssetWallet extends Equatable {
  final String uuid;
  final int assetId;
  final bool isEnabled;
  final Map<int, NetworkWallet> _wallets;

  const AssetWallet(
    this.uuid,
    this.assetId,
    this.isEnabled,
    this._wallets,
  );

  AssetWallet.builder({
    String? uuid,
    required int assetId,
    bool isEnabled = true,
    Map<int, NetworkWallet> wallets = const {},
  }) : this(
          uuid ?? const Uuid().v4(),
          assetId,
          isEnabled,
          wallets,
        );

  List<NetworkWallet> get wallets => _wallets.values.toList();

  @override
  List<Object?> get props => [
        assetId,
        isEnabled,
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

  AssetWallet copyWith({
    bool? isEnabled,
    Map<int, NetworkWallet>? wallets,
  }) {
    return AssetWallet(
      uuid,
      assetId,
      isEnabled ?? this.isEnabled,
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
  final bool isEnabled;

  @HiveField(3)
  final List<NetworkWalletLocal> wallets;

  AssetWalletLocal({
    required this.uuid,
    required this.assetId,
    required this.isEnabled,
    required this.wallets,
  });
}
