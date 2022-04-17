import 'package:pejskari/data/NotificationRepeatSettings.dart';

/// Utility class for working with time and date format.
class TimeFormatUtil {

  //https://stackoverflow.com/a/54775297/6713035
  static String printDurationHHMM(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    //   String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  }

  static String printDurationHours(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return twoDigits(duration.inHours);
  }

  static String printDurationMinutes(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return twoDigitMinutes;
  }

  static String getDateFormatBasedOnRepeat(NotificationRepeatSettings repeatSettings) {
    switch (repeatSettings) {
      case NotificationRepeatSettings.none:
        return "dd.MM.yyyy HH:mm";
      case NotificationRepeatSettings.everyDay:
        return "HH:mm";
      case NotificationRepeatSettings.everyWeek:
        return "EEEE HH:mm";
      case NotificationRepeatSettings.everyYear:
        return "dd.MM.";
      default:
        return "dd.MM.yyyy HH:mm";
    }
  }

}