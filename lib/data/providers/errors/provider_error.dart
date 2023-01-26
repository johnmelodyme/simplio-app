import 'package:simplio_app/data/models/error.dart';

enum ProviderErrorCodes implements ErrorCode {
  unknown(code: 'UNKNOWN'),
  invalidValue(code: 'PROVIDER_INVALID_VALUE'),
  failedToSave(code: 'PROVIDER_FAILED_TO_SAVE');

  @override
  final String code;

  const ProviderErrorCodes({this.code = ''});
}

class ProviderError extends BaseError<ProviderErrorCodes> {
  ProviderError({
    super.code = ProviderErrorCodes.unknown,
    super.message = 'Unknown error',
  });
}
