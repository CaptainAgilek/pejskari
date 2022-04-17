import 'package:flutter/cupertino.dart';
import 'package:pejskari/SqliteDatabaseConnector.dart';
import 'package:pejskari/entity/DogProfileEntity.dart';
import 'package:pejskari/repository/CrudRepository.dart';
import 'package:pejskari/repository/DogProfileRepositoryImpl.dart';
import 'package:test/test.dart';

//RUN VIA COMMAND ON DEVICE: flutter run test/repository/DogProfileRepositoryImpl_test.dart
void main() {
  group('Dog profile tests:', () {
    tearDown(() async {
      SqliteDatabaseConnector _databaseConnector = SqliteDatabaseConnector();
      var database = await _databaseConnector.database;
      await database.rawQuery("DELETE FROM dog_profile;");
      await database.rawQuery(
          "DELETE FROM sqlite_sequence WHERE name = 'dog_profile';"); //reset autosequence for id
    });

    test('Insert dog profile', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<DogProfileEntity> tested = DogProfileRepositoryImpl();
      DogProfileEntity entity = DogProfileEntity(0, "Kiko", "Zlatý retrívr",
          "123456789", "17.5.2020", 50, "profileImagePath", 1, 0);
      //WHEN
      var result = await tested.insert(entity);
      //THEN
      expect(result.id, 1);
      expect(result, entity);
    });

    test('Get all dog profiles', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<DogProfileEntity> tested = DogProfileRepositoryImpl();
      DogProfileEntity entity = DogProfileEntity(0, "Kiko", "Zlatý retrívr",
          "123456789", "17.5.2020", 50, "profileImagePath", 1, 0);
      DogProfileEntity entity2 = DogProfileEntity(0, "Čiko", "Husky",
          "123456789", "17.5.2021", 45, "profileImagePath2", 0, 1);
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

    test('Delete dog profile', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<DogProfileEntity> tested = DogProfileRepositoryImpl();
      DogProfileEntity entity = DogProfileEntity(0, "Kiko", "Zlatý retrívr",
          "123456789", "17.5.2020", 50, "profileImagePath", 1, 0);
      tested.insert(entity);

      var all = await tested.getAll();
      expect(all.length, 1);

      //WHEN
      await tested.delete(all.first.id);
      all = await tested.getAll();

      //THEN
      expect(all.length, 0);
    });

    test('Update dog profile', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<DogProfileEntity> tested = DogProfileRepositoryImpl();
      DogProfileEntity entity = DogProfileEntity(0, "Kiko", "Zlatý retrívr",
          "123456789", "17.5.2020", 50, "profileImagePath", 1, 0);
      var inserted = await tested.insert(entity);
      expect(inserted.id, 1);

      DogProfileEntity newEntity = DogProfileEntity(
          inserted.id,
          "Fat Kiko",
          "Zlatý retrívr",
          "123456789",
          "17.5.2020",
          60,
          "profileImagePath2",
          1,
          1);
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
