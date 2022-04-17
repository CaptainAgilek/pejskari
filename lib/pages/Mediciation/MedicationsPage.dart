import 'package:flutter/material.dart';
import 'package:pejskari/NavigationDrawer.dart';
import 'package:pejskari/data/DogProfile.dart';
import 'package:pejskari/data/Medication.dart';
import 'package:pejskari/pages/Mediciation/MedicationEditPageArgs.dart';
import 'package:pejskari/pages/Mediciation/MedicationEnhancedData.dart';
import 'package:pejskari/routes/Routes.dart';
import 'package:pejskari/service/DogProfileService.dart';
import 'package:pejskari/service/MedicationService.dart';

/// This class represents page with medication records.
class MedicationsPage extends StatefulWidget {
  static const String routeName = "/medications";

  const MedicationsPage({Key? key}) : super(key: key);

  @override
  _MedicationsPageState createState() => _MedicationsPageState();
}

class _MedicationsPageState extends State<MedicationsPage> {
  final MedicationService _medicationService = MedicationService();
  final DogProfileService _dogProfileService = DogProfileService();

  List<DogProfile> _dogProfiles = [];

  @override
  initState() {
    super.initState();
    _fetchDogProfiles();
  }

  /// Fetches dog profiles from database.
  _fetchDogProfiles() async {
    _dogProfiles = await _dogProfileService.getAll();
  }

  /// Pairs medications with dog profiles.
  Future<List<MedicationEnhancedData>> _pairMedicationsAndDogProfiles() async {
    var medications = await _medicationService.getAll();

    var list = medications
        .map((e) => MedicationEnhancedData(
        e,
        _dogProfiles.singleWhere(
                (element) => (e.dogProfileId == element.id),
            orElse: () => DogProfile(0, "", "", "", "", 0, "", 0, 0)),))
        .toList();

    return list;
  }

  /// Opens page for adding new medication. If no dog profile exists, then shows alert.
  _onAddButtonPressed(BuildContext context) async {
    if (_dogProfiles.isEmpty) {
      var result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Nemáte vytvořený žádný profil psa'),
          content:
          const Text("Nemůžete vytvářet záznamy bez vytvořeného profilu psa."),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Rozumím'),
            ),
          ],
        ),
      );
    } else {
      final result = await Navigator.of(context).pushNamed(
          Routes.medicationEditPage,
          arguments: MedicationEditPageArgs(
              Medication(0, "", DateTime.now().toIso8601String(), "", 0),
              _dogProfiles));
      if (result == true) {
        setState(() {});
      }
    }
  }

  /// Opens page for editing dof profile.
  _onEditButtonPressed(BuildContext context, snapshot, index) async {
    final result = await Navigator.of(context).pushNamed(
        Routes.medicationEditPage,
        arguments:
        MedicationEditPageArgs(snapshot.data![index].medication, _dogProfiles));

    if (result == true) {
      setState(() {});
    }
  }

  /// Deletes dog profile.
  _onDeleteButtonPressed(BuildContext context, Medication medication) async {
    var result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Chcete opravdu smazat záznam o medikaci?'),
        content: const Text("Záznam bude nevratně smazán."),
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
      await _medicationService.delete(medication.id);
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: const Text("Smazáno")));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Medikace"),
        ),
        drawer: const NavigationDrawer(),
        body: FutureBuilder(
            future: _pairMedicationsAndDogProfiles(),
            builder: (context, AsyncSnapshot<List<MedicationEnhancedData>> snapshot) {
              if (snapshot.hasError) {
                return Wrap(children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  )
                ]);
              }
              if (snapshot.hasData) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.medication_liquid),
                      title: Text(snapshot.data![index].medication.name),
                      subtitle: Text(
                            snapshot.data![index].dogProfile.name,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _onDeleteButtonPressed(
                                    context, snapshot.data![index].medication);
                              }),
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _onEditButtonPressed(
                                    context, snapshot, index);
                              }),
                        ],
                      ),
                      onTap: () {
                            Navigator.of(context).pushNamed(Routes.medicationDetailPage,
                                 arguments: MedicationEnhancedData(snapshot.data![index].medication, snapshot.data![index].dogProfile));
                      },
                    );
                  },
                  separatorBuilder: (buildContext, index) {
                    return const Divider(height: 1);
                  },
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(5),
                  scrollDirection: Axis.vertical,
                );
              }
              return const Center(child: CircularProgressIndicator());
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              _onAddButtonPressed(context);
            },
            tooltip: 'Přidat nové upozornění',
            child: const Icon(Icons.add)));
  }
}
