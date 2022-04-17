import 'package:pejskari/SqliteDatabaseConnector.dart';
import 'package:pejskari/entity/DogWeightEntity.dart';
import 'package:pejskari/repository/CrudRepository.dart';
import 'package:sqflite/sqflite.dart';

/// Repository for CRUD operations on dog weight.
class DogWeightRepositoryImpl implements CrudRepository<DogWeightEntity> {
  final SqliteDatabaseConnector _databaseConnector = SqliteDatabaseConnector();

  @override
  Future<void> delete(int id) async {
    final db = await _databaseConnector.database;

    await db.delete(
      "dog_weight",
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<DogWeightEntity?> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<DogWeightEntity>> getAll() async {
    final db = await _databaseConnector.database;
    final List<Map<String, dynamic>> maps = await db.query("dog_weight");

    return List.generate(maps.length, (i) {
      return DogWeightEntity(maps[i]['id'], maps[i]['weight'], maps[i]['date'],
          maps[i]['notes'], maps[i]["dog_profile_id"]);
    });
  }

  @override
  Future<DogWeightEntity> insert(DogWeightEntity entity) async {
    final db = await _databaseConnector.database;

    entity.id = await db.insert(
      "dog_weight",
      entity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return entity;
  }

  @override
  Future<void> update(DogWeightEntity entity) async {
    final db = await _databaseConnector.database;
    await db.update(
      "dog_weight",
      entity.toMap(),
      where: 'id = ?',
      whereArgs: [entity.id],
    );
  }
}
