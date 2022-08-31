import 'package:flutter/material.dart';
import 'package:simplio_app/data/model/asset_wallet.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/screens/mixins/wallet_utils_mixin.dart';
import 'package:simplio_app/view/themes/common_theme.dart';
import 'package:simplio_app/view/widgets/headline_text.dart';

class AssetSendScreen extends StatelessWidget with WalletUtilsMixin {
  final String? assetId;
  final String? networkId;
  AssetSendScreen({super.key, required this.assetId, this.networkId});

  @override
  Widget build(BuildContext context) {
    if (assetId == null) {
      throw Exception('No assetId provided');
    }

    AssetWallet? assetWallet = getAssetWallet(context, assetId!);

    if (assetWallet == null) {
      throw Exception('No AssetWallet Provided');
    }

    return Scaffold(
      appBar: AppBar(
        title: HeadlineText(
          '${context.locale.sendCoinsBtn} ${assetWallet.toString()}',
          headlineSize: HeadlineSize.small,
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: CommonTheme.horizontalPadding,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => {},
                child: Text(context.locale.sendCoinsBtn),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
