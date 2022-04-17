import 'package:flutter/cupertino.dart';
import 'package:pejskari/SqliteDatabaseConnector.dart';
import 'package:pejskari/data/NotificationRepeatSettings.dart';
import 'package:pejskari/entity/NotificationEntity.dart';
import 'package:pejskari/repository/CrudRepository.dart';
import 'package:pejskari/repository/NotificationRepositoryImpl.dart';
import 'package:test/test.dart';

//RUN VIA COMMAND ON DEVICE: flutter run test/repository/NotificationRepositoryImpl_test.dart
void main() {
  group('Notification tests:', ()
  {
    tearDown(() async {
      SqliteDatabaseConnector _databaseConnector = SqliteDatabaseConnector();
      var database = await _databaseConnector.database;
      await database.rawQuery("DELETE FROM notification;");
      await database.rawQuery(
          "DELETE FROM `sqlite_sequence` WHERE `name` = 'notification';"); //reset autosequence for id
    });

    test('Insert notification', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<NotificationEntity> tested = NotificationRepositoryImpl();
      NotificationEntity entity = NotificationEntity(
          0, "upozornění", "17.5.2020", NotificationRepeatSettings.everyDay);
      //WHEN
      var result = await tested.insert(entity);
      //THEN
      expect(result.id, 1);
      expect(result, entity);
    });

    test('Get all notifications', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<NotificationEntity> tested = NotificationRepositoryImpl();

      NotificationEntity entity = NotificationEntity(
          0, "upozornění", "17.5.2020", NotificationRepeatSettings.everyDay);
      NotificationEntity entity2 = NotificationEntity(
          0, "upozornění2", "18.5.2020", NotificationRepeatSettings.everyWeek);

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

    test('Delete notification', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<NotificationEntity> tested = NotificationRepositoryImpl();

      NotificationEntity entity = NotificationEntity(
          0, "upozornění", "17.5.2020", NotificationRepeatSettings.everyDay);

      tested.insert(entity);

      var all = await tested.getAll();
      expect(all.length, 1);

      //WHEN
      await tested.delete(all.first.id);
      all = await tested.getAll();

      //THEN
      expect(all.length, 0);
    });

    test('Update notification', () async {
      //GIVEN
      WidgetsFlutterBinding.ensureInitialized();
      CrudRepository<NotificationEntity> tested = NotificationRepositoryImpl();

      NotificationEntity entity = NotificationEntity(
          0, "upozornění", "17.5.2020", NotificationRepeatSettings.everyDay);
      var inserted = await tested.insert(entity);
      expect(inserted.id, 1);

      NotificationEntity newEntity = NotificationEntity(
          inserted.id, "upravené upozornění", "18.5.2020",
          NotificationRepeatSettings.everyWeek);
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