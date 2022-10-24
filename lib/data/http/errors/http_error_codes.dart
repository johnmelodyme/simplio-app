enum HttpErrorCodes {
  buyChangedRate(code: 'RATES_CHANGED'),
  unknown();

  final String code;

  const HttpErrorCodes({this.code = ''});
}
