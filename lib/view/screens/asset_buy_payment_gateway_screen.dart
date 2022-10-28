import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/asset_buy_form/asset_buy_form_cubit.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AssetBuyPaymentGateWayScreen extends StatefulWidget {
  const AssetBuyPaymentGateWayScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AssetBuyPaymentGateWayScreen();
}

class _AssetBuyPaymentGateWayScreen
    extends State<AssetBuyPaymentGateWayScreen> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssetBuyFormCubit, AssetBuyFormState>(
      listenWhen: (prev, curr) => curr.response is AssetBuyFormSuccess,
      listener: (context, state) => GoRouter.of(context).replaceNamed(
        AuthenticatedRouter.assetBuySuccess,
        params: {
          'assetId': state.sourceAssetWallet.assetId.toString(),
          'networkId': state.sourceNetworkWallet.networkId.toString(),
        },
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.center,
            colors: [
              SioColors.backGradient4Start,
              SioColors.softBlack,
            ],
          ),
        ),
        child: Column(
          children: [
            ColorizedAppBar(
              firstPart:
                  context.locale.asset_buy_payment_gateway_screen_payment,
              secondPart:
                  context.locale.asset_buy_payment_gateway_screen_gateway_lc,
              actionType: ActionType.back,
              onBackTap: () {
                final state = context.read<AssetBuyFormCubit>().state;
                GoRouter.of(context).replaceNamed(
                  AuthenticatedRouter.assetBuySummary,
                  params: {
                    'assetId': state.sourceAssetWallet.assetId.toString(),
                    'networkId': state.sourceNetworkWallet.networkId.toString(),
                  },
                );
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: Dimensions.padding16,
                  right: Dimensions.padding16,
                  bottom: Dimensions.padding10,
                ),
                child: BlocBuilder<AssetBuyFormCubit, AssetBuyFormState>(
                  buildWhen: (prev, curr) =>
                      prev.paymentGatewayUrl != curr.paymentGatewayUrl,
                  builder: (context, state) => WebView(
                    backgroundColor: Colors.transparent,
                    initialUrl: state.paymentGatewayUrl,
                    javascriptMode: JavascriptMode.unrestricted,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
