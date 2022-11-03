import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/asset_buy_form/asset_buy_form_cubit.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/screens/mixins/popup_dialog_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/list_loading.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AssetBuyPaymentGateWayScreen extends StatefulWidget {
  const AssetBuyPaymentGateWayScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AssetBuyPaymentGateWayScreen();
}

class _AssetBuyPaymentGateWayScreen extends State<AssetBuyPaymentGateWayScreen>
    with PopupDialogMixin {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssetBuyFormCubit, AssetBuyFormState>(
      listenWhen: (prev, curr) =>
          curr.response is AssetBuyFormSuccess ||
          curr.response is AssetBuyFormFailure,
      listener: (context, state) {
        if (state.response is AssetBuyFormSuccess) {
          GoRouter.of(context).pop();
          GoRouter.of(context).replaceNamed(
            AuthenticatedRouter.assetBuySuccess,
            params: {
              'assetId': state.sourceAssetWallet.assetId.toString(),
              'networkId': state.sourceNetworkWallet.networkId.toString(),
            },
          );
        } else if (state.response is AssetBuyFormFailure) {
          showError(
            context,
            message: context
                .locale.asset_buy_payment_gateway_screen_payment_failed_msg,
            afterHideAction: () => GoRouter.of(context).pop(),
          );
        }
      },
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
                  builder: (context, state) => state.paymentGatewayUrl.isEmpty
                      ? const ListLoading()
                      : WebView(
                          backgroundColor: Colors.transparent,
                          initialUrl: state.paymentGatewayUrl,
                          javascriptMode: JavascriptMode.unrestricted,
                          onPageStarted: (url) {
                            // this is temporary solution to prevent showing swipelux summary page to the user
                            if (url.isNotEmpty &&
                                (url.contains(
                                        'https://swipelux.com/order.html?') ||
                                    url.contains(
                                        'https://pay.mercuryo.io/response'))) {
                              context.read<AssetBuyFormCubit>().clearTimers();
                              context
                                  .read<AssetBuyFormCubit>()
                                  .navigateToSuccessPage();
                            }
                          },
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
