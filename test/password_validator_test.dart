import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_booking/widget/password_validator.dart';

void main() {
  test('Check if password is empty', () {
    // arrange : variables that are required to be tested.
    var password = '';

    // Act upon the given variable
    var result = PasswordValidation.checkPasswordIsEmpty(password);

    // Assert or Check the poutput for the expected result.

    expect(result, 'Required Field');
  });

  test('Check if email is Invalid', () {
    // arrange : variables that are required to be tested.
    var password = '';

    // Act upon the given variable
    var result = PasswordValidation.checkPasswordIsInvalid(password);

    // Assert or Check the poutput for the expected result.
    expect(result, 'Password Lenght is Invalid.');
  });

  test('Check if email is Valid', () {
    // arrange : variables that are required to be tested.
    var password = 'Sid@1234';

    // Act upon the given variable
    var result = PasswordValidation.checkPasswordValid(password);

    // Assert or Check the poutput for the expected result.

    expect(result, 'Valid');
  });

  test('Check if email is Valid', () {
    // arrange : variables that are required to be tested.
    var password = 'Sid@';

    // Act upon the given variable
    var result = PasswordValidation.checkPasswordValid(password);

    // Assert or Check the poutput for the expected result.

    expect(result, 'Valid');
  });
}
