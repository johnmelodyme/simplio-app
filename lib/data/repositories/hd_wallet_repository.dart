import 'package:crypto_assets/crypto_assets.dart';
import 'package:simplio_app/data/http/apis/blockchain_api.dart';
import 'package:simplio_app/data/http/apis/broadcast_api.dart';
import 'package:simplio_app/data/http/apis/wallet_inventory_api.dart';
import 'package:simplio_app/data/models/error.dart';
import 'package:simplio_app/data/models/helpers/lockable.dart';
import 'package:simplio_app/data/models/transaction.dart';
import 'package:simplio_app/data/models/wallet.dart';
import 'package:simplio_app/data/providers/interfaces/wallet_db.dart';
import 'package:simplio_app/data/repositories/asset_repository.dart';
import 'package:simplio_app/data/repositories/errors/repository_error.dart';
import 'package:simplio_app/data/repositories/interfaces/wallet_repository.dart';
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
  final BlockchainApi _blockchainApi;
  final BroadcastApi _broadcastApi;
  final WalletInventoryApi _walletInventoryApi;

  late String _walletId;
  late HDWallet _wallet;

  HDWalletRepository({
    required WalletDb walletDb,
    required BlockchainApi blockchainApi,
    required BroadcastApi broadcastApi,
    required WalletInventoryApi walletInventoryApi,
  })  : _walletDb = walletDb,
        _blockchainApi = blockchainApi,
        _broadcastApi = broadcastApi,
        _walletInventoryApi = walletInventoryApi;

  @override
  Future<AccountWallet> loadAccountWallet(
    String accountId, {
    required String key,
  }) async {
    try {
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
    } on BaseError {
      rethrow;
    } catch (e) {
      throw RepositoryError(
        code: RepositoryErrorCodes.invalidDependency,
        message: e.toString(),
      );
    }
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
              walletAddress: getCoinAddress(
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
      throw RepositoryError(
        code: RepositoryErrorCodes.invalidValue,
        message: "Asset Wallet '$assetId' was not found.",
      );
    }

    final networkWallet = assetWallet.getWallet(networkId);
    if (networkWallet == null) {
      throw RepositoryError(
        code: RepositoryErrorCodes.invalidValue,
        message:
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
    String currency = 'USD',
  }) async {
    try {
      final balanced = await _walletInventoryApi.accountWalletBalance(
        accountWallet,
        currency: currency,
      );

      return await _walletDb.save(balanced.copyWith(
        updatedAt: DateTime.now(),
      ));
    } catch (_) {
      return await _walletDb.save(accountWallet.copyWith(
        updatedAt: DateTime.now(),
      ));
    }
  }

  @override
  Future<AccountWallet> updateAccountWalletInventory(
    AccountWallet accountWallet,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<AccountWallet> updateNetworkWalletInventory(
    AccountWallet accountWallet, {
    required NetworkWallet networkWallet,
  }) {
    throw UnimplementedError();
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
    BroadcastTransaction transaction,
  ) {
    return _broadcastApi.broadcastTransaction(transaction);
  }

  @override
  String getCoinAddress(
    String accountWalletId, {
    required NetworkId networkId,
  }) {
    _checkInitializedAccountWallet(accountWalletId);

    if (!sio.Networks.isSupported(networkId: networkId)) {
      throw RepositoryError(
        code: RepositoryErrorCodes.invalidValue,
        message: "Network wallet '$networkId}' is not supported",
      );
    }

    return _wallet.getAddressForCoin(networkId);
  }

  @override
  Future<BroadcastTransaction> signTransaction(
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
    BroadcastTransaction? transaction;

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
      throw RepositoryError(
        code: RepositoryErrorCodes.invalidValue,
        message: 'networkId $networkId not supported!',
      );
    }

    return transaction;
  }

  @override
  Future<BroadcastTransaction?> signEthereumTransaction(
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

    final nonce = await _blockchainApi.getNonce(
      networkId: networkId,
      walletAddress: getCoinAddress(accountWalletId, networkId: networkId),
    );

    BroadcastTransaction? transaction;

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

  BroadcastTransaction _makeTransaction({
    required int networkId,
    required sio.Transaction transaction,
  }) {
    return BroadcastTransaction(
      networkId: networkId,
      rawTx: transaction.rawTx,
      networkFee: transaction.networkFee,
    );
  }

  Future<BroadcastTransaction?> _signUtxoTransaction(
    String accountWalletId, {
    required int networkId,
    required BigInt amount,
    required String toAddress,
    required BigInt feeAmount,
  }) async {
    _checkInitializedAccountWallet(accountWalletId);

    if (!sio.Cluster.utxo.contains(networkId)) return null;

    final utxos = await _blockchainApi.getUtxo(
      networkId: networkId,
      walletAddress: getCoinAddress(
        accountWalletId,
        networkId: networkId,
      ),
    );

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

  Future<BroadcastTransaction?> _signSolanaTransaction(
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

    final latestBlockHash = await _blockchainApi.getLatestBlockHash(
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

  void _checkInitializedAccountWallet(String accountWalletId) {
    if (_walletId == accountWalletId) return;

    throw RepositoryError(
      code: RepositoryErrorCodes.invalidDependency,
      message: "Account wallet '$accountWalletId}' is not initialized",
    );
  }
}
