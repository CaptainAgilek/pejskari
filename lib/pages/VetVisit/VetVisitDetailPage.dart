import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:pejskari/pages/VetVisit/VetVisitEnhancedData.dart';
import 'package:pejskari/util/DataPairUtil.dart';

/// This class represents page with detail of vet visit.
class VetVisitDetailPage extends StatefulWidget {
  static const String routeName = "/vet-visit/detail";

  const VetVisitDetailPage({Key? key}) : super(key: key);

  @override
  _VetVisitDetailPageState createState() => _VetVisitDetailPageState();
}

class _VetVisitDetailPageState extends State<VetVisitDetailPage> {
  bool _documentsPanelExpanded = false;
  final expansionKey = GlobalKey();

  /// Prepares data for displaying on this page.
  _prepareData(VetVisitEnhancedData data) {
    var list = [];
    var date = DataPairUtil.createMapForAttribute("Datum návštěvy",
        DateFormat('dd.MM.yyyy').format(DateTime.parse(data.vetVisit.date)));
    list.add(date);
    var vetName = DataPairUtil.createMapForAttribute("Jméno veterináře", data.vet.name);
    list.add(vetName);

    return list;
  }

  //https://stackoverflow.com/a/65088773/6713035
  /// Scrolls to widget marked with expansionKey.
  void _scrollToExpanded() {
    final keyContext = expansionKey.currentContext;
    if (keyContext != null) {
      Future.delayed(const Duration(milliseconds: 200)).then((value) {
        Scrollable.ensureVisible(keyContext,
            duration: const Duration(milliseconds: 200));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //extract dog profile from arguments
    final _args = ModalRoute.of(context)!.settings.arguments;
    var vetVisitAndDogProfile = _args as VetVisitEnhancedData;
    var data = _prepareData(vetVisitAndDogProfile);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Návštěva veterináře"),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Column(children: [
          const SizedBox(height: 10),
          CircleAvatar(
              radius: 70,
              backgroundImage:
                  vetVisitAndDogProfile.dogProfile.profileImagePath == ""
                      ? Image.asset(
                          "assets/dog_avatar.png",
                          fit: BoxFit.cover,
                        ).image
                      : Image.file(
                              File(vetVisitAndDogProfile
                                  .dogProfile.profileImagePath),
                              fit: BoxFit.cover)
                          .image),
          const SizedBox(height: 10),
          Text(vetVisitAndDogProfile.dogProfile.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black87, //font color
                  fontStyle: FontStyle.normal)),
          GridView.builder(
            shrinkWrap: true,
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
          ),
          Padding(
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
                      child:
                          Text(vetVisitAndDogProfile.vetVisit.notes.toString()),
                      padding: const EdgeInsets.only(bottom: 10)),
                ),
              ))),
          ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _documentsPanelExpanded = !isExpanded;
                  if (_documentsPanelExpanded == true) {
                    _scrollToExpanded();
                  }
                });
              },
              children: [
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return const ListTile(
                      title: Text("Dokumenty"),
                    );
                  },
                  body: GridView.builder(
                    key: expansionKey,
                    physics: const ScrollPhysics(),
                    itemCount:
                        vetVisitAndDogProfile.vetVisit.documentPaths.length,
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 20.0 / 20, crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: const EdgeInsets.all(2),
                          child: GestureDetector(
                              child: Container(
                                width: double.infinity,
                                child: Card(
                                  semanticContainer: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(children: [
                                    Expanded(
                                        child: vetVisitAndDogProfile
                                                .vetVisit.documentPaths
                                                .elementAt(index)
                                                .endsWith(".pdf")
                                            ? const FittedBox(
                                                child: Icon(Icons
                                                    .picture_as_pdf_outlined),
                                                fit: BoxFit.fill,
                                              )
                                            : Image.file(
                                                File(vetVisitAndDogProfile
                                                    .vetVisit.documentPaths
                                                    .elementAt(index)),
                                                fit: BoxFit.cover,
                                              )),
                                    Padding(
                                        padding: const EdgeInsets.only(left: 3),
                                        child: Text(
                                          basename(vetVisitAndDogProfile
                                              .vetVisit.documentPaths
                                              .elementAt(index)),
                                          overflow: TextOverflow.ellipsis,
                                        ))
                                  ]),
                                ),
                              ),
                              onTap: () {
                                OpenFile.open(vetVisitAndDogProfile
                                    .vetVisit.documentPaths
                                    .elementAt(index));
                              }));
                    },
                  ),
                  isExpanded: _documentsPanelExpanded,
                )
              ])
        ]))));
  }
}
