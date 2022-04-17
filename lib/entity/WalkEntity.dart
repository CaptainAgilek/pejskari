import 'package:flutter/foundation.dart';
import 'package:pejskari/entity/BaseEntity.dart';

class WalkEntity extends BaseEntity {
  final String date;
  final String notes;
  final double distance;
  final int time;
  final List<int> dogProfilesIds;

  WalkEntity(id, this.date, this.notes, this.distance, this.time, this.dogProfilesIds) : super(id);

  static String getCreateTableQuery() {
    return "CREATE TABLE walk(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, date STRING, notes STRING, distance REAL, time INTEGER)";
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "date": date,
      "notes": notes,
      "distance": distance,
      "time" : time,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalkEntity &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          notes == other.notes &&
          distance == other.distance &&
          time == other.time &&
          listEquals(dogProfilesIds, other.dogProfilesIds);

  @override
  int get hashCode =>
      date.hashCode ^
      notes.hashCode ^
      distance.hashCode ^
      time.hashCode ^
      dogProfilesIds.hashCode;
}