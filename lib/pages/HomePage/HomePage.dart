import 'package:flutter/material.dart';
import 'package:pejskari/NavigationDrawer.dart';
import 'package:pejskari/data/Walk.dart';
import 'package:pejskari/pages/HomePage/MenuItem.dart';
import 'package:pejskari/routes/Routes.dart';
import 'package:pejskari/service/WalkService.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WalkService _walkService = WalkService();
  int _walksTodayCount = 0;
  var _menuData;

  @override
  void initState() {
    super.initState();
    _getDailyWalksCount().then((value) {
      if (mounted) {
        setState(() {
          _walksTodayCount = value;
        });
      }
    });
  }

  /// Calculates how many walks were done today.
  Future<int> _getDailyWalksCount() async {
    List<Walk> walks = await _walkService.getAll();

    var now = DateTime.now();

    int walksTodayCount = 0;
    for (var walk in walks) {
      var date = DateTime.parse(walk.date);

      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        walksTodayCount++;
      }
    }

    return walksTodayCount;
  }

  _prepareMenuData() {
    var list = [];
    const iconColor = Colors.blueGrey;
    var menuIcon1 = MenuItem(
        const Icon(
          Icons.account_circle,
          color: iconColor,
        ),
        NavigationDrawer.DOG_PROFILES,
        Routes.dogProfiles);
    list.add(menuIcon1);

    var menuIcon2 = MenuItem(const Icon(Icons.notifications, color: iconColor),
        NavigationDrawer.NOTIFICATION, Routes.notificationsPage);
    list.add(menuIcon2);

    var menuIcon3 = MenuItem(const Icon(Icons.monitor_weight, color: iconColor),
        NavigationDrawer.WEIGHT, Routes.dogWeightPage);
    list.add(menuIcon3);

    var menuIcon4 = MenuItem(
        const Icon(Icons.medical_services, color: iconColor),
        NavigationDrawer.VETS,
        Routes.vetsPage);
    list.add(menuIcon4);

    var menuIcon5 = MenuItem(const Icon(Icons.medication, color: iconColor),
        NavigationDrawer.VACCINATION, Routes.vaccinationsPage);
    list.add(menuIcon5);

    var menuIcon6 = MenuItem(
        const Icon(Icons.medication_liquid, color: iconColor),
        NavigationDrawer.MEDICATION,
        Routes.medicationsPage);
    list.add(menuIcon6);

    var menuIcon7 = MenuItem(
        const Icon(Icons.health_and_safety, color: iconColor),
        NavigationDrawer.VET_VISITS,
        Routes.vetVisitPage);
    list.add(menuIcon7);

    var menuIcon8 = MenuItem(const Icon(Icons.map, color: iconColor),
        NavigationDrawer.WALK, Routes.walkPage);
    list.add(menuIcon8);

    var menuIcon9 = MenuItem(const Icon(Icons.edit_road, color: iconColor),
        NavigationDrawer.WALKS, Routes.walksPage);
    list.add(menuIcon9);

    var menuIcon10 = MenuItem(const Icon(Icons.article, color: iconColor),
        NavigationDrawer.ARTICLES, Routes.articlesPage);
    list.add(menuIcon10);

    var menuIcon11 = MenuItem(const Icon(Icons.help, color: iconColor),
        NavigationDrawer.HELP, Routes.helpPage);
    list.add(menuIcon11);

    return list;
  }

  @override
  Widget build(BuildContext context) {
    _menuData = _prepareMenuData();

    return Scaffold(
        appBar: AppBar(),
        drawer: const NavigationDrawer(),
        body: Column(children: [
          Flexible(
              flex: 1,
              child: Center(
                child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, bottom: 10, top: 10),
                    child: Card(
                        child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Align(
                                alignment: Alignment.center,
                                child: Wrap(children: [
                                  Visibility(
                                    visible: _walksTodayCount == 0,
                                    child: const Center(
                                      child: Text(
                                          "Dnes jste ještě nebyli na procházce."),
                                    ),
                                  ),
                                  Visibility(
                                      visible: _walksTodayCount > 0,
                                      child: RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            const TextSpan(
                                                text: 'Dnes procházek: ',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            TextSpan(
                                                text:
                                                    _walksTodayCount.toString(),
                                                style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 24)),
                                          ],
                                        ),
                                      ))
                                ]))))),
              )),
          Flexible(
              flex: 7,
              child: GridView.builder(
                itemCount: _menuData.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 10.0 / 9.0,
                  crossAxisCount: 2,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: Card(
                        semanticContainer: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child: FittedBox(
                                  child: _menuData[index].icon,
                                  fit: BoxFit.fill,
                                )),
                                Text(_menuData[index].name),
                              ],
                            ),
                            onTap: () {
                              if (NavigationDrawer.isWalkActive) {
                                Navigator.of(context)
                                    .pushNamed(_menuData[index].route);
                              } else {
                                Navigator.of(context).pushReplacementNamed(
                                    _menuData[index].route);
                              }
                            })),
                  );
                },
              )),
        ]));
  }
}
