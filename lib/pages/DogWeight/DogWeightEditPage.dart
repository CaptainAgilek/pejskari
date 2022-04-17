import 'package:flutter/material.dart';
import 'package:pejskari/data/DogWeight.dart';
import 'package:pejskari/forms/DogWeightEditForm.dart';
import 'package:pejskari/pages/DogWeight/DogWeightEditPageArgs.dart';
import 'package:pejskari/service/DogWeightService.dart';

/// This class represents page for editing dog weight.
class DogWeightEditPage extends StatefulWidget {
  static const String routeName = "/dog-weight/edit";

  const DogWeightEditPage({Key? key}) : super(key: key);

  @override
  _DogWeightEditPageState createState() => _DogWeightEditPageState();
}

class _DogWeightEditPageState extends State<DogWeightEditPage> {
  final DogWeightService dogWeightService = DogWeightService();
  bool isNewRecord = false;

  /// This method saves dog weight to database.
  _onSave(DogWeight dogWeight) {
    if (isNewRecord) {
      var insert = dogWeightService.create(dogWeight);
      isNewRecord = false;
    } else {
      dogWeightService.update(dogWeight);
    }
    Navigator.of(context).pop(true);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Uloženo")));
  }

  @override
  Widget build(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments;
    var _receivedArgs = _args as DogWeightEditPageArgs;
    isNewRecord = (_receivedArgs.dogWeightAndProfile == null);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Záznam váhy"),
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
                child: DogWeightEditForm(
              dogWeightEditPageArgs: _receivedArgs,
              onSubmit: _onSave,
            ))
          ],
        ),
      ),
    );
  }
}
