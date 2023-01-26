import 'package:simplio_app/data/http/errors/http_error.dart';
import 'package:simplio_app/data/http/http_client.dart';
import 'package:simplio_app/data/http/services/broadcast_service.dart';
import 'package:simplio_app/data/models/transaction.dart';

class BroadcastApi extends HttpApi<BroadcastService> {
  Future<String> broadcastTransaction(
    BroadcastTransaction transaction,
  ) async {
    final res = await service.transaction(
      transaction.networkId.toString(),
      transaction.rawTx,
    );

    final body = res.body;

    if (!res.isSuccessful || body == null) {
      throw BadRequestHttpError.fromObject(res.error);
    }

    if (!body.success) {
      throw BadRequestHttpError(
        code: HttpErrorCodes.blockchainBroadcastFailed,
        message: body.errorMessage ?? 'Broadcasting Transaction has failed!',
      );
    }

    final result = body.result;
    if (result != null) return result;

    throw const BadRequestHttpError(
      code: HttpErrorCodes.blockchainBroadcastFailed,
      message: 'Broadcast result is not present',
    );
  }
}
