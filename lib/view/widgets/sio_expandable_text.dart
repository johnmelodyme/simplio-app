import 'package:flutter/material.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/gradient_text.dart';
import 'package:sio_glyphs/sio_icons.dart';

const collapsedTextLength = 200;

class SioExpandableText extends StatefulWidget {
  const SioExpandableText(this.captions, {super.key});

  final List<String> captions;

  @override
  State<SioExpandableText> createState() => _SioExpandableTextState();
}

class _SioExpandableTextState extends State<SioExpandableText> {
  late bool isExpanded;
  late String firstHalf;
  late String secondHalf;
  late String text;

  @override
  void initState() {
    text = widget.captions.join('\n\n');
    isExpanded = false;
    if (text.length > collapsedTextLength) {
      firstHalf = text.substring(0, collapsedTextLength);
      secondHalf = text.substring(collapsedTextLength, text.length);
    } else {
      firstHalf = text;
      secondHalf = '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (secondHalf.isEmpty || isExpanded)
          Text(
            '$firstHalf${isExpanded ? secondHalf : ''}',
            style: SioTextStyles.bodyPrimary.copyWith(
              color: SioColors.whiteBlue,
            ),
          )
        else
          GradientText(
            '$firstHalf${isExpanded ? secondHalf : '..'}',
            style: SioTextStyles.bodyPrimary.copyWith(
              color: SioColors.whiteBlue,
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                SioColors.whiteBlue,
                if (secondHalf.isNotEmpty && !isExpanded)
                  SioColors.whiteBlue.withOpacity(0),
              ],
            ),
          ),
        Gaps.gap14,
        if (secondHalf.isNotEmpty)
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isExpanded
                      ? context.locale.common_read_less
                      : context.locale.common_read_more,
                  style: SioTextStyles.buttonSmall.apply(
                    color: SioColors.mentolGreen,
                  ),
                ),
                Gaps.gap2,
                Icon(
                  isExpanded ? SioIcons.arrow_top : SioIcons.arrow_bottom,
                  color: SioColors.mentolGreen,
                  size: 14,
                ),
              ],
            ),
          )
      ],
    );
  }
}
