import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/http/services/swap_service.dart';
import 'package:simplio_app/data/repositories/swap_repository.dart';
import 'package:simplio_app/data/repositories/interfaces/wallet_repository.dart';
import 'package:sio_big_decimal/sio_big_decimal.dart';

part 'asset_swap_summary_state.dart';

class AssetSwapSummaryCubit extends Cubit<AssetSwapSummaryState> {
  AssetSwapSummaryCubit._() : super(const AssetSwapSummaryInit());

  AssetSwapSummaryCubit({
    required SwapRepository swapRepository,
    required WalletRepository walletRepository,
  }) : this._();
}
