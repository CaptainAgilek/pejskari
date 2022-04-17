import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pejskari/pages/Vaccination/VaccinationAndDogProfile.dart';
import 'package:pejskari/util/DataPairUtil.dart';

/// This class represents page with detail of vaccination.
class VaccinationDetailPage extends StatelessWidget {
  static const String routeName = "/vaccinations/detail";

  const VaccinationDetailPage({Key? key}) : super(key: key);

  /// Prepared data for vaccination page.
  _prepareData(VaccinationAndDogProfile data) {
    var list = [];
    var name = DataPairUtil.createMapForAttribute("Název vakcíny", data.vaccination.name);
    list.add(name);
    var dog = DataPairUtil.createMapForAttribute("Pes", data.dogProfile.name);
    list.add(dog);
    var date = DataPairUtil.createMapForAttribute("Datum návštěvy",
        DateFormat('dd.MM.yyyy').format(DateTime.parse(data.vaccination.date)));
    list.add(date);

    return list;
  }

  @override
  Widget build(BuildContext context) {
    var vaccinationAndDogProfile =
        ModalRoute.of(context)!.settings.arguments as VaccinationAndDogProfile;
    var data = _prepareData(vaccinationAndDogProfile);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Vakcinace"),
        ),
        body: Center(
            child: Column(children: [
          const SizedBox(height: 10),
          Expanded(
              flex: data.length,
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
                                    leading:
                                        Container(child: const Icon(Icons.album)),
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
                          },
                        ));
                  })),
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
                          child: Text(vaccinationAndDogProfile.vaccination.notes
                              .toString()),
                          padding: const EdgeInsets.only(bottom: 10)),
                    ),
                  ))))
        ])));
  }
}
