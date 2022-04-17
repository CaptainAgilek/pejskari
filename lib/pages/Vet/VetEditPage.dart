import 'package:flutter/material.dart';
import 'package:pejskari/data/Vet.dart';
import 'package:pejskari/forms/VetEditForm.dart';
import 'package:pejskari/service/VetService.dart';

/// This class represents page for editing vet.
class VetEditPage extends StatefulWidget {
  static const String routeName = "/vets/edit";

  const VetEditPage({Key? key}) : super(key: key);

  @override
  _VetEditPageState createState() => _VetEditPageState();
}

class _VetEditPageState extends State<VetEditPage> {
  final VetService _vetService = VetService();
  bool _isNewRecord = false;

  /// Saved vet record to database.
  _onSave(Vet vet) {
    if (_isNewRecord) {
      var insert = _vetService.create(vet);
      _isNewRecord = false;
    } else {
      _vetService.update(vet);
    }
    Navigator.of(context).pop(true);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Uloženo")));
  }

  @override
  Widget build(BuildContext context) {
    var _receivedArgs = ModalRoute.of(context)!.settings.arguments as Vet;
    _isNewRecord = (_receivedArgs.id == 0);

    return Scaffold(
      appBar: AppBar(
        title: Text("Záznam veterináře"),
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
                child: VetEditForm(vet: _receivedArgs,
                  onSubmit: _onSave,
                ))
          ],
        ),
      ),
    );
  }
}
