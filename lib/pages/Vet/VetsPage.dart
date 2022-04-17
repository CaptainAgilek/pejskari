import 'package:flutter/material.dart';
import 'package:pejskari/NavigationDrawer.dart';
import 'package:pejskari/data/Vet.dart';
import 'package:pejskari/routes/Routes.dart';
import 'package:pejskari/service/VetService.dart';
import 'package:url_launcher/url_launcher.dart';

class VetsPage extends StatefulWidget {
  static const String routeName = "/vets";

  const VetsPage({Key? key}) : super(key: key);

  @override
  _VetsPageState createState() => _VetsPageState();
}

class _VetsPageState extends State<VetsPage> {
  final VetService _vetService = VetService();

  /// Opens page for adding new vet.
  _onAddButtonPressed(BuildContext context) async {
    final result = await Navigator.of(context)
        .pushNamed(Routes.vetEditPage, arguments: const Vet(0, "", "", ""));
    if (result == true) {
      setState(() {});
    }
  }

  /// Opens page for editing vet.
  _onEditButtonPressed(BuildContext context, snapshot, index) async {
    final result = await Navigator.of(context)
        .pushNamed(Routes.vetEditPage, arguments: snapshot.data![index]);
    if (result == true) {
      setState(() {});
    }
  }

  /// Deletes vet.
  _onDeleteButtonPressed(BuildContext context, Vet vet) async {
    var result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Chcete opravdu smazat záznam?'),
        content: const Text("Záznam veterináře bude nevratně smazán."),
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
      await _vetService.delete(vet.id);
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Smazáno")));
      });
    }
  }

  /// Calls phone number.
  _callPhone(String phoneNumber) async {
    String url = "tel:" + phoneNumber;
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Veterináři"),
        ),
        drawer: const NavigationDrawer(),
        body: FutureBuilder(
            future: _vetService.getAll(),
            builder: (context, AsyncSnapshot<List<Vet>> snapshot) {
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
                      leading: const Icon(Icons.medical_services),
                      title: Text(snapshot.data![index].name),
                      subtitle: Text(snapshot.data![index].phone),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (snapshot.data![index].phone.isNotEmpty)
                            IconButton(
                                icon: const Icon(
                                  Icons.phone,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  _callPhone(snapshot.data![index].phone);
                                }),
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
                        Navigator.of(context).pushNamed(Routes.vetDetailPage,
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
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              _onAddButtonPressed(context);
            },
            tooltip: 'Přidat nového veterináře',
            child: const Icon(Icons.add)));
  }
}
