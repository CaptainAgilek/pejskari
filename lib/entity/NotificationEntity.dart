import 'package:pejskari/data/NotificationRepeatSettings.dart';
import 'package:pejskari/entity/BaseEntity.dart';

class NotificationEntity extends BaseEntity {
  final String title;
  final String dateTime;
  final NotificationRepeatSettings repeatSettings;

  NotificationEntity(int id, this.title, this.dateTime, this.repeatSettings) : super(id);

  static String getCreateTableQuery() {
    return "CREATE TABLE notification(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title STRING, date_time STRING, repeat_settings INTEGER)";
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "title": title,
      "date_time": dateTime,
      "repeat_settings": repeatSettings.value,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationEntity &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          dateTime == other.dateTime &&
          repeatSettings == other.repeatSettings;

  @override
  int get hashCode =>
      title.hashCode ^ dateTime.hashCode ^ repeatSettings.hashCode;
}