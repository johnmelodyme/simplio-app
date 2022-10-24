import 'dart:convert';
import 'package:simplio_app/data/http/errors/http_error_codes.dart';

class BadRequestHttpError {
  final HttpErrorCodes code;
  final String message;
  final Map<String, dynamic> detail;

  const BadRequestHttpError({
    this.code = HttpErrorCodes.unknown,
    this.message = '',
    this.detail = const {},
  });

  factory BadRequestHttpError.fromObject(Object? object) {
    if (object is! String) return const BadRequestHttpError();

    final Map<String, dynamic> map = json.decode(object);
    return BadRequestHttpError.fromMap(map);
  }

  BadRequestHttpError.fromMap(Map<String, dynamic> map)
      : this(
          code: HttpErrorCodes.values.firstWhere(
              (e) => e.code == (map['code'] is String ? map['code'] : ''),
              orElse: () => HttpErrorCodes.unknown),
          message: map['message'] is String ? map['message'] : '',
          detail: map['detail'] is Map ? map['detail'] : const {},
        );
}
