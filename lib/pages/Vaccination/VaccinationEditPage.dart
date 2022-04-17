import 'package:flutter/material.dart';
import 'package:pejskari/data/Vaccination.dart';
import 'package:pejskari/forms/VaccinationEditForm.dart';
import 'package:pejskari/pages/Vaccination/VaccinationEditPageArgs.dart';
import 'package:pejskari/service/VaccinationService.dart';

/// This class represents page for editing vaccination.
class VaccinationEditPage extends StatefulWidget {
  static const String routeName = "/vaccinations/edit";

  const VaccinationEditPage({Key? key}) : super(key: key);

  @override
  _VaccinationEditPageState createState() => _VaccinationEditPageState();
}

class _VaccinationEditPageState extends State<VaccinationEditPage> {
  final VaccinationService _vaccinationService = VaccinationService();
  bool isNewRecord = false;

  _onSave(Vaccination vaccination) {
    if (isNewRecord) {
      var insert = _vaccinationService.create(vaccination);
      isNewRecord = false;
    } else {
      _vaccinationService.update(vaccination);
    }
    Navigator.of(context).pop(true);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Uloženo")));
  }

  @override
  Widget build(BuildContext context) {
    var _receivedArgs =
        ModalRoute.of(context)!.settings.arguments as VaccinationEditPageArgs;
    isNewRecord = (_receivedArgs.vaccination.id == 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Záznam vakcinace"),
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
                child: VaccinationEditForm(
              vaccinationEditPageArgs: _receivedArgs,
              onSubmit: _onSave,
            ))
          ],
        ),
      ),
    );
  }
}
