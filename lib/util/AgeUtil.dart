import 'package:age_calculator/age_calculator.dart';

/// Utility class for working with age.
class AgeUtil {
  static String computeAgeString(String dob) {
    DateTime dateOfBirth = DateTime.parse(dob);
    DateDuration age;
    age = AgeCalculator.age(dateOfBirth);

    String monthSuffix = "měsíců";
    if (age.months == 1) {
      monthSuffix = "měsíc";
    } else if (age.months == 2 || age.months == 3 || age.months == 4) {
      monthSuffix = "měsíce";
    }

    String yearSuffix = "let";
    if (age.years == 1) {
      yearSuffix = "rok";
    } else if (age.years == 2 || age.years == 3 || age.years == 4) {
      yearSuffix = "roky";
    }

    if (age.years == 0) {
      return age.months.toString() + " " + monthSuffix;
    } else {
      return age.years.toString() +
          " " +
          yearSuffix +
          " " +
          age.months.toString() +
          " " +
          monthSuffix;
    }
  }
}
