import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pejskari/pages/Walk/WalkAndDogNames.dart';
import 'package:pejskari/util/DataPairUtil.dart';
import 'package:pejskari/util/TimeFormatUtil.dart';

/// This page represents page with detail of walk.
class WalkDetailPage extends StatelessWidget {
  static const String routeName = "/walk/detail";

  const WalkDetailPage({Key? key}) : super(key: key);

  /// Prepares data for displaying walk on page.
  _prepareData(WalkAndDogNames data) {
    var list = [];
    var date = DataPairUtil.createMapForAttribute("Datum procházky",
        DateFormat('dd.MM.yyyy').format(DateTime.parse(data.walk.date)));
    list.add(date);
    var distance = DataPairUtil.createMapForAttribute(
        "Vzdálenost", data.walk.distance.toStringAsFixed(2) + " km");
    list.add(distance);
    var time = DataPairUtil.createMapForAttribute(
        "Čas",
        TimeFormatUtil.printDurationHHMM(
            Duration(milliseconds: data.walk.time)));
    list.add(time);
    var dogs = DataPairUtil.createMapForAttribute(
        "Psi na procházce", data.dogNames.join(", "));
    list.add(dogs);

    return list;
  }

  @override
  Widget build(BuildContext context) {
    var walkAndDogNames =
        ModalRoute.of(context)!.settings.arguments as WalkAndDogNames;
    var data = _prepareData(walkAndDogNames);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Procházka"),
        ),
        body: Center(
            child: Column(children: [
          const SizedBox(height: 10),
          Expanded(
              flex: 4,
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
                                    contentPadding:
                                        const EdgeInsets.only(left: 10),
                                    minLeadingWidth: 18,
                                    leading: Container(
                                        child: const Icon(Icons.album)),
                                    title: Text(data[index]["title"]),
                                    subtitle: Text(data[index]["value"]),
                                  )
                                ],
                              )),
                          onTap: () {
                            Clipboard.setData(
                                    ClipboardData(text: data[index]["value"]))
                                .then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(data[index]["title"] +
                                          " zkopírováno do schránky.")));
                            });
                          }));
                },
              )),
          Expanded(
              flex: 2,
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
                      leading: Container(child: const Icon(Icons.album)),
                      title: const Text("Poznámky"),
                      subtitle: SingleChildScrollView(
                          child: Text(walkAndDogNames.walk.notes),
                          padding: const EdgeInsets.only(bottom: 10)),
                    ),
                  ))))
        ])));
  }
}
