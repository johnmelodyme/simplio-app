import 'package:intl/intl.dart';

extension DateParse on DateTime {
  String getDateFormatShort() {
    return DateFormat('d MMM').format(toLocal());
  }
}
