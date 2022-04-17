class DogProfile {
  final int id;
  final String name;
  final String breed;
  final String chipId;
  final String dateOfBirth;
  final int? height;
  String profileImagePath;
  final int gender;
  final int castrated;

  DogProfile(this.id, this.name, this.breed, this.chipId, this.dateOfBirth, this.height, this.profileImagePath, this.gender, this.castrated);

}