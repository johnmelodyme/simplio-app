import 'package:simplio_app/data/model/transaction.dart';

class TransactionRepository {
  Future<List<Transaction>> loadDummyTransactions(
    int offset,
    int pageSize,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    int endIndex = (offset + pageSize) % (_transactionItems.length - 1);
    if (endIndex < offset) {
      endIndex = _transactionItems.length;
    }

    return _transactionItems.sublist(offset, endIndex);
  }

  final List<Transaction> _transactionItems = [
    Transaction(
        name: 'AXS',
        datetime: DateTime.parse('2022-04-27T16:30:00.000Z'),
        transactionType: TransactionType.send,
        transactionStatus: TransactionStatus.processing,
        volume: 1.4,
        price: 21.5),
    Transaction(
        name: 'AXS',
        datetime: DateTime.parse('2022-04-27T16:30:00.000Z'),
        transactionType: TransactionType.receive,
        volume: 12.7601,
        price: 176.45),
    Transaction(
        name: 'GCOIN TO AXS',
        datetime: DateTime.parse('2022-05-27T16:30:00.000Z'),
        transactionType: TransactionType.swap,
        volume: 1393.52,
        price: 176.45),
    Transaction(
        name: 'GCOIN',
        datetime: DateTime.parse('2022-06-25T16:30:00.000Z'),
        transactionType: TransactionType.purchase,
        volume: 1371.25,
        price: 180.5),
    Transaction(
        name: 'SOL',
        datetime: DateTime.parse('2022-06-05T16:30:00.000Z'),
        transactionType: TransactionType.earning,
        transactionStatus: TransactionStatus.earning,
        volume: 2.92845,
        price: 100),
    Transaction(
        name: 'AXS',
        datetime: DateTime.parse('2022-04-27T16:30:00.000Z'),
        transactionType: TransactionType.send,
        transactionStatus: TransactionStatus.processing,
        volume: 1.4,
        price: 21.5),
    Transaction(
        name: 'AXS',
        datetime: DateTime.parse('2022-04-27T16:30:00.000Z'),
        transactionType: TransactionType.receive,
        volume: 12.7601,
        price: 176.45),
    Transaction(
        name: 'GCOIN TO AXS',
        datetime: DateTime.parse('2022-05-27T16:30:00.000Z'),
        transactionType: TransactionType.swap,
        volume: 1393.52,
        price: 176.45),
    Transaction(
        name: 'GCOIN',
        datetime: DateTime.parse('2022-06-25T16:30:00.000Z'),
        transactionType: TransactionType.purchase,
        volume: 1371.25,
        price: 180.5),
    Transaction(
        name: 'SOL',
        datetime: DateTime.parse('2022-06-05T16:30:00.000Z'),
        transactionType: TransactionType.earning,
        transactionStatus: TransactionStatus.earning,
        volume: 2.92845,
        price: 100),
    Transaction(
        name: 'AXS',
        datetime: DateTime.parse('2022-04-27T16:30:00.000Z'),
        transactionType: TransactionType.send,
        transactionStatus: TransactionStatus.processing,
        volume: 1.4,
        price: 21.5),
    Transaction(
        name: 'AXS',
        datetime: DateTime.parse('2022-04-27T16:30:00.000Z'),
        transactionType: TransactionType.receive,
        volume: 12.7601,
        price: 176.45),
    Transaction(
        name: 'GCOIN TO AXS',
        datetime: DateTime.parse('2022-05-27T16:30:00.000Z'),
        transactionType: TransactionType.swap,
        volume: 1393.52,
        price: 176.45),
    Transaction(
        name: 'GCOIN',
        datetime: DateTime.parse('2022-06-25T16:30:00.000Z'),
        transactionType: TransactionType.purchase,
        volume: 1371.25,
        price: 180.5),
    Transaction(
        name: 'SOL',
        datetime: DateTime.parse('2022-06-05T16:30:00.000Z'),
        transactionType: TransactionType.earning,
        transactionStatus: TransactionStatus.earning,
        volume: 2.92845,
        price: 100),
    Transaction(
        name: 'AXS',
        datetime: DateTime.parse('2022-04-27T16:30:00.000Z'),
        transactionType: TransactionType.send,
        transactionStatus: TransactionStatus.processing,
        volume: 1.4,
        price: 21.5),
    Transaction(
        name: 'AXS',
        datetime: DateTime.parse('2022-04-27T16:30:00.000Z'),
        transactionType: TransactionType.receive,
        volume: 12.7601,
        price: 176.45),
    Transaction(
        name: 'GCOIN TO AXS',
        datetime: DateTime.parse('2022-05-27T16:30:00.000Z'),
        transactionType: TransactionType.swap,
        volume: 1393.52,
        price: 176.45),
    Transaction(
        name: 'GCOIN',
        datetime: DateTime.parse('2022-06-25T16:30:00.000Z'),
        transactionType: TransactionType.purchase,
        volume: 1371.25,
        price: 180.5),
    Transaction(
        name: 'SOL',
        datetime: DateTime.parse('2022-06-05T16:30:00.000Z'),
        transactionType: TransactionType.earning,
        transactionStatus: TransactionStatus.earning,
        volume: 2.92845,
        price: 100),
    Transaction(
        name: 'AXS',
        datetime: DateTime.parse('2022-04-27T16:30:00.000Z'),
        transactionType: TransactionType.send,
        transactionStatus: TransactionStatus.processing,
        volume: 1.4,
        price: 21.5),
    Transaction(
        name: 'AXS',
        datetime: DateTime.parse('2022-04-27T16:30:00.000Z'),
        transactionType: TransactionType.receive,
        volume: 12.7601,
        price: 176.45),
    Transaction(
        name: 'GCOIN TO AXS',
        datetime: DateTime.parse('2022-05-27T16:30:00.000Z'),
        transactionType: TransactionType.swap,
        volume: 1393.52,
        price: 176.45),
    Transaction(
        name: 'GCOIN',
        datetime: DateTime.parse('2022-06-25T16:30:00.000Z'),
        transactionType: TransactionType.purchase,
        volume: 1371.25,
        price: 180.5),
    Transaction(
        name: 'SOL',
        datetime: DateTime.parse('2022-06-05T16:30:00.000Z'),
        transactionType: TransactionType.earning,
        transactionStatus: TransactionStatus.earning,
        volume: 2.92845,
        price: 100),
    Transaction(
        name: 'AXS',
        datetime: DateTime.parse('2022-04-27T16:30:00.000Z'),
        transactionType: TransactionType.send,
        transactionStatus: TransactionStatus.processing,
        volume: 1.4,
        price: 21.5),
    Transaction(
        name: 'AXS',
        datetime: DateTime.parse('2022-04-27T16:30:00.000Z'),
        transactionType: TransactionType.receive,
        volume: 12.7601,
        price: 176.45),
    Transaction(
        name: 'GCOIN TO AXS',
        datetime: DateTime.parse('2022-05-27T16:30:00.000Z'),
        transactionType: TransactionType.swap,
        volume: 1393.52,
        price: 176.45),
    Transaction(
        name: 'GCOIN',
        datetime: DateTime.parse('2022-06-25T16:30:00.000Z'),
        transactionType: TransactionType.purchase,
        volume: 1371.25,
        price: 180.5),
    Transaction(
        name: 'SOL',
        datetime: DateTime.parse('2022-06-05T16:30:00.000Z'),
        transactionType: TransactionType.earning,
        transactionStatus: TransactionStatus.earning,
        volume: 2.92845,
        price: 100),
    Transaction(
        name: 'AXS',
        datetime: DateTime.parse('2022-04-27T16:30:00.000Z'),
        transactionType: TransactionType.send,
        transactionStatus: TransactionStatus.processing,
        volume: 1.4,
        price: 21.5),
    Transaction(
        name: 'AXS',
        datetime: DateTime.parse('2022-04-27T16:30:00.000Z'),
        transactionType: TransactionType.receive,
        volume: 12.7601,
        price: 176.45),
    Transaction(
        name: 'GCOIN TO AXS',
        datetime: DateTime.parse('2022-05-27T16:30:00.000Z'),
        transactionType: TransactionType.swap,
        volume: 1393.52,
        price: 176.45),
    Transaction(
        name: 'GCOIN',
        datetime: DateTime.parse('2022-06-25T16:30:00.000Z'),
        transactionType: TransactionType.purchase,
        volume: 1371.25,
        price: 180.5),
    Transaction(
        name: 'SOL',
        datetime: DateTime.parse('2022-06-05T16:30:00.000Z'),
        transactionType: TransactionType.earning,
        transactionStatus: TransactionStatus.earning,
        volume: 2.92845,
        price: 100),
    Transaction(
        name: 'AXS',
        datetime: DateTime.parse('2022-04-27T16:30:00.000Z'),
        transactionType: TransactionType.send,
        transactionStatus: TransactionStatus.processing,
        volume: 1.4,
        price: 21.5),
    Transaction(
        name: 'AXS',
        datetime: DateTime.parse('2022-04-27T16:30:00.000Z'),
        transactionType: TransactionType.receive,
        volume: 12.7601,
        price: 176.45),
    Transaction(
        name: 'GCOIN TO AXS',
        datetime: DateTime.parse('2022-05-27T16:30:00.000Z'),
        transactionType: TransactionType.swap,
        volume: 1393.52,
        price: 176.45),
    Transaction(
        name: 'GCOIN',
        datetime: DateTime.parse('2022-06-25T16:30:00.000Z'),
        transactionType: TransactionType.purchase,
        volume: 1371.25,
        price: 180.5),
    Transaction(
        name: 'SOL',
        datetime: DateTime.parse('2022-06-05T16:30:00.000Z'),
        transactionType: TransactionType.earning,
        transactionStatus: TransactionStatus.earning,
        volume: 2.92845,
        price: 100),
  ];
}
