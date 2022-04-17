import 'package:pejskari/data/NotificationRepeatSettings.dart';

class Notification {
  final int id;
  final String title;
  final String dateTime;
  final NotificationRepeatSettings repeatSettings;

  Notification(this.id, this.title, this.dateTime, this.repeatSettings);

  Notification.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
  dateTime = json["dateTime"],
  repeatSettings = NotificationRepeatSettings.none.fromValue(json["repeatSettings"]);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      "dateTime": dateTime,
      "repeatSettings": repeatSettings.value
    };
  }
}