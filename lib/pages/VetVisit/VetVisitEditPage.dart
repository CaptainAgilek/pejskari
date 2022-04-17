import 'package:flutter/material.dart';
import 'package:pejskari/data/VetVisit.dart';
import 'package:pejskari/forms/VetVisitEditForm.dart';
import 'package:pejskari/pages/VetVisit/VetVisitEditPageArgs.dart';
import 'package:pejskari/service/VetVisitService.dart';

/// This class represents page for editing vet visit.
class VetVisitEditPage extends StatefulWidget {
  static const String routeName = "/vet-visit/edit";

  const VetVisitEditPage({Key? key}) : super(key: key);

  @override
  _VetVisitEditPageState createState() => _VetVisitEditPageState();
}

class _VetVisitEditPageState extends State<VetVisitEditPage> {
  final VetVisitService _vetVisitService = VetVisitService();
  bool isNewRecord = false;

  /// Saves vet visit to database.
  _onSave(VetVisit vetVisit) {
    if (isNewRecord) {
      var insert = _vetVisitService.create(vetVisit);
      isNewRecord = false;
    } else {
      _vetVisitService.update(vetVisit);
    }
    Navigator.of(context).pop(true);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Uloženo")));
  }

  @override
  Widget build(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments;
    var _receivedArgs = _args as VetVisitEditPageArgs;
    isNewRecord = (_receivedArgs.vetVisitAndDogProfile == null);

    return Scaffold(
      appBar: AppBar(
        title: Text("Záznam návštěvy veterináře"),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, true);
          return true;
        },
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Expanded(
                child: VetVisitEditForm(
              vetVisitEditPageArgs: _receivedArgs,
              onSubmit: _onSave,
            )),
          ],
        ),
      ),
    );
  }
}
