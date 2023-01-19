import 'package:hive_flutter/hive_flutter.dart';
import 'package:simplio_app/data/providers/helpers/box_provider.dart';

part 'wallet_connect_v1_session_entity.g.dart';

// TODO - this is likely to be a changed to a WalletConnect v2 session.
@HiveType(typeId: 6)
class WalletConnectV1SessionEntity extends Entity {
  @HiveField(0)
  final String accountWalletId;

  @HiveField(1)
  final String topicId;

  @HiveField(2)
  final String sessionId;

  @HiveField(3)
  final String sessionDetail;

  WalletConnectV1SessionEntity({
    required this.accountWalletId,
    required this.topicId,
    required this.sessionId,
    required this.sessionDetail,
  });
}
