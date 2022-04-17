import 'package:flutter/material.dart' hide Notification;
import 'package:pejskari/data/Notification.dart';
import 'package:pejskari/forms/NotificationEditForm.dart';
import 'package:pejskari/service/NotificationService.dart';

/// This class represents page for editing notification.
class NotificationEditPage extends StatefulWidget {
  static const String routeName = "/notifications/edit";

  const NotificationEditPage({Key? key}) : super(key: key);

  @override
  _NotificationEditPageState createState() => _NotificationEditPageState();
}

class _NotificationEditPageState extends State<NotificationEditPage> {
  final NotificationService _notificationService = NotificationService();
  bool _isNewNotification = false;

  /// Saves notification to database.
  _onSave(Notification notification) async {
    if (!_notificationService
        .isDateInFuture(DateTime.parse(notification.dateTime))) {
      var result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Datum a čas nemůže být v minulosti.'),
          content: const Text("Nastavte prosím datum a čas v budoucnosti."),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Rozumím'),
            ),
          ],
        ),
      );
      return;
    }

    if (_isNewNotification) {
      var insert = await _notificationService.create(notification);
      _notificationService.scheduleNotification(insert);
      _isNewNotification = false;
    } else {
      await _notificationService.update(notification);
      _notificationService.scheduleNotification(notification);
    }
    Navigator.of(context).pop(true);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Uloženo")));
  }

  @override
  Widget build(BuildContext context) {
    var _receivedArgs =
        ModalRoute.of(context)!.settings.arguments as Notification;
    _isNewNotification = (_receivedArgs.id == 0);

    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, true);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Upozornění"),
          ),
          body: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              Expanded(
                  child: NotificationEditForm(
                notification: _receivedArgs,
                onSubmit: _onSave,
              ))
            ],
          ),
        ));
  }
}
