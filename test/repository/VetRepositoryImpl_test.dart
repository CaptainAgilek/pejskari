import 'package:flutter/cupertino.dart';
import 'package:pejskari/SqliteDatabaseConnector.dart';
import 'package:pejskari/entity/VetEntity.dart';
import 'package:pejskari/repository/CrudRepository.dart';
import 'package:pejskari/repository/VetRepositoryImpl.dart';
import 'package:test/test.dart';

//RUN VIA COMMAND ON DEVICE: flutter run test/repository/VetRepositoryImpl_test.dart
void main() {
  group('Vet tests:', ()
  {
    tearDown(() async {
      SqliteDatabaseConnector _databaseConnector = SqliteDatabaseConnector();
      var database = await _databaseConnector.database;
      await database.rawQuery("DELETE FROM vet;");
      await database.rawQuery(
          "DELETE FROM `sqlite_sequence` WHERE `name` = 'vet';"); //reset autosequence for id
    });

    test('Insert vet', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<VetEntity> tested = VetRepositoryImpl();
      VetEntity entity = VetEntity(0, "Karel Novák", "728216485", "poznámky");
      //WHEN
      var result = await tested.insert(entity);
      //THEN
      expect(result.id, 1);
      expect(result, entity);
    });

    test('Get all vets', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<VetEntity> tested = VetRepositoryImpl();

      VetEntity entity = VetEntity(0, "Karel Novák", "728216485", "poznámky");
      VetEntity entity2 = VetEntity(
          0, "Jirka Skočdopole", "778216484", "poznámky2");

      tested.insert(entity);
      tested.insert(entity2);
      //WHEN
      var all = await tested.getAll();
      //THEN
      expect(all.length, 2);
      expect(all.first.id, 1);
      expect(all.first, entity);
      expect(all.last.id, 2);
      expect(all.last, entity2);
    });

    test('Delete vet', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<VetEntity> tested = VetRepositoryImpl();

      VetEntity entity = VetEntity(0, "Karel Novák", "728216485", "poznámky");

      tested.insert(entity);

      var all = await tested.getAll();
      expect(all.length, 1);

      //WHEN
      await tested.delete(all.first.id);
      all = await tested.getAll();

      //THEN
      expect(all.length, 0);
    });

    test('Update vet', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<VetEntity> tested = VetRepositoryImpl();

      VetEntity entity = VetEntity(0, "Karel Novák", "728216485", "poznámky");
      var inserted = await tested.insert(entity);
      expect(inserted.id, 1);

      VetEntity newEntity = VetEntity(
          inserted.id, "Karlos Novák", "729216465", "poznámky upravené");

      //WHEN
      await tested.update(newEntity);
      var all = await tested.getAll();

      //THEN
      expect(all.length, 1);
      expect(all.first.id, 1);
      expect(all.first, newEntity);
    });
  });
}