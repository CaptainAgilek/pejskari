import 'package:pejskari/entity/BaseEntity.dart';

class VetEntity extends BaseEntity {
  final String name;
  final String phone;
  final String notes;

  VetEntity(id, this.name, this.phone, this.notes) : super(id);

  static String getCreateTableQuery() {
    return "CREATE TABLE vet(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name STRING, phone STRING, notes STRING)";
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "name": name,
      "phone": phone,
      "notes": notes,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VetEntity &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          phone == other.phone &&
          notes == other.notes;

  @override
  int get hashCode => name.hashCode ^ phone.hashCode ^ notes.hashCode;
}