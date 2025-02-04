import 'package:pumba/core/app_strings.dart';

enum Gender {
  male,
  female,
  other;

  static const MALE_KEY = 'male';
  static const FEMALE_KEY = 'female';
  static const OTHER_KEY = 'other';

  static Gender fromString(String value) {
    switch (value) {
      case MALE_KEY:
        return Gender.male;
      case FEMALE_KEY:
        return Gender.female;
      case OTHER_KEY:
        return Gender.other;
      default:
        throw ArgumentError('Unknown gender: $value');
    }
  }

  String get json {
    switch (this) {
      case Gender.male:
        return MALE_KEY;
      case Gender.female:
        return FEMALE_KEY;
      case Gender.other:
        return OTHER_KEY;
    }
  }

  String get name {
    switch (this) {
      case Gender.male:
        return AppStrings.male;
      case Gender.female:
        return AppStrings.female;
      case Gender.other:
        return AppStrings.other;
    }
  }
}
