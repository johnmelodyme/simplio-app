import 'package:simplio_app/data/http/services/buy_service.dart';

class BuyRepository {
  BuyRepository._();

  BuyRepository({
    required BuyService buyService,
  }) : this._();

  Future<List<BuyPairResponseItem>> pairs({
    bool readCache = true,
  }) async {
    // final res = await _buyService.pairs();

    // final body = res.body;
    // if (res.isSuccessful && body != null) return body.items;

    // throw Exception("Fetching buy pairs has failed: ${res.error.toString()}");

    //TODO: Mocked list for MVP. Return to get data from Backend.
    final List<BuyPairResponseItem> pairs = [
      BuyPairResponseItem(
        fiatAsset: PairFiatAsset(
          assetId: 'USD',
          decimalPlaces: 2,
          minimum: 11,
          maximum: 2500,
        ),
        cryptoAsset: PairCryptoAsset(
          assetId: 1,
          networkId: 0,
        ),
      ),
      BuyPairResponseItem(
        fiatAsset: PairFiatAsset(
          assetId: 'USD',
          decimalPlaces: 2,
          minimum: 11,
          maximum: 2500,
        ),
        cryptoAsset: PairCryptoAsset(
          assetId: 3,
          networkId: 501,
        ),
      ),
      // BuyPairResponseItem(
      //   fiatAsset: PairFiatAsset(
      //     assetId: 'USD',
      //     decimalPlaces: 2,
      //   ),
      //   cryptoAsset: PairCryptoAsset(
      //     assetId: 4,
      //     networkId: 501,
      //   ),
      // ),
      BuyPairResponseItem(
        fiatAsset: PairFiatAsset(
          assetId: 'USD',
          decimalPlaces: 2,
          minimum: 11,
          maximum: 2500,
        ),
        cryptoAsset: PairCryptoAsset(
          assetId: 4,
          networkId: 20000714,
        ),
      ),
      // BuyPairResponseItem(
      //   fiatAsset: PairFiatAsset(
      //     assetId: 'USD',
      //     decimalPlaces: 2,
      //   ),
      //   cryptoAsset: PairCryptoAsset(
      //     assetId: 5,
      //     networkId: 501,
      //   ),
      // ),
      BuyPairResponseItem(
        fiatAsset: PairFiatAsset(
          assetId: 'USD',
          decimalPlaces: 2,
          minimum: 11,
          maximum: 2500,
        ),
        cryptoAsset: PairCryptoAsset(
          assetId: 5,
          networkId: 20000714,
        ),
      ),
      BuyPairResponseItem(
        fiatAsset: PairFiatAsset(
          assetId: 'USD',
          decimalPlaces: 2,
          minimum: 11,
          maximum: 2500,
        ),
        cryptoAsset: PairCryptoAsset(
          assetId: 6,
          networkId: 20000714,
        ),
      ),
      BuyPairResponseItem(
        fiatAsset: PairFiatAsset(
          assetId: 'USD',
          decimalPlaces: 2,
          minimum: 11,
          maximum: 2500,
        ),
        cryptoAsset: PairCryptoAsset(
          assetId: 7,
          networkId: 20000714,
        ),
      ),
      BuyPairResponseItem(
        fiatAsset: PairFiatAsset(
          assetId: 'USD',
          decimalPlaces: 2,
          minimum: 11,
          maximum: 2500,
        ),
        cryptoAsset: PairCryptoAsset(
          assetId: 8,
          networkId: 20000714,
        ),
      ),
      BuyPairResponseItem(
        fiatAsset: PairFiatAsset(
          assetId: 'USD',
          decimalPlaces: 2,
          minimum: 11,
          maximum: 2500,
        ),
        cryptoAsset: PairCryptoAsset(
          assetId: 9,
          networkId: 20000714,
        ),
      ),
      BuyPairResponseItem(
        fiatAsset: PairFiatAsset(
          assetId: 'USD',
          decimalPlaces: 2,
          minimum: 11,
          maximum: 2500,
        ),
        cryptoAsset: PairCryptoAsset(
          assetId: 150,
          networkId: 20000714,
        ),
      ),
    ];

    return pairs;
  }

  // Future<List<BuyHistoryResponseItem>> history() async {
  //   final res = await _buyService.history();
  //   final body = res.body;
  //   if (res.isSuccessful && body != null) {
  //     return body
  //       ..sort((a, b) => a.lastUpdatedAt.millisecondsSinceEpoch >
  //               b.lastUpdatedAt.millisecondsSinceEpoch
  //           ? 1
  //           : -1);
  //   }

  //   throw Exception("Fetching buy pairs has failed: ${res.error.toString()}");
  // }

  // Future<BuyHistoryResponseItem> currentOrder() async {
  //   final res = await history();
  //   return res.last;
  // }

  // Future<BuyConvertResponse> convert({
  //   required String fiatAssetId,
  //   required int cryptoAssetId,
  //   required int cryptoNetworkId,
  //   required double amount,
  //   bool fromCrypto = true,
  // }) async {
  //   final res = fromCrypto
  //       ? await _buyService.convertForCrypto(
  //           BuyConvertBodyForCrypto(
  //             fiatAsset: ConvertFiatAssetWithoutAmount(
  //               assetId: fiatAssetId,
  //             ),
  //             cryptoAsset: ConvertCryptoAsset(
  //               assetId: cryptoAssetId,
  //               networkId: cryptoNetworkId,
  //               amount: amount,
  //             ),
  //           ),
  //         )
  //       : await _buyService.convertForFiat(
  //           BuyConvertBodyForFiat(
  //             fiatAsset: ConvertFiatAsset(
  //               assetId: fiatAssetId,
  //               amount: amount,
  //             ),
  //             cryptoAsset: ConvertCryptoAssetWithoutAmount(
  //               assetId: cryptoAssetId,
  //               networkId: cryptoNetworkId,
  //             ),
  //           ),
  //         );

  //   final body = res.body;
  //   if (res.isSuccessful && body != null) return body;

  //   throw Exception("Converting amount has failed: ${res.error.toString()}");
  // }

  //TODO: Mocked convert response for MVP. Return to get data from Backend.
  Future<BuyConvertResponse> convert({
    required String fiatAssetId,
    required int cryptoAssetId,
    required int cryptoNetworkId,
    required double amount,
    bool fromCrypto = true,
  }) async {
    if (amount == 0) throw Exception("Converting zero amount");

    double cryptoAssetAmount = 0;

    switch (cryptoNetworkId) {
      case 20000714:
        cryptoAssetAmount = amount * 1.235;
        break;
      case 501:
        cryptoAssetAmount = amount / 14.75;
        break;
      case 0:
        cryptoAssetAmount = amount / 15744.74;
        break;
      default:
        cryptoAssetAmount = amount * 1.235;
        break;
    }

    final BuyConvertResponse convertedValue = BuyConvertResponse(
      fiatAsset: FiatAsset(
        assetId: 'USD',
        amount: amount,
      ),
      cryptoAsset: CryptoAsset(
        assetId: cryptoAssetId,
        networkId: cryptoNetworkId,
        amount: cryptoAssetAmount,
      ),
      targetAmount: FeeAsset(assetId: fiatAssetId, amount: 2.5),
    );
    return convertedValue;
  }

  // Future<BuyOrderResponse> buy({
  //   required BuyConvertResponse convertResponse,
  //   required String walletAddress,
  // }) async {
  //   final res = await _buyService.initialize(BuyOrderBody(
  //     fiatAsset: ConvertFiatAsset(
  //       assetId: convertResponse.fiatAsset.assetId,
  //       amount: convertResponse.fiatAsset.amount,
  //     ),
  //     cryptoAsset: ConvertCryptoAssetWithoutAmount(
  //       assetId: convertResponse.cryptoAsset.assetId,
  //       networkId: convertResponse.cryptoAsset.networkId,
  //     ),
  //     targetAmount: ConvertTargetAmount(
  //       assetId: convertResponse.targetAmount.assetId,
  //       amount: convertResponse.targetAmount.amount,
  //     ),
  //     walletAddress: walletAddress,
  //   ));

  //   final body = res.body;
  //   if (res.isSuccessful && body != null) return body;

  //   if (res.statusCode == HttpStatus.badRequest) {
  //     throw BadRequestHttpError.fromObject(res.error);
  //   }

  //   throw Exception("Could not create buy order: ${res.error.toString()}");
  // }

  // Future<StatusResponse> status(String orderId) async {
  //   final res = await _buyService.status(orderId);

  //   final body = res.body;
  //   if (res.isSuccessful && body != null) return body;

  //   throw Exception(
  //       "Could not get status with orderId $orderId - ${res.error.toString()}");
  // }
}
