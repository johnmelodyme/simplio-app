import 'package:hive/hive.dart';
import 'package:simplio_app/data/model/wallet_connect_session.dart';
import 'package:simplio_app/data/providers/box_provider.dart';
import 'package:simplio_app/data/repositories/wallet_connect_repository.dart';

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
