import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pejskari/data/DogProfile.dart';
import 'package:pejskari/data/Vet.dart';
import 'package:pejskari/data/VetVisit.dart';
import 'package:pejskari/pages/VetVisit/VetVisitEditPageArgs.dart';
import 'package:pejskari/pages/VetVisit/VetVisitEnhancedData.dart';
import 'package:pejskari/routes/Routes.dart';
import 'package:pejskari/service/VetVisitService.dart';

/// This class represents tab page with vet visit records.
class VetVisitRecordsTab extends StatefulWidget {
  final List<DogProfile> dogProfiles;
  final List<Vet> vets;
  const VetVisitRecordsTab(
      {Key? key, required this.dogProfiles, required this.vets})
      : super(key: key);

  @override
  _VetVisitRecordsTabState createState() => _VetVisitRecordsTabState();
}

class _VetVisitRecordsTabState extends State<VetVisitRecordsTab> {
  final VetVisitService _vetVisitService = VetVisitService();

  /// Pairs vet visits with dog profiles.
  Future<List<VetVisitEnhancedData>> _pairVetVisitsAndDogProfiles() async {
    var visits = await _vetVisitService.getAll();

    var list = visits
        .map((e) => VetVisitEnhancedData(
            e,
            widget.dogProfiles.singleWhere(
                (element) => (e.dogProfileId == element.id),
                orElse: () => DogProfile(0, "", "", "", "", 0, "", 0, 0)),
            widget.vets.singleWhere((element) => (e.vetId == element.id),
                orElse: () => const Vet(0, "", "", ""))))
        .toList();
    return list;
  }

  /// Opens page for editing vet visit.
  _onEditButtonPressed(BuildContext context, snapshot, index) async {
    final result = await Navigator.of(context).pushNamed(
        Routes.vetVisitEditPage,
        arguments: VetVisitEditPageArgs(
            snapshot.data![index], widget.dogProfiles, widget.vets));

    if (result == true) {
      setState(() {});
    }
  }

  /// Deletes vet visit.
  _onDeleteButtonPressed(BuildContext context, VetVisit vetVisit) async {
    var result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title:
            const Text('Chcete opravdu smazat záznam o návštěvě veterináře?'),
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
      await _vetVisitService.delete(vetVisit.id);
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Smazáno")));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _pairVetVisitsAndDogProfiles(),
      builder: (context, AsyncSnapshot<List<VetVisitEnhancedData>> snapshot) {
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
                    backgroundImage:
                        snapshot.data![index].dogProfile.profileImagePath == ""
                            ? Image.asset(
                                "assets/dog_avatar.png",
                                fit: BoxFit.cover,
                              ).image
                            : Image.file(
                                    File(snapshot.data![index].dogProfile
                                        .profileImagePath),
                                    fit: BoxFit.cover)
                                .image),
                title: Text(snapshot.data![index].dogProfile.name),
                subtitle: Text(DateFormat('dd.MM.yyyy').format(
                        DateTime.parse(snapshot.data![index].vetVisit.date)) +
                    "\n" +
                    snapshot.data![index].vet.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _onDeleteButtonPressed(
                              context, snapshot.data![index].vetVisit);
                        }),
                    IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _onEditButtonPressed(context, snapshot, index);
                        }),
                  ],
                  // spacing: 20,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.vetVisitDetailPage,
                      arguments: snapshot.data![index]);
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
      },
    );
  }
}
