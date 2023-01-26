part of 'account_wallet_cubit.dart';

abstract class AccountWalletState extends Equatable {
  const AccountWalletState();

  @override
  List<Object?> get props => [];
}

class AccountWalletInitial extends AccountWalletState {
  const AccountWalletInitial();
}

class AccountWalletLoading extends AccountWalletState {
  const AccountWalletLoading();
}

abstract class AccountWalletProvided extends AccountWalletState {
  final AccountWallet wallet;
  final AccountWalletInventory accountWalletInventory;
  final Map<String, NetworkWalletInventory> networkWalletInventories;

  const AccountWalletProvided({
    required this.wallet,
    this.accountWalletInventory = const AccountWalletInventory(),
    this.networkWalletInventories = const {},
  }) : super();

  @override
  List<Object?> get props => [
        wallet,
        accountWalletInventory,
        networkWalletInventories,
      ];
}

class AccountWalletLoaded extends AccountWalletProvided {
  const AccountWalletLoaded({
    required super.wallet,
    super.accountWalletInventory,
    super.networkWalletInventories,
  });
}

class AccountWalletLoadedWithError extends AccountWalletState {
  final BaseError error;
  const AccountWalletLoadedWithError(this.error);

  @override
  List<Object?> get props => [error];
}

class AccountWalletUpdated extends AccountWalletProvided {
  const AccountWalletUpdated({
    required super.wallet,
    super.accountWalletInventory,
    super.networkWalletInventories,
  });
}

class AccountWalletUpdatedWithError extends AccountWalletProvided {
  final BaseError error;

  const AccountWalletUpdatedWithError(
    this.error, {
    required super.wallet,
  });

  @override
  List<Object?> get props => [wallet, error];
}

class NetworkWalletInventory extends Equatable {
  final AssetId assetId;
  final NetworkId networkId;
  final DateTime updatedAt;
  final List<List<BroadcastTransaction>> transactions;

  const NetworkWalletInventory({
    required this.assetId,
    required this.networkId,
    required this.updatedAt,
    required this.transactions,
  });

  @override
  List<Object?> get props => [
        assetId,
        networkId,
        updatedAt,
        transactions,
      ];
}

class AccountWalletInventory extends Equatable {
  // TODO - implement data type for nfts when they are ready.
  final List<String> nfts;
  final List<List<BroadcastTransaction>> transactions;

  const AccountWalletInventory({
    this.nfts = const [],
    this.transactions = const [],
  });

  @override
  List<Object?> get props => [nfts, transactions];

  AccountWalletInventory addAccountInventoryTransactions(
    List<BroadcastTransaction> transactions,
  ) {
    return this;
  }

  // TODO - implement copyWith
  // TODO - when object is copied reduce the ivnentory data to only first list of transactions to keep the object slim.
  // AccountWalletInventory copyWith(
  //   List<String>? nfts,
  //   List<BroadcastTransaction>? transactions,
  // ) {
  //   return AccountWalletInventory(
  //     nfts: nfts ?? this.nfts,
  //     transactions: [transactions] ?? this.transactions.,
  //   );
  // }
}
