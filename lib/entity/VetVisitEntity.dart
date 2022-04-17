import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pejskari/entity/BaseEntity.dart';

class VetVisitEntity extends BaseEntity {
  final String date;
  final String notes;
  final int vetId;
  final int dogProfileId;
  final List<String> documentPaths;

  VetVisitEntity(int id, this.date, this.notes, this.vetId, this.dogProfileId, this.documentPaths) : super(id);

  static String getCreateTableQuery() {
    return "CREATE TABLE vet_visit(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, date STRING, notes STRING, vet_id INTEGER, dog_profile_id INTEGER, document_paths STRING, FOREIGN KEY (vet_id) REFERENCES vet (id) ON DELETE CASCADE, FOREIGN KEY (dog_profile_id) REFERENCES dog_profile (id) ON DELETE CASCADE)";
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "date": date,
      "notes": notes,
      "vet_id": vetId,
      "dog_profile_id": dogProfileId,
      "document_paths": jsonEncode(documentPaths)
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VetVisitEntity &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          notes == other.notes &&
          vetId == other.vetId &&
          dogProfileId == other.dogProfileId &&
          listEquals(documentPaths,other.documentPaths);

  @override
  int get hashCode =>
      date.hashCode ^
      notes.hashCode ^
      vetId.hashCode ^
      dogProfileId.hashCode ^
      documentPaths.hashCode;
}