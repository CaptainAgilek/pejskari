//associative table between walk and dog_profile tables


class WalkDogProfileEntity {
  final int walk_id;
  final int dog_profile_id;

  WalkDogProfileEntity(id, this.walk_id, this.dog_profile_id);

  static String getCreateTableQuery() {
    return "CREATE TABLE walk_dog_profile(walk_id INTEGER NOT NULL, dog_profile_id INTEGER NOT NULL, FOREIGN KEY (walk_id) REFERENCES walk (id) ON DELETE CASCADE, FOREIGN KEY (dog_profile_id) REFERENCES dog_profile (id) ON DELETE CASCADE, PRIMARY KEY(walk_id, dog_profile_id))";
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "walk_id": walk_id,
      "dog_profile_id": dog_profile_id,
    };
  }
}