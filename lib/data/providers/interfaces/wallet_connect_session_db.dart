import 'package:simplio_app/data/providers/entities/wallet_connect_v1_session_entity.dart';

abstract class WalletConnectSessionDb {
  Future<void> save(WalletConnectV1SessionEntity session);
  List<WalletConnectV1SessionEntity> getAll(String accountWalletId);
  Future<void> remove(String topicId);
}
