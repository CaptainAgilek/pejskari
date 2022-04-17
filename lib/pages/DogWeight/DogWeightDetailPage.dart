import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pejskari/pages/DogWeight/DogWeightRecordsTab.dart';
import 'package:pejskari/util/DataPairUtil.dart';

/// This class represents page with detail of dog weight.
class DogWeightDetailPage extends StatelessWidget {
  static const String routeName = "/dog-weight/detail";

  const DogWeightDetailPage({Key? key}) : super(key: key);

  /// Prepares data for page.
  _prepareData(DogWeightAndProfile data) {
    var list = [];
    var date = DataPairUtil.createMapForAttribute("Datum vážení",
        DateFormat('dd.MM.yyyy').format(DateTime.parse(data.dogWeight.date)));
    list.add(date);
    var height = DataPairUtil.createMapForAttribute(
        "Váha", data.dogWeight.weight.toString() + " kg");
    list.add(height);

    return list;
  }


  @override
  Widget build(BuildContext context) {
    //extract dog profile from arguments
    final _args = ModalRoute.of(context)!.settings.arguments;
    var dogWeightAndProfile = _args as DogWeightAndProfile;
    var data = _prepareData(dogWeightAndProfile);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Záznam o váze psa"),
        ),
        body: Center(
            child: Column(children: [
          const SizedBox(height: 10),
          CircleAvatar(
              radius: 70,
              backgroundImage: Image.file(
                      File(dogWeightAndProfile.dogProfile.profileImagePath),
                      fit: BoxFit.cover)
                  .image),
          const SizedBox(height: 10),
          Text(dogWeightAndProfile.dogProfile.name,
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black87, //font color
                  fontStyle: FontStyle.normal)),
          Expanded(
              child: GridView.builder(
            itemCount: data.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 40.0 / 10.0,
              crossAxisCount: 1,
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
                              ListTile(
                                contentPadding: const EdgeInsets.only(left: 10),
                                minLeadingWidth: 18,
                                // minLeadingWidth: 0, contentPadding:EdgeInsets.all(3),
                                leading: Container(child: const Icon(Icons.album)),
                                title: Text(data[index]["title"]),
                                subtitle: Text(data[index]["value"]),
                              )
                            ],
                          )),
                      onTap: () {
                        Clipboard.setData(
                                ClipboardData(text: data[index]["value"]))
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(data[index]["title"] +
                                  " zkopírováno do schránky.")));
                        });
                      }));
            },
          )),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 2, right: 2, bottom: 2),
                  child: GestureDetector(
                      child: Card(
                    semanticContainer: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      isThreeLine: true,
                      contentPadding: const EdgeInsets.only(left: 10),
                      minLeadingWidth: 18,
                      // minLeadingWidth: 0, contentPadding:EdgeInsets.all(3),
                      leading: Container(child: const Icon(Icons.album)),
                      title: const Text("Poznámky"),
                      subtitle: SingleChildScrollView(
                          child: Text(
                              dogWeightAndProfile.dogWeight.notes.toString()),
                          padding: const EdgeInsets.only(bottom: 10)),
                    ),
                  ))))
        ])));
  }
}
