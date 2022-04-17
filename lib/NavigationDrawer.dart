import 'package:flutter/material.dart';
import 'package:pejskari/routes/Routes.dart';

/// This class represents navigation menu in application.
class NavigationDrawer extends StatelessWidget {
  static const String DOG_PROFILES = "Profily psů";
  static const String NOTIFICATION = "Upozornění";
  static const String WEIGHT = "Váha";
  static const String VETS = "Veterináři";
  static const String VACCINATION = "Vakcinace";
  static const String MEDICATION = "Medikace";
  static const String VET_VISITS = "Návštěvy veterináře";
  static const String WALK = "Procházka";
  static const String WALKS = "Procházky";
  static const String ARTICLES = "Články";
  static const String HELP = "Nápověda";

  static bool isWalkActive = false;

  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // const SizedBox(
          //     height: 90.0,
          //     child: DrawerHeader(
          //       decoration: BoxDecoration(
          //         color: Colors.blue,
          //       ),
          //       child: Text(
          //         'Pejskaři',
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 24,
          //         ),
          //       ),
          //     )),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Domů'),
            onTap: () {
              if (isWalkActive) {
                Navigator.of(context).pushNamed(Routes.homePage);
              } else {
                Navigator.of(context).pushReplacementNamed(Routes.homePage);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text(DOG_PROFILES),
            onTap: () {
              if (isWalkActive) {
                Navigator.of(context).pushNamed(Routes.dogProfiles);
              } else {
                Navigator.of(context).pushReplacementNamed(Routes.dogProfiles);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text(NOTIFICATION),
            onTap: () {
              if (isWalkActive) {
                Navigator.of(context).pushNamed(Routes.notificationsPage);
              } else {
                Navigator.of(context)
                    .pushReplacementNamed(Routes.notificationsPage);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.monitor_weight),
            title: const Text(WEIGHT),
            onTap: () {
              if (isWalkActive) {
                Navigator.of(context).pushNamed(Routes.dogWeightPage);
              } else {
                Navigator.of(context)
                    .pushReplacementNamed(Routes.dogWeightPage);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.medical_services),
            title: const Text(VETS),
            onTap: () {
              if (isWalkActive) {
                Navigator.of(context).pushNamed(Routes.vetsPage);
              } else {
                Navigator.of(context).pushReplacementNamed(Routes.vetsPage);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.medication),
            title: const Text(VACCINATION),
            onTap: () {
              if (isWalkActive) {
                Navigator.of(context).pushNamed(Routes.vaccinationsPage);
              } else {
                Navigator.of(context)
                    .pushReplacementNamed(Routes.vaccinationsPage);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.medication_liquid),
            title: const Text(MEDICATION),
            onTap: () {
              if (isWalkActive) {
                Navigator.of(context).pushNamed(Routes.medicationsPage);
              } else {
                Navigator.of(context)
                    .pushReplacementNamed(Routes.medicationsPage);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.health_and_safety),
            title: const Text(VET_VISITS),
            onTap: () {
              if (isWalkActive) {
                Navigator.of(context).pushNamed(Routes.vetVisitPage);
              } else {
                Navigator.of(context).pushReplacementNamed(Routes.vetVisitPage);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text(WALK),
            onTap: () {
              if (isWalkActive) {
                Navigator.of(context)
                    .popUntil(ModalRoute.withName(Routes.walkPage));
              } else {
                Navigator.of(context).pushReplacementNamed(Routes.walkPage);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_road),
            title: const Text(WALKS),
            onTap: () {
              if (isWalkActive) {
                Navigator.of(context).pushNamed(Routes.walksPage);
              } else {
                Navigator.of(context).pushReplacementNamed(Routes.walksPage);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text(ARTICLES),
            onTap: () {
              if (isWalkActive) {
                Navigator.of(context).pushNamed(Routes.articlesPage);
              } else {
                Navigator.of(context).pushReplacementNamed(Routes.articlesPage);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text(HELP),
            onTap: () {
              if (isWalkActive) {
                Navigator.of(context).pushNamed(Routes.helpPage);
              } else {
                Navigator.of(context).pushReplacementNamed(Routes.helpPage);
              }
            },
          ),
        ],
      ),
    );
  }
}
