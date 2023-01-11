import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class DetailRow extends StatelessWidget {
  final String title;
  final Widget? child;

  const DetailRow({
    super.key,
    required this.title,
    this.child,
  });

  factory DetailRow.value({
    Key? key,
    required String title,
    required String primaryValue,
    String? secondaryValue,
    Widget? child,
  }) {
    return _DetailRowWithValue(
      key: key,
      title: title,
      primaryValue: primaryValue,
      secondaryValue: secondaryValue,
      child: child,
    );
  }

  // TODO - add a factory constructor for a row with a expansion child.

  @override
  Widget build(BuildContext context) {
    return _DetailRowContainer(
      children: [
        _DetailRowTitleText(title),
        if (child != null) child!,
      ],
    );
  }
}

class _DetailRowWithValue extends DetailRow {
  final String primaryValue;
  final String? secondaryValue;

  const _DetailRowWithValue({
    super.key,
    required super.title,
    super.child,
    required this.primaryValue,
    this.secondaryValue,
  });

  @override
  Widget build(BuildContext context) {
    return _DetailRowContainer(
      children: [
        _DetailRowTitleText(title),
        Padding(
          padding: Paddings.horizontal20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  primaryValue,
                  style: SioTextStyles.bodyPrimary.copyWith(
                    color: SioColors.whiteBlue,
                  ),
                ),
              ),
              if (secondaryValue != null)
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: Dimensions.padding16),
                    child: Text(
                      secondaryValue!,
                      style: SioTextStyles.bodyPrimary.copyWith(
                        color: SioColors.secondary7,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}

class _DetailRowContainer extends StatelessWidget {
  final List<Widget> children;

  const _DetailRowContainer({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        )
      ],
    );
  }
}

class _DetailRowTitleText extends StatelessWidget {
  final String title;

  const _DetailRowTitleText(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: Dimensions.padding20,
        right: Dimensions.padding20,
        bottom: Dimensions.padding12,
        left: Dimensions.padding20,
      ),
      child: Text(
        title,
        style: SioTextStyles.bodyPrimary.copyWith(
          color: SioColors.secondary7,
        ),
      ),
    );
  }
}
