import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/dialog/dialog_cubit.dart';
import 'package:simplio_app/view/helpers/custom_painters.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/gradient_text_button.dart';
import 'package:simplio_app/view/widgets/outlined_container.dart';
import 'package:sio_glyphs/sio_icons.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// TODO - Why not to use the built-in ModalBottomSheet widget?
// TODO - Consider to remove or refactor. I causes multiple issues.
abstract class ScreenWithDialog extends StatefulWidget {
  const ScreenWithDialog({
    this.withBottomTabBar = false,
    super.key,
  });

  final bool withBottomTabBar;

  @override
  State<ScreenWithDialog> createState() => _ScreenWithDialogState();

  Widget innerBuild(BuildContext context);
}

class _ScreenWithDialogState extends State<ScreenWithDialog> {
  final PanelController panelController = PanelController();

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return BlocListener<DialogCubit, DialogState>(
      listener: (context, state) {
        if (state.displayed) panelController.open();
        if (!state.displayed) panelController.close();
      },
      child: SlidingUpPanel(
        controller: panelController,
        color: Colors.transparent,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(RadiusSize.radius20),
          topRight: Radius.circular(RadiusSize.radius20),
        ),
        boxShadow: null,
        minHeight: 0,
        maxHeight: Constants.dialogHeight +
            (widget.withBottomTabBar ? Constants.bottomTabBarHeight : 0),
        body: Stack(
          children: [
            widget.innerBuild(context),
            BlocBuilder<DialogCubit, DialogState>(
              buildWhen: (prev, curr) => prev.displayed != curr.displayed,
              builder: (context, state) => (state.displayed)
                  ? GestureDetector(
                      onTap: () => context.read<DialogCubit>().hideDialog(),
                      child: Opacity(
                        opacity: 0.1,
                        child: Container(
                          color: Colors.transparent,
                          height: double.infinity,
                          width: double.infinity,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
        panel: BlocBuilder<DialogCubit, DialogState>(
          buildWhen: (prev, curr) => prev.dialogType != curr.dialogType,
          builder: (context, state) => Container(
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
                Gaps.gap40,
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
                    _Icon(dialogType: state.dialogType),
                  ],
                ),
                const Spacer(),
                _Label(dialogType: state.dialogType),
                const Spacer(),
                Padding(
                  padding: Paddings.horizontal16,
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadii.radius30,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => context
                                  .read<DialogCubit>()
                                  .onActionTap(false),
                              child: SizedBox(
                                height: Constants.earningButtonHeight,
                                child: OutlinedContainer(
                                  strokeWidth: 1,
                                  radius: RadiusSize.radius30,
                                  gradient: LinearGradient(
                                    colors: [
                                      SioColors.highlight1,
                                      SioColors.vividBlue,
                                    ],
                                  ),
                                  child: Padding(
                                    padding: Paddings.horizontal20,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _cancelAction(
                                              state.dialogType, context),
                                          style: SioTextStyles.buttonLarge
                                              .copyWith(
                                            color: SioColors.whiteBlue,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gaps.gap16,
                      Expanded(
                        child: GradientTextButton(
                            _proceedAction(state.dialogType, context),
                            enabled: true,
                            onPressed: () =>
                                context.read<DialogCubit>().onActionTap(true)),
                      ),
                    ],
                  ),
                ),
                Gaps.gap30,
                if (widget.withBottomTabBar)
                  const SizedBox(
                      height:
                          Constants.bottomTabBarHeight + Dimensions.padding20)
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _proceedAction(DialogType dialogType, BuildContext context) {
    switch (dialogType) {
      case DialogType.createCoin:
        return context.locale.common_continue;
      case DialogType.cancelEarning:
        return context.locale.common_cancel;
      case DialogType.disconnectDApp:
        return context.locale.common_disconnect;
      case DialogType.removeCoin:
        return context.locale.common_remove;
    }
  }

  String _cancelAction(DialogType dialogType, BuildContext context) {
    switch (dialogType) {
      case DialogType.createCoin:
      case DialogType.cancelEarning:
      case DialogType.disconnectDApp:
      case DialogType.removeCoin:
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
      case DialogType.createCoin:
        return Icon(
          SioIcons.plus,
          color: SioColors.highlight,
          size: 20,
        );
      case DialogType.cancelEarning:
      case DialogType.removeCoin:
        return Icon(
          SioIcons.cancel,
          color: SioColors.attention,
          size: 20,
        );
      case DialogType.disconnectDApp:
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
      case DialogType.createCoin:
        return _CreateCoinText();
      case DialogType.cancelEarning:
        return _CancelEarningText();
      case DialogType.disconnectDApp:
        return _DisconnectDAppText();
      case DialogType.removeCoin:
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
