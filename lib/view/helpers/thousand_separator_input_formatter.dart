import 'package:flutter/services.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = ',';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Handle "deletion" of separator character
    String oldValueText = oldValue.text.replaceAll(separator, '');
    String newValueText = newValue.text.replaceAll(separator, '');

    if (oldValue.text.endsWith(separator) &&
        oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    // Only process if the old value and new value are different
    if (oldValueText != newValueText) {
      int selectionIndex =
          newValue.text.length - newValue.selection.extentOffset;
      final beforeDecimalDot = newValueText.split('.').first.split('');
      final afterDecimalDot = newValueText.split('.').length > 1
          ? '.${newValueText.split('.')[1]}'
          : '';

      String newString = '';
      for (int i = beforeDecimalDot.length - 1; i >= 0; i--) {
        if ((beforeDecimalDot.length - 1 - i) % 3 == 0 &&
            i != beforeDecimalDot.length - 1) {
          newString = separator + newString;
        }
        newString = beforeDecimalDot[i] + newString;
      }

      return TextEditingValue(
        text: '$newString$afterDecimalDot',
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndex + afterDecimalDot.length,
        ),
      );
    }

    // If the new value and old value are the same, just return as-is
    return newValue;
  }

  String format(String text) {
    return formatEditUpdate(
      const TextEditingValue(),
      TextEditingValue(
        text: text,
        selection: TextSelection(
          baseOffset: text.length,
          extentOffset: text.length,
        ),
      ),
    ).text;
  }
}
