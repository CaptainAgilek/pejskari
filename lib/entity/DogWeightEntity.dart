import 'package:pejskari/entity/BaseEntity.dart';

class DogWeightEntity extends BaseEntity {
  double weight;
  String date;
  String notes;
  int dogProfileId;

  DogWeightEntity(id, this.weight, this.date, this.notes, this.dogProfileId) : super(id);

  static String getCreateTableQuery() {
    return "CREATE TABLE dog_weight(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, weight REAL, date STRING, notes STRING, dog_profile_id INTEGER, FOREIGN KEY (dog_profile_id) REFERENCES dog_profile (id) ON DELETE CASCADE)";
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "weight": weight,
      "date": date,
      "notes": notes,
      "dog_profile_id": dogProfileId,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DogWeightEntity &&
          runtimeType == other.runtimeType &&
          weight == other.weight &&
          date == other.date &&
          notes == other.notes &&
          dogProfileId == other.dogProfileId;

  @override
  int get hashCode =>
      weight.hashCode ^ date.hashCode ^ notes.hashCode ^ dogProfileId.hashCode;
}