import 'package:flutter/material.dart';
import 'package:pejskari/NavigationDrawer.dart';
import 'package:pejskari/data/DogProfile.dart';
import 'package:pejskari/data/Vet.dart';
import 'package:pejskari/pages/VetVisit/VetVisitEditPageArgs.dart';
import 'package:pejskari/pages/VetVisit/VetVisitRecordsTab.dart';
import 'package:pejskari/routes/Routes.dart';
import 'package:pejskari/service/DogProfileService.dart';
import 'package:pejskari/service/VetService.dart';

/// This class represents page with vet visits.
class VetVisitPage extends StatefulWidget {
  static const String routeName = "/vet-visit";

  const VetVisitPage({Key? key}) : super(key: key);

  @override
  _VetVisitPageState createState() => _VetVisitPageState();
}

class _VetVisitPageState extends State<VetVisitPage> {
  final DogProfileService _dogProfileService = DogProfileService();
  final VetService _vetService = VetService();

  List<DogProfile> _dogProfiles = [];
  List<Vet> _vets = [];
  int _tabIndex = 0;

  @override
  initState() {
    super.initState();
    _fetchDogProfiles();
    _fetchVets();
  }

  _onTabTapped(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  /// Fetches dog profiles from database.
  _fetchDogProfiles() async {
    _dogProfiles = await _dogProfileService.getAll();
    setState(() {});
  }

  /// Fetches vets from database.
  _fetchVets() async {
    _vets = await _vetService.getAll();
  }

  /// Opens page for adding new vet visit. IF no dog profile exists, then shows alert.
  _onAddButtonPressed(BuildContext context) async {
    if (_dogProfiles.isEmpty) {
      var result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Nemáte vytvořený žádný profil psa'),
          content: const Text(
              "Nemůžete vytvářet záznamy bez vytvořeného profilu psa."),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Rozumím'),
            ),
          ],
        ),
      );
    } else if (_vets.isEmpty) {
      var result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Nemáte přidaného žádného veterináře.'),
          content: const Text(
              "Nemůžete vytvářet záznamy bez vytvořeného veterináře."),
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
          Routes.vetVisitEditPage,
          arguments: VetVisitEditPageArgs(null, _dogProfiles, _vets));
      if (result == true) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 1,
        child: Scaffold(
            drawer: NavigationDrawer(),
            appBar: AppBar(
              title: const Text("Návštěvy veterináře"),
              bottom: TabBar(
                onTap: (index) {
                  _onTabTapped(index);
                },
                tabs: const [
                  Tab(text: "ZÁZNAMY"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                VetVisitRecordsTab(
                  dogProfiles: _dogProfiles,
                  vets: _vets,
                ),
              ],
            ),
            floatingActionButton: _tabIndex == 0
                ? FloatingActionButton(
                    onPressed: () {
                      _onAddButtonPressed(context);
                    },
                    tooltip: 'Přidat nový záznam o návštěvě veterináře',
                    child: Icon(Icons.add))
                : null));
  }
}
