import 'package:flutter/cupertino.dart';
import 'package:pejskari/SqliteDatabaseConnector.dart';
import 'package:pejskari/entity/DogProfileEntity.dart';
import 'package:pejskari/entity/VaccinationEntity.dart';
import 'package:pejskari/repository/CrudRepository.dart';
import 'package:pejskari/repository/DogProfileRepositoryImpl.dart';
import 'package:pejskari/repository/VaccinationRepositoryImpl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test/test.dart';

//RUN VIA COMMAND ON DEVICE: flutter run test/repository/VaccinationRepositoryImpl_test.dart
void main() {
  group('Vaccination tests:', () {
    tearDown(() async {
      SqliteDatabaseConnector _databaseConnector = SqliteDatabaseConnector();
      var database = await _databaseConnector.database;
      await database.rawQuery("DELETE FROM vaccination;");
      await database.rawQuery(
          "DELETE FROM `sqlite_sequence` WHERE `name` = 'vaccination';"); //reset autosequence for id
      await database.rawQuery("DELETE FROM dog_profile;");
      await database.rawQuery(
          "DELETE FROM `sqlite_sequence` WHERE `name` = 'dog_profile';"); //reset autosequence for id
    });

    test('Insert vaccination with nonexistent dog profile foreign key',
        () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<VaccinationEntity> tested = VaccinationRepositoryImpl();
      VaccinationEntity entity =
          VaccinationEntity(0, "název vakcíny", "17.5.2020", "poznámky", 1);
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

    test('Insert vaccination', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<VaccinationEntity> tested = VaccinationRepositoryImpl();

      //ensure dog profile exists
      CrudRepository<DogProfileEntity> dogProfileRepository =
          DogProfileRepositoryImpl();
      var insertedDogProfile = await dogProfileRepository.insert(
          DogProfileEntity(0, "Kiko", "Zlatý retrívr", "123456789", "17.5.2020",
              50, "profileImagePath", 1, 0));

      VaccinationEntity entity =
          VaccinationEntity(0, "název vakcíny", "17.5.2020", "poznámky", 1);

      //WHEN
      var result = await tested.insert(entity);

      //THEN
      expect(result.id, 1);
      expect(result, entity);
    });

    test('Get all vaccinations', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<VaccinationEntity> tested = VaccinationRepositoryImpl();

      //ensure dog profile exists
      CrudRepository<DogProfileEntity> dogProfileRepository =
          DogProfileRepositoryImpl();
      var insertedDogProfile = await dogProfileRepository.insert(
          DogProfileEntity(0, "Kiko", "Zlatý retrívr", "123456789", "17.5.2020",
              50, "profileImagePath", 1, 0));

      VaccinationEntity entity =
          VaccinationEntity(0, "název vakcíny", "17.5.2020", "poznámky", 1);
      VaccinationEntity entity2 =
          VaccinationEntity(0, "název vakcíny2", "18.5.2020", "poznámky2", 1);

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

    test('Delete vaccination', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<VaccinationEntity> tested = VaccinationRepositoryImpl();

      //ensure dog profile exists
      CrudRepository<DogProfileEntity> dogProfileRepository =
          DogProfileRepositoryImpl();
      var insertedDogProfile = await dogProfileRepository.insert(
          DogProfileEntity(0, "Kiko", "Zlatý retrívr", "123456789", "17.5.2020",
              50, "profileImagePath", 1, 0));

      VaccinationEntity entity =
          VaccinationEntity(0, "název vakcíny", "17.5.2020", "poznámky", 1);

      tested.insert(entity);

      var all = await tested.getAll();
      expect(all.length, 1);

      //WHEN
      await tested.delete(all.first.id);
      all = await tested.getAll();

      //THEN
      expect(all.length, 0);
    });

    test('Update vaccination', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<VaccinationEntity> tested = VaccinationRepositoryImpl();

      //ensure dog profile exists
      CrudRepository<DogProfileEntity> dogProfileRepository =
          DogProfileRepositoryImpl();
      var insertedDogProfile = await dogProfileRepository.insert(
          DogProfileEntity(0, "Kiko", "Zlatý retrívr", "123456789", "17.5.2020",
              50, "profileImagePath", 1, 0));

      VaccinationEntity entity =
          VaccinationEntity(0, "název vakcíny", "17.5.2020", "poznámky", 1);

      var inserted = await tested.insert(entity);
      expect(inserted.id, 1);

      VaccinationEntity newEntity = VaccinationEntity(
          inserted.id,
          "název vakcíny upravený",
          "19.5.2020",
          "poznámky upravené",
          inserted.dogProfileId);

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
