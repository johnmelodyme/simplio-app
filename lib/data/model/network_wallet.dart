import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto_assets/crypto_assets.dart';

part 'network_wallet.g.dart';

class NetworkWallet extends Equatable {
  static AssetPreset makePreset({
    required int assetId,
    required int networkId,
  }) {
    return Assets.getAssetPreset(
      assetId: assetId,
      networkId: networkId,
    );
  }

  final String uuid;
  final int networkId;
  final String address;
  final BigInt balance;
  final double fiatBalance;
  final bool isEnabled;
  final AssetPreset preset;

  const NetworkWallet({
    required this.uuid,
    required this.networkId,
    required this.address,
    required this.balance,
    required this.fiatBalance,
    required this.isEnabled,
    required this.preset,
  });

  NetworkWallet.builder({
    required int networkId,
    required String address,
    BigInt? balance,
    double? fiatBalance,
    bool isEnabled = true,
    required AssetPreset preset,
  }) : this(
          uuid: const Uuid().v4(),
          networkId: networkId,
          address: address,
          balance: balance ?? BigInt.zero,
          fiatBalance: fiatBalance ?? 0,
          isEnabled: isEnabled,
          preset: preset,
        );

  bool get isToken => preset.contractAddress?.isNotEmpty == true;
  bool get isNotToken => !isToken;

  @override
  List<Object?> get props => [
        uuid,
        networkId,
        address,
        balance,
        fiatBalance,
        isEnabled,
      ];

  NetworkWallet copyWith({
    BigInt? balance,
    double? fiatBalance,
    bool? isEnabled,
  }) {
    return NetworkWallet(
      uuid: uuid,
      networkId: networkId,
      address: address,
      balance: balance ?? this.balance,
      fiatBalance: fiatBalance ?? this.fiatBalance,
      isEnabled: isEnabled ?? this.isEnabled,
      preset: preset,
    );
  }
}

@HiveType(typeId: 5)
class NetworkWalletLocal extends HiveObject {
  @HiveField(0)
  final String uuid;

  @HiveField(1)
  final int networkId;

  @HiveField(2)
  final String address;

  @HiveField(3)
  final BigInt balance;

  @HiveField(4)
  final bool isEnabled;

  @HiveField(5)
  final double fiatBalance;

  NetworkWalletLocal({
    required this.uuid,
    required this.networkId,
    required this.address,
    required this.balance,
    required this.isEnabled,
    required this.fiatBalance,
  });
}
