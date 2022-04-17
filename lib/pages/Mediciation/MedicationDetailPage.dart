import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pejskari/pages/Mediciation/MedicationEnhancedData.dart';
import 'package:pejskari/util/DataPairUtil.dart';

/// This class represents page with detail of medication.
class MedicationDetailPage extends StatelessWidget {
  static const String routeName = "/medications/detail";

  const MedicationDetailPage({Key? key}) : super(key: key);

  /// Prepares medication data for page.
  _prepareMedicationData(MedicationEnhancedData medication) {
    var list = [];
    var name = DataPairUtil.createMapForAttribute(
        "Název medikace", medication.medication.name);
    list.add(name);
    var dateTime = DataPairUtil.createMapForAttribute(
        "Datum a čas",
        DateFormat("dd.MM.yyyy HH:mm")
            .format(DateTime.parse(medication.medication.dateTime)));
    list.add(dateTime);

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments;
    var medicationEnhancedData = _args as MedicationEnhancedData;
    var data = _prepareMedicationData(medicationEnhancedData);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Medikace"),
        ),
        body: Center(
            child: Column(children: [
          const SizedBox(height: 10),
          CircleAvatar(
              radius: 70,
              backgroundImage:
                  medicationEnhancedData.dogProfile.profileImagePath == ""
                      ? Image.asset("assets/dog_avatar.png").image
                      : Image.file(
                              File(medicationEnhancedData
                                  .dogProfile.profileImagePath),
                              fit: BoxFit.cover)
                          .image),
          const SizedBox(height: 10),
          Text(medicationEnhancedData.dogProfile.name,
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
                            Expanded(
                                child: ListTile(
                              contentPadding: const EdgeInsets.only(left: 10),
                              minLeadingWidth: 18,
                              // minLeadingWidth: 0, contentPadding:EdgeInsets.all(3),
                              leading:
                                  Container(child: const Icon(Icons.album)),
                              title: Text(data[index]["title"]),
                              subtitle: Text(data[index]["value"]),
                            ))
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
                    },
                  ));
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
                          child: Text(medicationEnhancedData.medication.notes
                              .toString()),
                          padding: const EdgeInsets.only(bottom: 10)),
                    ),
                  )))),
        ])));
  }
}
