import 'dart:convert';

import 'package:pejskari/SqliteDatabaseConnector.dart';
import 'package:pejskari/entity/VetVisitEntity.dart';
import 'package:pejskari/repository/CrudRepository.dart';
import 'package:sqflite/sqflite.dart';

/// Repository for CRUD operations on vet visit.
class VetVisitRepositoryImpl implements CrudRepository<VetVisitEntity> {
  final SqliteDatabaseConnector _databaseConnector = SqliteDatabaseConnector();

  @override
  Future<void> delete(int id) async {
    final db = await _databaseConnector.database;

    await db.delete(
      "vet_visit",
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<VetVisitEntity?> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<VetVisitEntity>> getAll() async {
    final db = await _databaseConnector.database;
    final List<Map<String, dynamic>> maps = await db.query("vet_visit");

    return List.generate(maps.length, (i) {
      List<String> documentPaths =
          jsonDecode(maps[i]["document_paths"]).cast<String>();
      return VetVisitEntity(maps[i]['id'], maps[i]['date'], maps[i]['notes'],
          maps[i]['vet_id'], maps[i]["dog_profile_id"], documentPaths);
    });
  }

  @override
  Future<VetVisitEntity> insert(VetVisitEntity entity) async {
    final db = await _databaseConnector.database;

    entity.id = await db.insert(
      "vet_visit",
      entity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return entity;
  }

  @override
  Future<void> update(VetVisitEntity entity) async {
    final db = await _databaseConnector.database;
    await db.update(
      "vet_visit",
      entity.toMap(),
      where: 'id = ?',
      whereArgs: [entity.id],
    );
  }
}
