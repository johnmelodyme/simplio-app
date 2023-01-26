import 'package:simplio_app/data/http/apis/asset_api.dart';

class FeeRepository {
  final AssetApi _assetApi;

  FeeRepository._(
    this._assetApi,
  );

  FeeRepository({
    required AssetApi assetApi,
  }) : this._(assetApi);

  Future<FeeData> loadFees({
    required int assetId,
    required int networkId,
  }) async {
    final res = await _assetApi.getCryptoFees(assetId, networkId);

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
  final String? unit;
  final List<BigInt> _values;

  const FeeData._(this.gasLimit, this.unit, this._values);

  const FeeData({
    required BigInt gasLimit,
    required String? unit,
    List<BigInt> values = const [],
  }) : this._(gasLimit, unit, values);

  List<BigInt> get values => _values..sort((a, b) => a.compareTo(b));

  BigInt get lowFee => values.isNotEmpty ? values.first : BigInt.zero;
  BigInt get regularFee => values.length > 1 ? values[1] : BigInt.zero;
  BigInt get highFee => values.length > 2 ? values[2] : BigInt.zero;
  BigInt get max => values.isNotEmpty ? values.last : BigInt.zero;

  int get length => _values.length;
}
