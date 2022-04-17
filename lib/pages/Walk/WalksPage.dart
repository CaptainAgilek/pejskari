import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pejskari/NavigationDrawer.dart';
import 'package:pejskari/data/DogProfile.dart';
import 'package:pejskari/data/Walk.dart';
import 'package:pejskari/pages/Walk/WalkAndDogNames.dart';
import 'package:pejskari/pages/Walk/WalkEditPageArgs.dart';
import 'package:pejskari/routes/Routes.dart';
import 'package:pejskari/service/DogProfileService.dart';
import 'package:pejskari/service/WalkService.dart';

/// This class represents page with walks.
class WalksPage extends StatefulWidget {
  static const String routeName = "/walks";

  const WalksPage({Key? key}) : super(key: key);

  @override
  _WalksPageState createState() => _WalksPageState();
}

class _WalksPageState extends State<WalksPage> {
  final WalkService _walkService = WalkService();
  final DogProfileService _dogProfileService = DogProfileService();
  List<DogProfile> _dogProfiles = [];
  List<WalkAndDogNames> _walkAndDogNames = [];

  /// Pairs walks with dog names.
  Future<List<WalkAndDogNames>> _pairWalkAndDogNames() async {
    var walks = await _walkService.getAll();
    _dogProfiles = await _dogProfileService.getAll();
    List<WalkAndDogNames> list = [];
    for (var element in walks) {
      var walkAndNames = WalkAndDogNames(element, []);

      for (var profile in _dogProfiles) {
        if (element.dogProfilesIds.contains(profile.id)) {
          walkAndNames.dogNames.add(profile.name);
        }
      }
      list.add(walkAndNames);
    }
    _walkAndDogNames = list;
    return list;
  }

  /// Opens page for editing walk.
  _onEditButtonPressed(BuildContext context, snapshot, index) async {
    final result = await Navigator.of(context).pushNamed(Routes.walkEditPage,
        arguments: WalkEditPageArgs(snapshot.data![index].walk, _dogProfiles));
    if (result == true) {
      setState(() {});
    }
  }

  /// Opens page for adding new walk.
  _onAddButtonPressed(BuildContext context) async {
    final result = await Navigator.of(context).pushNamed(Routes.walkEditPage,
        arguments: WalkEditPageArgs(
            Walk(0, DateTime.now().toIso8601String(), "", 0, 0, []),
            _dogProfiles));
    if (result == true) {
      setState(() {});
    }
  }

  /// Deletes walk from database.
  _onDeleteButtonPressed(BuildContext context, Walk walk) async {
    var result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Chcete opravdu záznam smazat?'),
        content: const Text("Záznam procházky bude smazán."),
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
      await _walkService.delete(walk.id);
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Smazáno")));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Procházky"),
        ),
        drawer: const NavigationDrawer(),
        body: FutureBuilder(
            future: _pairWalkAndDogNames(),
            builder: (context, AsyncSnapshot<List<WalkAndDogNames>> snapshot) {
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
                      leading: const Icon(Icons.directions_run),
                      title: Text(snapshot.data![index].walk.distance
                              .toStringAsFixed(2) +
                          " km"),
                      subtitle: Text(
                        DateFormat('dd.MM.yyyy').format(DateTime.parse(
                                snapshot.data![index].walk.date)) +
                            "\n" +
                            snapshot.data![index].dogNames.join(", "),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _onDeleteButtonPressed(
                                    context, snapshot.data![index].walk);
                              }),
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _onEditButtonPressed(context, snapshot, index);
                              }),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.walkDetailPage,
                            arguments: _walkAndDogNames.where((e) => e.walk == snapshot.data![index].walk).single);
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
            tooltip: 'Přidat nový profil',
            child: const Icon(Icons.add)));
  }
}
