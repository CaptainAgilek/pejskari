import 'package:flutter/material.dart';
import 'package:pejskari/data/Vet.dart';

/// Form for editing vet.
class VetEditForm extends StatefulWidget {
  final Vet vet;
  final Function(Vet vet) onSubmit;

  const VetEditForm({Key? key, required this.vet, required this.onSubmit})
      : super(key: key);

  @override
  _VetEditFormState createState() => _VetEditFormState();
}

class _VetEditFormState extends State<VetEditForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.vet.name;
    _phoneController.text = widget.vet.phone;
    _notesController.text = widget.vet.notes;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  _submitForm() {
    if (_formKey.currentState!.validate()) {
      final Vet vet = Vet(widget.vet.id, _nameController.text,
          _phoneController.text, _notesController.text);
      widget.onSubmit(vet);
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
          TextFormField(
            validator: _validateInput,
            controller: _nameController,
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'Zadejte jméno veterináře',
              labelText: 'Jméno veterináře',
            ),
          ),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              icon: Icon(Icons.phone),
              hintText: 'Zadejte telefon veterináře',
              labelText: 'Telefon veterináře',
            ),
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
