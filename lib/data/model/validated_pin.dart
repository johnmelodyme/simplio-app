class ValidatedPin {
  static const int length = 4;

  final List<int> value;

  const ValidatedPin({this.value = const <int>[]});

  bool get isValid => value.length == length;

  @override
  String toString() => value.join('');

  ValidatedPin copyWith({List<int>? value}) {
    return ValidatedPin(value: value ?? this.value);
  }
}
