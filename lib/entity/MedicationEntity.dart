import 'package:pejskari/entity/BaseEntity.dart';

class MedicationEntity extends BaseEntity {
  final String name;
  final String dateTime;
  final String notes;
  final int dogProfileId;

  MedicationEntity(id, this.name, this.dateTime, this.notes, this.dogProfileId) : super(id);

  static String getCreateTableQuery() {
    return "CREATE TABLE medication(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name STRING, date_time STRING, notes STRING, dog_profile_id INTEGER, FOREIGN KEY (dog_profile_id) REFERENCES dog_profile (id) ON DELETE CASCADE)";
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "name": name,
      "date_time": dateTime,
      "notes": notes,
      "dog_profile_id": dogProfileId,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicationEntity &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          dateTime == other.dateTime &&
          notes == other.notes &&
          dogProfileId == other.dogProfileId;

  @override
  int get hashCode =>
      name.hashCode ^
      dateTime.hashCode ^
      notes.hashCode ^
      dogProfileId.hashCode;
}
