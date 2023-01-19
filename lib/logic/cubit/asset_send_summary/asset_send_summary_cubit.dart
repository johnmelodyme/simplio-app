import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/repositories/interfaces/wallet_repository.dart';

part 'asset_send_summary_state.dart';

class AssetSendSummaryCubit extends Cubit<AssetSendSummaryState> {
  AssetSendSummaryCubit._() : super(const AssetSendSummaryInit());

  AssetSendSummaryCubit({
    required WalletRepository walletRepository,
  }) : this._();
}
