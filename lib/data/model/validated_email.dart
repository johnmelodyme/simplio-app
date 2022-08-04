class ValidatedEmail {
  final String value;

  const ValidatedEmail({this.value = ''});

  bool get isValid => _emailValidator(value);

  @override
  String toString() => value;

  String? emailValidator(
    String? email, {
    required String errorMessage,
  }) {
    if (_emailValidator(email)) return null;

    return errorMessage;
  }

  bool _emailValidator(String? value) {
    return value!.contains(RegExp(
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\])|(([a-zA-Z\-\d]+\.)+[a-zA-Z]{2,}))$'));
  }
}
