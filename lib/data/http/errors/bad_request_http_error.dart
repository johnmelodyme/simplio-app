part of './http_error.dart';

class BadRequestHttpError extends HttpError {
  const BadRequestHttpError({
    super.code,
    super.message,
    super.detail,
  });

  factory BadRequestHttpError.fromObject(Object? object) {
    final body = HttpErrorBodyConvertor.fromObject(object);
    return BadRequestHttpError(
      code: body.code,
      message: body.message,
      detail: body.detail,
    );
  }
}
