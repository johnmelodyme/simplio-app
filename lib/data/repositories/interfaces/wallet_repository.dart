import 'package:simplio_app/data/models/transaction.dart';
import 'package:simplio_app/data/models/wallet.dart';

abstract class WalletRepository
    implements
        AccountWalletLoader,
        AccountWalletAdderRemover,
        MnemonicGetter,
        NetworkWalletEnablerDisabler,
        NetworkWalletAddressGetter,
        WalletInventoryUpdater,
        BalanceUpdater,
        TransactionSigner,
        MessageSigner,
        TransactionBroadcaster {
  const WalletRepository();
}

abstract class AccountWalletLoader {
  Future<AccountWallet> loadAccountWallet(
    String accountId, {
    required String key,
  });
}

abstract class AccountWalletAdderRemover {
  Future<AccountWallet> addAccountWallet(
    String accountId, {
    required key,
    String? name,
    String? mnemonic,
  });

  Future<AccountWallet> importAccountWallet(
    String accountId, {
    required key,
    String? name,
    required String mnemonic,
  });

  Future<void> removeAccountWallet(
    String accountId,
  );
}

abstract class NetworkWalletEnablerDisabler {
  Future<AccountWallet> enableNetworkWallet(
    AccountWallet accountWallet, {
    required int assetId,
    required NetworkId networkId,
  });

  Future<AccountWallet> disableNetworkWallet(
    AccountWallet accountWallet, {
    required int assetId,
    required NetworkId networkId,
  });
}

abstract class MnemonicGetter {
  String getMnemonic(
    AccountWallet accountWallet, {
    required String key,
  });
}

abstract class NetworkWalletAddressGetter {
  String getCoinAddress(
    String accountWalletId, {
    required NetworkId networkId,
  });
}

abstract class TransactionSigner {
  Future<BroadcastTransaction> signTransaction(
    String accountWalletId, {
    required NetworkId networkId,
    required String toAddress,
    required BigInt amount,
    required BigInt feeAmount,
    required BigInt gasLimit,
    required int assetDecimals,
    String? contractAddress,
    // TODO: change this to required after it is implemented in backend and
    // we can fetch it from there.
    String maxInclusionFeePerGas = '2000000000',
    String? data,
  });

  Future<BroadcastTransaction?> signEthereumTransaction(
    String accountWalletId, {
    required NetworkId networkId,
    required BigInt amount,
    required String toAddress,
    required BigInt feeAmount,
    required BigInt gasLimit,
    String? contractAddress,
    // TODO: change this to required after it is implemented in backend and
    // we can fetch it from there.
    String maxInclusionFeePerGas = '2000000000',
    String? data,
  });
}

abstract class MessageSigner {
  String signMessage({
    required NetworkId networkId,
    required String message,
  });

  String signPersonalMessage({
    required NetworkId networkId,
    required String message,
  });

  String signTypedData({
    required NetworkId networkId,
    required String jsonData,
  });
}

abstract class TransactionBroadcaster {
  Future<String> broadcastTransaction(
    BroadcastTransaction transaction,
  );
}

abstract class BalanceUpdater {
  Future<AccountWallet> updateAccountWalletBalance(
    AccountWallet accountWallet, {
    required String currency,
  });
}

abstract class WalletInventoryUpdater {
  Future<AccountWallet> updateAccountWalletInventory(
    AccountWallet accountWallet,
  );

  Future<AccountWallet> updateNetworkWalletInventory(
    AccountWallet accountWallet, {
    required NetworkWallet networkWallet,
  });
}
