import 'package:simplio_app/data/http/http_client.dart';
import 'package:simplio_app/data/http/services/blockchain_utils_service.dart';
import 'package:simplio_app/data/models/wallet.dart';

class BlockchainApi extends HttpApi<BlockchainUtilsService> {
  Future<int> getNonce({
    required NetworkId networkId,
    required String walletAddress,
  }) async {
    final res = await service.ethereum(
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

  Future<String> getLatestBlockHash({
    required int networkId,
    required String walletAddress,
  }) async {
    final res = await service.solana(
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

  Future<List<Utxo>> getUtxo({
    required NetworkId networkId,
    required String walletAddress,
  }) async {
    final res = await service.utxo(
      networkId: networkId.toString(),
      walletAddress: walletAddress,
    );

    final body = res.body;

    if (!res.isSuccessful || body == null) {
      throw Exception('Utxo fetching has failed!');
    }

    return body.items;
  }
}
