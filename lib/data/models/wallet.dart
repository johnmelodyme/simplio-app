import 'package:crypto_assets/crypto_assets.dart';
import 'package:equatable/equatable.dart';
import 'package:simplio_app/data/models/helpers/lockable.dart';
import 'package:uuid/uuid.dart';

typedef ID = int;
typedef AssetId = ID;
typedef NetworkId = ID;

const accountWalletUpdateLifetimeInSeconds = 180;

abstract class Wallet<T> extends Equatable {
  String get uuid;
  BigInt get cryptoBalance;
  // TOOD - add fait balance.
  // double get fiatBalance;

  const Wallet();

  @override
  List<Object?> get props => [uuid, cryptoBalance];

  Wallet<T> copyWith();
}

mixin WalletOwner<T> on Wallet<T> {
  List<T> get wallets;
}

mixin WalletGetter<T> on WalletOwner<T> {
  T? getWallet(int address);
  T? findWallet(String uuid);
  bool containsWallet(ID address);
}

mixin WalletsUpdated<T> on WalletOwner<T> {
  Wallet<T> updateWalletsFromIterable(Iterable<T> wallets);
  Wallet<T> updateWalletsFrom(Map<ID, T> wallets);
  Wallet<T> addWallet(T wallet);
}

class AccountWallet extends Wallet<AssetWallet>
    with WalletOwner, WalletGetter, WalletsUpdated {
  static String makeUUID(String address) {
    return const Uuid().v5(
      Uuid.NAMESPACE_URL,
      'https://mnemonic.simplio.io/$address',
    );
  }

  @override
  final String uuid;
  final String accountId;
  final DateTime updatedAt;
  final LockableMnemonic mnemonic;
  final AccountWalletTypes walletType;
  final Map<int, AssetWallet> _wallets;

  const AccountWallet(
    this.uuid,
    this.accountId,
    this.updatedAt,
    this.mnemonic,
    this.walletType,
    this._wallets,
  );

  AccountWallet.hd({
    required String uuid,
    required String accountId,
    DateTime? updatedAt,
    String? name,
    required LockableMnemonic mnemonic,
    Map<int, AssetWallet>? wallets,
  }) : this(
          uuid,
          accountId,
          updatedAt ?? DateTime.now(),
          mnemonic,
          AccountWalletTypes.hdWallet,
          wallets ?? const {},
        );

  @override
  List<AssetWallet> get wallets => _wallets.values.toList();
  List<AssetWallet> get enabled {
    return _wallets.values.where((w) => w.enabled.isNotEmpty).toList();
  }

  @override
  BigInt get cryptoBalance => BigInt.zero;

  @override
  List<Object?> get props => [
        uuid,
        cryptoBalance,
        accountId,
        updatedAt,
        walletType,
        wallets,
      ];

  @override
  AssetWallet? getWallet(AssetId assetId) {
    return _wallets[assetId];
  }

  @override
  AccountWallet addWallet(AssetWallet wallet) {
    final Map<AssetId, AssetWallet> m = Map.from(_wallets);
    m[wallet.assetId] = wallet;
    return copyWith(wallets: m);
  }

  @override
  bool containsWallet(AssetId assetId) {
    return _wallets.containsKey(assetId);
  }

  @override
  AccountWallet updateWalletsFromIterable(Iterable<AssetWallet> wallets) {
    final Map<AssetId, AssetWallet> walletsMap =
        wallets.fold({}, (acc, curr) => acc..addAll({curr.assetId: curr}));

    return updateWalletsFrom(walletsMap);
  }

  @override
  AccountWallet updateWalletsFrom(Map<AssetId, AssetWallet> wallets) {
    final Map<AssetId, AssetWallet> walletsMap = Map.from(_wallets)
      ..updateAll((assetId, assetWallet) {
        final wallet = wallets[assetId] ?? assetWallet;
        return findWallet(wallet.uuid) != null ? wallet : assetWallet;
      });

    return copyWith(wallets: walletsMap, updatedAt: DateTime.now());
  }

  @override
  AssetWallet? findWallet(String uuid) {
    final res = _wallets.values.where((w) => w.uuid == uuid);
    return res.isEmpty ? null : res.first;
  }

  // todo: refactor the method - move the logic into AssetWallet
  bool isNetworkWalletEnabled({required int assetId, required int networkId}) {
    final wallet = getWallet(assetId);
    if (wallet == null) return false;

    final networkWallet = wallet.getWallet(networkId);
    if (networkWallet == null) return false;

    return networkWallet.isEnabled;
  }

  bool get isNotValid => !isValid;

  bool get isValid {
    final expiresAt = updatedAt.millisecondsSinceEpoch +
        (accountWalletUpdateLifetimeInSeconds * 1000);

    return DateTime.now().millisecondsSinceEpoch <= expiresAt;
  }

  @override
  AccountWallet copyWith({
    DateTime? updatedAt,
    LockableMnemonic? mnemonic,
    Map<AssetId, AssetWallet>? wallets,
  }) {
    return AccountWallet(
      uuid,
      accountId,
      updatedAt ?? this.updatedAt,
      mnemonic ?? this.mnemonic,
      walletType,
      wallets ?? _wallets,
    );
  }
}

enum AccountWalletTypes {
  hdWallet,
}

class AssetWallet extends Wallet<NetworkWallet>
    with WalletOwner, WalletGetter, WalletsUpdated {
  @override
  final String uuid;
  final AssetId assetId;
  final Map<NetworkId, NetworkWallet> _wallets;

  const AssetWallet(
    this.uuid,
    this.assetId,
    this._wallets,
  );

  AssetWallet.builder({
    String? uuid,
    required AssetId assetId,
    Map<NetworkId, NetworkWallet> wallets = const {},
  }) : this(
          uuid ?? const Uuid().v4(),
          assetId,
          wallets,
        );

  @override
  List<NetworkWallet> get wallets => _wallets.values.toList();
  List<NetworkWallet> get enabled {
    return _wallets.values.where((w) => w.isEnabled).toList();
  }

  @override
  BigInt get cryptoBalance => BigInt.zero;

  @override
  List<Object?> get props => [
        uuid,
        cryptoBalance,
        assetId,
        wallets,
      ];

  @override
  NetworkWallet? getWallet(NetworkId networkId) {
    return _wallets[networkId];
  }

  @override
  AssetWallet addWallet(NetworkWallet wallet) {
    final Map<NetworkId, NetworkWallet> m = Map.from(_wallets);
    m[wallet.networkId] = wallet;
    return copyWith(wallets: m);
  }

  @override
  bool containsWallet(NetworkId networkId) {
    return _wallets.containsKey(networkId);
  }

  @override
  AssetWallet updateWalletsFromIterable(Iterable<NetworkWallet> wallets) {
    final Map<NetworkId, NetworkWallet> walletsMap =
        wallets.fold({}, (acc, curr) => acc..addAll({curr.networkId: curr}));

    return updateWalletsFrom(walletsMap);
  }

  @override
  AssetWallet updateWalletsFrom(Map<NetworkId, NetworkWallet> wallets) {
    final Map<NetworkId, NetworkWallet> walletsMap = Map.from(_wallets)
      ..updateAll((networkId, networkWallet) {
        final wallet = wallets[networkId] ?? networkWallet;
        return findWallet(wallet.uuid) != null ? wallet : networkWallet;
      });

    return copyWith(wallets: walletsMap);
  }

  @override
  NetworkWallet? findWallet(String uuid) {
    final res = _wallets.values.where((w) => w.uuid == uuid);
    return res.isEmpty ? null : res.first;
  }

  @override
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

class NetworkWallet extends Wallet<Object> {
  static AssetPreset makePreset({
    required AssetId assetId,
    required NetworkId networkId,
  }) {
    return Assets.getAssetPreset(
      assetId: assetId,
      networkId: networkId,
    );
  }

  @override
  final String uuid;
  final AssetId assetId;
  final NetworkId networkId;
  final String address;
  @override
  final BigInt cryptoBalance;
  final double fiatBalance;
  final bool isEnabled;
  final AssetPreset preset;

  const NetworkWallet({
    required this.uuid,
    required this.assetId,
    required this.networkId,
    required this.address,
    required this.cryptoBalance,
    required this.fiatBalance,
    required this.isEnabled,
    required this.preset,
  });

  NetworkWallet.builder({
    required AssetId assetId,
    required NetworkId networkId,
    required String address,
    BigInt? balance,
    double? fiatBalance,
    bool isEnabled = true,
    required AssetPreset preset,
  }) : this(
          uuid: const Uuid().v4(),
          assetId: assetId,
          networkId: networkId,
          address: address,
          cryptoBalance: balance ?? BigInt.zero,
          fiatBalance: fiatBalance ?? 0,
          isEnabled: isEnabled,
          preset: preset,
        );

  bool get isToken => preset.contractAddress?.isNotEmpty == true;
  bool get isNotToken => !isToken;

  // TODO - get price in BigDecimal
  double get price =>
      fiatBalance /
      (cryptoBalance.toDouble() /
          BigInt.from(10).pow(preset.decimalPlaces).toDouble());

  @override
  List<Object?> get props => [
        uuid,
        assetId,
        networkId,
        cryptoBalance,
        address,
        fiatBalance,
        isEnabled,
      ];

  @override
  NetworkWallet copyWith({
    BigInt? cryptoBalance,
    double? fiatBalance,
    bool? isEnabled,
  }) {
    return NetworkWallet(
      uuid: uuid,
      assetId: assetId,
      networkId: networkId,
      address: address,
      cryptoBalance: cryptoBalance ?? this.cryptoBalance,
      fiatBalance: fiatBalance ?? this.fiatBalance,
      isEnabled: isEnabled ?? this.isEnabled,
      preset: preset,
    );
  }
}
