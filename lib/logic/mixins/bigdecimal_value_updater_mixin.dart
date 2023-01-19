import 'package:simplio_app/data/models/helpers/big_decimal.dart';
import 'package:simplio_app/view/widgets/keypad.dart';

mixin BigDecimalValueUpdaterMixin {
  BigDecimal updateBigDecimalValue(
    BigDecimal value, {
    required NumpadValue modifier,
  }) {
    if (modifier.value < numpadBehaviorRange) return value.add(modifier.value);
    if (modifier == NumpadValue.erase) return value.remove();
    if (modifier == NumpadValue.decimal) return value.add(null);
    if (modifier == NumpadValue.clear) return value.clear();
    return value;
  }
}
