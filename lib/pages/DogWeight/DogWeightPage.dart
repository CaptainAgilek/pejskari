import 'package:flutter/material.dart';
import 'package:pejskari/NavigationDrawer.dart';
import 'package:pejskari/data/DogProfile.dart';
import 'package:pejskari/pages/DogWeight/DogWeightChartTab.dart';
import 'package:pejskari/pages/DogWeight/DogWeightEditPageArgs.dart';
import 'package:pejskari/pages/DogWeight/DogWeightRecordsTab.dart';
import 'package:pejskari/routes/Routes.dart';
import 'package:pejskari/service/DogProfileService.dart';

/// This class represents page with dog weight records.
class DogWeightPage extends StatefulWidget {
  static const String routeName = "/dog-weight";

  const DogWeightPage({Key? key}) : super(key: key);

  @override
  _DogWeightPageState createState() => _DogWeightPageState();
}

class _DogWeightPageState extends State<DogWeightPage> {
  final DogProfileService _dogProfileService = DogProfileService();
  List<DogProfile> _dogProfiles = [];
  int _tabIndex = 0;

  @override
  initState() {
    super.initState();
    _fetchDogProfiles();
  }

  /// Fetches dog profiles from database.
  _fetchDogProfiles() async {
    _dogProfiles = await _dogProfileService.getAll();
    setState(() {
    });
  }

  _onTabTapped(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  /// This method opens page for adding dog weight. If no dog profile exists, then shows alert.
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
          Routes.dogWeightEditPage,
          arguments: DogWeightEditPageArgs(null, _dogProfiles));
      if (result == true) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            drawer: const NavigationDrawer(),
            appBar: AppBar(
              title: const Text("Váha"),
              bottom: TabBar(
                onTap: (index) {
                  _onTabTapped(index);
                },
                tabs: const [
                  Tab(text: "ZÁZNAMY"),
                  Tab(text: "GRAF"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                DogWeightRecordsTab(dogProfiles: _dogProfiles),
                DogWeightChartTab(dogProfiles: _dogProfiles),
              ],
            ),
            floatingActionButton: _tabIndex == 0
                ? FloatingActionButton(
                    onPressed: () {
                      _onAddButtonPressed(context);
                    },
                    tooltip: 'Přidat nový záznam o váze',
                    child: const Icon(Icons.add))
                : null));
  }
}
