class ValidatedPassword {
  final String value;

  const ValidatedPassword({this.value = ''});

  bool get isValid => _validatePassword(value);

  String? passwordValidator(String? password, {required String errorMsg}) {
    if (_validatePassword(password)) return null;

    return errorMsg;
  }

  String? passworMatchValidator(String? password1, String? password2,
      {required String errorMsg}) {
    if (_validateMatchingPasswords(password1, password2)) return null;

    return errorMsg;
  }

  bool _validatePassword(String? password) {
    return _hasSpecialCharacters(password) &&
        _hasUpperCharacters(password) &&
        _hasNumbers(password) &&
        _isLongEnough(password);
  }

  bool _validateMatchingPasswords(String? password1, String? password2) {
    return password1 == password2;
  }

  Map<String, bool> get missingValue => {
        'specialChar': _hasSpecialCharacters(value),
        'upperChar': _hasUpperCharacters(value),
        'numberChar': _hasNumbers(value),
        'length': _isLongEnough(value),
      };

  @override
  String toString() => value;

  bool _hasSpecialCharacters(String? value) {
    Pattern specialCharRegexp =
        RegExp(r'''^(?=.*[ `!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?~])''');

    return value!.contains(specialCharRegexp);
  }

  bool _hasUpperCharacters(String? value) {
    Pattern upperCharRegexp = RegExp(r'''^(?=.*[A-Z])''');

    return value!.contains(upperCharRegexp);
  }

  bool _hasNumbers(String? value) {
    Pattern numbersRegexp = RegExp(r'''^(?=.*[0-9])''');

    return value!.contains(numbersRegexp);
  }

  bool _isLongEnough(String? value) {
    return value!.length >= 8;
  }
}
