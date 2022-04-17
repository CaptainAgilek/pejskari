import 'package:flutter/cupertino.dart';
import 'package:pejskari/SqliteDatabaseConnector.dart';
import 'package:pejskari/entity/DogProfileEntity.dart';
import 'package:pejskari/entity/MedicationEntity.dart';
import 'package:pejskari/repository/CrudRepository.dart';
import 'package:pejskari/repository/DogProfileRepositoryImpl.dart';
import 'package:pejskari/repository/MedicationRepositoryImpl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test/test.dart';

//RUN VIA COMMAND ON DEVICE: flutter run test/repository/MedicationRepositoryImpl_test.dart
void main() {
  group('Medication tests:', () {
    tearDown(() async {
      SqliteDatabaseConnector _databaseConnector = SqliteDatabaseConnector();
      var database = await _databaseConnector.database;
      await database.rawQuery("DELETE FROM medication;");
      await database.rawQuery(
          "DELETE FROM `sqlite_sequence` WHERE `name` = 'medication';"); //reset autosequence for id
      await database.rawQuery("DELETE FROM dog_profile;");
      await database.rawQuery(
          "DELETE FROM `sqlite_sequence` WHERE `name` = 'dog_profile';"); //reset autosequence for id
    });

    test('Insert medication with nonexistent dog profile foreign key',
        () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<MedicationEntity> tested = MedicationRepositoryImpl();
      MedicationEntity entity =
          MedicationEntity(0, "léky", "17.5.2020", "poznámky", 1);

      //WHEN
      try {
        await tested.insert(entity);
      } catch (e) {
        //THEN
        expect(e, isA<DatabaseException>());
        expect((e as DatabaseException).getResultCode(),
            787); //https://www.sqlite.org/rescode.html
        return;
      }
      fail(
          "Exception not thrown! Exception should be thrown because foreign key constraint was violated.");
    });

    test('Insert medication', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<MedicationEntity> tested = MedicationRepositoryImpl();

      //ensure dog profile exists
      CrudRepository<DogProfileEntity> dogProfileRepository =
          DogProfileRepositoryImpl();
      var insertedDogProfile = await dogProfileRepository.insert(
          DogProfileEntity(0, "Kiko", "Zlatý retrívr", "123456789", "17.5.2020",
              50, "profileImagePath", 1, 0));

      MedicationEntity entity =
          MedicationEntity(0, "léky", "17.5.2020", "poznámky", 1);

      //WHEN
      var result = await tested.insert(entity);

      //THEN
      expect(result.id, 1);
      expect(result, entity);
    });

    test('Get all medications', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<MedicationEntity> tested = MedicationRepositoryImpl();

      //ensure dog profile exists
      CrudRepository<DogProfileEntity> dogProfileRepository =
          DogProfileRepositoryImpl();
      var insertedDogProfile = await dogProfileRepository.insert(
          DogProfileEntity(0, "Kiko", "Zlatý retrívr", "123456789", "17.5.2020",
              50, "profileImagePath", 1, 0));

      MedicationEntity entity = MedicationEntity(
          0, "léky", "17.5.2020", "poznámky", insertedDogProfile.id);
      MedicationEntity entity2 = MedicationEntity(
          0, "léky2", "20.5.2020", "poznámky2", insertedDogProfile.id);

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

    test('Delete medication', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<MedicationEntity> tested = MedicationRepositoryImpl();

      //ensure dog profile exists
      CrudRepository<DogProfileEntity> dogProfileRepository =
          DogProfileRepositoryImpl();
      var insertedDogProfile = await dogProfileRepository.insert(
          DogProfileEntity(0, "Kiko", "Zlatý retrívr", "123456789", "17.5.2020",
              50, "profileImagePath", 1, 0));

      MedicationEntity entity = MedicationEntity(
          0, "léky", "17.5.2020", "poznámky", insertedDogProfile.id);

      tested.insert(entity);

      var all = await tested.getAll();
      expect(all.length, 1);

      //WHEN
      await tested.delete(all.first.id);
      all = await tested.getAll();

      //THEN
      expect(all.length, 0);
    });

    test('Update medication', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<MedicationEntity> tested = MedicationRepositoryImpl();

      //ensure dog profile exists
      CrudRepository<DogProfileEntity> dogProfileRepository =
          DogProfileRepositoryImpl();
      var insertedDogProfile = await dogProfileRepository.insert(
          DogProfileEntity(0, "Kiko", "Zlatý retrívr", "123456789", "17.5.2020",
              50, "profileImagePath", 1, 0));

      MedicationEntity entity = MedicationEntity(
          0, "léky", "17.5.2020", "poznámky", insertedDogProfile.id);

      var inserted = await tested.insert(entity);
      expect(inserted.id, 1);

      MedicationEntity newEntity = MedicationEntity(
          inserted.id,
          "léky upravené",
          "18.6.2020",
          "poznámky upravené",
          insertedDogProfile.id);

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
