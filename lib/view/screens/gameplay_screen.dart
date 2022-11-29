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
  final Game game;
  final VoidCallback onClosed;

  const GameplayScreen({
    super.key,
    required this.game,
    required this.onClosed,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onClosed.call();
        return true;
      },
      child: SioScaffold(
        body: Stack(
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
                  return SafeArea(
                    child: InAppWebView(
                      initialUrlRequest: URLRequest(
                        url: Uri.parse(game.playUri),
                      ),
                      initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                          useShouldOverrideUrlLoading: true,
                        ),
                      ),
                      onConsoleMessage: (controller, consoleMessage) {
                        if (!WalletConnectUriValidator.validate(
                          consoleMessage.message,
                        )) return;

                        final s = context.read<AccountWalletCubit>().state;
                        if (s is AccountWalletProvided) {
                          context
                              .read<WalletConnectCubit>()
                              .openApprovedSession(
                                s.wallet.uuid,
                                uri: consoleMessage.message,
                                sessionId: _sessionId,
                                networkId: game.assetEmbedded.networkId,
                              );
                        }
                      },
                    ),
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
              bottom:
                  MediaQuery.of(context).padding.bottom + Dimensions.padding16,
              right: Dimensions.padding16,
              child: GestureDetector(
                onTap: () async {
                  context
                      .read<WalletConnectCubit>()
                      .closeSessionBySessionId(_sessionId);

                  onClosed.call();
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
    );
  }
}
