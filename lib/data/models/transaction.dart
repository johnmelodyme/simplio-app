import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:simplio_app/data/models/wallet.dart';
import 'package:sio_big_decimal/sio_big_decimal.dart';

// TODO - remove generic transaction and replace with domain specific transaction.
class Transaction {
  final String name;
  final DateTime datetime;
  final double volume;
  final double price;
  final TransactionType transactionType;
  final TransactionStatus? transactionStatus;

  Transaction({
    required this.name,
    required this.datetime,
    required this.volume,
    required this.price,
    required this.transactionType,
    this.transactionStatus,
  });
}

enum TransactionType {
  unknown,
  send,
  receive,
  swap,
  purchase,
  earning;

  static TransactionType getType(String value) {
    return values.firstWhereOrNull((s) => s.name == value) ?? unknown;
  }
}

enum TransactionStatus {
  unknown,
  processing,
  earning;

  static TransactionStatus getStatus(String value) {
    return values.firstWhereOrNull((s) => s.name == value) ?? unknown;
  }
}

class AssetTransaction extends Equatable {
  final int assetId;
  final int networkId;
  final String status;
  final String assetName;
  final String txType;
  final DateTime createdAt;
  final BigDecimal cryptoAmount;
  final BigDecimal fiatAmount;

  const AssetTransaction({
    required this.assetId,
    required this.networkId,
    required this.status,
    required this.assetName,
    required this.txType,
    required this.createdAt,
    required this.cryptoAmount,
    required this.fiatAmount,
  });

  @override
  List<Object?> get props => [
        assetId,
        networkId,
        status,
        assetName,
        txType,
        createdAt,
        cryptoAmount,
        fiatAmount,
      ];
}

class BroadcastTransaction {
  final NetworkId networkId;
  final BigInt networkFee;
  String rawTx;

  BroadcastTransaction({
    required this.networkId,
    required this.networkFee,
    required this.rawTx,
  });
}
