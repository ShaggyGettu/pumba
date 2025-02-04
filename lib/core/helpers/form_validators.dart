import 'package:pumba/core/app_strings.dart';

abstract class FormValidators {
  static String? emailValidator(String? str) {
    if (str == null) {
      return AppStrings.wrongEmailFormat;
    }
    // Define a regular expression pattern for a basic email validation
    RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    // Use the pattern to match the email
    return emailRegExp.hasMatch(str) ? null : AppStrings.wrongEmailFormat;
  }

  static String? firstNameValidator(String? str) {
    // Define a regular expression pattern for a basic name validation
    RegExp nameRegExp = RegExp(
      r'^[a-zA-Z]{2,}',
    );

    // Use the pattern to match the name
    return nameRegExp.hasMatch(str ?? '')
        ? null
        : AppStrings.wrongFirstNameFormat;
  }

  static String? lastNameValidator(String? str) {
    // Define a regular expression pattern for a basic name validation
    RegExp nameRegExp = RegExp(
      r'^[a-zA-Z]{2,}',
    );

    // Use the pattern to match the name
    return nameRegExp.hasMatch(str ?? '')
        ? null
        : AppStrings.wrongLastNameFormat;
  }

  static String? passwordValidator(String? str) {
    if (str == null || str.isEmpty) {
      return AppStrings.wrongPasswordError;
    }

    // Define a regular expression pattern for a basic password validation
    RegExp passwordRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$',
    );

    // Use the pattern to match the password
    return passwordRegExp.hasMatch(str) ? null : AppStrings.wrongPasswordError;
  }
}
