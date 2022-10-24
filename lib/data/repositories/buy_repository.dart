import 'dart:io';
import 'package:simplio_app/data/http/errors/bad_request_http_error.dart';
import 'package:simplio_app/data/http/services/account_service.dart';
import 'package:simplio_app/data/http/services/buy_service.dart';

class BuyRepository {
  final AccountService _accountService;
  final BuyService _buyService;

  BuyRepository._(
    this._accountService,
    this._buyService,
  );

  BuyRepository({
    required AccountService accountService,
    required BuyService buyService,
  }) : this._(
          accountService,
          buyService,
        );

  Future<List<BuyPairResponseItem>> pairs({
    bool readCache = true,
  }) async {
    final res = await _buyService.pairs();

    final body = res.body;
    if (res.isSuccessful && body != null) return body.items;

    throw Exception("Fetching buy pairs has failed: ${res.error.toString()}");
  }

  Future<List<BuyHistoryResponseItem>> history() async {
    final res = await _buyService.history();
    final body = res.body;
    if (res.isSuccessful && body != null) {
      return body
        ..sort((a, b) => a.lastUpdatedAt.millisecondsSinceEpoch >
                b.lastUpdatedAt.millisecondsSinceEpoch
            ? 1
            : -1);
    }

    throw Exception("Fetching buy pairs has failed: ${res.error.toString()}");
  }

  Future<BuyHistoryResponseItem> currentOrder() async {
    final res = await history();
    return res.last;
  }

  Future<BuyConvertResponse> convert({
    required String fiatAssetId,
    required int cryptoAssetId,
    required double amount,
    bool fromCrypto = true,
  }) async {
    final res = fromCrypto
        ? await _buyService.convertForCrypto(
            BuyConvertBodyForCrypto(
              fiatAsset: ConvertFiatAssetWithoutAmount(
                assetId: fiatAssetId,
              ),
              cryptoAsset: ConvertCryptoAsset(
                assetId: cryptoAssetId,
                amount: amount,
              ),
            ),
          )
        : await _buyService.convertForFiat(
            BuyConvertBodyForFiat(
              fiatAsset: ConvertFiatAsset(
                assetId: fiatAssetId,
                amount: amount,
              ),
              cryptoAsset: ConvertCryptoAssetWithoutAmount(
                assetId: cryptoAssetId,
              ),
            ),
          );

    final body = res.body;
    if (res.isSuccessful && body != null) return body;

    throw Exception("Converting amount has failed: ${res.error.toString()}");
  }

  Future<BuyOrderResponse> buy({
    required BuyConvertResponse convertResponse,
    required String walletAddress,
  }) async {
    final profile = await _getAccountProfile();

    if (!profile.isVerified) {
      throw Exception('Account is not verified.');
    }

    if (profile.applicantId == null) {
      throw Exception("Account does not have 'applicantId'.");
    }

    final res = await _buyService.initialize(BuyOrderBody(
      fiatAsset: ConvertFiatAsset(
        assetId: convertResponse.fiatAsset.assetId,
        amount: convertResponse.fiatAsset.amount,
      ),
      cryptoAsset: ConvertCryptoAssetWithoutAmount(
        assetId: convertResponse.cryptoAsset.assetId,
      ),
      targetAmount: ConvertTargetAmount(
        assetId: convertResponse.fee.assetId.toString(),
        amount: double.parse(convertResponse.fee.amount),
      ),
      walletAddress: walletAddress,
      applicantId: profile.applicantId!,
    ));

    final body = res.body;
    if (res.isSuccessful && body != null) return body;

    if (res.statusCode == HttpStatus.badRequest) {
      throw BadRequestHttpError.fromObject(res.error);
    }

    throw Exception("Could not create buy order: ${res.error.toString()}");
  }

  Future<StatusResponse> status(String orderId) async {
    final res = await _buyService.status(orderId);

    final body = res.body;
    if (res.isSuccessful && body != null) return body;

    throw Exception(
        "Could not get status with orderId $orderId - ${res.error.toString()}");
  }

  Future<AccountProfileResponse> _getAccountProfile() async {
    final res = await _accountService.profile();

    final body = res.body;
    if (res.isSuccessful && body != null) return body;

    throw Exception("Could not fetch account profile: ${res.error.toString()}");
  }
}
