import 'package:flutter/cupertino.dart';
import 'package:pejskari/SqliteDatabaseConnector.dart';
import 'package:pejskari/entity/DogProfileEntity.dart';
import 'package:pejskari/entity/VetEntity.dart';
import 'package:pejskari/entity/VetVisitEntity.dart';
import 'package:pejskari/repository/CrudRepository.dart';
import 'package:pejskari/repository/DogProfileRepositoryImpl.dart';
import 'package:pejskari/repository/VetRepositoryImpl.dart';
import 'package:pejskari/repository/VetVisitRepositoryImpl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test/test.dart';

//RUN VIA COMMAND ON DEVICE: flutter run test/repository/VetVisitRepositoryImpl_test.dart
void main() {
  group('Vet visit tests:', () {
    tearDown(() async {
      SqliteDatabaseConnector _databaseConnector = SqliteDatabaseConnector();
      var database = await _databaseConnector.database;
      await database.rawQuery("DELETE FROM vet_visit;");
      await database.rawQuery(
          "DELETE FROM `sqlite_sequence` WHERE `name` = 'vet_visit';"); //reset autosequence for id
      await database.rawQuery("DELETE FROM dog_profile;");
      await database.rawQuery(
          "DELETE FROM `sqlite_sequence` WHERE `name` = 'dog_profile';"); //reset autosequence for id
      await database.rawQuery("DELETE FROM vet;");
      await database.rawQuery(
          "DELETE FROM `sqlite_sequence` WHERE `name` = 'vet';"); //reset autosequence for id
    });

    test('Insert vet visit with nonexistent dog profile and vet foreign key',
        () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<VetVisitEntity> tested = VetVisitRepositoryImpl();
      VetVisitEntity entity =
          VetVisitEntity(2, "17.5.2020", "poznámky", 1, 1, ["path1", "path2"]);

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

    test('Insert vet visit with nonexistent dog profile', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<VetVisitEntity> tested = VetVisitRepositoryImpl();

      //ensure vet exists
      CrudRepository<VetEntity> vetRepository = VetRepositoryImpl();
      var insertedVet = await vetRepository.insert(VetEntity(
        0,
        "Karel Novák",
        "728215489",
        "poznámky",
      ));

      VetVisitEntity entity = VetVisitEntity(
          0, "17.5.2020", "poznámky", insertedVet.id, 1, ["path1", "path2"]);

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

    test('Insert vet visit with nonexistent vet', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<VetVisitEntity> tested = VetVisitRepositoryImpl();

      //ensure dog profile exists
      CrudRepository<DogProfileEntity> dogProfileRepository =
          DogProfileRepositoryImpl();
      var insertedDogProfile = await dogProfileRepository.insert(
          DogProfileEntity(0, "Kiko", "Zlatý retrívr", "123456789", "17.5.2020",
              50, "profileImagePath", 1, 0));

      VetVisitEntity entity = VetVisitEntity(0, "17.5.2020", "poznámky", 1,
          insertedDogProfile.id, ["path1", "path2"]);

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

    test('Insert vet visit', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<VetVisitEntity> tested = VetVisitRepositoryImpl();

      //ensure dog profile exists
      CrudRepository<DogProfileEntity> dogProfileRepository =
          DogProfileRepositoryImpl();
      var insertedDogProfile = await dogProfileRepository.insert(
          DogProfileEntity(0, "Kiko", "Zlatý retrívr", "123456789", "17.5.2020",
              50, "profileImagePath", 1, 0));

      //ensure vet exists
      CrudRepository<VetEntity> vetRepository = VetRepositoryImpl();
      var insertedVet = await vetRepository.insert(VetEntity(
        0,
        "Karel Novák",
        "728215489",
        "poznámky",
      ));

      VetVisitEntity entity = VetVisitEntity(0, "17.5.2020", "poznámky",
          insertedVet.id, insertedDogProfile.id, ["path1", "path2"]);

      //WHEN
      var result = await tested.insert(entity);

      //THEN
      expect(result.id, 1);
      expect(result, entity);
    });

    test('Get all vet visits', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<VetVisitEntity> tested = VetVisitRepositoryImpl();

      //ensure dog profile exists
      CrudRepository<DogProfileEntity> dogProfileRepository =
          DogProfileRepositoryImpl();
      var insertedDogProfile = await dogProfileRepository.insert(
          DogProfileEntity(0, "Kiko", "Zlatý retrívr", "123456789", "17.5.2020",
              50, "profileImagePath", 1, 0));

      //ensure vet exists
      CrudRepository<VetEntity> vetRepository = VetRepositoryImpl();
      var insertedVet = await vetRepository.insert(VetEntity(
        0,
        "Karel Novák",
        "728215489",
        "poznámky",
      ));

      VetVisitEntity entity = VetVisitEntity(0, "17.5.2020", "poznámky",
          insertedVet.id, insertedDogProfile.id, ["path1", "path2"]);
      VetVisitEntity entity2 = VetVisitEntity(0, "19.6.2020", "poznámky2",
          insertedVet.id, insertedDogProfile.id, ["path3", "path4"]);

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

    test('Delete vet visit', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<VetVisitEntity> tested = VetVisitRepositoryImpl();

      //ensure dog profile exists
      CrudRepository<DogProfileEntity> dogProfileRepository =
          DogProfileRepositoryImpl();
      var insertedDogProfile = await dogProfileRepository.insert(
          DogProfileEntity(0, "Kiko", "Zlatý retrívr", "123456789", "17.5.2020",
              50, "profileImagePath", 1, 0));

      //ensure vet exists
      CrudRepository<VetEntity> vetRepository = VetRepositoryImpl();
      var insertedVet = await vetRepository.insert(VetEntity(
        0,
        "Karel Novák",
        "728215489",
        "poznámky",
      ));

      VetVisitEntity entity = VetVisitEntity(0, "17.5.2020", "poznámky",
          insertedVet.id, insertedDogProfile.id, ["path1", "path2"]);

      tested.insert(entity);

      var all = await tested.getAll();
      expect(all.length, 1);

      //WHEN
      await tested.delete(all.first.id);
      all = await tested.getAll();

      //THEN
      expect(all.length, 0);
    });

    test('Deleting vet should delete vet visit (cascade)', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<VetVisitEntity> tested = VetVisitRepositoryImpl();

      //ensure dog profile exists
      CrudRepository<DogProfileEntity> dogProfileRepository =
          DogProfileRepositoryImpl();
      var insertedDogProfile = await dogProfileRepository.insert(
          DogProfileEntity(0, "Kiko", "Zlatý retrívr", "123456789", "17.5.2020",
              50, "profileImagePath", 1, 0));

      //ensure vet exists
      CrudRepository<VetEntity> vetRepository = VetRepositoryImpl();
      var insertedVet = await vetRepository.insert(VetEntity(
        0,
        "Karel Novák",
        "728215489",
        "poznámky",
      ));

      VetVisitEntity entity = VetVisitEntity(0, "17.5.2020", "poznámky",
          insertedVet.id, insertedDogProfile.id, ["path1", "path2"]);

      tested.insert(entity);

      var all = await tested.getAll();
      expect(all.length, 1);

      //WHEN
      await vetRepository.delete(insertedVet.id);
      all = await tested.getAll();

      //THEN
      expect(all.length, 0);
    });

    test('Deleting dog profile should delete vet visit (cascade)', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<VetVisitEntity> tested = VetVisitRepositoryImpl();

      //ensure dog profile exists
      CrudRepository<DogProfileEntity> dogProfileRepository =
          DogProfileRepositoryImpl();
      var insertedDogProfile = await dogProfileRepository.insert(
          DogProfileEntity(0, "Kiko", "Zlatý retrívr", "123456789", "17.5.2020",
              50, "profileImagePath", 1, 0));

      //ensure vet exists
      CrudRepository<VetEntity> vetRepository = VetRepositoryImpl();
      var insertedVet = await vetRepository.insert(VetEntity(
        0,
        "Karel Novák",
        "728215489",
        "poznámky",
      ));

      VetVisitEntity entity = VetVisitEntity(0, "17.5.2020", "poznámky",
          insertedVet.id, insertedDogProfile.id, ["path1", "path2"]);

      tested.insert(entity);

      var all = await tested.getAll();
      expect(all.length, 1);

      //WHEN
      await dogProfileRepository.delete(insertedDogProfile.id);
      all = await tested.getAll();

      //THEN
      expect(all.length, 0);
    });

    //
    test('Update vet visit', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<VetVisitEntity> tested = VetVisitRepositoryImpl();

      //ensure dog profile exists
      CrudRepository<DogProfileEntity> dogProfileRepository =
          DogProfileRepositoryImpl();
      var insertedDogProfile = await dogProfileRepository.insert(
          DogProfileEntity(0, "Kiko", "Zlatý retrívr", "123456789", "17.5.2020",
              50, "profileImagePath", 1, 0));

      //ensure vet exists
      CrudRepository<VetEntity> vetRepository = VetRepositoryImpl();
      var insertedVet = await vetRepository.insert(VetEntity(
        0,
        "Karel Novák",
        "728215489",
        "poznámky",
      ));

      VetVisitEntity entity = VetVisitEntity(0, "17.5.2020", "poznámky",
          insertedVet.id, insertedDogProfile.id, ["path1", "path2"]);

      var inserted = await tested.insert(entity);
      expect(inserted.id, 1);

      VetVisitEntity newEntity = VetVisitEntity(
          inserted.id,
          "18.5.2020",
          "poznámky upravené",
          insertedVet.id,
          insertedDogProfile.id,
          ["path3", "path4"]);

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
