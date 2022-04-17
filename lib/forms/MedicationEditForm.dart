import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pejskari/data/Medication.dart';
import 'package:pejskari/pages/Mediciation/MedicationEditPageArgs.dart';

/// Form for editing medication.
class MedicationEditForm extends StatefulWidget {
  final MedicationEditPageArgs medicationEditPageArgs;
  final Function(Medication medication) onSubmit;

  const MedicationEditForm(
      {Key? key, required this.medicationEditPageArgs, required this.onSubmit})
      : super(key: key);

  @override
  _MedicationEditFormState createState() => _MedicationEditFormState();
}

class _MedicationEditFormState extends State<MedicationEditForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? pickedDate;
  int _selectedDogProfileId = 0;

  @override
  void initState() {
    super.initState();
    DateTime date =
        DateTime.parse(widget.medicationEditPageArgs.medication.dateTime);
    pickedDate = date;
    _dateController.text = DateFormat('dd.MM.yyyy').format(pickedDate!);

    _nameController.text = widget.medicationEditPageArgs.medication.name;

    _timeController.text = DateFormat('HH:mm').format(date);
    _notesController.text = widget.medicationEditPageArgs.medication.notes;
    _selectedDogProfileId = _getDefaultSelectedDogProfileId(
        widget.medicationEditPageArgs.medication.dogProfileId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  _getDefaultSelectedDogProfileId(int dogProfileId) {
    if (widget.medicationEditPageArgs.dogProfiles
        .where((element) => element.id == dogProfileId)
        .isNotEmpty) {
      return dogProfileId;
    }
    return widget.medicationEditPageArgs.dogProfiles.first.id;
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

  _pickTime(context) async {
    TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
            pickedDate == null ? DateTime.now() : pickedDate!));

    if (time != null) {
      setState(() {
        _timeController.text = time.format(context);
        pickedDate = DateTime(pickedDate!.year, pickedDate!.month,
            pickedDate!.day, time.hour, time.minute);
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
      final Medication medication = Medication(
          widget.medicationEditPageArgs.medication.id,
          _nameController.text,
          pickedDate!.toIso8601String(),
          _notesController.text,
          _selectedDogProfileId);
      widget.onSubmit(medication);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: <Widget>[
          TextFormField(
            validator: _validateInput,
            controller: _nameController,
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'Zadejte název medikace',
              labelText: 'Název medikace',
            ),
          ),
          DropdownButtonFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.pets),
              hintText: 'Zvolte psa',
              labelText: 'Pes',
            ),
            hint: Text('Zvolte psa'),
            items: widget.medicationEditPageArgs.dogProfiles.map((e) {
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
            controller: _dateController,
            decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today),
              hintText: 'Zadejte datum',
              labelText: 'Datum',
            ),
            readOnly: true,
            onTap: () {
              _pickDate(context);
            },
          ),
          TextFormField(
            controller: _timeController,
            decoration: const InputDecoration(
              icon: Icon(Icons.timer),
              hintText: 'Zadejte čas',
              labelText: 'Čas',
            ),
            readOnly: true,
            onTap: () {
              _pickTime(context);
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
