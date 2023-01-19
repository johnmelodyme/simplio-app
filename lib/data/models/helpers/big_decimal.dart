import 'dart:math';
import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class BigDecimal extends Equatable {
  static const defaultPrecision = 0;

  static BigDecimal parse(
    String value, {
    int precision = defaultPrecision,
  }) {
    try {
      return BigDecimal.fromBigInt(
        BigInt.parse(
          Decimal.parse(value).toStringAsFixed(precision).replaceAll('.', ''),
        ),
        precision: precision,
      );
    } catch (_) {
      return const BigDecimal.zero();
    }
  }

  const BigDecimal._(
    this._abs,
    this._dec,
    this.precision,
  );

  const BigDecimal.zero({
    int precision = defaultPrecision,
  }) : this._(const [], null, precision);

  factory BigDecimal.fromDouble(
    double value, {
    int? precision,
  }) {
    return parse(
      value.toString(),
      precision: precision ?? Decimal.parse(value.toString()).precision,
    );
  }

  factory BigDecimal.fromBigInt(
    BigInt value, {
    int precision = defaultPrecision,
  }) {
    try {
      final v = Decimal.fromBigInt(value);
      final p = Decimal.fromBigInt(BigInt.from(pow(10, precision)));
      final r = (v / p)
          .toDecimal()
          .toString()
          .replaceAll(RegExp(r'.0*$'), '')
          .split('.');

      return BigDecimal._(
        r.isNotEmpty ? r.first.split('').map(int.parse).toList() : const [],
        r.length > 1 ? r.last.split('').map(int.parse).toList() : null,
        precision,
      );
    } catch (_) {
      return BigDecimal.zero(precision: precision);
    }
  }

  /// must be a valid `int` value. it is list of integers
  final List<int> _abs;

  /// must be a valid `int` value
  final List<int>? _dec;

  /// represents decimal place
  final int precision;

  bool get isZero => _abs.isEmpty && _dec == null;
  bool get isNotZero => !isZero;
  bool get isDecimal => _dec != null;
  bool get isNotDecimal => !isDecimal;
  bool get isFinite => _dec != null && _dec!.length < precision;

  BigDecimal operator -(BigDecimal other) {
    return BigDecimal.parse(
      (toDecimal() - other.toDecimal()).toString(),
      precision: precision,
    );
  }

  BigDecimal operator +(BigDecimal other) {
    return BigDecimal.parse(
      (toDecimal() + other.toDecimal()).toString(),
      precision: precision,
    );
  }

  BigDecimal operator *(BigDecimal other) {
    return BigDecimal.parse(
      (toDecimal() * other.toDecimal()).toString(),
      precision: precision,
    );
  }

  BigDecimal operator /(BigDecimal other) {
    return BigDecimal.fromDouble(
      toDecimal().toDouble() / other.toDecimal().toDouble(),
      precision: precision,
    );
  }

  BigDecimal clear() => BigDecimal.zero(precision: precision);

  BigDecimal remove() {
    if (_abs.isEmpty) return _copyWith();
    if (!isDecimal) return _copyWith(absolute: List.from(_abs)..removeLast());
    if (_dec!.isEmpty) return BigDecimal._(_abs, null, precision);

    return _copyWith(decimal: List.from(_dec!)..removeLast());
  }

  BigDecimal add(int? n) {
    if (n == null) return _addPrecision();
    if (isDecimal) return _addDec(n);
    return _addAbs(n);
  }

  BigDecimal _addPrecision() {
    if (isDecimal) return _copyWith();
    return _copyWith(
      absolute: _abs.isEmpty ? [0] : _abs,
      decimal: const [],
    );
  }

  BigDecimal _addAbs(int n) {
    final updated = [..._abs, n];
    if (int.tryParse(updated.join('')) == null) return _copyWith();
    if (_abs.isEmpty && n < 1) return _copyWith();
    return _copyWith(absolute: [..._abs, n]);
  }

  BigDecimal _addDec(int n) {
    if (isNotDecimal) return _copyWith(decimal: [n]);
    if (_dec!.length < precision) return _copyWith(decimal: [..._dec!, n]);
    return _copyWith();
  }

  BigInt toBigInt() {
    return BigInt.tryParse(toString().replaceAll('.', '')) ?? BigInt.zero;
  }

  Decimal toDecimal() {
    return Decimal.parse(toString());
  }

  @override
  String toString() {
    final abs = _abs.isNotEmpty ? _abs.join('') : '0';
    final dec = _dec?.join('') ?? '0';
    final str = [abs, dec].join('.').replaceAll(RegExp(r'[.]*$'), '');

    return (Decimal.tryParse(str) ?? Decimal.zero).toStringAsFixed(precision);
  }

  String format({String? locale = 'en_US'}) {
    if (_abs.isEmpty) return '';

    final f = NumberFormat('###,###', locale);
    final a = f.format(
      DecimalIntl(Decimal.tryParse(_abs.join('')) ?? Decimal.zero),
    );

    if (isNotDecimal) return a;
    return [a, _dec?.join('')].join('.');
  }

  BigDecimal _copyWith({
    List<int>? absolute,
    List<int>? decimal,
  }) {
    return BigDecimal._(
      absolute ?? _abs,
      decimal ?? _dec,
      precision,
    );
  }

  @override
  List<Object?> get props => [format()];
}
