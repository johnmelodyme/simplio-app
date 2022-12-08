import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/http/services/marketplace_service.dart';
import 'package:simplio_app/data/repositories/helpers/wallet_connect_uri_validator.dart';
import 'package:simplio_app/logic/cubit/account_wallet/account_wallet_cubit.dart';
import 'package:simplio_app/logic/cubit/wallet_connect/wallet_connect_cubit.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';

const _sessionId = 'gameplay';

class GameplayScreen extends StatelessWidget {
  final GlobalKey _webViewKey = GlobalKey();
  final Game game;

  GameplayScreen({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SioScaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              FutureBuilder(
                future: context.read<AccountWalletCubit>().enableNetworkWallet(
                      networkId: game.assetEmbedded.networkId,
                      assetId: game.assetEmbedded.assetId,
                    ),
                builder: (context, snapshot) {
                  if (snapshot.hasError) GoRouter.of(context).pop();

                  if (snapshot.connectionState == ConnectionState.done) {
                    return _GameplayWebView(
                      webViewKey: _webViewKey,
                      playUri: game.playUri,
                      onMessage: (message) {
                        if (!WalletConnectUriValidator.validate(
                          message,
                        )) return;

                        final s = context.read<AccountWalletCubit>().state;
                        if (s is AccountWalletProvided) {
                          context
                              .read<WalletConnectCubit>()
                              .openApprovedSession(
                                s.wallet.uuid,
                                uri: message,
                                sessionId: _sessionId,
                                networkId: game.assetEmbedded.networkId,
                              );
                        }
                      },
                    );
                  }

                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: Dimensions.padding2,
                      color: SioColors.secondary4,
                      backgroundColor: SioColors.secondary2,
                    ),
                  );
                },
              ),
              Positioned(
                bottom: Dimensions.padding16,
                right: Dimensions.padding16,
                child: GestureDetector(
                  onTap: () async {
                    context
                        .read<WalletConnectCubit>()
                        .closeSessionBySessionId(_sessionId);

                    GoRouter.of(context).pop();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameplayWebView extends StatefulWidget {
  final GlobalKey? webViewKey;
  final String playUri;
  final void Function(String message) onMessage;

  const _GameplayWebView({
    required this.webViewKey,
    required this.playUri,
    required this.onMessage,
  });

  @override
  State<_GameplayWebView> createState() => _GameplayWebViewState();
}

class _GameplayWebViewState extends State<_GameplayWebView> {
  // InAppWebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SioScaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(widget.playUri.trim()),
                ),
                key: widget.webViewKey,
                initialSettings: InAppWebViewSettings(
                  // TODO - enabling cache is only for mvp.
                  cacheEnabled: true,
                  clearCache: false,
                  iframeAllowFullscreen: false,
                  isElementFullscreenEnabled: false,
                  disableInputAccessoryView: true,
                  disableContextMenu: true,
                  allowsBackForwardNavigationGestures: false,
                ),
                onWebViewCreated: (controller) => setState(() {
                  // _controller = controller;
                }),
                onConsoleMessage: (controller, consoleMessage) {
                  widget.onMessage(consoleMessage.message);
                },
              ),
              Positioned(
                bottom: Dimensions.padding16,
                right: Dimensions.padding16,
                child: GestureDetector(
                  onTap: () async {
                    context
                        .read<WalletConnectCubit>()
                        .closeSessionBySessionId(_sessionId);

                    GoRouter.of(context).pop();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    // TODO - cache is enabled for mvp purposes.
    // _controller?.clearCache();
  }
}
