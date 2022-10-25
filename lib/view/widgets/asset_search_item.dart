import 'package:flutter/material.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/avatar_with_shadow.dart';
import 'package:simplio_app/view/widgets/back_gradient2.dart';
import 'package:simplio_app/view/widgets/small_button.dart';
import 'package:sio_glyphs/sio_icons.dart';

class AssetSearchItem extends StatelessWidget {
  const AssetSearchItem({
    super.key,
    required this.label,
    required this.priceLabel,
    required this.assetIcon,
    this.onTap,
    required this.assetAction,
    required this.onActionPressed,
  });

  final String label;
  final String priceLabel;
  final Widget assetIcon;
  final Function? onTap;
  final List<AssetAction> assetAction;
  final Function(AssetAction) onActionPressed;

  Color getTextColorByActionType(
      BuildContext context, AssetAction assetAction) {
    switch (assetAction) {
      case AssetAction.addToInventory:
        return SioColors.secondary7;
      case AssetAction.buy:
        return SioColors.black;
    }
  }

  SmallButtonType getButtonStyleByActionType(
      BuildContext context, AssetAction assetAction) {
    switch (assetAction) {
      case AssetAction.buy:
        return SmallButtonType.highlighted;
      case AssetAction.addToInventory:
        return SmallButtonType.bordered;
    }
  }

  Color? getBorderColorByActionType(
      BuildContext context, AssetAction assetAction) {
    if (assetAction == AssetAction.addToInventory) {
      return SioColors.secondary7;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadii.radius20,
      child: SizedBox(
        height: Constants.assetItemHeight,
        child: BackGradient2(
          child: Padding(
            padding: const EdgeInsets.only(
              top: Dimensions.padding20,
              left: Dimensions.padding20,
              bottom: Dimensions.padding20,
              right: Dimensions.padding25,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: SioTextStyles.h4.apply(
                          color: SioColors.whiteBlue,
                        ),
                      ),
                      Gaps.gap5,
                      Row(
                        children: [
                          Flexible(
                            child: Icon(
                              SioIcons.coins,
                              color: SioColors.coins,
                            ),
                          ),
                          Gaps.gap5,
                          Text(
                            context.locale.common_item_coin_price_label,
                            style: SioTextStyles.bodyDetail.copyWith(
                              color: SioColors.secondary7,
                              height: 1,
                            ),
                          ),
                          Text(
                            priceLabel,
                            style: SioTextStyles.bodyDetail.copyWith(
                              color: SioColors.whiteBlue,
                              height: 1,
                            ),
                          )
                        ],
                      ),
                      const Spacer(),
                      Wrap(
                        spacing: Dimensions.padding5,
                        runSpacing: Dimensions.padding5,
                        children: assetAction.map((assetAction) {
                          return SmallButton(
                            label: context.locale
                                .asset_item_action_types(assetAction.name),
                            onPressed: () {
                              onActionPressed.call(assetAction);
                            },
                            type: getButtonStyleByActionType(
                                context, assetAction),
                            labelColor:
                                getTextColorByActionType(context, assetAction),
                            borderColor: getBorderColorByActionType(
                                context, assetAction),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                AvatarWithShadow(
                  size: 50,
                  child: assetIcon,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum AssetAction { buy, addToInventory }
