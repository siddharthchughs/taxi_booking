class PasswordValidation {
  static String? checkPasswordIsEmpty(String password) {
    if (password.isEmpty) {
      return 'Required Field';
    }
    return null;
  }

  static String? checkPasswordIsInvalid(String password) {
    if (password.isEmpty) {
      return 'Password Lenght is Invalid.';
    }
    return null;
  }

  static String? checkPasswordStrenght(String password) {
    if (password.length > 6) {
      return 'Valid';
    } else {
      return 'NO Strong, try again.';
    }
  }

  static String? checkPasswordValid(String password) {
    String pattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    RegExp regExp = RegExp(pattern);

    if (regExp.hasMatch(password)) {
      return 'Valid';
    }
    return null;
  }
}
