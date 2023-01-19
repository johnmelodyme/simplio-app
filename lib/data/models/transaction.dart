// TODO - add a context. is that an asset transaction or a nft transaction?
class Transaction {
  final String name;
  // TODO - should this be a createdAt, updatedAt or timeStamp?
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

enum TransactionType { send, receive, swap, purchase, earning }

enum TransactionStatus { processing, earning }
