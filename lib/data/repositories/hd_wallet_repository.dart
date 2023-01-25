import 'package:crypto_assets/crypto_assets.dart';
import 'package:simplio_app/data/http/services/balance_service.dart';
import 'package:simplio_app/data/http/services/blockchain_utils_service.dart';
import 'package:simplio_app/data/http/services/broadcast_service.dart';
import 'package:simplio_app/data/models/helpers/lockable.dart';
import 'package:simplio_app/data/models/wallet.dart';
import 'package:simplio_app/data/providers/interfaces/wallet_db.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:simplio_app/data/repositories/interfaces/wallet_repository.dart';
import 'package:sio_big_decimal/sio_big_decimal.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';
import 'package:sio_core_light/sio_core_light.dart' as sio;

class HDWalletRepository extends WalletRepository {
  static HDWallet createWithMnemonic(String mnemonic) {
    return HDWallet.createWithMnemonic(mnemonic);
  }

  static bool validateAddress(
    String address, {
    required NetworkId networkId,
  }) {
    return sio.Address.isValid(
      address: address,
      networkId: networkId,
    );
  }

  final WalletDb _walletDb;
  final BlockchainUtilsService _blockchainService;
  final BroadcastService _broadcastService;
  final BalanceService _balanceService;

  late String _walletId;
  late HDWallet _wallet;

  HDWalletRepository({
    required WalletDb walletDb,
    required BlockchainUtilsService blockchainService,
    required BroadcastService broadcastService,
    required BalanceService balanceService,
  })  : _walletDb = walletDb,
        _blockchainService = blockchainService,
        _broadcastService = broadcastService,
        _balanceService = balanceService;

  @override
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

  @override
  Future<AccountWallet> addAccountWallet(
    String accountId, {
    required key,
    String? name,
    String? mnemonic,
  }) {
    final m = mnemonic ?? sio.Mnemonic().generate;
    final isProvided = mnemonic != null;

    final lockableMnemonic = LockableMnemonic.unlocked(
      mnemonic: m,
      isBackedUp: isProvided,
      isImported: isProvided,
    );

    lockableMnemonic.lock(key);

    return _walletDb.save(AccountWallet.hd(
      uuid: AccountWallet.makeUUID(
        createWithMnemonic(m).getAddressForCoin(NetworkIds.bitcoin.id),
      ),
      accountId: accountId,
      mnemonic: lockableMnemonic,
    ));
  }

  @override
  Future<AccountWallet> importAccountWallet(
    String accountId, {
    required key,
    String? name,
    required String mnemonic,
  }) {
    // TODO: implement importAccountWallet
    throw UnimplementedError();
  }

  @override
  Future<void> removeAccountWallet(
    String accountId,
  ) {
    // TODO: implement removeAccountWallet
    throw UnimplementedError();
  }

  @override
  Future<AccountWallet> enableNetworkWallet(
    AccountWallet accountWallet, {
    required int assetId,
    required NetworkId networkId,
  }) async {
    _checkInitializedAccountWallet(accountWallet.uuid);

    final assetWallet = accountWallet.getWallet(assetId) ??
        AssetWallet.builder(assetId: assetId);

    final networkWallet =
        assetWallet.getWallet(networkId)?.copyWith(isEnabled: true) ??
            NetworkWallet.builder(
              assetId: assetId,
              networkId: networkId,
              address: getCoinAddress(
                accountWallet.uuid,
                networkId: networkId,
              ),
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

  @override
  Future<AccountWallet> disableNetworkWallet(
    AccountWallet accountWallet, {
    required int assetId,
    required NetworkId networkId,
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

  @override
  Future<AccountWallet> updateAccountWalletBalance(
    AccountWallet accountWallet, {
    bool save = true,
  }) async {
    try {
      final wallet = await _updateAccountWalletBalance(accountWallet);

      if (save) await _walletDb.save(wallet);

      return wallet;
    } catch (e) {
      return accountWallet;
    }
  }

  @override
  Future<AccountWallet> updateAssetWalletBalance(
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
      return accountWallet;
    }
  }

  @override
  Future<AccountWallet> updateNetworkWalletBalance(
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
      return accountWallet;
    }
  }

  @override
  String getMnemonic(
    AccountWallet accountWallet, {
    required String key,
  }) {
    // TODO - unlock lockable mnemonic with provided key.
    throw UnimplementedError();
  }

  @override
  Future<String> broadcastTransaction(
    WalletTransaction transaction,
  ) async {
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

  @override
  String getCoinAddress(
    String accountWalletId, {
    required NetworkId networkId,
  }) {
    _checkInitializedAccountWallet(accountWalletId);
    if (!sio.Networks.isSupported(networkId: networkId)) {
      throw Exception("Network wallet '$networkId}' is not supported");
    }
    return _wallet.getAddressForCoin(networkId);
  }

  @override
  String getTokenAddress(
    String accountWalletId, {
    required AssetId assetId,
    required NetworkId networkId,
  }) {
    // TODO: implement getTokenAddress
    throw UnimplementedError();
  }

  @override
  Future<WalletTransaction> signTransaction(
    String accountWalletId, {
    required NetworkId networkId,
    required String toAddress,
    required BigInt amount,
    required BigInt feeAmount,
    required BigInt gasLimit,
    required int assetDecimals,
    String? contractAddress,
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

  @override
  Future<WalletTransaction?> signEthereumTransaction(
    String accountWalletId, {
    required NetworkId networkId,
    required BigInt amount,
    required String toAddress,
    required BigInt feeAmount,
    required BigInt gasLimit,
    String? contractAddress,
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

  @override
  String signMessage({
    required NetworkId networkId,
    required String message,
  }) {
    try {
      return sio.EthSign.personalMessage(
        wallet: _wallet,
        networkId: networkId,
        message: message,
      );
    } catch (_) {
      return sio.EthSign.message(
        wallet: _wallet,
        networkId: networkId,
        message: message,
      );
    }
  }

  @override
  String signPersonalMessage({
    required NetworkId networkId,
    required String message,
  }) {
    try {
      return sio.EthSign.personalMessage(
        wallet: _wallet,
        networkId: networkId,
        message: message,
      );
    } catch (_) {
      return '';
    }
  }

  @override
  String signTypedData({
    required NetworkId networkId,
    required String jsonData,
  }) {
    try {
      return sio.EthSign.typedData(
        wallet: _wallet,
        networkId: networkId,
        jsonData: jsonData,
      );
    } catch (_) {
      return '';
    }
  }

  Future<int> _getNonce({
    required int networkId,
    required String walletAddress,
  }) async {
    final res = await _blockchainService.ethereum(
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
    final res = await _blockchainService.solana(
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

  Future<List<Utxo>> _getUtxo(
    String accountWalletId, {
    required int networkId,
  }) async {
    final res = await _blockchainService.utxo(
      networkId: networkId.toString(),
      walletAddress: getCoinAddress(accountWalletId, networkId: networkId),
    );

    final body = res.body;

    if (!res.isSuccessful || body == null) {
      throw Exception('Utxo fetching has failed!');
    }

    return body.items;
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
      return assetWallet;
    }
  }

  Future<NetworkWallet> _updateNetworkWalletBalance(
    NetworkWallet networkWallet,
  ) async {
    try {
      final BigDecimal cryptoBalance = await (networkWallet.isToken
          ? _getTokenBalance(networkWallet)
          : _getCoinBalance(networkWallet));

      return networkWallet.copyWith(cryptoBalance: cryptoBalance);
    } catch (e) {
      return networkWallet;
    }
  }

  Future<BigDecimal> _getCoinBalance(NetworkWallet networkWallet) async {
    final res = await _balanceService.coin(
      networkWallet.networkId,
      networkWallet.address,
    );

    final body = res.body;
    final success = body?.success ?? false;

    if (body != null && success) {
      return BigDecimal.parse(
        body.balance,
        precision: networkWallet.preset.decimalPlaces,
      );
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

  Future<BigDecimal> _getTokenBalance(NetworkWallet networkWallet) async {
    final res = await _balanceService.token(
      networkWallet.networkId,
      networkWallet.address,
      networkWallet.preset.contractAddress!,
    );

    final body = res.body;
    final success = body?.success ?? false;

    if (body != null && success) {
      return BigDecimal.parse(
        body.balance,
        precision: networkWallet.preset.decimalPlaces,
      );
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

  void _checkInitializedAccountWallet(String accountWalletId) {
    if (_walletId == accountWalletId) return;
    throw Exception("Account wallet '$accountWalletId}' is not initialized");
  }
}
