import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pejskari/data/VetVisit.dart';
import 'package:pejskari/pages/VetVisit/VetVisitEditPageArgs.dart';

/// Form for editing vet visit.
class VetVisitEditForm extends StatefulWidget {
  final VetVisitEditPageArgs vetVisitEditPageArgs;

  final Function(VetVisit vetVisit) onSubmit;

  const VetVisitEditForm(
      {Key? key, required this.vetVisitEditPageArgs, required this.onSubmit})
      : super(key: key);

  @override
  _VetVisitEditFormState createState() => _VetVisitEditFormState();
}

class _VetVisitEditFormState extends State<VetVisitEditForm> {
  final _formKey = GlobalKey<FormState>();
  final _dogProfileController = TextEditingController();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? pickedDate;
  int _selectedDogProfileId = 0;
  int _selectedVetId = 0;
  bool _documentsPanelExpanded = false;
  List<String> _documentPaths = [];

  @override
  void initState() {
    super.initState();
    DateTime date = DateTime.parse(
        widget.vetVisitEditPageArgs.vetVisitAndDogProfile?.vetVisit.date ??
            DateTime.now().toIso8601String());
    pickedDate = date;
    _dateController.text = DateFormat('dd.MM.yyyy').format(pickedDate!);
    _selectedVetId =
        widget.vetVisitEditPageArgs.vetVisitAndDogProfile?.vetVisit.vetId ??
            _getDefaultSelectedVetId();
    _notesController.text =
        widget.vetVisitEditPageArgs.vetVisitAndDogProfile?.vetVisit.notes ?? "";

    _selectedDogProfileId = widget.vetVisitEditPageArgs.vetVisitAndDogProfile
            ?.vetVisit.dogProfileId ??
        _getDefaultSelectedDogProfileId();
    _documentPaths = widget.vetVisitEditPageArgs.vetVisitAndDogProfile?.vetVisit
            .documentPaths ??
        [];
  }

  _getDefaultSelectedVetId() {
    if (widget.vetVisitEditPageArgs.vets.isNotEmpty) {
      return widget.vetVisitEditPageArgs.vets.first.id;
    }
    return 0;
  }

  _getDefaultSelectedDogProfileId() {
    if (widget.vetVisitEditPageArgs.dogProfiles.isNotEmpty) {
      return widget.vetVisitEditPageArgs.dogProfiles.first.id;
    }
    return 0;
  }

  @override
  void dispose() {
    _dogProfileController.dispose();
    _dateController.dispose();
    _notesController.dispose();
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
        _dateController.text = formattedDate;
      });
    }
  }

  _submitForm() {
    if (_formKey.currentState!.validate()) {
      final VetVisit vetVisit = VetVisit(
          widget.vetVisitEditPageArgs.vetVisitAndDogProfile?.vetVisit.id ?? 0,
          pickedDate!.toIso8601String(),
          _notesController.text,
          _selectedVetId,
          _selectedDogProfileId,
          _documentPaths);
      widget.onSubmit(vetVisit);
    }
  }

  _showSelectDocumentDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Vyberte odkud chcete nahrát dokument."),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: const Text("Soubory"),
                      onTap: () {
                        _pickDocuments(false);
                        Navigator.of(context).pop();
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(16.0)),
                    GestureDetector(
                      child: const Text("Fotoaparát"),
                      onTap: () {
                        _pickDocuments(true);
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ));
        });
  }

  _pickDocuments(bool fromCamera) async {
    //use file picker or image picker from camera
    if (fromCamera == true) {
      XFile? picture =
          await ImagePicker().pickImage(source: ImageSource.camera);
      var applicationDocumentsDirectory =
          await getApplicationDocumentsDirectory();

      if (picture != null) {
        File file = File(picture.path);
        final savedImage = await file
            .copy('${applicationDocumentsDirectory.path}/${picture.name}');
        setState(() {
          _documentPaths.add(savedImage.path);
        });

        return;
      }
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: [
          'png',
          'jpg',
          'pdf',
        ]);

    if (result != null) {
      var applicationDocumentsDirectory =
          await getApplicationDocumentsDirectory();

      for (int i = 0; i < result.files.length; i++) {
        File file = await File(result.files[i].path!).copy(
            '${applicationDocumentsDirectory.path}/${result.files[i].name}');
        setState(() {
          _documentPaths.add(file.path);
        });
      }
    }
  }

  _onDeleteButtonPressed(BuildContext context, int index) async {
    var result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Chcete opravdu soubor smazat?'),
        content: const Text("Soubor bude nevratně smazán."),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Ne'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ano'),
          ),
        ],
      ),
    );


    if (result == true) {
      File(_documentPaths.elementAt(index - 1))
          .delete()
          .then((value) => setState(() {
                _documentPaths.removeAt(index - 1);
              }));
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
            items: widget.vetVisitEditPageArgs.dogProfiles.map((e) {
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
              hintText: 'Zadejte datum návštěvy',
              labelText: 'Datum návštěvy',
            ),
            readOnly: true,
            onTap: () {
              _pickDate(context);
            },
          ),
          DropdownButtonFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.pets),
              hintText: 'Zvolte veterináře',
              labelText: 'Veterinář',
            ),
            hint: const Text('Zvolte veterináře'),
            items: widget.vetVisitEditPageArgs.vets.map((e) {
              return DropdownMenuItem(child: Text(e.name), value: e.id);
            }).toList(),
            value: _selectedVetId,
            onChanged: (value) {
              setState(() {
                _selectedVetId = int.parse(value.toString());
              });
            },
            isExpanded: true,
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
          const SizedBox(
            height: 8,
          ),
          ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _documentsPanelExpanded = !isExpanded;
                });
              },
              children: [
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return const ListTile(
                      title: Text("Dokumenty"),
                    );
                  },
                  body: GridView.builder(
                    physics: const ScrollPhysics(),
                    itemCount: _documentPaths.length + 1,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 20.0 / 20, crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Padding(
                            padding: const EdgeInsets.all(2),
                            child: Card(
                                semanticContainer: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  child: ListView(
                                    children: const <Widget>[
                                      FittedBox(
                                        child: Icon(Icons.add),
                                        fit: BoxFit.fill,
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    _showSelectDocumentDialog(context);
                                  },
                                )));
                      }

                      return Stack(children: [
                        Padding(
                            padding: const EdgeInsets.all(2),
                            child: GestureDetector(
                                child: Container(
                                  width: double.infinity,
                                  child: Card(
                                    semanticContainer: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Column(children: [
                                      Expanded(
                                          child: _documentPaths
                                                  .elementAt(index - 1)
                                                  .endsWith(".pdf")
                                              ? const FittedBox(
                                                  child: Icon(Icons
                                                      .picture_as_pdf_outlined),
                                                  fit: BoxFit.fill,
                                                )
                                              : Image.file(
                                                  File(_documentPaths
                                                      .elementAt(index - 1)),
                                                  fit: BoxFit.cover,
                                                )),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3),
                                          child: Text(
                                            basename(_documentPaths
                                                .elementAt(index - 1)),
                                            overflow: TextOverflow.ellipsis,
                                          ))
                                    ]),
                                  ),
                                ),
                                onTap: () {
                                  OpenFile.open(
                                      _documentPaths.elementAt(index - 1));
                                })),
                        Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              decoration: const ShapeDecoration(
                                color: Colors.blue,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.white,
                                onPressed: () =>
                                    _onDeleteButtonPressed(context, index),
                              ),
                            ))
                      ]);
                    },
                  ),
                  isExpanded: _documentsPanelExpanded,
                )
              ]),
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
