import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simplio_app/data/repositories/wallet_connect_repository.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/back_gradient2.dart';
import 'package:simplio_app/view/widgets/button/highlighted_elevated_button.dart';
import 'package:simplio_app/view/widgets/text/currency_text.dart';
import 'package:sio_big_decimal/sio_big_decimal.dart';
import 'package:simplio_app/view/widgets/button/outlined_sio_button.dart';

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
    final asset = Assets.getAssetDetail(widget.request.assetId);
    final preset = Assets.getAssetPreset(
      assetId: widget.request.assetId,
      networkId: widget.request.networkId,
    );
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
                      width: 52,
                      height: 52,
                      child: Material(
                        clipBehavior: Clip.antiAlias,
                        color: asset.style.foregroundColor,
                        elevation: 4.0,
                        shape: const CircleBorder(),
                        child: asset.style.icon,
                      ),
                    ),
                  ),
                  CurrencyText(
                    // TODO - make request amount a big decimal.
                    value: BigDecimal.fromBigInt(
                      widget.request.amount,
                      precision: preset.decimalPlaces,
                    ),
                    style: SioTextStyles.h3.copyWith(
                      overflow: TextOverflow.ellipsis,
                      color: SioColors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.padding10,
                    ),
                    child: Text(
                      "${widget.request.peer.name} ${context.locale.wallet_connect_request_transaction}",
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: SioColors.highlight1,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
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
                        child: OutlinedSioButton(
                          onPressed: () {
                            setState(() => _isLoading = true);
                            widget.onReject().onError((_, __) {
                              setState(() => _isLoading = false);
                            });
                          },
                          label: context.locale.common_reject,
                          // child: Text(context.locale.common_reject),
                        ),
                      ),
                      const Gap(Dimensions.padding10),
                      Expanded(
                        child: HighlightedElevatedButton.primary(
                          onPressed: () {
                            setState(() => _isLoading = true);
                            widget.onApprove().onError((_, __) {
                              setState(() => _isLoading = false);
                            });
                          },
                          label:
                              widget.request.type == TransactionRequestType.send
                                  ? context.locale.common_send_btn_label
                                  : context.locale.common_sign_btn_label,
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
                      width: 52,
                      height: 52,
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
                    style: SioTextStyles.h3.apply(color: SioColors.white),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.padding10,
                    ),
                    child: Text(
                      context.locale.wallet_connect_request_signature,
                      style: TextStyle(
                        color: SioColors.highlight1,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
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
                        child: OutlinedSioButton(
                          onPressed: () {
                            setState(() => _isLoading = true);
                            widget.onReject();
                          },
                          label: context.locale.common_ignore_btn_label,
                        ),
                      ),
                      const Gap(Dimensions.padding10),
                      Expanded(
                        child: HighlightedElevatedButton(
                          onPressed: () {
                            setState(() => _isLoading = true);
                            widget.onApprove();
                          },
                          label:
                              widget.request.type == TransactionRequestType.send
                                  ? context.locale.common_send_btn_label
                                  : context.locale.common_sign_btn_label,
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
                      width: 52,
                      height: 52,
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
                    style: SioTextStyles.h3.copyWith(
                      color: SioColors.white,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.padding10,
                    ),
                    child: Text(
                      context.locale.wallet_connect_request_session,
                      style: TextStyle(
                        color: SioColors.highlight1,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(RadiusSize.radius12),
                    color: SioColors.secondary1,
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.padding8),
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
                                style: SioTextStyles.subtitleStyle
                                    .apply(color: SioColors.white),
                              ),
                            ),
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
                child: OutlinedSioButton(
                  label: context.locale.common_reject,
                  onPressed: widget.onReject,
                ),
              ),
              const Gap(Dimensions.padding10),
              Expanded(
                child: HighlightedElevatedButton(
                  onPressed: () => widget.onApprove(widget.request.networkId),
                  label: context.locale.common_approve,
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
        elevation: 36.0,
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(RadiusSize.radius20),
        color: SioColors.transparent,
        child: BackGradient2(child: child),
      ),
    );
  }
}
