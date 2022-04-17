enum NotificationRepeatSettings {
  none,
  everyDay,
  everyWeek,
  everyYear,
}

extension NotificationRepeatSettingsExtension on NotificationRepeatSettings {
  int get value {
    switch (this) {
      case NotificationRepeatSettings.none:
        return 0;
      case NotificationRepeatSettings.everyDay:
        return 1;
      case NotificationRepeatSettings.everyWeek:
        return 2;
      case NotificationRepeatSettings.everyYear:
        return 3;
      default:
        return 0;
    }
  }

  String get czName {
    switch (this) {
      case NotificationRepeatSettings.none:
        return "Žádné opakování";
      case NotificationRepeatSettings.everyDay:
        return "Každý den";
      case NotificationRepeatSettings.everyWeek:
        return "Každý týden";
      case NotificationRepeatSettings.everyYear:
        return "Každý rok";
      default:
        return "Žádné opakování";
    }
  }

  NotificationRepeatSettings fromValue(int value)  {
    switch (value) {
      case 0:
        return NotificationRepeatSettings.none;
      case 1:
        return NotificationRepeatSettings.everyDay;
      case 2:
        return NotificationRepeatSettings.everyWeek;
      case 3:
        return NotificationRepeatSettings.everyYear;
      default:
        return NotificationRepeatSettings.none;
    }
  }
}
