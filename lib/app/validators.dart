// ignore_for_file: body_might_complete_normally_nullable

import 'constants2.dart';

class Validator {
  static String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }

    return null;
  }

  static String? validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }

    if (int.tryParse(value) == null) {
      return "Please enter a valid number";
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }

    if (!emailValidatorRegExp.hasMatch(value)) {
      return "Invalid email address";
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }

    if (!phoneValidatorRegExp.hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    // if (!pswdValidatorRegExp.hasMatch(value)) {
    //   return 'Password contain at least one uppercase letter, one lowercase letter, and one number';
    // }

    return null;
  }

  static String? validateUserid(String? value) {
    if (value == null || value.isEmpty) {
      return 'Plase enter a userid';
    }
    if (value.length < 6) {
      return 'Userid must be at lease 6 charaters long';
    }
  }

  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a OTP';
    }

    if (!otpValidatorRegExp.hasMatch(value)) {
      return 'Please enter a valid 6-digit otp';
    }

    return null;
  }

  static String? validateGst(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a GST No';
    }

    if (!gstValidatorRegExp.hasMatch(value)) {
      return 'Please enter a valid GST No';
    }

    return null;
  }

  static String? validateMin(String? value, {int min = 3}) {
    if (value == null || value.isEmpty || value.trim().length < min) {
      return 'Min $min letters are required';
    }

    return null;
  }

  static String? compose(
    String? value,
    List<String? Function(String?)>? validators,
  ) {
    if (validators == null) return null;

    for (final validator in validators) {
      final error = validator(value);
      if (error != null) {
        return error;
      }
    }

    return null;
  }
}
