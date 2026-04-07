import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_booking/maths_util.dart';

void main() {
  group("check all ", () {
    test('Validate for two numbers are added', () {
      var a = 123;
      var b = 12;
      var sum = add(a, b);
      expect(sum, 135);
    });

    test('Validate for two numbers are multiply', () {
      var a = 123;
      var b = 12;
      var mult = multiply(a, b);
      expect(mult, 1476);
    });

    test('Validate for two numbers are subtracted', () {
      var a = 123;
      var b = 12;
      var sub = subtract(a, b);
      expect(sub, 111);
    });
  });
}
