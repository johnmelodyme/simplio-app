abstract class ErrorCode {
  final String code;

  const ErrorCode(this.code);

  @override
  String toString() => code;
}

abstract class BaseError<T extends ErrorCode> {
  final T code;
  final String message;

  const BaseError({
    required this.code,
    required this.message,
  });
}
