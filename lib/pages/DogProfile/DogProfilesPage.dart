import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pejskari/data/DogProfile.dart';
import 'package:pejskari/routes/Routes.dart';
import 'package:pejskari/service/DogProfileService.dart';

import '../../NavigationDrawer.dart';

/// This class represents page with dog profiles.
class DogProfilesPage extends StatefulWidget {
  static const String routeName = "/dog-profiles";

  const DogProfilesPage({Key? key}) : super(key: key);

  @override
  _DogProfilesPageState createState() => _DogProfilesPageState();
}

class _DogProfilesPageState extends State<DogProfilesPage> {
  final DogProfileService dogProfileService = DogProfileService();
  List<DogProfile> _dogProfiles = [];

  Future<List<DogProfile>> fetchDogProfiles() async {
    _dogProfiles = await dogProfileService.getAll();
    return _dogProfiles;
  }

   /// This method opens page for editing dog profile.
  _onEditButtonPressed(BuildContext context, snapshot, index) async {
    final result = await Navigator.of(context)
        .pushNamed(Routes.dogProfileEdit, arguments: snapshot.data![index]);
    if (result == true) {
      setState(() {});
    }
  }

  /// This method opens page for adding new dog profile.
  _onAddButtonPressed(BuildContext context) async {
    final result = await Navigator.of(context).pushNamed(Routes.dogProfileEdit);
    if (result == true) {
      setState(() {});
    }
  }

  /// This method deletes dog profile.
  _onDeleteButtonPressed(BuildContext context, DogProfile dogProfile) async {
    var result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Chcete opravdu profil smazat?'),
        content: Text("Profil psa " + dogProfile.name + " bude smazán."),
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
      await dogProfileService.delete(dogProfile.id);
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
          title: const Text("Profily psů"),
        ),
        drawer: const NavigationDrawer(),
        body: FutureBuilder(
            future: dogProfileService.getAll(),
            builder: (context, AsyncSnapshot<List<DogProfile>> snapshot) {
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
                      leading: CircleAvatar(
                          backgroundImage: snapshot.data![index].profileImagePath == "" ? Image.asset("assets/dog_avatar.png").image : Image.file(
                                  File(snapshot.data![index].profileImagePath),
                                  fit: BoxFit.cover)
                              .image),
                      title: Text(snapshot.data![index].name),
                      subtitle: Text(snapshot.data![index].breed),
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
                        Navigator.of(context).pushNamed(Routes.dogProfileDetail,
                            arguments: snapshot.data![index]);
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
