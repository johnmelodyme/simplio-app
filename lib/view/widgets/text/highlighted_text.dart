import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextStyle? highlightedStyle;
  final TextAlign textAlign;

  const HighlightedText(
    this.data, {
    super.key,
    this.style,
    this.highlightedStyle,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        children: _buildTextSpans(data, style, highlightedStyle),
      ),
    );
  }

  static List<InlineSpan> _buildTextSpans(
    String data,
    TextStyle? style,
    TextStyle? highlightedStyle,
  ) {
    final List<String> words = data.split(' ');
    final List<InlineSpan> spans = [];

    for (var i = 0; i < words.length; i++) {
      final isZero = i == 0;
      final word = words[i];
      if (word.startsWith('^')) {
        final w = word.substring(1);
        spans.add(TextSpan(
          text: isZero ? w : ' $w',
          style: highlightedStyle,
        ));
      } else {
        spans.add(TextSpan(
          text: isZero ? word : ' $word',
          style: style,
        ));
      }
    }

    return spans;
  }
}
