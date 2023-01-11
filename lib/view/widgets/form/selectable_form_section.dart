import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

class SelectableFormSection extends StatelessWidget {
  final String label;
  final bool isSelected;
  final List<Widget> children;

  const SelectableFormSection({
    super.key,
    required this.label,
    this.isSelected = false,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: Paddings.horizontal16,
      decoration: isSelected
          ? BoxDecoration(
              borderRadius: BorderRadii.radius20,
              gradient: RadialGradient(
                radius: 10,
                colors: [
                  SioColors.backGradient4Start,
                  SioColors.secondary6,
                ],
              ),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: Paddings.vertical8,
            child: Text(
              label,
              textAlign: TextAlign.start,
              style: SioTextStyles.bodyS.copyWith(
                color:
                    isSelected ? SioColors.mentolGreen : SioColors.secondary7,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}
