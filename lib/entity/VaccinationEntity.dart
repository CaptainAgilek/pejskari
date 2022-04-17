import 'package:pejskari/entity/BaseEntity.dart';

class VaccinationEntity extends BaseEntity {
  final String name;
  final String date;
  final String notes;
  final int dogProfileId;

  VaccinationEntity(id, this.name, this.date, this.notes, this.dogProfileId) : super(id);

  static String getCreateTableQuery() {
    return "CREATE TABLE vaccination(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name STRING, date STRING, notes STRING, dog_profile_id INTEGER, FOREIGN KEY (dog_profile_id) REFERENCES dog_profile (id) ON DELETE CASCADE)";
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "name": name,
      "date": date,
      "notes": notes,
      "dog_profile_id": dogProfileId,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VaccinationEntity &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          date == other.date &&
          notes == other.notes &&
          dogProfileId == other.dogProfileId;

  @override
  int get hashCode =>
      name.hashCode ^ date.hashCode ^ notes.hashCode ^ dogProfileId.hashCode;
}