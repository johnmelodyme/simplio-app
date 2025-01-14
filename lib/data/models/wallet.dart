import 'package:crypto_assets/crypto_assets.dart';
import 'package:equatable/equatable.dart';
import 'package:simplio_app/data/models/helpers/lockable.dart';
import 'package:sio_big_decimal/sio_big_decimal.dart';
import 'package:uuid/uuid.dart';

typedef ID = int;
typedef AssetId = ID;
typedef NetworkId = ID;

abstract class Wallet<T> extends Equatable {
  String get uuid;
  BigDecimal get cryptoBalance;
  BigDecimal get fiatBalance;

  const Wallet();

  @override
  List<Object?> get props => [uuid, cryptoBalance, fiatBalance];

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

mixin WalletsUpdater<T> on WalletOwner<T> {
  Wallet<T> updateWalletsFromIterable(Iterable<T> wallets);
  Wallet<T> updateWalletsFrom(Map<ID, T> wallets);
  Wallet<T> addWallet(T wallet);
}

mixin WalletFiatBalanceCounter<T extends Wallet> on WalletOwner<T> {
  @override
  BigDecimal get fiatBalance {
    return wallets.fold(
      const BigDecimal.zero(),
      (sum, wallet) => sum + wallet.fiatBalance,
    );
  }
}

class AccountWallet extends Wallet<AssetWallet>
    with WalletOwner, WalletGetter, WalletsUpdater, WalletFiatBalanceCounter {
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
  BigDecimal get cryptoBalance => const BigDecimal.zero();

  @override
  BigDecimal get fiatBalance {
    return wallets.fold(
      const BigDecimal.zero(),
      (sum, wallet) => sum + wallet.fiatBalance,
    );
  }

  @override
  List<Object?> get props => [
        uuid,
        cryptoBalance,
        fiatBalance,
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

    return copyWith(wallets: walletsMap);
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
    with WalletOwner, WalletGetter, WalletsUpdater {
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
  BigDecimal get cryptoBalance {
    return _wallets.values.fold(
      const BigDecimal.zero(),
      (acc, curr) => acc + curr.cryptoBalance,
    );
  }

  @override
  BigDecimal get fiatBalance {
    return _wallets.values.fold(
      const BigDecimal.zero(),
      (acc, curr) => acc + curr.fiatBalance,
    );
  }

  @override
  List<Object?> get props => [
        uuid,
        cryptoBalance,
        fiatBalance,
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
  final String walletAddress;
  @override
  final BigDecimal cryptoBalance;
  @override
  final BigDecimal fiatBalance;
  final bool isEnabled;
  final AssetPreset preset;

  const NetworkWallet({
    required this.uuid,
    required this.assetId,
    required this.networkId,
    required this.walletAddress,
    required this.cryptoBalance,
    required this.fiatBalance,
    required this.isEnabled,
    required this.preset,
  });

  NetworkWallet.builder({
    required AssetId assetId,
    required NetworkId networkId,
    required String walletAddress,
    BigDecimal? cryptoBalance,
    BigDecimal? fiatBalance,
    bool isEnabled = true,
    required AssetPreset preset,
  }) : this(
          uuid: const Uuid().v4(),
          assetId: assetId,
          networkId: networkId,
          walletAddress: walletAddress,
          cryptoBalance: cryptoBalance ?? const BigDecimal.zero(),
          fiatBalance: fiatBalance ?? const BigDecimal.zero(),
          isEnabled: isEnabled,
          preset: preset,
        );

  bool get isToken => preset.contractAddress?.isNotEmpty == true;
  bool get isNotToken => !isToken;

  @override
  List<Object?> get props => [
        uuid,
        assetId,
        networkId,
        cryptoBalance,
        walletAddress,
        fiatBalance,
        isEnabled,
      ];

  @override
  NetworkWallet copyWith({
    BigDecimal? cryptoBalance,
    BigDecimal? fiatBalance,
    bool? isEnabled,
  }) {
    return NetworkWallet(
      uuid: uuid,
      assetId: assetId,
      networkId: networkId,
      walletAddress: walletAddress,
      cryptoBalance: cryptoBalance ?? this.cryptoBalance,
      fiatBalance: fiatBalance ?? this.fiatBalance,
      isEnabled: isEnabled ?? this.isEnabled,
      preset: preset,
    );
  }
}
