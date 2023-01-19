import 'package:hive/hive.dart';
import 'package:simplio_app/data/providers/entities/wallet_connect_v1_session_entity.dart';
import 'package:simplio_app/data/providers/helpers/box_provider.dart';
import 'package:simplio_app/data/providers/interfaces/wallet_connect_session_db.dart';

class WalletConnectSessionDbProvider
    extends BoxProvider<WalletConnectV1SessionEntity>
    implements WalletConnectSessionDb {
  @override
  final String boxName = 'walletConnectSessionV1Box';

  @override
  void registerAdapters() {
    Hive.registerAdapter(WalletConnectV1SessionEntityAdapter());
  }

  @override
  List<WalletConnectV1SessionEntity> getAll(String accountWalletId) {
    try {
      return box.values
          .where((s) => s.accountWalletId == accountWalletId)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> remove(String topicId) {
    final sessions =
        box.values.where((s) => s.topicId == topicId).map((s) => s.delete());

    return Future.wait(sessions);
  }

  @override
  Future<void> save(WalletConnectV1SessionEntity session) {
    return box.add(session);
  }
}
