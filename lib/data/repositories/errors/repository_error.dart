import 'package:simplio_app/data/models/error.dart';

enum RepositoryErrorCodes implements ErrorCode {
  unknown(code: 'UNKNOWN'),
  invalidValue(code: 'REPOSITORY_INVALID_VALUE'),
  invalidDependency(code: 'REPOSITORY_INVALID_DEPENDENCY');

  @override
  final String code;

  const RepositoryErrorCodes({this.code = ''});
}

class RepositoryError extends BaseError {
  final BaseError? error;

  RepositoryError({
    super.code = RepositoryErrorCodes.unknown,
    super.message = 'Unknown error',
    this.error,
  });
}
