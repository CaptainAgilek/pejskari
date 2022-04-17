import 'package:pejskari/SqliteDatabaseConnector.dart';
import 'package:pejskari/entity/WalkDogProfileEntity.dart';
import 'package:pejskari/entity/WalkEntity.dart';
import 'package:pejskari/repository/CrudRepository.dart';
import 'package:sqflite/sqflite.dart';

/// Repository for CRUD operations on walk.
class WalkRepositoryImpl implements CrudRepository<WalkEntity> {
  final SqliteDatabaseConnector _databaseConnector = SqliteDatabaseConnector();

  @override
  Future<void> delete(int id) async {
    final db = await _databaseConnector.database;

    await db.delete(
      "walk",
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<WalkEntity?> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<WalkEntity>> getAll() async {
    final db = await _databaseConnector.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT walk.id, date, notes, distance,time, GROUP_CONCAT(walk_dog_profile.dog_profile_id) AS dog_profiles_ids FROM walk LEFT JOIN walk_dog_profile ON walk.id = walk_dog_profile.walk_id GROUP BY walk.id");

    return List.generate(maps.length, (i) {
      List<int> ids = maps[i]["dog_profiles_ids"]
              ?.split(',')
              .map(int.parse)
              .toList()
              .cast<int>() ??
          [];
      return WalkEntity(maps[i]['id'], maps[i]['date'], maps[i]['notes'],
          maps[i]['distance'], maps[i]['time'], ids);
    });
  }

  @override
  Future<WalkEntity> insert(WalkEntity entity) async {
    final db = await _databaseConnector.database;

    entity.id = await db.insert(
      "walk",
      entity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    //also insert to associative table
    for (var dogProfileId in entity.dogProfilesIds) {
      await db.insert("walk_dog_profile",
          WalkDogProfileEntity(0, entity.id, dogProfileId).toMap());
    }

    return entity;
  }

  @override
  Future<void> update(WalkEntity entity) async {
    final db = await _databaseConnector.database;
    await db.update(
      "walk",
      entity.toMap(),
      where: 'id = ?',
      whereArgs: [entity.id],
    );
    //remove rows for this walk from associative table and create them again, this is needed in case of removing dog from walk
    db.delete("walk_dog_profile", where: "walk_id = ?", whereArgs: [entity.id]);
    // recreate associative table
    for (var dogProfileId in entity.dogProfilesIds) {
      db.insert("walk_dog_profile",
          WalkDogProfileEntity(0, entity.id, dogProfileId).toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }
}
