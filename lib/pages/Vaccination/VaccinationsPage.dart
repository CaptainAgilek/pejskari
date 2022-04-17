import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pejskari/NavigationDrawer.dart';
import 'package:pejskari/data/DogProfile.dart';
import 'package:pejskari/data/Vaccination.dart';
import 'package:pejskari/pages/Vaccination/VaccinationAndDogProfile.dart';
import 'package:pejskari/pages/Vaccination/VaccinationEditPageArgs.dart';
import 'package:pejskari/routes/Routes.dart';
import 'package:pejskari/service/DogProfileService.dart';
import 'package:pejskari/service/VaccinationService.dart';

/// This class represents page with vaccinations.
class VaccinationsPage extends StatefulWidget {
  static const String routeName = "/vaccinations";

  const VaccinationsPage({Key? key}) : super(key: key);

  @override
  _VaccinationsPageState createState() => _VaccinationsPageState();
}

class _VaccinationsPageState extends State<VaccinationsPage> {
  final VaccinationService _vaccinationService = VaccinationService();
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

  /// Opens page for adding new vaccination. If there exists no dog profile, then shows alert.
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
          Routes.vaccinationEditPage,
          arguments: VaccinationEditPageArgs(
              Vaccination(0, "", DateTime.now().toIso8601String(), "", 0),
              _dogProfiles));
      if (result == true) {
        setState(() {});
      }
    }
  }

  /// Opens page for editing vaccination.
  _onEditButtonPressed(BuildContext context, snapshot, index) async {
    final result = await Navigator.of(context).pushNamed(
        Routes.vaccinationEditPage,
        arguments:
            VaccinationEditPageArgs(snapshot.data![index], _dogProfiles));
    if (result == true) {
      setState(() {});
    }
  }

  /// Deletes vaccination.
  _onDeleteButtonPressed(BuildContext context, Vaccination vaccination) async {
    var result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Chcete opravdu smazat záznam o vakcinaci?'),
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
      await _vaccinationService.delete(vaccination.id);
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: const Text("Smazáno")));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Vakcinace"),
        ),
        drawer: const NavigationDrawer(),
        body: FutureBuilder(
            future: _vaccinationService.getAll(),
            builder: (context, AsyncSnapshot<List<Vaccination>> snapshot) {
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
                      leading: const Icon(Icons.medication),
                      title: Text(snapshot.data![index].name),
                      subtitle: Text(
                        DateFormat('dd.MM.yyyy')
                            .format(DateTime.parse(snapshot.data![index].date)),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _onDeleteButtonPressed(
                                    context, snapshot.data![index]);
                              }),
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _onEditButtonPressed(context, snapshot, index);
                              }),
                        ],
                      ),
                      onTap: () {
                         Navigator.of(context).pushNamed(Routes.vaccinationDetailPage,
                              arguments: VaccinationAndDogProfile(snapshot.data![index], _dogProfiles.where((element) => element.id == snapshot.data![index].dogProfileId).single));
                      },
                    );
                  },
                  separatorBuilder: (BuildContext, index) {
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
            tooltip: 'Přidat nový profil',
            child: const Icon(Icons.add)));
  }
}
