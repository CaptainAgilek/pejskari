import 'package:flutter/material.dart';
import 'package:pejskari/data/Walk.dart';
import 'package:pejskari/forms/WalkEditForm.dart';
import 'package:pejskari/pages/Walk/WalkEditPageArgs.dart';
import 'package:pejskari/service/WalkService.dart';

/// This class represents page for editing walk.
class WalkEditPage extends StatefulWidget {
  static const String routeName = "/walk/edit";
  const WalkEditPage({Key? key}) : super(key: key);

  @override
  _WalkEditPageState createState() => _WalkEditPageState();
}

class _WalkEditPageState extends State<WalkEditPage> {
  final WalkService _walkService = WalkService();
  WalkEditPageArgs? _walkEditPageArgs;
  bool isNewRecord = false;
  bool isSaved = false;

  /// Saves walk to database.
  _onSave(Walk walk) {
      if (isNewRecord) {
        var insert = _walkService.create(walk);
        isNewRecord = false;
      } else {
        _walkService.update(walk);
      }
      isSaved = true;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Uloženo")));
  }

  /// Dialog opens when user goes back from page.
  _onBackButton() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Opravdu chcete odejít?'),
        content: const Text("Pokud odejdete, ztratíte všechny údaje o procházce."),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Odejít'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Zrušit'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    _walkEditPageArgs ??= ModalRoute.of(context)!.settings.arguments as WalkEditPageArgs;
    isNewRecord = _walkEditPageArgs!.walk.id == 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Záznam procházky"),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (isSaved) {
            Navigator.pop(context, true);
            return true;
          } else {
            var result = await _onBackButton();
            if (result == true) {
              Navigator.pop(context, true);
              return true;
            } else {
              //do not pop
              return false;
            }
          }
        },
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Expanded(
                child: WalkEditForm(
              walkEditPageArgs: _walkEditPageArgs!,
              onSubmit: _onSave,
            ))
          ],
        ),
      ),
    );
  }
}
