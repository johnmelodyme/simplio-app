enum ValidationErrorCodes {
  invalidFormat('INVALID_FORMAT'),
  invalidValue('INVALID_VALUE'),
  insufficientValue('INSUFFICIENT_VALUE'),
  unknown('UNKNOWN');

  final String code;

  const ValidationErrorCodes(this.code);
}

class ValidationError implements Exception {
  final String message;
  final ValidationErrorCodes code;

  const ValidationError({
    required this.message,
    required this.code,
  });

  @override
  String toString() => 'ValidationError: $message';
}
