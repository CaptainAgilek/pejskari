import 'package:flutter/material.dart' hide Notification;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pejskari/NavigationDrawer.dart';
import 'package:pejskari/data/Notification.dart';
import 'package:pejskari/data/NotificationRepeatSettings.dart';
import 'package:pejskari/routes/Routes.dart';
import 'package:pejskari/service/NotificationService.dart';
import 'package:pejskari/util/TimeFormatUtil.dart';

/// This class represents page with notifications.
class NotificationsPage extends StatefulWidget {
  static const String routeName = "/notifications";

  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationService _notificationService = NotificationService();
  bool notificationShown = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  /// Opens page for adding new notification.
  _onAddButtonPressed(BuildContext context) async {
    final result = await Navigator.of(context).pushNamed(
        Routes.notificationsEditPage,
        arguments: Notification(
            0,
            "",
            DateTime.now().add(const Duration(minutes: 5)).toIso8601String(),
            NotificationRepeatSettings.none));

    if (result == true) {
      setState(() {});
    }
  }

  /// Opens page for editing notification.
  _onEditButtonPressed(BuildContext context, Notification notification) async {
    final result = await Navigator.of(context).pushNamed(
        Routes.notificationsEditPage,
        arguments: Notification(notification.id, notification.title,
            notification.dateTime, notification.repeatSettings));
    if (result == true) {
      setState(() {});
    }
  }

  /// Deletes notification from database.
  _onDeleteButtonPressed(
      BuildContext context, Notification notification) async {
    var result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Chcete opravdu smazat upozornění?'),
        content: const Text("Upozornění bude nevratně smazáno."),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Ne'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ano'),
          ),
        ],
      ),
    );

    if (result == true) {
      _notificationService.cancelNotification(notification.id);
      await _notificationService.delete(notification.id);
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Smazáno")));
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Upozornění"),
        ),
        drawer: const NavigationDrawer(),
        body: FutureBuilder(
            future: _notificationService.getAll(),
            builder: (context, AsyncSnapshot<List<Notification>> snapshot) {
              if (snapshot.hasError) {
                return Wrap(children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  )
                ]);
              }
              if (snapshot.hasData) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.notifications),
                      title: Text(snapshot.data![index].title),
                      subtitle: Text(
                        DateFormat(
                                    TimeFormatUtil.getDateFormatBasedOnRepeat(
                                        snapshot.data![index].repeatSettings),
                                    "cs")
                                .format(DateTime.parse(
                                    snapshot.data![index].dateTime)) +
                            "\n" +
                            snapshot.data![index].repeatSettings.czName,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _onDeleteButtonPressed(
                                    context, snapshot.data![index]);
                              }),
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _onEditButtonPressed(
                                    context, snapshot.data![index]);
                              }),
                        ],
                      ),
                      onTap: () {},
                    );
                  },
                  separatorBuilder: (buildContext, index) {
                    return const Divider(height: 1);
                  },
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(5),
                  scrollDirection: Axis.vertical,
                );
              }
              return const Center(child: CircularProgressIndicator());
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              _onAddButtonPressed(context);
            },
            tooltip: 'Přidat nové upozornění',
            child: const Icon(Icons.add)));
  }
}
