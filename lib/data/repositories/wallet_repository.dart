import 'package:flutter/foundation.dart';
import 'package:simplio_app/data/http/services/balance_service.dart';
import 'package:simplio_app/data/http/services/blockchain_utils_service.dart';
import 'package:simplio_app/data/http/services/broadcast_service.dart';
import 'package:simplio_app/data/model/account_wallet.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/data/model/network_wallet.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';
import 'package:sio_core_light/sio_core_light.dart' as sio;

class WalletRepository {
  final WalletDb _walletDb;
  final BlockchainUtilsService _blockchainUtilsService;
  final BroadcastService _broadcastService;
  final BalanceService _balanceService;

  late String _walletId;
  late HDWallet _wallet;

  WalletRepository._(
    this._walletDb,
    this._blockchainUtilsService,
    this._broadcastService,
    this._balanceService,
  );

  WalletRepository({
    required WalletDb walletDb,
    required BlockchainUtilsService blockchainUtilsService,
    required BroadcastService broadcastService,
    required BalanceService balanceService,
  }) : this._(
          walletDb,
          blockchainUtilsService,
          broadcastService,
          balanceService,
        );

  Future<AccountWallet> loadAccountWallet(
    String accountId, {
    required String key,
  }) async {
    final AccountWallet w = _walletDb.getLast(accountId) ??
        await addAccountWallet(
          accountId,
          key: key,
        );

    final mnemonic = w.mnemonic.unlock(key);

    /// Initialize [HDWallet] in repository.
    _walletId = w.uuid;
    _wallet = HDWallet.createWithMnemonic(mnemonic);

    return w;
  }

  Future<AccountWallet> addAccountWallet(
    String accountId, {
    required key,
    String? name,
    String? mnemonic,
  }) async {
    final isProvided = mnemonic != null;
    final m = LockableMnemonic.unlocked(
      mnemonic: mnemonic ?? sio.Mnemonic().generate,
      isBackedUp: isProvided,
      isImported: isProvided,
    );
    m.lock(key);

    return _walletDb.save(AccountWallet.hd(
      accountId: accountId,
      mnemonic: m,
    ));
  }

  Future<AccountWallet> enableNetworkWallet(
    AccountWallet accountWallet, {
    required int assetId,
    required int networkId,
  }) async {
    _checkInitializedAccountWallet(accountWallet.uuid);

    final assetWallet = accountWallet.getWallet(assetId) ??
        AssetWallet.builder(assetId: assetId);

    final networkWallet =
        assetWallet.getWallet(networkId)?.copyWith(isEnabled: true) ??
            NetworkWallet.builder(
              networkId: networkId,
              address: getCoinAddress(accountWallet.uuid, networkId: networkId),
              isEnabled: true,
              preset: NetworkWallet.makePreset(
                assetId: assetId,
                networkId: networkId,
              ),
            );

    return await _walletDb.save(
      accountWallet.addWallet(
        assetWallet.addWallet(networkWallet),
      ),
    );
  }

  Future<AccountWallet> disableNetworkWallet(
    AccountWallet accountWallet, {
    required int assetId,
    required int networkId,
  }) async {
    final assetWallet = accountWallet.getWallet(assetId);
    if (assetWallet == null) {
      throw Exception("Asset Wallet '$assetId' was not found.");
    }

    final networkWallet = assetWallet.getWallet(networkId);
    if (networkWallet == null) {
      throw Exception(
        "Asset Wallet '$assetId' does not have network Wallet '$networkId'.",
      );
    }

    return await _walletDb.save(
      accountWallet.updateWalletsFromIterable([
        assetWallet.updateWalletsFromIterable([
          networkWallet.copyWith(isEnabled: false),
        ])
      ]),
    );
  }

  // Might be used in the future.
  String getMnemonic(String accountWalletId) {
    _checkInitializedAccountWallet(accountWalletId);
    return _wallet.mnemonic();
  }

  bool isValidAddress({
    required String address,
    required int networkId,
  }) {
    return sio.Address.isValid(address: address, networkId: networkId);
  }

  String getCoinAddress(
    String accountWalletId, {
    required int networkId,
  }) {
    _checkInitializedAccountWallet(accountWalletId);
    if (!sio.Networks.isSupported(networkId: networkId)) {
      throw Exception("Network wallet '$networkId}' is not supported");
    }
    return _wallet.getAddressForCoin(networkId);
  }

  Future<WalletTransaction> signTransaction(
    String accountWalletId, {
    required int networkId,
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
  }) async {
    WalletTransaction? transaction;

    transaction ??= await signEthereumTransaction(
      accountWalletId,
      networkId: networkId,
      amount: amount,
      toAddress: toAddress,
      feeAmount: feeAmount,
      gasLimit: gasLimit,
      contractAddress: contractAddress,
      maxInclusionFeePerGas: maxInclusionFeePerGas,
      data: data,
    );

    transaction ??= await _signUtxoTransaction(
      accountWalletId,
      networkId: networkId,
      amount: amount,
      toAddress: toAddress,
      feeAmount: feeAmount,
    );

    transaction ??= await _signSolanaTransaction(
      accountWalletId,
      networkId: networkId,
      amount: amount,
      toAddress: toAddress,
      feeAmount: feeAmount,
      contractAddress: contractAddress,
      assetDecimals: assetDecimals,
    );

    if (transaction == null) {
      throw Exception('networkId $networkId not supported!');
    }

    return transaction;
  }

  Future<int> _getNonce({
    required int networkId,
    required String walletAddress,
  }) async {
    final res = await _blockchainUtilsService.ethereum(
      networkId: networkId.toString(),
      walletAddress: walletAddress,
    );

    final body = res.body;

    if (!res.isSuccessful || body == null) {
      throw Exception('Nonce fetching has failed!');
    }

    if (!body.success) {
      throw Exception(body.errorMessage);
    }

    return int.parse(body.transactionCount ?? '0');
  }

  WalletTransaction _makeTransaction({
    required int networkId,
    required sio.Transaction transaction,
  }) {
    return WalletTransaction(
      networkId: networkId,
      rawTx: transaction.rawTx,
      networkFee: transaction.networkFee,
    );
  }

  Future<WalletTransaction?> signEthereumTransaction(
    String accountWalletId, {
    required int networkId,
    required BigInt amount,
    required String toAddress,
    required BigInt feeAmount,
    required BigInt gasLimit,
    String? contractAddress,
    // TODO: change this to required after it is implemented in backend and
    // we can fetch it from there.
    String maxInclusionFeePerGas = '2000000000',
    String? data,
  }) async {
    _checkInitializedAccountWallet(accountWalletId);

    if (!(sio.Cluster.ethereumEIP1559.contains(networkId) ||
        sio.Cluster.ethereumLegacy.contains(networkId))) return null;

    final nonce = await _getNonce(
      networkId: networkId,
      walletAddress: getCoinAddress(accountWalletId, networkId: networkId),
    );

    WalletTransaction? transaction;

    if (sio.Cluster.ethereumLegacy.contains(networkId)) {
      if (contractAddress != null) {
        transaction = _makeTransaction(
          networkId: networkId,
          transaction: sio.BuildTransaction.ethereumERC20TokenLegacy(
            wallet: _wallet,
            amount: amount,
            tokenContract: contractAddress,
            toAddress: toAddress,
            nonce: nonce,
            chainId: AssetRepository.chainId(networkId: networkId),
            coinType: networkId,
            gasPrice: feeAmount,
            gasLimit: gasLimit,
          ),
        );
        transaction.rawTx = '0x${transaction.rawTx}';
      } else {
        transaction = _makeTransaction(
          networkId: networkId,
          transaction: sio.BuildTransaction.ethereumLegacy(
            wallet: _wallet,
            amount: amount,
            toAddress: toAddress,
            nonce: nonce,
            chainId: AssetRepository.chainId(networkId: networkId),
            coinType: networkId,
            gasPrice: feeAmount,
            gasLimit: gasLimit,
            data: data,
          ),
        );
        transaction.rawTx = '0x${transaction.rawTx}';
      }
    }

    if (sio.Cluster.ethereumEIP1559.contains(networkId)) {
      if (contractAddress != null) {
        transaction = _makeTransaction(
          networkId: networkId,
          transaction: sio.BuildTransaction.ethereumERC20TokenEIP1559(
            wallet: _wallet,
            amount: amount,
            tokenContract: contractAddress,
            toAddress: toAddress,
            nonce: nonce,
            chainId: AssetRepository.chainId(networkId: networkId),
            coinType: networkId,
            maxFeePerGas: feeAmount,
            maxInclusionFeePerGas: maxInclusionFeePerGas,
            gasLimit: gasLimit,
          ),
        );
        transaction.rawTx = '0x${transaction.rawTx}';
      } else {
        transaction = _makeTransaction(
          networkId: networkId,
          transaction: sio.BuildTransaction.ethereumEIP1559(
            wallet: _wallet,
            amount: amount,
            toAddress: toAddress,
            nonce: nonce,
            chainId: AssetRepository.chainId(networkId: networkId),
            coinType: networkId,
            maxFeePerGas: feeAmount,
            maxInclusionFeePerGas: maxInclusionFeePerGas,
            gasLimit: gasLimit,
            data: data,
          ),
        );
        transaction.rawTx = '0x${transaction.rawTx}';
      }
    }

    return transaction;
  }

  Future<List<Utxo>> _getUtxo(
    String accountWalletId, {
    required int networkId,
  }) async {
    final res = await _blockchainUtilsService.utxo(
      networkId: networkId.toString(),
      walletAddress: getCoinAddress(accountWalletId, networkId: networkId),
    );

    final body = res.body;

    if (!res.isSuccessful || body == null) {
      throw Exception('Utxo fetching has failed!');
    }

    return body.items;
  }

  Future<WalletTransaction?> _signUtxoTransaction(
    String accountWalletId, {
    required int networkId,
    required BigInt amount,
    required String toAddress,
    required BigInt feeAmount,
  }) async {
    _checkInitializedAccountWallet(accountWalletId);

    if (!sio.Cluster.utxo.contains(networkId)) return null;

    final utxos = await _getUtxo(accountWalletId, networkId: networkId);

    return _makeTransaction(
      networkId: networkId,
      transaction: sio.BuildTransaction.utxoCoin(
        wallet: _wallet,
        coin: networkId,
        toAddress: toAddress,
        amount: amount,
        byteFee: feeAmount,
        utxo: utxos.map((utxo) => utxo.toJson()).toList(),
      ),
    );
  }

  Future<String> _getLatestBlockHash({
    required int networkId,
    required String walletAddress,
  }) async {
    final res = await _blockchainUtilsService.solana(
      walletAddress: walletAddress,
    );

    final body = res.body;

    if (!res.isSuccessful || body == null) {
      throw Exception('LatestBlockHash fetching has failed!');
    }

    if (body.success == false) {
      throw Exception(body.errorMessage);
    }

    return body.lastBlockHash ?? '';
  }

  Future<WalletTransaction?> _signSolanaTransaction(
    String accountWalletId, {
    required int networkId,
    required BigInt amount,
    required String toAddress,
    required BigInt feeAmount,
    required int assetDecimals,
    String? contractAddress,
  }) async {
    _checkInitializedAccountWallet(accountWalletId);

    if (!sio.Cluster.solana.contains(networkId)) return null;

    final latestBlockHash = await _getLatestBlockHash(
      networkId: networkId,
      walletAddress: getCoinAddress(accountWalletId, networkId: networkId),
    );

    if (contractAddress != null) {
      return _makeTransaction(
          networkId: networkId,
          transaction: sio.BuildTransaction.solanaToken(
            wallet: _wallet,
            recipientSolanaAddress: toAddress,
            tokenMintAddress: contractAddress,
            amount: amount,
            decimals: assetDecimals,
            latestBlockHash: latestBlockHash,
            fee: feeAmount,
          ));
    }
    return _makeTransaction(
      networkId: networkId,
      transaction: sio.BuildTransaction.solana(
        wallet: _wallet,
        recipient: toAddress,
        amount: amount,
        latestBlockHash: latestBlockHash,
        fee: feeAmount,
      ),
    );
  }

  Future<String> broadcastTransaction(WalletTransaction transaction) async {
    final res = await _broadcastService.transaction(
      transaction.networkId.toString(),
      transaction.rawTx,
    );

    final body = res.body;

    if (!res.isSuccessful || body == null) {
      throw Exception('Broadcasting Transaction has failed!');
    }

    if (!body.success) {
      throw Exception(body.errorMessage);
    }

    final result = body.result;
    if (result != null) return result;

    throw Exception('Broadcasted transaction does not exist');
  }

  void _checkInitializedAccountWallet(String accountWalletId) {
    if (_walletId == accountWalletId) return;
    throw Exception("Account wallet '$accountWalletId}' is not initialized");
  }

  String signMessage({
    required int networkId,
    required String message,
  }) {
    try {
      return sio.EthSign.message(
          wallet: _wallet, networkId: networkId, message: message);
    } catch (_) {
      return sio.EthSign.personalMessage(
          wallet: _wallet, networkId: networkId, message: message);
    }
  }

  String signPersonalMessage({
    required int networkId,
    required String message,
  }) {
    try {
      return sio.EthSign.personalMessage(
          wallet: _wallet, networkId: networkId, message: message);
    } catch (_) {
      return '';
    }
  }

  String signTypedData({
    required int networkId,
    required String jsonData,
  }) {
    try {
      return sio.EthSign.typedData(
          wallet: _wallet, networkId: networkId, jsonData: jsonData);
    } catch (_) {
      return '';
    }
  }

  // Do we need this or is inventoryRepository enough??
  Future<AccountWallet> refreshAccountWalletBalance(
    AccountWallet accountWallet, {
    bool save = true,
  }) async {
    try {
      final wallet = await _updateAccountWalletBalance(accountWallet);

      if (save) await _walletDb.save(wallet);

      return wallet;
    } catch (e) {
      debugPrint(e.toString());
      return accountWallet;
    }
  }

  // Might be used in the future
  Future<AccountWallet> refreshAssetWalletBalance(
    AccountWallet accountWallet, {
    required AssetWallet assetWallet,
    bool save = true,
  }) async {
    try {
      final assWallet = await _updateAssetWalletBalance(assetWallet);
      final accWallet = accountWallet.updateWalletsFromIterable([assWallet]);

      if (save) await _walletDb.save(accWallet);

      return accWallet;
    } catch (e) {
      debugPrint(e.toString());
      return accountWallet;
    }
  }

  Future<AccountWallet> refreshNetworkWalletBalance(
    AccountWallet accountWallet, {
    required NetworkWallet networkWallet,
    bool save = true,
  }) async {
    try {
      final netWallet = await _updateNetworkWalletBalance(networkWallet);
      final assWallet = accountWallet.wallets.firstWhere(
        (w) => w.findWallet(networkWallet.uuid) != null,
      );
      final accWallet = accountWallet.updateWalletsFromIterable([
        assWallet.updateWalletsFromIterable([netWallet]),
      ]);

      if (save) await _walletDb.save(accWallet);

      return accWallet;
    } catch (e) {
      debugPrint(e.toString());
      return accountWallet;
    }
  }

  Future<AccountWallet> _updateAccountWalletBalance(
    AccountWallet accountWallet,
  ) async {
    try {
      final updatedWallets = await Future.wait(accountWallet.wallets.map(
        _updateAssetWalletBalance,
      ));

      return accountWallet.updateWalletsFromIterable(updatedWallets);
    } catch (e) {
      debugPrint(e.toString());
      return accountWallet;
    }
  }

  Future<AssetWallet> _updateAssetWalletBalance(
    AssetWallet assetWallet,
  ) async {
    try {
      final updatedWallets = await Future.wait(assetWallet.wallets.map(
        _updateNetworkWalletBalance,
      ));

      return assetWallet.updateWalletsFromIterable(updatedWallets);
    } catch (e) {
      debugPrint(e.toString());
      return assetWallet;
    }
  }

  Future<NetworkWallet> _updateNetworkWalletBalance(
    NetworkWallet networkWallet,
  ) async {
    try {
      final BigInt balance = await (networkWallet.isToken
          ? _getTokenBalance(networkWallet)
          : _getCoinBalance(networkWallet));

      return networkWallet.copyWith(balance: balance);
    } catch (e) {
      debugPrint(e.toString());
      return networkWallet;
    }
  }

  Future<BigInt> _getCoinBalance(NetworkWallet networkWallet) async {
    final res = await _balanceService.coin(
      networkWallet.networkId,
      networkWallet.address,
    );

    final body = res.body;
    final success = body?.success ?? false;

    if (body != null && success) {
      return BigInt.parse(body.balance);
    }

    if (!success) {
      throw Exception(
        "Fetching coin balance for ${networkWallet.address} address failed with ${body?.errorMessage}",
      );
    }

    throw Exception(
      "Fetching coin balance for ${networkWallet.address} address failed",
    );
  }

  Future<BigInt> _getTokenBalance(NetworkWallet networkWallet) async {
    final res = await _balanceService.token(
      networkWallet.networkId,
      networkWallet.address,
      networkWallet.preset.contractAddress!,
    );

    final body = res.body;
    final success = body?.success ?? false;

    if (body != null && success) {
      return BigInt.parse(body.balance);
    }

    if (!success) {
      throw Exception(
        "Fetching token balance for ${networkWallet.address} address failed with ${body?.errorMessage}",
      );
    }

    throw Exception(
      "Fetching token balance for ${networkWallet.address} address failed",
    );
  }
}

class WalletTransaction {
  final int networkId;
  String rawTx;
  final BigInt networkFee;

  WalletTransaction({
    required this.networkId,
    required this.rawTx,
    required this.networkFee,
  });
}

abstract class WalletDb {
  Future<AccountWallet> save(AccountWallet accountWallet);
  List<AccountWallet> getAll(String accountId);
  AccountWallet? getLast(String accountId);
}
