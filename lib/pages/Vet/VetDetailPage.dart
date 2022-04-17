import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pejskari/data/Vet.dart';
import 'package:pejskari/util/DataPairUtil.dart';

/// This class represents page with detail of vet.
class VetDetailPage extends StatelessWidget {
  static const String routeName = "/vets/detail";

  const VetDetailPage({Key? key}) : super(key: key);

  /// Prepares data for displaying on this page.
  _prepareVetData(Vet vet) {
    var list = [];
    var name = DataPairUtil.createMapForAttribute("Jméno veterináře", vet.name);
    list.add(name);
    var phone = DataPairUtil.createMapForAttribute("Telefon", vet.phone);
    list.add(phone);

    return list;
  }

  @override
  Widget build(BuildContext context) {
    var vetData = ModalRoute.of(context)!.settings.arguments as Vet;
    var data = _prepareVetData(vetData);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Veterinář"),
        ),
        body: Center(
            child: Column(children: [
          GridView.builder(
            itemCount: data.length,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 40.0 / 10.0,
              crossAxisCount: 1,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  padding: EdgeInsets.all(2),
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
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(data[index]["title"] +
                                " zkopírováno do schránky.")));
                      });
                    },
                  ));
            },
          ),
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
                      leading: Container(child: Icon(Icons.album)),
                      title: const Text("Poznámky"),
                      subtitle: SingleChildScrollView(
                          child: Text(vetData.notes.toString()),
                          padding: const EdgeInsets.only(bottom: 10)),
                    ),
                  )))),
        ])));
  }
}
