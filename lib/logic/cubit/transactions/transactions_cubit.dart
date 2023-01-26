import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:simplio_app/data/models/transaction.dart';
import 'package:simplio_app/data/repositories/transaction_repository.dart';
import 'package:simplio_app/view/themes/constants.dart';

part 'transactions_state.dart';

// TODO - remove this cubit as it belongs to account wallet cubit.
class TransactionsCubit extends Cubit<TransactionsState> {
  final TransactionRepository _transactionRepository;
  final PagingController<int, Transaction> pagingController =
      PagingController(firstPageKey: 0);

  TransactionsCubit._(
    this._transactionRepository,
  ) : super(TransactionsInitialState());

  TransactionsCubit.builder({
    required TransactionRepository transactionRepository,
  }) : this._(transactionRepository);

  void reloadTransactions() {
    _emitSafely(TransactionsLoadingState());
    pagingController.refresh();
    _emitSafely(TransactionsInitialState());
  }

  void loadTransactions(int offset) async {
    _emitSafely(TransactionsLoadingState());

    try {
      List<Transaction> transactions = await _transactionRepository
          .loadDummyTransactions(offset, Constants.pageSizeTransactions);

      if (transactions.length < Constants.pageSizeTransactions) {
        pagingController.appendLastPage(transactions);
      } else {
        pagingController.appendPage(transactions, offset + transactions.length);
      }

      _emitSafely(const TransactionsLoadedState());
    } catch (exception) {
      pagingController.error = exception.toString();
      _emitSafely(TransactionsErrorState(exception.toString()));
    }
  }

  void _emitSafely(TransactionsState transactionsState) {
    if (!isClosed) {
      emit(transactionsState);
    }
  }
}
