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

  late String _walletId;
  late HDWallet _wallet;

  WalletRepository._(
    this._walletDb,
    this._blockchainUtilsService,
    this._broadcastService,
  );

  WalletRepository.builder({
    required WalletDb walletDb,
    required BlockchainUtilsService blockchainUtilsService,
    required BroadcastService broadcastService,
  }) : this._(
          walletDb,
          blockchainUtilsService,
          broadcastService,
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

  Future<AccountWallet> addNetworkWallet(
    AccountWallet accountWallet, {
    required NetworkData data,
  }) async {
    _checkInitializedAccountWallet(accountWallet.uuid);

    /// Add [NetworkWallet] for already existing [AssetWallet].
    final assetWallet = accountWallet.getWallet(data.assetId);
    if (assetWallet != null) {
      final w = _addNetworkWallet(assetWallet, data: data);
      return _walletDb.save(accountWallet.addWallet(w));
    }

    /// Build a new [AssetWallet] and immediately add [NetworkWallet] to it.
    final w = _addNetworkWallet(
      AssetWallet.builder(assetId: data.assetId),
      data: data,
    );
    return _walletDb.save(accountWallet.addWallet(w));
  }

  AssetWallet _addNetworkWallet(
    AssetWallet wallet, {
    required NetworkData data,
  }) {
    if (wallet.containsWallet(data.networkId)) return wallet.copyWith();

    return wallet.addWallet(NetworkWallet.builder(
      networkId: data.networkId,
      address: _wallet.getAddressForCoin(data.networkId),
      decimalPlaces: data.decimalPlaces,
      contractAddress: data.contractAddress,
    ));
  }

  String getMnemonic(String accountWalletId) {
    _checkInitializedAccountWallet(accountWalletId);
    return _wallet.mnemonic();
  }

  String getCoinAddress(
    String accountWalletId, {
    required int networkId,
  }) {
    _checkInitializedAccountWallet(accountWalletId);
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
    String contractAddress = '',
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
      raw: transaction.rawTx,
    );
  }

  Future<WalletTransaction?> signEthereumTransaction(
    String accountWalletId, {
    required int networkId,
    required BigInt amount,
    required String toAddress,
    required BigInt feeAmount,
    required BigInt gasLimit,
    String contractAddress = '',
    String maxInclusionFeePerGas = '2000000000',
    String? data,
  }) async {
    _checkInitializedAccountWallet(accountWalletId);

    final nonce = await _getNonce(
      networkId: networkId,
      walletAddress: _wallet.getAddressForCoin(networkId),
    );

    WalletTransaction? transaction;

    if (sio.Cluster.ethereumLegacy.contains(networkId)) {
      if (contractAddress.isNotEmpty) {
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
        transaction.raw = '0x${transaction.raw}';
      }
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
      transaction.raw = '0x${transaction.raw}';
    }

    if (sio.Cluster.ethereumEIP1559.contains(networkId)) {
      if (contractAddress.isNotEmpty) {
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
        transaction.raw = '0x${transaction.raw}';
      }
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
      transaction.raw = '0x${transaction.raw}';
    }

    return transaction;
  }

  Future<List<Utxo>> _getUtxo({required int networkId}) async {
    final res = await _blockchainUtilsService.utxo(
      networkId: networkId.toString(),
      walletAddress: _wallet.getAddressForCoin(networkId),
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

    final utxos = await _getUtxo(networkId: networkId);

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
    String contractAddress = '',
  }) async {
    _checkInitializedAccountWallet(accountWalletId);

    if (!sio.Cluster.solana.contains(networkId)) return null;

    final latestBlockHash = await _getLatestBlockHash(
      networkId: networkId,
      walletAddress: _wallet.getAddressForCoin(networkId),
    );

    if (contractAddress.isEmpty) {
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
      transaction.raw,
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
}

class WalletTransaction {
  final int networkId;
  String raw;

  WalletTransaction({
    required this.networkId,
    required this.raw,
  });
}

abstract class WalletDb {
  Future<AccountWallet> save(AccountWallet accountWallet);
  List<AccountWallet> getAll(String accountId);
  AccountWallet? getLast(String accountId);
}
