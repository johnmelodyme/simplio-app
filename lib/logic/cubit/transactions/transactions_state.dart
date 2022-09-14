part of 'transactions_cubit.dart';

abstract class TransactionsState extends Equatable {
  const TransactionsState();
}

class TransactionsInitialState extends TransactionsState {
  @override
  List<Object?> get props => [];
}

class TransactionsLoadingState extends TransactionsState {
  @override
  List<Object?> get props => [];
}

class TransactionsLoadedState extends TransactionsState {
  const TransactionsLoadedState();
  @override
  List<Object?> get props => [];
}

class TransactionsErrorState extends TransactionsState {
  final String errorMessage;

  const TransactionsErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
