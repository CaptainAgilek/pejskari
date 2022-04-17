import 'package:pejskari/SqliteDatabaseConnector.dart';
import 'package:pejskari/entity/DogProfileEntity.dart';
import 'package:pejskari/repository/CrudRepository.dart';
import 'package:sqflite/sqflite.dart';

/// Repository for CRUD operations on dog profile.
class DogProfileRepositoryImpl implements CrudRepository<DogProfileEntity> {
  final SqliteDatabaseConnector _databaseConnector = SqliteDatabaseConnector();

  @override
  Future<void> delete(int id) async {
    final db = await _databaseConnector.database;

    await db.delete(
      "dog_profile",
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<DogProfileEntity?> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<DogProfileEntity>> getAll() async {
    final db = await _databaseConnector.database;
    final List<Map<String, dynamic>> maps = await db.query('dog_profile');

    return List.generate(maps.length, (i) {
      return DogProfileEntity(
          maps[i]['id'],
          maps[i]['name'],
          maps[i]['breed'],
          maps[i]["chip_id"],
          maps[i]["date_of_birth"],
          maps[i]["height"],
          maps[i]["profile_image_path"],
          maps[i]["gender"],
          maps[i]["castrated"]);
    });
  }

  @override
  Future<DogProfileEntity> insert(DogProfileEntity entity) async {
    final db = await _databaseConnector.database;
    entity.id = await db.insert(
      "dog_profile",
      entity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return entity;
  }

  @override
  Future<void> update(DogProfileEntity entity) async {
    final db = await _databaseConnector.database;
    await db.update(
      "dog_profile",
      entity.toMap(),
      where: 'id = ?',
      whereArgs: [entity.id],
    );
  }
}
