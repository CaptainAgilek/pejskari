import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pejskari/data/Walk.dart';
import 'package:pejskari/pages/Walk/WalkEditPageArgs.dart';
import 'package:pejskari/util/TimeFormatUtil.dart';

/// Form for editing walk.
class WalkEditForm extends StatefulWidget {
  final WalkEditPageArgs walkEditPageArgs;

  final Function(Walk walk) onSubmit;

  const WalkEditForm(
      {Key? key, required this.walkEditPageArgs, required this.onSubmit})
      : super(key: key);

  @override
  _WalkEditFormState createState() => _WalkEditFormState();
}

class _WalkEditFormState extends State<WalkEditForm> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();
  final _distanceController = TextEditingController();
  final _hoursController = TextEditingController();
  final _minutesController = TextEditingController();

  DateTime? pickedDate;
  Map<String, bool> _dogsForWalk = {};

  @override
  void initState() {
    super.initState();
    DateTime date = DateTime.parse(widget.walkEditPageArgs.walk.date);
    pickedDate = date;
    _dateController.text = DateFormat('dd.MM.yyyy').format(pickedDate!);
    _notesController.text = widget.walkEditPageArgs.walk.notes;
    _distanceController.text =
        widget.walkEditPageArgs.walk.distance.toStringAsFixed(2);
    var time = Duration(milliseconds: widget.walkEditPageArgs.walk.time);
    _hoursController.text = TimeFormatUtil.printDurationHours(time);
    _minutesController.text = TimeFormatUtil.printDurationMinutes(time);

    for (var dogProfile in widget.walkEditPageArgs.dogProfiles) {
      _dogsForWalk.putIfAbsent(dogProfile.name, () => false);
      for (var dogId in widget.walkEditPageArgs.walk.dogProfilesIds) {
        if (dogId == dogProfile.id) {
          _dogsForWalk.update(dogProfile.name, (value) => true);
        }
      }
    }
  }


  @override
  void dispose() {
    _dateController.dispose();
    _notesController.dispose();
    _distanceController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  _pickDate(context) async {
    pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 24),
        lastDate: DateTime(2100));

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd.MM.yyyy').format(pickedDate!);
      setState(() {
        _dateController.text =
            formattedDate;
      });
    }
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return "Pole je povinné.";
    }
    return null;
  }

  _submitForm() {
    if (_formKey.currentState!.validate()) {
      var duration = Duration(
          hours: int.parse(_hoursController.text),
          minutes: int.parse(_minutesController.text));

      List<int> dogIdsForWalk = [];

      for (var dogProfile in widget.walkEditPageArgs.dogProfiles) {
        for (var entry in _dogsForWalk.entries) {
          if (entry.key == dogProfile.name && entry.value == true) {
            dogIdsForWalk.add(dogProfile.id);
          }
        }
      }

      final Walk walk = Walk(
          widget.walkEditPageArgs.walk.id,
          pickedDate!.toIso8601String(),
          _notesController.text,
          double.parse(_distanceController.text),
          duration.inMilliseconds,
          dogIdsForWalk);
      widget.onSubmit(walk);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: <Widget>[
          Column(
              children: widget.walkEditPageArgs.dogProfiles
                  .map((e) => CheckboxListTile(
                        title: Text(e.name),
                        value: _dogsForWalk[e.name],
                        activeColor: Colors.pink,
                        checkColor: Colors.white,
                        tristate: false,
                        onChanged: (value) {
                          setState(() {
                            if (_dogsForWalk.isNotEmpty) {
                              _dogsForWalk[e.name] = value!;
                            }
                          });
                        },
                      ))
                  .toList()),
          TextFormField(
            controller: _dateController,
            decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today),
              hintText: 'Zadejte datum procházky',
              labelText: 'Datum procházky',
            ),
            readOnly: true,
            onTap: () {
              _pickDate(context);
            },
          ),
          TextFormField(
            validator: _validateInput,
            controller: _distanceController,
            decoration: const InputDecoration(
                icon: Icon(Icons.directions_walk_sharp),
                hintText: 'Zadejte vzdálenost',
                labelText: 'Vzdálenost',
                suffixText: "km"),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
            ],
          ),
          Row(children: [
            Expanded(
                child: TextFormField(
              validator: _validateInput,
              controller: _hoursController,
              decoration: const InputDecoration(
                  icon: Icon(Icons.timer),
                  // hintText: 'Zadejte trvání procházky',
                  labelText: 'Čas procházky',
                  suffixText: "hodin"),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'(^[0-9]{1,2})'))
              ],
            )),
            Expanded(
                child: TextFormField(
              validator: _validateInput,
              controller: _minutesController,
              decoration: const InputDecoration(
                  icon: Icon(Icons.timer),
                  //  hintText: 'Zadejte trvání procházky',
                  labelText: 'Čas procházky',
                  suffixText: "minut"),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'(^[0-5]?[0-9])'))
              ],
            ))
          ]),
          TextFormField(
            controller: _notesController,
            minLines: 1,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              icon: Icon(Icons.note),
              hintText: 'Zadejte poznámky',
              labelText: 'Poznámky',
            ),
          ),
          Container(
              padding: const EdgeInsets.only(left: 150.0, top: 40.0),
              child: ElevatedButton(
                child: const Text("Uložit"),
                onPressed: _submitForm,
              )),
        ],
      ),
    );
  }
}
