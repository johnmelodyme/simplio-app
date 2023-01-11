import 'package:hive/hive.dart';
import 'package:simplio_app/data/providers/helpers/box_provider.dart';
import 'package:simplio_app/data/repositories/wallet_connect_repository.dart';

part 'wallet_connect_session_db_provider.g.dart';

class WalletConnectSessionDbProvider
    extends BoxProvider<WalletConnectSessionLocal>
    implements WalletConnectSessionDb {
  @override
  String get boxName => 'walletConnectSessionV1Box';

  @override
  void registerAdapters() {
    Hive.registerAdapter(WalletConnectSessionLocalAdapter());
  }

  @override
  List<WalletConnectSessionLocal> getAll(String accountWalletId) {
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
  Future<void> save(WalletConnectSessionLocal session) {
    return box.add(session);
  }
}

@HiveType(typeId: 6)
class WalletConnectSessionLocal extends HiveObject {
  @HiveField(0)
  final String accountWalletId;

  @HiveField(1)
  final String topicId;

  @HiveField(2)
  final String sessionId;

  @HiveField(3)
  final String sessionDetail;

  WalletConnectSessionLocal({
    required this.accountWalletId,
    required this.topicId,
    required this.sessionId,
    required this.sessionDetail,
  });
}
