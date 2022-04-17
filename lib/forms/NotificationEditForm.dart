import 'package:flutter/material.dart' hide Notification;
import 'package:intl/intl.dart';
import 'package:pejskari/data/Notification.dart';
import 'package:pejskari/data/NotificationRepeatSettings.dart';

/// Form for editing notification.
class NotificationEditForm extends StatefulWidget {
  final Notification notification;
  final Function(Notification notification) onSubmit;

  const NotificationEditForm(
      {Key? key, required this.notification, required this.onSubmit})
      : super(key: key);

  @override
  _NotificationEditFormState createState() => _NotificationEditFormState();
}

class _NotificationEditFormState extends State<NotificationEditForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  DateTime? pickedDate;
  NotificationRepeatSettings _selectedRepeatSettings =
      NotificationRepeatSettings.none;

  @override
  void initState() {
    super.initState();
    DateTime date = DateTime.parse(widget.notification.dateTime);
    pickedDate = date;
    _dateController.text = DateFormat('dd.MM.yyyy').format(pickedDate!);

    _titleController.text = widget.notification.title;

    _selectedRepeatSettings = widget.notification.repeatSettings;

    _timeController.text = DateFormat('HH:mm').format(date);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
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

  _pickTime(context) async {
    TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay.fromDateTime(pickedDate == null ? DateTime.now().add(const Duration(minutes: 5)) : pickedDate!));

    if (time != null) {
      setState(() {
        _timeController.text =
            time.format(context);
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
      final Notification notification = Notification(
          widget.notification.id,
          _titleController.text,
          pickedDate!.toIso8601String(),
          _selectedRepeatSettings);
      widget.onSubmit(notification);
      setState(() {

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
            validator: _validateInput,
            controller: _titleController,
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'Zadejte název upozornění',
              labelText: 'Název upozornění',
            ),
          ),
          TextFormField(
            controller: _dateController,
            decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today),
              hintText: 'Zadejte datum upozornění',
              labelText: 'Datum upozornění',
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
              hintText: 'Zadejte čas upozornění',
              labelText: 'Čas upozornění',
            ),
            readOnly: true,
            onTap: () {
              _pickTime(context);
            },
          ),
          DropdownButtonFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.pets),
              hintText: 'Zvolte opakování',
              labelText: 'Opakování',
            ),
            hint: const Text('Zvolte opakování'),
            items: const [
              DropdownMenuItem(
                  child: Text("Žádné opakování"),
                  value: NotificationRepeatSettings.none),
              DropdownMenuItem(
                  child: Text("Každý den"),
                  value: NotificationRepeatSettings.everyDay),
              DropdownMenuItem(
                  child: Text("Každý týden"),
                  value: NotificationRepeatSettings.everyWeek),
              DropdownMenuItem(
                  child: Text("Každý rok"),
                  value: NotificationRepeatSettings.everyYear)
            ],
            value: _selectedRepeatSettings,
            onChanged: (value) {
              setState(() {
                _selectedRepeatSettings = value as NotificationRepeatSettings;
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
