import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pejskari/data/Notification.dart';
import 'package:pejskari/data/NotificationRepeatSettings.dart';
import 'package:pejskari/entity/NotificationEntity.dart';
import 'package:pejskari/repository/NotificationRepositoryImpl.dart';
import 'package:pejskari/service/NotificationService.dart';
import 'package:test/test.dart';

import 'NotificationService_test.mocks.dart';

@GenerateMocks([NotificationRepositoryImpl])
void main() {
  test('Get all', () async {
    //GIVEN
    final NotificationService tested = NotificationService();
    final mockRepository = MockNotificationRepositoryImpl();

    List<NotificationEntity> notifications = [
      NotificationEntity(2, "nazev notifikace", "17.5.2020", NotificationRepeatSettings.everyYear),
      NotificationEntity(3, "nazev notifikace2", "17.5.2021", NotificationRepeatSettings.everyDay)
    ];

    when(mockRepository.getAll()).thenAnswer((_) async => notifications);
    tested.repository = mockRepository;

    //WHEN
    var result = await tested.getAll();

    //THEN
    verify(mockRepository.getAll()).called(1);
    expect(result.length, notifications.length);

    for (int i = 0; i < result.length; i++) {
      expect(result[i].id, notifications[i].id);
      expect(result[i].title, notifications[i].title);
      expect(result[i].dateTime, notifications[i].dateTime);
      expect(result[i].repeatSettings, notifications[i].repeatSettings);
    }
  });

  test('Delete', () async {
    //GIVEN
    final NotificationService tested = NotificationService();
    final mockRepository = MockNotificationRepositoryImpl();

    when(mockRepository.delete(any)).thenAnswer((_) async {});
    tested.repository = mockRepository;

    int id = 25;

    //WHEN
    var result = await tested.delete(id);

    //THEN
    verify(mockRepository.delete(id)).called(1);
  });

  test('Create', () async {
    //GIVEN
    final NotificationService tested = NotificationService();
    final mockRepository = MockNotificationRepositoryImpl();

    var notification = Notification(2, "nazev notifikace", "17.5.2020", NotificationRepeatSettings.everyYear);

    when(mockRepository.insert(argThat(isA<NotificationEntity>())))
        .thenAnswer((arg) async {
      return arg.positionalArguments[0];
    });

    tested.repository = mockRepository;

    //WHEN
    var result = await tested.create(notification);

    //THEN
    verify(mockRepository.insert(argThat(isA<NotificationEntity>()))).called(1);
    expect(result.id, notification.id);
    expect(result.title, notification.title);
    expect(result.dateTime, notification.dateTime);
    expect(result.repeatSettings, notification.repeatSettings);
  });

  test('Update', () async {
    //GIVEN
    final NotificationService tested = NotificationService();
    final mockRepository = MockNotificationRepositoryImpl();

    var notification = Notification(2, "nazev notifikace", "17.5.2020", NotificationRepeatSettings.everyYear);

    when(mockRepository.update(argThat(isA<NotificationEntity>())))
        .thenAnswer((_) async {});

    tested.repository = mockRepository;

    //WHEN
    await tested.update(notification);

    //THEN
    var verificationResult =
        verify(mockRepository.update(captureThat(isA<NotificationEntity>())))
          ..called(1);
    var arg = verificationResult.captured.first;

    expect(arg.id, notification.id);
    expect(arg.title, notification.title);
    expect(arg.dateTime, notification.dateTime);
    expect(arg.repeatSettings, notification.repeatSettings);
  });
}
