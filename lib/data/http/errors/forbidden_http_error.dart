part of './http_error.dart';

class ForbiddenHttpError extends HttpError {
  const ForbiddenHttpError({
    super.code,
    super.message,
    super.detail,
  });

  factory ForbiddenHttpError.fromObject(Object? object) {
    final body = HttpErrorBodyConvertor.fromObject(object);
    return ForbiddenHttpError(
      code: body.code,
      message: body.message,
      detail: body.detail,
    );
  }
}
