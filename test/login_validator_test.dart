import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_booking/widget/email_validation.dart';
import 'package:taxi_booking/widget/password_validator.dart';

void main() {
  test('Check if email is null', () {
    // arrange : variables that are required to be tested.
    var emailAddress = '';

    // Act upon the given variable
    var result = EmailValidation.checkEmailIsEmpty(emailAddress);

    // Assert or Check the poutput for the expected result.

    expect(result, 'Required Field');
  });

  test('Check if email is Invalid', () {
    // arrange : variables that are required to be tested.
    var emailAddress = 'lkwlerrw';

    // Act upon the given variable
    var result = EmailValidation.checkEmailIsInvalid(emailAddress);

    // Assert or Check the poutput for the expected result.

    expect(result, 'Invalid');
  });

  test('Check if email is Valid', () {
    // arrange : variables that are required to be tested.
    var emailAddress = 'siddharth@gmail.com';

    // Act upon the given variable
    var result = EmailValidation.checkEmailIsValid(emailAddress);

    // Assert or Check the poutput for the expected result.

    expect(result, 'valid');
  });

  test("Check the lenght of the password", () {
    var password = 'Sid@14';

    // Act upon the given variable
    var result = PasswordValidation.checkPasswordStrenght(password);
    if (result!.length > 6) {
      return expect(result, 'Strong');
    } else {
      return expect(result, 'Strong');
    }
  });
}
