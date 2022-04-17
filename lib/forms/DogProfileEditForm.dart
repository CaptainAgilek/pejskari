import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pejskari/data/DogProfile.dart';
import 'package:pejskari/service/DogProfileService.dart';

/// Form for editing dog profile.
class DogProfileEditForm extends StatefulWidget {
  final DogProfile? dogProfile;
  final Function(DogProfile dogProfile) onSubmit;

  const DogProfileEditForm({Key? key, this.dogProfile, required this.onSubmit})
      : super(key: key);

  @override
  _DogProfileEditFormState createState() => _DogProfileEditFormState();
}

class _DogProfileEditFormState extends State<DogProfileEditForm> {
  final DogProfileService _dogProfileService = DogProfileService();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _chipIdController = TextEditingController();
  final _heightController = TextEditingController();
  final _dobController = TextEditingController();

  DateTime? pickedDate;
  int _selectedGender = 0;
  int _selectedCastration = 0;
  List<DogProfile> _allDogProfiles = [];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.dogProfile?.name ?? "";
    _breedController.text = widget.dogProfile?.breed ?? "";
    _chipIdController.text = widget.dogProfile?.chipId ?? "";
    _heightController.text = widget.dogProfile?.height?.toString() ?? "";
    DateTime dob = DateTime.parse(
        widget.dogProfile?.dateOfBirth ?? DateTime.now().toIso8601String());
    pickedDate = dob;
    _dobController.text = DateFormat('dd.MM.yyyy').format(pickedDate!);
    _selectedGender = widget.dogProfile?.gender ?? 0;
    _selectedCastration = widget.dogProfile?.castrated ?? 0;
    _fetchDogProfiles();
  }

  _fetchDogProfiles() async {
    _allDogProfiles = await _dogProfileService.getAll();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _chipIdController.dispose();
    _heightController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  String? _validateNameInput(String? value) {
    String? result = _validateMandatoryInput(value);
    if (result != null) {
      return result;
    }

    return _validateDupplicateNameInput(value);
  }

  String? _validateMandatoryInput(String? value) {
    if (value == null || value.isEmpty) {
      return "Pole je povinné.";
    }
    return null;
  }

  String? _validateDupplicateNameInput(String? value) {
    if (_allDogProfiles.map((e) => e.name).toList().contains(value) &&
        widget.dogProfile?.id == 0) {
      return "Profil s tímto jménem již existuje.";
    }
    return null;
  }

  _submitForm() {
    if (_formKey.currentState!.validate()) {
      final dogProfile = DogProfile(
          widget.dogProfile?.id ?? 0,
          _nameController.text,
          _breedController.text,
          _chipIdController.text,
          pickedDate!.toIso8601String(),
          int.tryParse(_heightController.text) ?? 0,
          widget.dogProfile?.profileImagePath ?? "",
          _selectedGender,
          _selectedCastration);

      widget.onSubmit(dogProfile);
    }
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
        _dobController.text = formattedDate;
      });
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
            controller: _nameController,
            validator: _validateNameInput,
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'Zadejte jméno psa',
              labelText: 'Jméno',
            ),
          ),
          TextFormField(
            controller: _breedController,
            decoration: const InputDecoration(
              icon: Icon(Icons.pets),
              hintText: 'Zadejte plemeno',
              labelText: 'Plemeno',
            ),
          ),
          DropdownButtonFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.pets),
              hintText: 'Zvolte pohlaví',
              labelText: 'Pohlaví',
            ),
            hint: const Text('Zvolte pohlaví'),
            items: const [
              DropdownMenuItem(
                child: Text('Pes'),
                value: 0,
              ),
              DropdownMenuItem(
                child: Text('Fena'),
                value: 1,
              )
            ],
            value: _selectedGender,
            onChanged: (value) {
              setState(() {
                _selectedGender = int.parse(value.toString());
              });
            },
            isExpanded: true,
          ),
          TextFormField(
              controller: _heightController,
              decoration: const InputDecoration(
                icon: Icon(Icons.height),
                hintText: 'Zadejte výšku v kohoutku',
                labelText: 'Výška',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
          TextFormField(
            controller: _dobController,
            decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today),
              hintText: 'Zadejte datum narození',
              labelText: 'Datum narození',
            ),
            readOnly: true,
            onTap: () {
              _pickDate(context);
            },
          ),
          TextFormField(
            controller: _chipIdController,
            decoration: const InputDecoration(
              icon: Icon(Icons.sd_card),
              hintText: 'Zadejte kód čipu',
              labelText: 'Kód čipu',
            ),
          ),
          DropdownButtonFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.close),
              hintText: 'Vyberta zda byl pes kastrovaný',
              labelText: 'Kastrace',
            ),
            hint: const Text('Vyberta zda byl pes kastrovaný'),
            items: const [
              DropdownMenuItem(
                child: Text('Ne'),
                value: 0,
              ),
              DropdownMenuItem(
                child: Text('Ano'),
                value: 1,
              )
            ],
            value: _selectedCastration,
            onChanged: (value) {
              setState(() {
                _selectedCastration = int.parse(value.toString());
              });
            },
            isExpanded: true,
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
