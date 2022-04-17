import 'package:clock/clock.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pejskari/data/Notification.dart' as Data;
import 'package:pejskari/data/NotificationRepeatSettings.dart';
import 'package:pejskari/entity/NotificationEntity.dart';
import 'package:pejskari/main.dart';
import 'package:pejskari/repository/CrudRepository.dart';
import 'package:pejskari/repository/NotificationRepositoryImpl.dart';
import 'package:pejskari/routes/Routes.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

//https://github.com/MaikuB/flutter_local_notifications/tree/master/flutter_local_notifications/example
/// Service for operations with notifications.
class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  CrudRepository<NotificationEntity> _repository = NotificationRepositoryImpl();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String channel_id = "1";

  set repository(CrudRepository<NotificationEntity> repository) {
    _repository = repository;
  }

  Future<List<Data.Notification>> getAll() async {
    List<NotificationEntity> entities = await _repository.getAll();
    var notifications = entities
        .map((e) =>
            Data.Notification(e.id, e.title, e.dateTime, e.repeatSettings))
        .toList();
    return notifications;
  }

  Future<Data.Notification> create(Data.Notification notification) async {
    var inserted = await _repository.insert(NotificationEntity(
        notification.id,
        notification.title,
        notification.dateTime,
        notification.repeatSettings));
    return Data.Notification(inserted.id, inserted.title, inserted.dateTime,
        inserted.repeatSettings);
  }

  Future<void> update(Data.Notification notification) async {
    return await _repository.update(NotificationEntity(
        notification.id,
        notification.title,
        notification.dateTime,
        notification.repeatSettings));
  }

  Future<void> delete(int id) async {
    await _repository.delete(id);
  }

  //local notifications //

  Future<void> init() async {
    _requestPermissions();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("app_icon");

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      //requestSoundPermission: false,
      //requestBadgePermission: false,
      //requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    tz.initializeTimeZones();
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  /// When user taps on notification, opens notifications page.
  void selectNotification(String? payload) async {
    if (payload != null && navigatorKey.currentState != null) {
      await navigatorKey.currentState!
          .pushReplacementNamed(Routes.notificationsPage);
    }
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {}

  /// Schedules notification.
  void scheduleNotification(Data.Notification notification) async {
    DateTime dateTime = DateTime.parse(notification.dateTime);
    tz.setLocalLocation(tz.getLocation("Europe/Prague"));
    var tzDateTime = tz.TZDateTime(tz.local, dateTime.year, dateTime.month,
        dateTime.day, dateTime.hour, dateTime.minute);

    DateTimeComponents? dateTimeComponents = null;
    if (notification.repeatSettings == NotificationRepeatSettings.everyDay) {
      dateTimeComponents = DateTimeComponents.time;
    } else if (notification.repeatSettings ==
        NotificationRepeatSettings.everyWeek) {
      dateTimeComponents = DateTimeComponents.dayOfWeekAndTime;
    } else if (notification.repeatSettings ==
        NotificationRepeatSettings.everyYear) {
      dateTimeComponents = DateTimeComponents.dateAndTime;
    }

    cancelNotification(notification.id);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        notification.id,
        "Pejskaři",
        notification.title,
        tzDateTime,
        // tz.TZDateTime.from(DateTime.parse(notification.dateTime), tz.local),
        const NotificationDetails(
            android: AndroidNotificationDetails(channel_id, "nazev kanalu",
                channelDescription: 'Popis kanalu',
                priority: Priority.max,
                importance: Importance.max,
                enableVibration: true,
                fullScreenIntent: true,
                playSound: true,
                channelShowBadge: true),
            iOS: IOSNotificationDetails(
                presentAlert: true, presentBadge: true, presentSound: true)),
        payload: notification.title,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: dateTimeComponents);

    List<PendingNotificationRequest> allScheduledNotifications =
        await getAllScheduledNotifications();
  }

  bool isDateInFuture(DateTime dateTime) {
    tz.setLocalLocation(tz.getLocation("Europe/Prague"));
    var tzDateTime = tz.TZDateTime(tz.local, dateTime.year, dateTime.month,
        dateTime.day, dateTime.hour, dateTime.minute);

    if (tzDateTime.isBefore(clock.now())) {
      return false;
    }
    return true;
  }

  void cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  void cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<List<PendingNotificationRequest>>
      getAllScheduledNotifications() async {
    List<PendingNotificationRequest> pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotifications;
  }
}
