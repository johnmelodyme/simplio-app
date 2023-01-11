import 'package:simplio_app/data/http/errors/http_error.dart';

class BadRequestHttpError implements HttpError {
  const BadRequestHttpError(this._body);

  BadRequestHttpError.fromObject(Object? object)
      : this(HttpErrorBodyConvertor.fromObject(object));

  BadRequestHttpError.fromMap(Map<String, dynamic> map)
      : this(HttpErrorBodyConvertor.fromMap(map));

  final HttpErrorBody _body;

  @override
  HttpErrorCodes get code => _body.code;
  @override
  String get message => _body.message;
  @override
  Map<String, dynamic> get detail => _body.detail;
}
