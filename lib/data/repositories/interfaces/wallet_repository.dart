import 'package:simplio_app/data/models/wallet.dart';

abstract class WalletRepository
    implements
        AccountWalletLoader,
        AccountWalletAdderRemover,
        MnemonicGetter,
        NetworkWalletEnablerDisabler,
        NetworkWalletAddressGetter,
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

  String getTokenAddress(
    String accountWalletId, {
    required AssetId assetId,
    required NetworkId networkId,
  });
}

abstract class TransactionSigner {
  Future<WalletTransaction> signTransaction(
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

  Future<WalletTransaction?> signEthereumTransaction(
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
    WalletTransaction transaction,
  );
}

abstract class BalanceUpdater {
  Future<AccountWallet> updateAccountWalletBalance(
    AccountWallet accountWallet, {
    bool save = true,
  });

  Future<AccountWallet> updateAssetWalletBalance(
    AccountWallet accountWallet, {
    required AssetWallet assetWallet,
    bool save = true,
  });

  Future<AccountWallet> updateNetworkWalletBalance(
    AccountWallet accountWallet, {
    required NetworkWallet networkWallet,
    bool save = true,
  });
}

// TODO - this should be moved to a separate file.
class WalletTransaction {
  final NetworkId networkId;
  String rawTx;
  final BigInt networkFee;

  WalletTransaction({
    required this.networkId,
    required this.rawTx,
    required this.networkFee,
  });
}
