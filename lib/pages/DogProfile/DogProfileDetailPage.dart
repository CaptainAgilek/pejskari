import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pejskari/data/DogProfile.dart';
import 'package:pejskari/util/AgeUtil.dart';
import 'package:pejskari/util/DataPairUtil.dart';

/// This class represents page with detail of dog profile.
class DogProfileDetailPage extends StatelessWidget {
  static const String routeName = "/dog-profiles/detail";

  const DogProfileDetailPage({Key? key}) : super(key: key);

  _prepareProfileData(DogProfile dogProfile) {
    var list = [];
    var dob = DataPairUtil.createMapForAttribute(
        "Datum narození",
        DateFormat('dd.MM.yyyy')
            .format(DateTime.parse(dogProfile.dateOfBirth)));
    list.add(dob);
    var height =
    DataPairUtil.createMapForAttribute("Výška", dogProfile.height.toString() + " cm");
    list.add(height);
    var chipId = DataPairUtil.createMapForAttribute("Kód čipu", dogProfile.chipId);
    list.add(chipId);

    var castrated = DataPairUtil.createMapForAttribute(
        "Kastrace", dogProfile.castrated == 0 ? "Ne" : "Ano");
    list.add(castrated);

    return list;
  }


  @override
  Widget build(BuildContext context) {
    //extract dog profile from arguments
    final _args = ModalRoute.of(context)!.settings.arguments;
    var dogProfile = _args as DogProfile;
    var profileData = _prepareProfileData(dogProfile);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Profil psa"),
        ),
        body: Center(
            child: Column(children: [
          const SizedBox(height: 10),
          CircleAvatar(
              radius: 70,
              backgroundImage: dogProfile.profileImagePath == ""
                  ? Image.asset("assets/dog_avatar.png").image
                  : Image.file(File(dogProfile.profileImagePath),
                          fit: BoxFit.cover)
                      .image),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              dogProfile.gender == 0
                      ? const Icon(
                          Icons.male,
                          color: Colors.blue,
                        )
                      : const Icon(
                          Icons.female,
                          color: Colors.pinkAccent,
                        ),
              Text(dogProfile.name,
                  style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black87, //font color
                      fontStyle: FontStyle.normal)),

            ],
          ),
          if (dogProfile.breed.isNotEmpty)
            Text(dogProfile.breed,
                style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black38, //font color
                    fontStyle: FontStyle.normal)),
          Text(AgeUtil.computeAgeString(dogProfile.dateOfBirth),
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black38, //font color
                  fontStyle: FontStyle.normal)),
          Expanded(
              child: GridView.builder(
            itemCount: profileData.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 17.0 / 10.0,
              crossAxisCount: 2,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  padding: const EdgeInsets.all(2),
                  child: GestureDetector(
                    child: Card(
                        semanticContainer: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                child: ListTile(
                              contentPadding: const EdgeInsets.only(left: 10),
                              minLeadingWidth: 18,
                              leading: Container(child: const Icon(Icons.album)),
                              title: Text(profileData[index]["title"]),
                              subtitle: Text(profileData[index]["value"]),
                            ))
                          ],
                        )),
                    onTap: () {
                      Clipboard.setData(
                              ClipboardData(text: profileData[index]["value"]))
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(profileData[index]["title"] +
                                " zkopírováno do schránky.")));
                      });
                    },
                  ));
            },
          ))
        ])));
  }
}
