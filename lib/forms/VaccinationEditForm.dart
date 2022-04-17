import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pejskari/data/Vaccination.dart';
import 'package:pejskari/pages/Vaccination/VaccinationEditPageArgs.dart';

/// Form for editing vaccination.
class VaccinationEditForm extends StatefulWidget {
  final VaccinationEditPageArgs vaccinationEditPageArgs;
  final Function(Vaccination vaccination) onSubmit;

  const VaccinationEditForm(
      {Key? key, required this.vaccinationEditPageArgs, required this.onSubmit})
      : super(key: key);

  @override
  _VaccinationEditFormState createState() => _VaccinationEditFormState();
}

class _VaccinationEditFormState extends State<VaccinationEditForm> {
  final _formKey = GlobalKey<FormState>();
  final _dogProfileController = TextEditingController();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? pickedDate;
  int _selectedDogProfileId = 1;

  @override
  void initState() {
    super.initState();
    DateTime date =
        DateTime.parse(widget.vaccinationEditPageArgs.vaccination.date);
    pickedDate = date;
    _dateController.text = DateFormat('dd.MM.yyyy').format(pickedDate!);
    _notesController.text = widget.vaccinationEditPageArgs.vaccination.notes;
    _nameController.text = widget.vaccinationEditPageArgs.vaccination.name;
    _selectedDogProfileId = _getDefaultSelectedDogProfileId(
        widget.vaccinationEditPageArgs.vaccination.dogProfileId);
  }

  @override
  void dispose() {
    _dogProfileController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  _getDefaultSelectedDogProfileId(int dogProfileId) {
    if (widget.vaccinationEditPageArgs.dogProfiles
        .where((element) => element.id == dogProfileId)
        .isNotEmpty) {
      return dogProfileId;
    }
    return widget.vaccinationEditPageArgs.dogProfiles.first.id;
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

  _submitForm() {
    if (_formKey.currentState!.validate()) {
      final Vaccination vaccination = Vaccination(
          widget.vaccinationEditPageArgs.vaccination.id,
          _nameController.text,
          pickedDate!.toIso8601String(),
          _notesController.text,
          _selectedDogProfileId);
      widget.onSubmit(vaccination);
    }
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return "Pole je povinné.";
    }
    return null;
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
            items: widget.vaccinationEditPageArgs.dogProfiles.map((e) {
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
            controller: _nameController,
            validator: _validateInput,
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'Zadejte název vakcíny',
              labelText: 'Název vakcíny',
            ),
          ),
          TextFormField(
            controller: _dateController,
            decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today),
              hintText: 'Zadejte datum vakcinace',
              labelText: 'Datum vakcinace',
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
