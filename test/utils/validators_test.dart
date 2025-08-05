import 'package:flutter_test/flutter_test.dart';
import 'package:abm4_customerapp/utils/validators.dart';

void main() {
  group('Validators Tests', () {
    group('validateEmail', () {
      test('should return null for valid email', () {
        expect(Validators.validateEmail('test@example.com'), isNull);
        expect(Validators.validateEmail('user.name@domain.co.uk'), isNull);
        expect(Validators.validateEmail('test123@test-domain.com'), isNull);
      });

      test('should return error for invalid email', () {
        expect(Validators.validateEmail('invalid-email'), isNotNull);
        expect(Validators.validateEmail('test@'), isNotNull);
        expect(Validators.validateEmail('@domain.com'), isNotNull);
        expect(Validators.validateEmail('test.domain.com'), isNotNull);
      });

      test('should return error for empty email', () {
        expect(Validators.validateEmail(''), isNotNull);
        expect(Validators.validateEmail(null), isNotNull);
      });
    });

    group('validatePassword', () {
      test('should return null for valid password', () {
        expect(Validators.validatePassword('password123'), isNull);
        expect(Validators.validatePassword('123456'), isNull);
        expect(Validators.validatePassword('P@ssw0rd!'), isNull);
      });

      test('should return error for short password', () {
        expect(Validators.validatePassword('12345'), isNotNull);
        expect(Validators.validatePassword('abc'), isNotNull);
      });

      test('should return error for long password', () {
        final longPassword = 'a' * 25;
        expect(Validators.validatePassword(longPassword), isNotNull);
      });

      test('should return error for empty password', () {
        expect(Validators.validatePassword(''), isNotNull);
        expect(Validators.validatePassword(null), isNotNull);
      });
    });

    group('validateMobile', () {
      test('should return null for valid mobile number', () {
        expect(Validators.validateMobile('1234567890'), isNull);
        expect(Validators.validateMobile('+1234567890123'), isNull);
        expect(Validators.validateMobile('(123) 456-7890'), isNull);
      });

      test('should return error for short mobile number', () {
        expect(Validators.validateMobile('123456789'), isNotNull);
        expect(Validators.validateMobile('12345'), isNotNull);
      });

      test('should return error for long mobile number', () {
        final longMobile = '1' * 20;
        expect(Validators.validateMobile(longMobile), isNotNull);
      });

      test('should return error for empty mobile number', () {
        expect(Validators.validateMobile(''), isNotNull);
        expect(Validators.validateMobile(null), isNotNull);
      });
    });

    group('validateMobileOrId', () {
      test('should return null for valid mobile or ID', () {
        expect(Validators.validateMobileOrId('1234567890'), isNull);
        expect(Validators.validateMobileOrId('USER123'), isNull);
        expect(Validators.validateMobileOrId('abc'), isNull);
      });

      test('should return error for short input', () {
        expect(Validators.validateMobileOrId('ab'), isNotNull);
        expect(Validators.validateMobileOrId('1'), isNotNull);
      });

      test('should return error for empty input', () {
        expect(Validators.validateMobileOrId(''), isNotNull);
        expect(Validators.validateMobileOrId(null), isNotNull);
      });
    });

    group('validateName', () {
      test('should return null for valid name', () {
        expect(Validators.validateName('John Doe'), isNull);
        expect(Validators.validateName('Alice'), isNull);
        expect(Validators.validateName('Mary Jane Watson'), isNull);
      });

      test('should return error for short name', () {
        expect(Validators.validateName('A'), isNotNull);
      });

      test('should return error for long name', () {
        final longName = 'A' * 60;
        expect(Validators.validateName(longName), isNotNull);
      });

      test('should return error for name with numbers', () {
        expect(Validators.validateName('John123'), isNotNull);
        expect(Validators.validateName('Alice2'), isNotNull);
      });

      test('should return error for name with special characters', () {
        expect(Validators.validateName('John@Doe'), isNotNull);
        expect(Validators.validateName('Alice#'), isNotNull);
      });

      test('should return error for empty name', () {
        expect(Validators.validateName(''), isNotNull);
        expect(Validators.validateName(null), isNotNull);
      });
    });

    group('validateConfirmPassword', () {
      test('should return null when passwords match', () {
        expect(Validators.validateConfirmPassword('password123', 'password123'), isNull);
      });

      test('should return error when passwords do not match', () {
        expect(Validators.validateConfirmPassword('password123', 'different'), isNotNull);
      });

      test('should return error for empty confirm password', () {
        expect(Validators.validateConfirmPassword('', 'password123'), isNotNull);
        expect(Validators.validateConfirmPassword(null, 'password123'), isNotNull);
      });
    });

    group('Helper methods', () {
      test('isNumeric should work correctly', () {
        expect(Validators.isNumeric('123456'), true);
        expect(Validators.isNumeric('0'), true);
        expect(Validators.isNumeric('abc'), false);
        expect(Validators.isNumeric('123abc'), false);
        expect(Validators.isNumeric(''), false);
        expect(Validators.isNumeric(null), false);
      });

      test('isAlphabetic should work correctly', () {
        expect(Validators.isAlphabetic('abc'), true);
        expect(Validators.isAlphabetic('ABC'), true);
        expect(Validators.isAlphabetic('AbC'), true);
        expect(Validators.isAlphabetic('abc123'), false);
        expect(Validators.isAlphabetic('123'), false);
        expect(Validators.isAlphabetic(''), false);
        expect(Validators.isAlphabetic(null), false);
      });

      test('isAlphanumeric should work correctly', () {
        expect(Validators.isAlphanumeric('abc123'), true);
        expect(Validators.isAlphanumeric('ABC'), true);
        expect(Validators.isAlphanumeric('123'), true);
        expect(Validators.isAlphanumeric('abc@123'), false);
        expect(Validators.isAlphanumeric(''), false);
        expect(Validators.isAlphanumeric(null), false);
      });
    });
  });
}