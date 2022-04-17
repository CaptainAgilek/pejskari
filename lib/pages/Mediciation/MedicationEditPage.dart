import 'package:flutter/material.dart';
import 'package:pejskari/data/Medication.dart';
import 'package:pejskari/forms/MedicationEditForm.dart';
import 'package:pejskari/pages/Mediciation/MedicationEditPageArgs.dart';
import 'package:pejskari/service/MedicationService.dart';

/// This class represents page for editing medication.
class MedicationEditPage extends StatefulWidget {
  static const String routeName = "/medications/edit";

  const MedicationEditPage({Key? key}) : super(key: key);

  @override
  _MedicationEditPageState createState() => _MedicationEditPageState();
}

class _MedicationEditPageState extends State<MedicationEditPage> {
  final MedicationService _medicationService = MedicationService();
  bool _isNewRecord = false;

  /// Saves medication to database.
  _onSave(Medication medication) {
    if (_isNewRecord) {
      var insert = _medicationService.create(medication);
      _isNewRecord = false;
    } else {
      _medicationService.update(medication);
    }
    Navigator.of(context).pop(true);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Uloženo")));
  }

  @override
  Widget build(BuildContext context) {
    var _receivedArgs =  ModalRoute.of(context)!.settings.arguments as MedicationEditPageArgs;
    _isNewRecord = (_receivedArgs.medication.id == 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Záznam medikace"),
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
                child: MedicationEditForm(medicationEditPageArgs: _receivedArgs,
                  onSubmit: _onSave,
                ))
          ],
        ),
      ),
    );
  }
}
