import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/bordered_text_button.dart';
import 'package:simplio_app/view/widgets/button/highlighted_elevated_button.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/view/widgets/text/highlighted_text.dart';

// TODO - refactor this dialog to dilalog for creating new asset wallet.
class AssetSwapReloadDialog extends StatefulWidget {
  final AsyncCallback onReload;
  final VoidCallback onDismiss;

  const AssetSwapReloadDialog({
    super.key,
    required this.onReload,
    required this.onDismiss,
  });

  @override
  State<AssetSwapReloadDialog> createState() => _AssetSwapReloadDialogState();
}

class _AssetSwapReloadDialogState extends State<AssetSwapReloadDialog> {
  Future<void>? _onReload;

  bool get _isConfirming => _onReload != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: Paddings.vertical16,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.only(
          topStart: BorderRadii.radius20.topLeft,
          topEnd: BorderRadii.radius20.topLeft,
          bottomEnd: Radius.zero,
          bottomStart: Radius.zero,
        ),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            SioColors.softBlack,
            SioColors.backGradient4Start,
          ],
        ),
      ),
      height: 300,
      child: _isConfirming
          ? FutureBuilder(
              future: _onReload,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: SioColors.mentolGreen,
                        ),
                        Gaps.gap16,
                        Text(
                          context.locale.asset_swap_reload_dialog_loading,
                          style: SioTextStyles.bodyS.copyWith(
                            color: SioColors.secondary6,
                          ),
                        ),
                      ],
                    );
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return _ErrorDialogContent(
                        onReload: () => setState(() {
                          _onReload = widget.onReload();
                        }),
                        onDismiss: widget.onDismiss,
                      );
                    }
                    Navigator.of(context).pop();
                    return const SizedBox.shrink();
                }
              },
            )
          : _InitialDialogContent(
              onReload: () => setState(() {
                _onReload = widget.onReload();
              }),
              onDismiss: widget.onDismiss,
            ),
    );
  }
}

class _InitialDialogContent extends StatelessWidget {
  final VoidCallback onReload;
  final VoidCallback onDismiss;

  const _InitialDialogContent({
    required this.onReload,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: HighlightedText(
              context.locale.asset_swap_reload_dialog_label,
              textAlign: TextAlign.center,
              style: SioTextStyles.h4.apply(
                color: SioColors.whiteBlue,
              ),
              highlightedStyle: SioTextStyles.h4.apply(
                color: SioColors.mentolGreen,
              ),
            ),
          ),
        ),
        SafeArea(
          top: false,
          left: false,
          right: false,
          child: Padding(
            padding: Paddings.horizontal20,
            child: Row(
              children: [
                Flexible(
                  child: BorderedTextButton(
                    label: context.locale.common_dismiss,
                    onPressed: onDismiss,
                  ),
                ),
                Gaps.gap16,
                Flexible(
                  child: HighlightedElevatedButton.primary(
                    label: context.locale.common_confirm,
                    onPressed: onReload,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _ErrorDialogContent extends StatelessWidget {
  final VoidCallback onReload;
  final VoidCallback onDismiss;

  const _ErrorDialogContent({
    required this.onReload,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: HighlightedText(
              context.locale.asset_swap_reload_dialog_error_label,
              textAlign: TextAlign.center,
              style: SioTextStyles.h4.apply(
                color: SioColors.whiteBlue,
              ),
              highlightedStyle: SioTextStyles.h4.apply(
                color: SioColors.attention,
              ),
            ),
          ),
        ),
        SafeArea(
          top: false,
          left: false,
          right: false,
          child: Padding(
            padding: Paddings.horizontal20,
            child: Row(
              children: [
                Flexible(
                  child: BorderedTextButton(
                    label: context.locale.common_dismiss,
                    onPressed: onDismiss,
                  ),
                ),
                Gaps.gap16,
                Flexible(
                  child: HighlightedElevatedButton.primary(
                    label: context.locale.common_try_again,
                    onPressed: onReload,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
