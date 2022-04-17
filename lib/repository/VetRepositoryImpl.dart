import 'package:pejskari/SqliteDatabaseConnector.dart';
import 'package:pejskari/entity/VetEntity.dart';
import 'package:pejskari/repository/CrudRepository.dart';
import 'package:sqflite/sqflite.dart';

/// Repository for CRUD operations on vet.
class VetRepositoryImpl implements CrudRepository<VetEntity> {
  final SqliteDatabaseConnector _databaseConnector = SqliteDatabaseConnector();

  @override
  Future<void> delete(int id) async {
    final db = await _databaseConnector.database;

    await db.delete(
      "vet",
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<VetEntity?> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<VetEntity>> getAll() async {
    final db = await _databaseConnector.database;
    final List<Map<String, dynamic>> maps = await db.query("vet");

    return List.generate(maps.length, (i) {
      return VetEntity(maps[i]['id'], maps[i]['name'],
          maps[i]['phone'].toString(), maps[i]['notes']);
    });
  }

  @override
  Future<VetEntity> insert(VetEntity entity) async {
    final db = await _databaseConnector.database;

    entity.id = await db.insert(
      "vet",
      entity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return entity;
  }

  @override
  Future<void> update(VetEntity entity) async {
    final db = await _databaseConnector.database;
    await db.update(
      "vet",
      entity.toMap(),
      where: 'id = ?',
      whereArgs: [entity.id],
    );
  }
}
