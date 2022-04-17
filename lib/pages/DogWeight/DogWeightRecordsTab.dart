import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pejskari/data/DogProfile.dart';
import 'package:pejskari/data/DogWeight.dart';
import 'package:pejskari/pages/DogWeight/DogWeightEditPageArgs.dart';
import 'package:pejskari/routes/Routes.dart';
import 'package:pejskari/service/DogWeightService.dart';

/// This class represents tab page with dog weight records.
class DogWeightRecordsTab extends StatefulWidget {
  final List<DogProfile> dogProfiles;

  const DogWeightRecordsTab({Key? key, required this.dogProfiles}) : super(key: key);

  @override
  _DogWeightRecordsTabState createState() => _DogWeightRecordsTabState();
}

class _DogWeightRecordsTabState extends State<DogWeightRecordsTab> {
  final DogWeightService _dogWeightService = DogWeightService();

  /// Pairs dog weight records with dog profiles.
  Future<List<DogWeightAndProfile>> _pairDogWeightsAndProfiles() async {
    var weights = await _dogWeightService.getAll();

    var list = weights
        .map((e) => DogWeightAndProfile(
            e,
            widget.dogProfiles.singleWhere(
                (element) => (e.dogProfileId == element.id),
                orElse: () => DogProfile(1, "", "", "", "", 0, "", 0, 0))))
        .toList();
    return list;
  }

  /// Opens page for editing dog weight record.
  _onEditButtonPressed(BuildContext context, snapshot, index) async {
    final result = await Navigator.of(context).pushNamed(
        Routes.dogWeightEditPage,
        arguments:
            DogWeightEditPageArgs(snapshot.data![index], widget.dogProfiles));
    if (result == true) {
      setState(() {});
    }
  }

  /// Deletes dog weight record.
  _onDeleteButtonPressed(BuildContext context, DogWeight dogWeight) async {
    var result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Chcete opravdu smazat záznam o váze?'),
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
      await _dogWeightService.delete(dogWeight.id);
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Smazáno")));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _pairDogWeightsAndProfiles(),
      builder: (context, AsyncSnapshot<List<DogWeightAndProfile>> snapshot) {
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
                            ? Image.asset("assets/dog_avatar.png").image
                            : Image.file(
                                    File(snapshot.data![index].dogProfile
                                        .profileImagePath),
                                    fit: BoxFit.cover)
                                .image),
                title: Text(snapshot.data![index].dogProfile.name +
                    " " +
                    snapshot.data![index].dogWeight.weight.toString() +
                    " Kg"),
                subtitle: Text(DateFormat('dd.MM.yyyy').format(
                    DateTime.parse(snapshot.data![index].dogWeight.date))),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _onDeleteButtonPressed(
                              context, snapshot.data![index].dogWeight);
                        }),
                    IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _onEditButtonPressed(context, snapshot, index);
                        }),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.dogWeightDetailPage,
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

class DogWeightAndProfile {
  DogWeight dogWeight;
  DogProfile dogProfile;

  DogWeightAndProfile(this.dogWeight, this.dogProfile);
}
