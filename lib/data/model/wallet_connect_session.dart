import 'package:hive/hive.dart';

part 'wallet_connect_session.g.dart';

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
