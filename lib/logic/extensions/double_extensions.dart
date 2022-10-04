extension DoubleExtension on double {
  String get lastChar {
    return toString().substring(0, toString().length - 1);
  }
}
