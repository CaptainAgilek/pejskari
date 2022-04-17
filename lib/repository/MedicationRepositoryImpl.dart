import 'package:pejskari/SqliteDatabaseConnector.dart';
import 'package:pejskari/entity/MedicationEntity.dart';
import 'package:pejskari/repository/CrudRepository.dart';
import 'package:sqflite/sqflite.dart';

/// Repository for CRUD operations on medication.
class MedicationRepositoryImpl implements CrudRepository<MedicationEntity> {
  final SqliteDatabaseConnector _databaseConnector = SqliteDatabaseConnector();

  @override
  Future<void> delete(int id) async {
    final db = await _databaseConnector.database;

    await db.delete(
      "medication",
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<MedicationEntity?> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<MedicationEntity>> getAll() async {
    final db = await _databaseConnector.database;
    final List<Map<String, dynamic>> maps = await db.query("medication");

    return List.generate(maps.length, (i) {
      return MedicationEntity(maps[i]['id'], maps[i]['name'],
          maps[i]['date_time'], maps[i]["notes"], maps[i]["dog_profile_id"]);
    });
  }

  @override
  Future<MedicationEntity> insert(MedicationEntity entity) async {
    final db = await _databaseConnector.database;

    entity.id = await db.insert(
      "medication",
      entity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return entity;
  }

  @override
  Future<void> update(MedicationEntity entity) async {
    final db = await _databaseConnector.database;
    await db.update(
      "medication",
      entity.toMap(),
      where: 'id = ?',
      whereArgs: [entity.id],
    );
  }
}
