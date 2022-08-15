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
  final bool isEnabled;

  const NetworkWallet({
    required this.uuid,
    required this.networkId,
    required this.address,
    this.contractAddress,
    required this.balance,
    required this.isEnabled,
  });

  NetworkWallet.builder({
    required int networkId,
    required String address,
    String? contractAddress,
    BigInt? balance,
    bool isEnabled = true,
  }) : this(
          uuid: const Uuid().v4(),
          networkId: networkId,
          address: address,
          contractAddress: contractAddress,
          balance: balance ?? BigInt.zero,
          isEnabled: isEnabled,
        );

  @override
  List<Object?> get props => [
        uuid,
        networkId,
        address,
        contractAddress,
        balance,
        isEnabled,
      ];
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
  final bool isEnabled;

  NetworkWalletLocal({
    required this.uuid,
    required this.networkId,
    required this.address,
    required this.contractAddress,
    required this.balance,
    required this.isEnabled,
  });
}
