import 'package:crypto_assets/src/model/helpers/types.dart';

enum AssetIds {
  simplio(0),
  bitcoin(1),
  ethereum(2),
  solana(3),
  usdCoin(4),
  tether(5),
  binanceUSD(6),
  bnb(7),
  tinyCoin(8),
  dai(150);

  const AssetIds(this.id);

  final AssetId id;
}
