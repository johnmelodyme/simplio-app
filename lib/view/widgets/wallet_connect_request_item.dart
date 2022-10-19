import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:simplio_app/data/repositories/wallet_connect_repository.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/highlighted_elevated_button.dart';
import 'package:sio_glyphs/sio_icons.dart';

abstract class WalletConnectRequestItem<T extends WalletConnectRequest>
    extends Widget {
  final T request;

  const WalletConnectRequestItem({super.key, required this.request});
}

class WalletConnectTransactionRequestItem extends StatefulWidget
    implements WalletConnectRequestItem<WalletConnectTransactionRequest> {
  @override
  final WalletConnectTransactionRequest request;
  final Future Function() onApprove;
  final Future Function() onReject;

  const WalletConnectTransactionRequestItem({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onReject,
  });

  @override
  State<WalletConnectTransactionRequestItem> createState() =>
      _WalletConnectTransactionRequestItemState();
}

class _WalletConnectTransactionRequestItemState
    extends State<WalletConnectTransactionRequestItem> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final asset = Assets.getNetworkDetail(60);
    return _ItemCard(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(
                Dimensions.padding10,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.padding32,
                    ),
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: Material(
                        clipBehavior: Clip.antiAlias,
                        color: asset.style.foregroundColor,
                        elevation: 4.0,
                        shape: const CircleBorder(),
                        child: asset.style.icon,
                      ),
                    ),
                  ),
                  Text(
                    widget.request.amount.toString(),
                    textAlign: TextAlign.center,
                    style: SioTextStyles.h2.copyWith(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.padding10,
                    ),
                    child: Text(
                      "${widget.request.peer.name} requests a transaction",
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: SioColors.highlight1,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(RadiusSize.radius20),
                    color: SioColors.secondary1,
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.padding10),
                      child: Row(
                        children: const [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(
                                Dimensions.padding10,
                              ),
                              // TODO - When widgets will be redesigned, add translations.
                              child: Text('Detail'),
                            ),
                          ),
                          Icon(
                            SioIcons.arrow_right,
                            size: 14.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _isLoading
              ? const ElevatedButton(
                  onPressed: null,
                  child: CircularProgressIndicator.adaptive(),
                )
              : Padding(
                  padding: const EdgeInsets.all(Dimensions.padding10),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() => _isLoading = true);
                            widget.onReject().onError((_, __) {
                              setState(() => _isLoading = false);
                            });
                          },
                          // TODO - When widgets will be redesigned, add translations.
                          child: const Text('Reject'),
                        ),
                      ),
                      Expanded(
                        child: HighlightedElevatedButton(
                          onPressed: () {
                            setState(() => _isLoading = true);
                            widget.onApprove().onError((_, __) {
                              setState(() => _isLoading = false);
                            });
                          },
                          // TODO - When widgets will be redesigned, add translations.
                          label:
                              widget.request.type == TransactionRequestType.send
                                  ? 'Send'
                                  : 'Sign',
                        ),
                      )
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class WalletConnectSignatureRequestItem extends StatefulWidget
    implements WalletConnectRequestItem<WalletConnectSignatureRequest> {
  @override
  final WalletConnectSignatureRequest request;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const WalletConnectSignatureRequestItem({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onReject,
  });

  @override
  State<WalletConnectSignatureRequestItem> createState() {
    return _WalletConnectSignatureRequestItemState();
  }
}

class _WalletConnectSignatureRequestItemState
    extends State<WalletConnectSignatureRequestItem> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _ItemCard(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(
                Dimensions.padding10,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.padding32,
                    ),
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: Material(
                        clipBehavior: Clip.antiAlias,
                        elevation: 4.0,
                        shape: const CircleBorder(),
                        child: Image.network(widget.request.peer.icons.first),
                      ),
                    ),
                  ),
                  Text(
                    widget.request.peer.name,
                    style: SioTextStyles.h2,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.padding10,
                    ),
                    // TODO - When widgets will be redesigned, add translations.
                    child: Text(
                      'Requests a signature',
                      style: TextStyle(
                        color: SioColors.highlight1,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(RadiusSize.radius20),
                    color: SioColors.secondary1,
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.padding10),
                      child: Row(
                        children: const [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(
                                Dimensions.padding10,
                              ),
                              // TODO - When widgets will be redesigned, add translations.
                              child: Text('Detail'),
                            ),
                          ),
                          Icon(SioIcons.arrow_right, size: 14.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _isLoading
              ? const ElevatedButton(
                  onPressed: null,
                  child: CircularProgressIndicator.adaptive(),
                )
              : Padding(
                  padding: const EdgeInsets.all(Dimensions.padding10),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() => _isLoading = true);
                            widget.onReject();
                          },
                          // TODO - When widgets will be redesigned, add translations.
                          child: const Text('Ignore'),
                        ),
                      ),
                      Expanded(
                        child: HighlightedElevatedButton(
                          onPressed: () {
                            setState(() => _isLoading = true);
                            widget.onApprove();
                          },
                          // TODO - When widgets will be redesigned, add translations.
                          label:
                              widget.request.type == TransactionRequestType.send
                                  ? 'Send'
                                  : 'Sign',
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class WalletConnectSessionRequestItem extends StatefulWidget
    implements WalletConnectRequestItem<WalletConnectSessionRequest> {
  @override
  final WalletConnectSessionRequest request;
  final Function(int networkId) onApprove;
  final Function() onReject;

  const WalletConnectSessionRequestItem({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onReject,
  });

  @override
  State<WalletConnectSessionRequestItem> createState() =>
      _WalletConnectSessionRequestItemState();
}

class _WalletConnectSessionRequestItemState
    extends State<WalletConnectSessionRequestItem> {
  bool selectNetwork = false;

  @override
  Widget build(BuildContext context) {
    final network = Assets.getNetworkDetail(widget.request.networkId);

    return _ItemCard(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(
                Dimensions.padding10,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.padding32,
                    ),
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: Material(
                        clipBehavior: Clip.antiAlias,
                        elevation: 4.0,
                        shape: const CircleBorder(),
                        child: Image.network(widget.request.peer.icons.first),
                      ),
                    ),
                  ),
                  Text(
                    widget.request.peer.name,
                    textAlign: TextAlign.center,
                    style: SioTextStyles.h2.copyWith(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.padding10,
                    ),
                    child: Text(
                      'wants to connect with your wallet',
                      style: TextStyle(
                        color: SioColors.highlight1,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(RadiusSize.radius20),
                    color: SioColors.secondary1,
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.padding10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            maxRadius: 14.0,
                            backgroundColor: network.style.primaryColor,
                            child: network.style.icon,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(
                                Dimensions.padding10,
                              ),
                              child: Text(
                                network.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const Icon(
                            SioIcons.arrow_right,
                            size: 14.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Dimensions.padding10),
            child: Row(children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onReject,
                  // TODO - When widgets will be redesigned, add translations.
                  child: const Text('Reject'),
                ),
              ),
              Expanded(
                child: HighlightedElevatedButton(
                  onPressed: () => widget.onApprove(widget.request.networkId),
                  // TODO - When widgets will be redesigned, add translations.
                  label: 'Approve',
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}

class WalletConnectUnknownEventItem<T extends WalletConnectRequest>
    extends StatelessWidget implements WalletConnectRequestItem<T> {
  @override
  final T request;
  const WalletConnectUnknownEventItem({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) => Container();
}

class _ItemCard extends StatelessWidget {
  final Widget child;

  const _ItemCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 320,
      ),
      child: Material(
        elevation: 20.0,
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(RadiusSize.radius20),
        color: SioColors.secondary1,
        child: child,
      ),
    );
  }
}
