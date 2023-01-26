part of './http_error.dart';

class UnauthorizedHttpError extends HttpError {
  const UnauthorizedHttpError({
    super.code,
    super.message,
    super.detail,
  });

  factory UnauthorizedHttpError.fromObject(Object? object) {
    final body = HttpErrorBodyConvertor.fromObject(object);
    return UnauthorizedHttpError(
      code: body.code,
      message: body.message,
      detail: body.detail,
    );
  }
}
