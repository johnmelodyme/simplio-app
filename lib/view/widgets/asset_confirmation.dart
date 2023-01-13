import 'package:flutter/material.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/view/helpers/custom_painters.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/button/highlighted_elevated_button.dart';
import 'package:simplio_app/view/widgets/button/gradient_bordered_text_button.dart';
import 'package:sio_glyphs/sio_icons.dart';

enum DialogType { createAsset, removeAsset, cancelEarning, disconnectDapp }

class AssetConfirmation extends StatelessWidget {
  const AssetConfirmation({
    super.key,
    required this.dialogType,
  });

  final DialogType dialogType;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
        child: Column(
          children: [
            Gaps.gap50,
            Stack(
              children: [
                CustomPaint(
                  painter: CirclePainter(
                    center: const Offset(10, 10),
                    radius: 20,
                    color: SioColors.mentolGreen,
                  ),
                ),
                CustomPaint(
                  painter: CirclePainter(
                    center: const Offset(10, 10),
                    radius: 18,
                    color: SioColors.softBlack,
                  ),
                ),
                _Icon(dialogType: dialogType),
              ],
            ),
            Gaps.gap25,
            _Label(dialogType: dialogType),
            Gaps.gap30,
            Padding(
              padding: Paddings.horizontal16,
              child: Row(
                children: [
                  Expanded(
                    child: GradientBorderedTextButton(
                      label: _cancelAction(dialogType, context),
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ),
                  Gaps.gap16,
                  Expanded(
                    child: HighlightedElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      label: _proceedAction(dialogType, context),
                    ),
                  ),
                ],
              ),
            ),
            Gaps.gap30,
          ],
        ),
      ),
    );
  }

  String _proceedAction(DialogType dialogType, BuildContext context) {
    switch (dialogType) {
      case DialogType.createAsset:
        return context.locale.common_continue;
      case DialogType.cancelEarning:
        return context.locale.common_cancel;
      case DialogType.disconnectDapp:
        return context.locale.common_disconnect;
      case DialogType.removeAsset:
        return context.locale.common_remove;
    }
  }

  String _cancelAction(DialogType dialogType, BuildContext context) {
    switch (dialogType) {
      case DialogType.createAsset:
      case DialogType.cancelEarning:
      case DialogType.disconnectDapp:
      case DialogType.removeAsset:
        return context.locale.slide_up_dialog_do_nothing;
    }
  }
}

class _Icon extends StatelessWidget {
  final DialogType dialogType;

  const _Icon({required this.dialogType});

  @override
  Widget build(BuildContext context) {
    switch (dialogType) {
      case DialogType.createAsset:
        return Icon(
          SioIcons.plus,
          color: SioColors.highlight,
          size: 20,
        );
      case DialogType.cancelEarning:
      case DialogType.removeAsset:
        return Icon(
          SioIcons.cancel,
          color: SioColors.attention,
          size: 20,
        );
      case DialogType.disconnectDapp:
        return Icon(
          Icons.link_off_outlined, // todo: use correct icon
          color: SioColors.attention,
          size: 20,
        );
    }
  }
}

class _Label extends StatelessWidget {
  final DialogType dialogType;

  const _Label({required this.dialogType});

  @override
  Widget build(BuildContext context) {
    switch (dialogType) {
      case DialogType.createAsset:
        return _CreateCoinText();
      case DialogType.cancelEarning:
        return _CancelEarningText();
      case DialogType.disconnectDapp:
        return _DisconnectDAppText();
      case DialogType.removeAsset:
        return _RemoveCoinText();
    }
  }
}

class _CreateCoinText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: context.locale.slide_up_dialog_create_coin_label_1,
            style: SioTextStyles.h4.apply(
              color: SioColors.whiteBlue,
            ),
          ),
          TextSpan(
            text: context.locale.slide_up_dialog_create_coin_label_2,
            style: SioTextStyles.h4.apply(color: SioColors.mentolGreen),
          ),
          TextSpan(
            text: context.locale.slide_up_dialog_create_coin_label_3,
            style: SioTextStyles.h4.apply(
              color: SioColors.whiteBlue,
            ),
          ),
        ],
      ),
    );
  }
}

class _CancelEarningText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: context.locale.slide_up_dialog_cancel_earning_label_1,
            style: SioTextStyles.h4.apply(
              color: SioColors.whiteBlue,
            ),
          ),
          TextSpan(
            text: context.locale.slide_up_dialog_cancel_earning_label_2,
            style: SioTextStyles.h4.apply(color: SioColors.mentolGreen),
          ),
          TextSpan(
            text: context.locale.slide_up_dialog_cancel_earning_label_3,
            style: SioTextStyles.h4.apply(
              color: SioColors.whiteBlue,
            ),
          ),
        ],
      ),
    );
  }
}

class _RemoveCoinText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: context.locale.slide_up_dialog_remove_coin_1,
            style: SioTextStyles.h4.apply(
              color: SioColors.whiteBlue,
            ),
          ),
          TextSpan(
            text: context.locale.slide_up_dialog_remove_coin_2,
            style: SioTextStyles.h4.apply(color: SioColors.mentolGreen),
          ),
          TextSpan(
            text: context.locale.slide_up_dialog_remove_coin_3,
            style: SioTextStyles.h4.apply(
              color: SioColors.whiteBlue,
            ),
          ),
        ],
      ),
    );
  }
}

class _DisconnectDAppText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: context.locale.slide_up_dialog_disconnect_dapp_1,
            style: SioTextStyles.h4.apply(
              color: SioColors.whiteBlue,
            ),
          ),
          TextSpan(
            text: context.locale.slide_up_dialog_disconnect_dapp_2,
            style: SioTextStyles.h4.apply(color: SioColors.mentolGreen),
          ),
          TextSpan(
            text: context.locale.slide_up_dialog_disconnect_dapp_3,
            style: SioTextStyles.h4.apply(
              color: SioColors.whiteBlue,
            ),
          ),
        ],
      ),
    );
  }
}
