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

  String getMnemonic() {
    return _wallet.mnemonic();
  }

  Future<String> sendTransaction({
    required int assetId,
    required int networkId,
    required String amount,
    required String toAddress,
    required String feeAmount,
    required String gasLimit,
    required String? contractAddress,
    required int assetDecimals,

    // not implemented yet in Backend since they have not implemented
    // EIP1559 chains yet.
    // TODO: set this as required after backend provide value. Meanwhile this
    // is set to 2_000_000_000 wei.
    String maxInclusionFeePerGas = '2000000000',
  }) async {
    var rawTransaction = await _getEthereumRawTx(
      networkId: networkId,
      amount: amount,
      toAddress: toAddress,
      feeAmount: feeAmount,
      gasLimit: gasLimit,
      contractAddress: contractAddress,
    );

    rawTransaction ??= await _getUtxoRawTx(
        networkId: networkId,
        amount: amount,
        toAddress: toAddress,
        feeAmount: feeAmount);

    rawTransaction ??= await _getSolanaRawTx(
      networkId: networkId,
      amount: amount,
      toAddress: toAddress,
      feeAmount: feeAmount,
      contractAddress: contractAddress,
      assetDecimals: assetDecimals,
    );

    if (rawTransaction == null) {
      throw Exception('networkId $networkId not supported!');
    }

    // Step3. Broadcast transaction and return Success or Not
    final broadcastResult =
        await _broadcastTransaction(networkId, rawTransaction);

    return broadcastResult;
  }

  Future<String> _getNonce(int networkId) async {
    final resp = await _blockchainUtilsService.ethereum(
        networkId: networkId.toString(),
        walletAddress: _wallet.getAddressForCoin(networkId));

    final respBody = resp.body;

    if (!resp.isSuccessful || respBody == null) {
      throw Exception('Nonce fetching has failed!');
    }

    if (respBody.success == false) {
      throw Exception(respBody.errorMessage);
    }

    return respBody.transactionCount!;
  }

  Future<sio.Transaction?> _getEthereumRawTx({
    required int networkId,
    required String amount,
    required String toAddress,
    required String feeAmount,
    required String gasLimit,
    required String? contractAddress,
    String maxInclusionFeePerGas = '2000000000',
  }) async {
    if (sio.ethereumLegacyGroup.contains(networkId) ||
        sio.ethereumEIP1559Group.contains(networkId)) {
      // Step1. GetUtils
      final nonce = await _getNonce(networkId);

      // Step2. BuildTransaction with sio_core_light
      if (sio.ethereumLegacyGroup.contains(networkId)) {
        if (contractAddress == null || contractAddress == '') {
          return sio.BuildTransaction.ethereumLegacy(
            wallet: _wallet,
            amount: amount,
            toAddress: toAddress,
            nonce: nonce,
            chainId: sio.EthereumNetworks.chainId(networkId: networkId),
            coinType: networkId,
            gasPrice: feeAmount,
            gasLimit: gasLimit,
          );
        }
        return sio.BuildTransaction.ethereumERC20TokenLegacy(
          wallet: _wallet,
          amount: amount,
          tokenContract: contractAddress,
          toAddress: toAddress,
          nonce: nonce,
          chainId: sio.EthereumNetworks.chainId(networkId: networkId),
          coinType: networkId,
          gasPrice: feeAmount,
          gasLimit: gasLimit,
        );
      }

      if (sio.ethereumEIP1559Group.contains(networkId)) {
        if (contractAddress == null || contractAddress == '') {
          return sio.BuildTransaction.ethereumEIP1559(
            wallet: _wallet,
            amount: amount,
            toAddress: toAddress,
            nonce: nonce,
            chainId: sio.EthereumNetworks.chainId(networkId: networkId),
            coinType: networkId,
            maxFeePerGas: feeAmount,
            maxInclusionFeePerGas: maxInclusionFeePerGas,
            gasLimit: gasLimit,
          );
        }
        return sio.BuildTransaction.ethereumERC20TokenEIP1559(
          wallet: _wallet,
          amount: amount,
          tokenContract: contractAddress,
          toAddress: toAddress,
          nonce: nonce,
          chainId: sio.EthereumNetworks.chainId(networkId: networkId),
          coinType: networkId,
          maxFeePerGas: feeAmount,
          maxInclusionFeePerGas: maxInclusionFeePerGas,
          gasLimit: gasLimit,
        );
      }
    }
    return null;
  }

  Future<List<Utxo>> _getUtxo(int networkId) async {
    final resp = await _blockchainUtilsService.utxo(
        networkId: networkId.toString(),
        walletAddress: _wallet.getAddressForCoin(networkId));
    final respBody = resp.body;

    if (!resp.isSuccessful || respBody == null) {
      throw Exception('Utxo fetching has failed!');
    }

    return respBody.items;
  }

  Future<sio.Transaction?> _getUtxoRawTx({
    required int networkId,
    required String amount,
    required String toAddress,
    required String feeAmount,
  }) async {
    if (sio.utxoGroup.contains(networkId)) {
      final utxos = await _getUtxo(networkId);

      return sio.BuildTransaction.utxoCoin(
        wallet: _wallet,
        coin: networkId,
        toAddress: toAddress,
        amount: amount,
        byteFee: feeAmount,
        // TODO: If Mario return an error in Bitcoin Tx here we should look.
        // If Bitcoin transaction test pass delete these comment.
        utxo: [...utxos.map((utxo) => utxo.toJson())],
      );
    }
    return null;
  }

  Future<String> _getLatestBlockHash(int networkId) async {
    final resp = await _blockchainUtilsService.solana(
        walletAddress: _wallet.getAddressForCoin(networkId));
    final respBody = resp.body;

    if (!resp.isSuccessful || respBody == null) {
      throw Exception('LatestBlockHash fetching has failed!');
    }

    if (respBody.success == false) {
      throw Exception(respBody.errorMessage);
    }

    return respBody.lastBlockHash!;
  }

  Future<sio.Transaction?> _getSolanaRawTx({
    required int networkId,
    required String amount,
    required String toAddress,
    required String feeAmount,
    required String? contractAddress,
    required int assetDecimals,
  }) async {
    if (sio.solanaGroup.contains(networkId)) {
      final latestBlockHash = await _getLatestBlockHash(networkId);

      if (contractAddress == null || contractAddress == '') {
        return sio.BuildTransaction.solana(
          wallet: _wallet,
          recipient: toAddress,
          amount: amount,
          latestBlockHash: latestBlockHash,
          fee: feeAmount,
        );
      }
      return sio.BuildTransaction.solanaToken(
        wallet: _wallet,
        recipientSolanaAddress: toAddress,
        tokenMintAddress: contractAddress,
        amount: amount,
        decimals: assetDecimals,
        latestBlockHash: latestBlockHash,
        fee: feeAmount,
      );
    }
    return null;
  }

  Future<String> _broadcastTransaction(
    int networkId,
    sio.Transaction rawTransaction,
  ) async {
    if (rawTransaction.rawTx == null || rawTransaction.rawTx == '') {
      throw Exception('There is no rawTx to broadcast!');
    }
    final broadcast = await _broadcastService.transaction(
      networkId.toString(),
      rawTransaction.rawTx!,
    );

    final broadcastBody = broadcast.body;

    if (!broadcast.isSuccessful || broadcastBody == null) {
      throw Exception('Broadcasting Transaction has failed!');
    }
    if (!broadcastBody.success) {
      throw Exception(broadcastBody.errorMessage);
    }
    if (broadcastBody.result == null) {
      throw Exception('Broadcast result is null!');
    }

    return broadcastBody.result!;
  }

  void _checkInitializedAccountWallet(String accountWalletId) {
    if (_walletId == accountWalletId) return;
    throw Exception("Account wallet '$accountWalletId}' is not initialized");
  }
}

abstract class WalletDb {
  Future<AccountWallet> save(AccountWallet accountWallet);
  List<AccountWallet> getAll(String accountId);
  AccountWallet? getLast(String accountId);
}
