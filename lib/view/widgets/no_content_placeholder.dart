import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/widgets/button/highlighted_elevated_button.dart';
import 'package:simplio_app/view/widgets/empty_list_placeholder.dart';

// TODO - put content into the screen as a pricate widget.
class NoContentPlaceholder extends StatelessWidget {
  const NoContentPlaceholder({
    super.key,
    required this.title,
    required this.buttonLabel,
    required this.onPressed,
  });

  final String title;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          EmptyListPlaceholder(
            label: title,
            child: Image.asset(
              'assets/images/empty_transactions_placeholder.png',
            ),
          ),
          Gaps.gap20,
          SizedBox(
            width: 234,
            child: HighlightedElevatedButton.primary(
              label: buttonLabel,
              onPressed: onPressed,
            ),
          )
        ],
      ),
    );
  }
}
