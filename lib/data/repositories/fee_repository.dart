import 'package:simplio_app/data/http/services/asset_service.dart';

class FeeRepository {
  final AssetService _assetService;

  FeeRepository._(
    this._assetService,
  );

  FeeRepository.builder({
    required AssetService assetService,
  }) : this._(assetService);

  Future<CryptoAssetResponse> _fetchCryptoFees(
    int assetId,
    int networkId,
  ) async {
    final res = await _assetService.crypto(
      selectedAssets: [assetId.toString()],
      selectedNetworks: [networkId.toString()],
    );

    final body = res.body;
    if (res.isSuccessful && body != null) return body.first;

    throw Exception(res.error);
  }

  Future<FeeData> loadFees({
    required int assetId,
    required int networkId,
  }) async {
    final res = await _fetchCryptoFees(assetId, networkId);

    return FeeData(
      gasLimit: BigInt.parse(res.gasLimit),
      unit: res.feeUnit,
      values: [
        BigInt.parse(res.lowFee),
        BigInt.parse(res.regularFee),
        BigInt.parse(res.highFee),
      ],
    );
  }
}

class FeeData {
  final BigInt gasLimit;
  final String unit;
  final List<BigInt> _values;

  const FeeData._(this.gasLimit, this.unit, this._values);

  const FeeData({
    required BigInt gasLimit,
    required String unit,
    List<BigInt> values = const [],
  }) : this._(gasLimit, unit, values);

  List<BigInt> get values => _values..sort((a, b) => a.compareTo(b));

  BigInt? get lowFee => values.isNotEmpty ? values.first : null;
  BigInt? get regularFee => values.length > 1 ? values[1] : null;
  BigInt? get highFee => values.length > 2 ? values[2] : null;
  BigInt get max => values.isNotEmpty ? values.last : BigInt.zero;

  int get length => _values.length;
}
