import 'package:path/path.dart';
import 'package:pejskari/entity/DogProfileEntity.dart';
import 'package:pejskari/entity/DogWeightEntity.dart';
import 'package:pejskari/entity/MedicationEntity.dart';
import 'package:pejskari/entity/NotificationEntity.dart';
import 'package:pejskari/entity/VaccinationEntity.dart';
import 'package:pejskari/entity/VetEntity.dart';
import 'package:pejskari/entity/VetVisitEntity.dart';
import 'package:pejskari/entity/WalkDogProfileEntity.dart';
import 'package:pejskari/entity/WalkEntity.dart';
import 'package:sqflite/sqflite.dart';

/// This class is used for connecting to SQLite database.
class SqliteDatabaseConnector {
  static final SqliteDatabaseConnector _instance =
      SqliteDatabaseConnector._internal();
  factory SqliteDatabaseConnector() => _instance;
  SqliteDatabaseConnector._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _init();

    //force recreate
    await _database?.close();
    await deleteDatabase(join(await getDatabasesPath(), 'app_database.db'));
    _database = await openDatabase(
        join(await getDatabasesPath(), 'app_database.db'),
        version: 1, onCreate: (db, version) async {
      await db.execute(DogProfileEntity.getCreateTableQuery());
      await db.execute(VetVisitEntity.getCreateTableQuery());
      await db.execute(WalkEntity.getCreateTableQuery());
      await db.execute(WalkDogProfileEntity.getCreateTableQuery());
      await db.execute(VetEntity.getCreateTableQuery());
      await db.execute(VaccinationEntity.getCreateTableQuery());
      await db.execute(NotificationEntity.getCreateTableQuery());
      await db.execute(MedicationEntity.getCreateTableQuery());
      return db.execute(
        DogWeightEntity.getCreateTableQuery(),
      );
    }, onConfigure: _onConfigure);
    //force recreate

    return _database!;
  }

  Future<Database?> _init() async {
    return await openDatabase(join(await getDatabasesPath(), 'app_database.db'),
        onCreate: (db, version) async {
      await db.execute(DogProfileEntity.getCreateTableQuery());
      await db.execute(VetVisitEntity.getCreateTableQuery());
      await db.execute(WalkEntity.getCreateTableQuery());
      await db.execute(WalkDogProfileEntity.getCreateTableQuery());
      await db.execute(VetEntity.getCreateTableQuery());
      await db.execute(VaccinationEntity.getCreateTableQuery());
      await db.execute(NotificationEntity.getCreateTableQuery());
      await db.execute(MedicationEntity.getCreateTableQuery());
      return db.execute(DogWeightEntity.getCreateTableQuery());
    },
        onOpen: (
          db,
        ) async {},

        // Set the version. This executes the onCreate function and provides a
        // path to perform database upgrades and downgrades.
        version: 1,
        onConfigure: _onConfigure);
  }

  _onConfigure(Database db) async {
    // Add support for cascade operations
    await db.execute("PRAGMA foreign_keys = ON");
  }
}
