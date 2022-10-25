import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'network_wallet.g.dart';

class NetworkWallet extends Equatable {
  final String uuid;
  final int networkId;
  final String address;
  final String? contractAddress;
  final BigInt balance;
  final double fiatBalance;
  final int decimalPlaces;
  final bool isEnabled;

  const NetworkWallet({
    required this.uuid,
    required this.networkId,
    required this.address,
    required this.contractAddress,
    required this.balance,
    required this.fiatBalance,
    required this.decimalPlaces,
    required this.isEnabled,
  });

  NetworkWallet.builder({
    required int networkId,
    required String address,
    String? contractAddress,
    BigInt? balance,
    double? fiatBalance,
    required int decimalPlaces,
    bool isEnabled = true,
  }) : this(
          uuid: const Uuid().v4(),
          networkId: networkId,
          address: address,
          contractAddress: contractAddress,
          balance: balance ?? BigInt.zero,
          fiatBalance: fiatBalance ?? 0,
          decimalPlaces: decimalPlaces,
          isEnabled: isEnabled,
        );

  bool get isToken => contractAddress?.isNotEmpty == true;
  bool get isNotToken => !isToken;

  @override
  List<Object?> get props => [
        uuid,
        networkId,
        address,
        contractAddress,
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
      contractAddress: contractAddress,
      balance: balance ?? this.balance,
      fiatBalance: fiatBalance ?? this.fiatBalance,
      decimalPlaces: decimalPlaces,
      isEnabled: isEnabled ?? this.isEnabled,
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
  final String? contractAddress;

  @HiveField(4)
  final BigInt balance;

  @HiveField(5)
  final int decimalPlaces;

  @HiveField(6)
  final bool isEnabled;

  @HiveField(7)
  final double fiatBalance;

  NetworkWalletLocal({
    required this.uuid,
    required this.networkId,
    required this.address,
    required this.contractAddress,
    required this.balance,
    required this.decimalPlaces,
    required this.isEnabled,
    required this.fiatBalance,
  });
}
