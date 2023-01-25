import 'package:simplio_app/view/widgets/keypad.dart';
import 'package:sio_big_decimal/sio_big_decimal.dart';

mixin BigDecimalValueUpdaterMixin {
  BigDecimal updateBigDecimalValue(
    BigDecimal value, {
    required NumpadValue modifier,
  }) {
    if (modifier.value < numpadBehaviorRange) {
      return value.addValue(modifier.value);
    }
    if (modifier == NumpadValue.erase) return value.removeValue();
    if (modifier == NumpadValue.decimal) return value.addValue(null);
    if (modifier == NumpadValue.clear) return value.clear();
    return value;
  }
}
