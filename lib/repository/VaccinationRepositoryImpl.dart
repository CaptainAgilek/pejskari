import 'package:pejskari/SqliteDatabaseConnector.dart';
import 'package:pejskari/entity/VaccinationEntity.dart';
import 'package:pejskari/repository/CrudRepository.dart';
import 'package:sqflite/sqflite.dart';

/// Repository for CRUD operations on vaccination.
class VaccinationRepositoryImpl implements CrudRepository<VaccinationEntity> {
  final SqliteDatabaseConnector _databaseConnector = SqliteDatabaseConnector();

  @override
  Future<void> delete(int id) async {
    final db = await _databaseConnector.database;

    await db.delete(
      "vaccination",
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<VaccinationEntity?> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<VaccinationEntity>> getAll() async {
    final db = await _databaseConnector.database;
    final List<Map<String, dynamic>> maps = await db.query("vaccination");

    return List.generate(maps.length, (i) {
      return VaccinationEntity(maps[i]['id'], maps[i]['name'], maps[i]['date'],
          maps[i]['notes'], maps[i]["dog_profile_id"]);
    });
  }

  @override
  Future<VaccinationEntity> insert(VaccinationEntity entity) async {
    final db = await _databaseConnector.database;

    entity.id = await db.insert(
      "vaccination",
      entity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return entity;
  }

  @override
  Future<void> update(VaccinationEntity entity) async {
    final db = await _databaseConnector.database;
    await db.update(
      "vaccination",
      entity.toMap(),
      where: 'id = ?',
      whereArgs: [entity.id],
    );
  }
}
