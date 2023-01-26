import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/models/wallet.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';

mixin WalletUtilsMixin {
  AssetWallet? getAssetWallet(
    BuildContext context,
    String assetId,
  ) {
    final state = context.read<AccountWalletCubit>().state;
    return state is AccountWalletProvided
        ? state.wallet.getWallet(int.parse(assetId))
        : throw Exception('No asset wallet found');
  }

  NetworkWallet? getNetwork(
      BuildContext context, String assetId, String networkId) {
    return getAssetWallet(context, assetId)
        ?.wallets
        .firstWhere((element) => element.networkId == int.parse(networkId));
  }

  String? getAddress(BuildContext context, String assetId, String? networkId) {
    return networkId == null
        ? getAssetWallet(context, assetId)
            ?.getWallet(int.parse(assetId))
            ?.walletAddress
        : getNetwork(context, assetId, networkId)?.walletAddress;
  }
}
