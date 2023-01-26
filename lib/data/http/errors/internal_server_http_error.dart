part of './http_error.dart';

class InternalServerHttpError extends HttpError {
  const InternalServerHttpError({
    super.code,
    super.message,
    super.detail,
  });

  factory InternalServerHttpError.fromObject(Object? object) {
    final body = HttpErrorBodyConvertor.fromObject(object);
    return InternalServerHttpError(
      code: body.code,
      message: body.message,
      detail: body.detail,
    );
  }
}
