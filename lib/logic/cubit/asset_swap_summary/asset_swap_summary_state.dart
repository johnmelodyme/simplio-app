part of 'asset_swap_summary_cubit.dart';

abstract class AssetSwapSummaryState extends Equatable {
  const AssetSwapSummaryState();

  @override
  List<Object?> get props => [];
}

class AssetSwapSummaryInit extends AssetSwapSummaryState {
  const AssetSwapSummaryInit();
}

class AssetSwapSummaryConvertedSuccess extends AssetSwapSummaryState {
  final SwapAsset source;
  final SwapAsset target;
  final BigDecimal cryptoAmount;
  final SwapParametersResponse response;
  final DateTime timestamp;

  const AssetSwapSummaryConvertedSuccess({
    required this.source,
    required this.target,
    required this.cryptoAmount,
    required this.response,
    required this.timestamp,
  });
}

class AssetSwapSummaryConvertedFailure extends AssetSwapSummaryState {
  final SwapAsset source;
  final SwapAsset target;
  final BigDecimal cryptoAmount;
  final Exception error;

  const AssetSwapSummaryConvertedFailure({
    required this.source,
    required this.target,
    required this.cryptoAmount,
    required this.error,
  });

  @override
  List<Object?> get props => [
        source,
        target,
        cryptoAmount,
        error,
      ];
}

class AssetSwapSummarySwapping extends AssetSwapSummaryState {
  const AssetSwapSummarySwapping();
}

class AssetSwapSummarySwappedSuccess extends AssetSwapSummaryState {
  const AssetSwapSummarySwappedSuccess();
}

class AssetSwapSummarySwappedFailure extends AssetSwapSummaryState {
  final Exception error;

  const AssetSwapSummarySwappedFailure({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
