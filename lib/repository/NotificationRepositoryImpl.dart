import 'package:pejskari/SqliteDatabaseConnector.dart';
import 'package:pejskari/data/NotificationRepeatSettings.dart';
import 'package:pejskari/entity/NotificationEntity.dart';
import 'package:pejskari/repository/CrudRepository.dart';
import 'package:sqflite/sqflite.dart';

/// Repository for CRUD operations on dog profile.
class NotificationRepositoryImpl implements CrudRepository<NotificationEntity> {
  final SqliteDatabaseConnector _databaseConnector = SqliteDatabaseConnector();

  @override
  Future<void> delete(int id) async {
    final db = await _databaseConnector.database;

    await db.delete(
      "notification",
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<NotificationEntity?> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<NotificationEntity>> getAll() async {
    final db = await _databaseConnector.database;
    final List<Map<String, dynamic>> maps = await db.query("notification");

    return List.generate(maps.length, (i) {
      return NotificationEntity(maps[i]['id'], maps[i]['title'], maps[i]['date_time'],
          NotificationRepeatSettings.none.fromValue(maps[i]['repeat_settings']));
    });
  }

  @override
  Future<NotificationEntity> insert(NotificationEntity entity) async {
    final db = await _databaseConnector.database;

    entity.id = await db.insert(
      "notification",
      entity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return entity;
  }

  @override
  Future<void> update(NotificationEntity entity) async {
    final db = await _databaseConnector.database;
    await db.update(
      "notification",
      entity.toMap(),
      where: 'id = ?',
      whereArgs: [entity.id],
    );
  }

}