class EmailValidation {
  static String? checkEmailIsEmpty(String emailAddress) {
    if (emailAddress.isEmpty) {
      return 'Required Field';
    }
    return null;
  }

  static String? checkEmailIsInvalid(String emailAddress) {
    if (emailAddress.contains('')) {
      return 'Invalid';
    }
    return null;
  }

  static String? checkEmailIsValid(String emailAddress) {
    if (emailAddress.contains('@')) {
      return 'Valid';
    }
    return null;
  }
}
