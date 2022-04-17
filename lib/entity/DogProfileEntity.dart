import 'package:pejskari/entity/BaseEntity.dart';

class DogProfileEntity extends BaseEntity {

  String name;
  String breed;
  String chipId;
  String dateOfBirth;
  int? height;
  String profileImagePath;
  int gender;
  int castrated;

  DogProfileEntity(id, this.name, this.breed, this.chipId, this.dateOfBirth, this.height, this.profileImagePath,  this.gender, this.castrated) : super(id);

  static String getCreateTableQuery() {
    return "CREATE TABLE dog_profile(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, breed TEXT, chip_id TEXT, date_of_birth TEXT, height INTEGER, profile_image_path TEXT, gender INTEGER, castrated INTEGER)";
  }

  @override
  Map<String, dynamic> toMap( ) {
      return <String, dynamic>{
        "name": name,
        "breed": breed,
        "chip_id": chipId,
        "date_of_birth": dateOfBirth,
        "height": height,
        "profile_image_path": profileImagePath,
        "gender": gender,
        "castrated": castrated,
      };

  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DogProfileEntity &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          breed == other.breed &&
          chipId == other.chipId &&
          dateOfBirth == other.dateOfBirth &&
          height == other.height &&
          profileImagePath == other.profileImagePath &&
          gender == other.gender &&
          castrated == other.castrated;

  @override
  int get hashCode =>
      name.hashCode ^
      breed.hashCode ^
      chipId.hashCode ^
      dateOfBirth.hashCode ^
      height.hashCode ^
      profileImagePath.hashCode ^
      gender.hashCode ^
      castrated.hashCode;
}