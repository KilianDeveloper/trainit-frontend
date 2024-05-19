import 'package:flutter_test/flutter_test.dart';
import 'package:trainit/helper/string.dart';

void main() {
  group('Email Validation', () {
    test('Email should be valid', () {
      expect("test@gmail.com".isValidEmail, true);
    });

    test('Email should be invalid', () {
      expect("test@gmail".isValidEmail, false);
    });

    test('Email should be invalid 2', () {
      expect("test.com".isValidEmail, false);
    });
  });

  group('Password Validation', () {
    test('Password should be valid', () {
      expect("Test123#".isValidPassword, true);
    });

    test('Email should be invalid because it is not at least 6 characters long',
        () {
      expect("dd".isValidPassword, false);
    });

    test('Email should be invalid because its empty', () {
      expect("".isValidPassword, false);
    });
  });

  group('Username Validation', () {
    test('Username should be valid', () {
      expect("StatiJovo".isValidUsername, true);
    });

    test('Email should be invalid', () {
      expect("".isValidUsername, false);
    });
  });
}
