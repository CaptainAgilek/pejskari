import 'package:flutter/material.dart';
import 'package:pejskari/NavigationDrawer.dart';

/// This class represents page with help.
class HelpPage extends StatefulWidget {
  static const String routeName = "/help";

  const HelpPage({Key? key}) : super(key: key);

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          title: const Text("Nápověda"),
        ),
        bottomNavigationBar: Text("https://icons8.com"),
        body: ListView(padding: const EdgeInsets.all(8), children: const [
          Text(
              "Aplikace Pejskaři slouží k evidenci informací o Vašem psovi a také evidenci již proběhlých událostí. Můžete také vytvářet upozornění pro nadcházející události."),
          SizedBox(height: 8,),
          Text(
              "Funkcionalita pro zobrazení psích parků a cvičišť na mapě vyžaduje internetové připojení."),
          SizedBox(height: 8,),
          Text(
              "Funkcionalita pro zobrazení článků vyžaduje internetové připojení.")
        ]));
  }
}
