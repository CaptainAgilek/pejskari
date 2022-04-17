import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:pejskari/SqliteDatabaseConnector.dart';
import 'package:pejskari/entity/DogProfileEntity.dart';
import 'package:pejskari/entity/WalkEntity.dart';
import 'package:pejskari/repository/CrudRepository.dart';
import 'package:pejskari/repository/DogProfileRepositoryImpl.dart';
import 'package:pejskari/repository/WalkRepositoryImpl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test/test.dart';

//RUN VIA COMMAND ON DEVICE: flutter run test/repository/WalkRepositoryImpl_test.dart
Future<void> main() async {
  group('Walk tests:', () {
    tearDown(() async {
      WidgetsFlutterBinding.ensureInitialized();
      SqliteDatabaseConnector _databaseConnector = SqliteDatabaseConnector();
      var database = await _databaseConnector.database;
      await database.rawQuery("DELETE FROM walk;");
      await database.rawQuery(
          "DELETE FROM `sqlite_sequence` WHERE `name` = 'walk';"); //reset autosequence for id
      await database.rawQuery("DELETE FROM dog_profile;");
      await database.rawQuery(
          "DELETE FROM `sqlite_sequence` WHERE `name` = 'dog_profile';"); //reset autosequence for id
    });

    test('Insert walk with no dog profile id', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<WalkEntity> tested = WalkRepositoryImpl();
      WalkEntity entity = WalkEntity(0, "17.5.2020", "poznámky", 10, 3000, []);
      //WHEN

      var inserted = await tested.insert(entity);

      //THEN
      expect(inserted.id, 1);
      expect(inserted, entity);
    });

    test('Insert walk with non existent dog profile id', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<WalkEntity> tested = WalkRepositoryImpl();
      WalkEntity entity = WalkEntity(0, "17.5.2020", "poznámky", 10, 3000, [1]);
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

    test('Insert walk', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<WalkEntity> tested = WalkRepositoryImpl();

      //ensure dog profile exists
      CrudRepository<DogProfileEntity> dogProfileRepository =
          DogProfileRepositoryImpl();
      var insertedDogProfile = await dogProfileRepository.insert(
          DogProfileEntity(0, "Kiko", "Zlatý retrívr", "123456789", "17.5.2020",
              50, "profileImagePath", 1, 0));

      var insertedDogProfile2 = await dogProfileRepository.insert(
          DogProfileEntity(0, "Čiko", "Husky", "123458689", "17.6.2020", 52,
              "profileImagePath2", 0, 0));

      WalkEntity entity = WalkEntity(0, "17.5.2020", "poznámky", 10, 3000,
          [insertedDogProfile.id, insertedDogProfile2.id]);

      //WHEN

      var inserted = await tested.insert(entity);

      //THEN
      expect(inserted.id, 1);
      expect(inserted, entity);
    });

    test('Get all walks', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<WalkEntity> tested = WalkRepositoryImpl();

      //ensure dog profile exists
      CrudRepository<DogProfileEntity> dogProfileRepository =
          DogProfileRepositoryImpl();
      var insertedDogProfile = await dogProfileRepository.insert(
          DogProfileEntity(0, "Kiko", "Zlatý retrívr", "123456789", "17.5.2020",
              50, "profileImagePath", 1, 0));
      WalkEntity entity = WalkEntity(
          0, "17.5.2020", "poznámky", 10, 3000, [insertedDogProfile.id]);
      WalkEntity entity2 = WalkEntity(
          0, "18.5.2020", "poznámky2", 15, 3500, [insertedDogProfile.id]);

      await tested.insert(entity);
      await tested.insert(entity2);

      //WHEN
      var all = await tested.getAll();

      //THEN
      expect(all.length, 2);
      expect(all.first.id, 1);
      expect(all.first, entity);
      expect(all.last.id, 2);
      expect(all.last, entity2);
    });

    test('Delete walk', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<WalkEntity> tested = WalkRepositoryImpl();

      //ensure dog profile exists
      CrudRepository<DogProfileEntity> dogProfileRepository =
          DogProfileRepositoryImpl();
      var insertedDogProfile = await dogProfileRepository.insert(
          DogProfileEntity(0, "Kiko", "Zlatý retrívr", "123456789", "17.5.2020",
              50, "profileImagePath", 1, 0));

      WalkEntity entity = WalkEntity(
          0, "17.5.2020", "poznámky", 10, 3000, [insertedDogProfile.id]);

      tested.insert(entity);

      var all = await tested.getAll();
      expect(all.length, 1);

      //WHEN
      await tested.delete(all.first.id);
      all = await tested.getAll();

      //THEN
      expect(all.length, 0);
      SqliteDatabaseConnector _databaseConnector = SqliteDatabaseConnector();
      var database = await _databaseConnector.database;
      var list = await database.query("walk_dog_profile");
      expect(list.length, 0);
    });

    test('Update walk', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<WalkEntity> tested = WalkRepositoryImpl();

      //ensure dog profile exists
      CrudRepository<DogProfileEntity> dogProfileRepository =
          DogProfileRepositoryImpl();
      var insertedDogProfile = await dogProfileRepository.insert(
          DogProfileEntity(0, "Kiko", "Zlatý retrívr", "123456789", "17.5.2020",
              50, "profileImagePath", 1, 0));
      var insertedDogProfile2 = await dogProfileRepository.insert(
          DogProfileEntity(0, "Kiko2", "Zlatý retrívr", "123456789",
              "17.5.2020", 50, "profileImagePath", 1, 0));

      WalkEntity entity = WalkEntity(
          0, "17.5.2020", "poznámky", 10, 3000, [insertedDogProfile.id]);

      var inserted = await tested.insert(entity);
      expect(inserted.id, 1);

      WalkEntity newEntity = WalkEntity(inserted.id, "18.5.2020",
          "poznámky upravené", 15, 3350, [insertedDogProfile2.id]);

      //WHEN
      await tested.update(newEntity);
      var all = await tested.getAll();

      //THEN
      expect(all.length, 1);
      expect(all.first.id, 1);
      expect(all.first, newEntity);

      SqliteDatabaseConnector _databaseConnector = SqliteDatabaseConnector();
      var database = await _databaseConnector.database;
      var list = await database.query("walk_dog_profile");
      expect(list.length, 1);
    });

    test('Update walk with removing dog from walk', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<WalkEntity> tested = WalkRepositoryImpl();

      //ensure dog profile exists
      CrudRepository<DogProfileEntity> dogProfileRepository =
          DogProfileRepositoryImpl();
      var insertedDogProfile = await dogProfileRepository.insert(
          DogProfileEntity(0, "Kiko", "Zlatý retrívr", "123456789", "17.5.2020",
              50, "profileImagePath", 1, 0));

      WalkEntity entity = WalkEntity(
          0, "17.5.2020", "poznámky", 10, 3000, [insertedDogProfile.id]);

      var inserted = await tested.insert(entity);
      expect(inserted.id, 1);

      WalkEntity newEntity = WalkEntity(
          inserted.id, "18.5.2020", "poznámky upravené", 15, 3350, []);

      //WHEN
      await tested.update(newEntity);
      var all = await tested.getAll();

      //THEN
      expect(all.length, 1);
      expect(all.first.id, 1);
      expect(all.first, newEntity);

      SqliteDatabaseConnector _databaseConnector = SqliteDatabaseConnector();
      var database = await _databaseConnector.database;
      var list = await database.query("walk_dog_profile");
      expect(list.length, 0);
    });
  });
}
