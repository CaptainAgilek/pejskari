import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pejskari/data/DogWeight.dart';
import 'package:pejskari/pages/DogWeight/DogWeightEditPageArgs.dart';

/// Form for editing dog weight.
class DogWeightEditForm extends StatefulWidget {
  final DogWeightEditPageArgs dogWeightEditPageArgs;

  final Function(DogWeight dogWeight) onSubmit;

  const DogWeightEditForm(
      {Key? key, required this.dogWeightEditPageArgs, required this.onSubmit})
      : super(key: key);

  @override
  _DogWeightEditFormState createState() => _DogWeightEditFormState();
}

class _DogWeightEditFormState extends State<DogWeightEditForm> {
  final _formKey = GlobalKey<FormState>();
  final _dogProfileController = TextEditingController();
  final _dateController = TextEditingController();
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? pickedDate;
  int _selectedDogProfileId = 0;

  @override
  void initState() {
    super.initState();
    DateTime date = DateTime.parse(
        widget.dogWeightEditPageArgs.dogWeightAndProfile?.dogWeight.date ??
            DateTime.now().toIso8601String());
    pickedDate = date;
    _dateController.text = DateFormat('dd.MM.yyyy').format(pickedDate!);
    _weightController.text = widget
            .dogWeightEditPageArgs.dogWeightAndProfile?.dogWeight.weight
            .toString() ??
        "";
    _notesController.text =
        widget.dogWeightEditPageArgs.dogWeightAndProfile?.dogWeight.notes ?? "";
    _selectedDogProfileId = _getDefaultSelectedDogProfileId(widget
        .dogWeightEditPageArgs.dogWeightAndProfile?.dogWeight.dogProfileId ?? _selectedDogProfileId);
  }

  @override
  void dispose() {
    _dogProfileController.dispose();
    _dateController.dispose();
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  _getDefaultSelectedDogProfileId(int dogProfileId) {
    if (widget.dogWeightEditPageArgs.dogProfiles
        .where((element) => element.id == dogProfileId)
        .isNotEmpty) {
      return dogProfileId;
    }
    return widget.dogWeightEditPageArgs.dogProfiles.first.id;
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
        _dateController.text = formattedDate;
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
      final DogWeight dogWeight = DogWeight(
          widget.dogWeightEditPageArgs.dogWeightAndProfile?.dogWeight.id ?? 0,
          double.tryParse(_weightController.text) ?? 0,
          pickedDate!.toIso8601String(),
          _notesController.text,
          _selectedDogProfileId);
      widget.onSubmit(dogWeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: <Widget>[
          DropdownButtonFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.pets),
              hintText: 'Zvolte psa',
              labelText: 'Pes',
            ),
            hint: const Text('Zvolte psa'),
            items: widget.dogWeightEditPageArgs.dogProfiles.map((e) {
              return DropdownMenuItem(child: Text(e.name), value: e.id);
            }).toList(),
            value: _selectedDogProfileId,
            onChanged: (value) {
              setState(() {
                _selectedDogProfileId = int.parse(value.toString());
              });
            },
            isExpanded: true,
          ),
          TextFormField(
              controller: _weightController,
              validator: _validateInput,
              decoration: const InputDecoration(
                icon: Icon(Icons.monitor_weight),
                hintText: 'Zadejte váhu v kg',
                labelText: 'Váha',
                suffixText: 'Kg',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
              ]),
          TextFormField(
            controller: _dateController,
            decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today),
              hintText: 'Zadejte datum vážení',
              labelText: 'Datum vážení',
            ),
            readOnly: true,
            onTap: () {
              _pickDate(context);
            },
          ),
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
