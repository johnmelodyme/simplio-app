import 'package:crypto_assets/src/model/helpers/types.dart';

enum NetworkIds {
  bitcoin(0),
  ethereum(60),
  solana(501),
  bnbSmartChain(20000714);

  const NetworkIds(this.id);

  final NetworkId id;
}
