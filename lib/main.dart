import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path/path.dart';
import 'package:pejskari/pages/Articles/ArticlesPage.dart';
import 'package:pejskari/pages/DogProfile/DogProfileDetailPage.dart';
import 'package:pejskari/pages/DogProfile/DogProfileEditPage.dart';
import 'package:pejskari/pages/DogProfile/DogProfilesPage.dart';
import 'package:pejskari/pages/DogWeight/DogWeightDetailPage.dart';
import 'package:pejskari/pages/DogWeight/DogWeightEditPage.dart';
import 'package:pejskari/pages/DogWeight/DogWeightPage.dart';
import 'package:pejskari/pages/Help/HelpPage.dart';
import 'package:pejskari/pages/HomePage/HomePage.dart';
import 'package:pejskari/pages/Mediciation/MedicationDetailPage.dart';
import 'package:pejskari/pages/Mediciation/MedicationEditPage.dart';
import 'package:pejskari/pages/Mediciation/MedicationsPage.dart';
import 'package:pejskari/pages/Notification/NotificationEditPage.dart';
import 'package:pejskari/pages/Notification/NotificationsPage.dart';
import 'package:pejskari/pages/Vaccination/VaccinationDetailPage.dart';
import 'package:pejskari/pages/Vaccination/VaccinationEditPage.dart';
import 'package:pejskari/pages/Vaccination/VaccinationsPage.dart';
import 'package:pejskari/pages/Vet/VetDetailPage.dart';
import 'package:pejskari/pages/Vet/VetEditPage.dart';
import 'package:pejskari/pages/Vet/VetsPage.dart';
import 'package:pejskari/pages/VetVisit/VetVisitDetailPage.dart';
import 'package:pejskari/pages/VetVisit/VetVisitEditPage.dart';
import 'package:pejskari/pages/VetVisit/VetVisitPage.dart';
import 'package:pejskari/pages/Walk/WalkDetailPage.dart';
import 'package:pejskari/pages/Walk/WalkEditPage.dart';
import 'package:pejskari/pages/Walk/WalkPage.dart';
import 'package:pejskari/pages/Walk/WalksPage.dart';
import 'package:pejskari/routes/Routes.dart';
import 'package:pejskari/service/NotificationService.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(),
        'app_database.db'), // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE dog_profile(id INTEGER PRIMARY KEY, name TEXT, breed TEXT, height INTEGER)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await NotificationService().init();

  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(useMaterial3: true),
      title: 'Pejskaři',
      navigatorKey: navigatorKey,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('cs'),
      ],
      home: const HomePage(),
      routes: {
        Routes.dogProfiles: (context) => const DogProfilesPage(),
        Routes.dogProfileEdit: (context) => const DogProfileEditPage(),
        Routes.dogProfileDetail: (context) => const DogProfileDetailPage(),
        Routes.dogWeightPage: (context) => const DogWeightPage(),
        Routes.dogWeightEditPage: (context) => const DogWeightEditPage(),
        Routes.dogWeightDetailPage: (context) => const DogWeightDetailPage(),
        Routes.vetVisitPage: (context) => const VetVisitPage(),
        Routes.vetVisitEditPage: (context) => const VetVisitEditPage(),
        Routes.vetVisitDetailPage: (context) => const VetVisitDetailPage(),
        Routes.walkPage: (context) => const WalkPage(),
        Routes.walksPage: (context) => const WalksPage(),
        Routes.walkEditPage: (context) => const WalkEditPage(),
        Routes.walkDetailPage: (context) => const WalkDetailPage(),
        Routes.vaccinationsPage: (context) => const VaccinationsPage(),
        Routes.vaccinationEditPage: (context) => const VaccinationEditPage(),
        Routes.vaccinationDetailPage: (context) => const VaccinationDetailPage(),
        Routes.notificationsPage: (context) => const NotificationsPage(),
        Routes.notificationsEditPage: (context) => const NotificationEditPage(),
        Routes.vetsPage: (context) => const VetsPage(),
        Routes.vetEditPage: (context) => const VetEditPage(),
        Routes.vetDetailPage: (context) => const VetDetailPage(),
        Routes.medicationsPage: (context) => const MedicationsPage(),
        Routes.medicationEditPage: (context) => const MedicationEditPage(),
        Routes.medicationDetailPage: (context) => const MedicationDetailPage(),
        Routes.articlesPage: (context) => const ArticlesPage(),
        Routes.helpPage: (context) => const HelpPage(),
      },
    );
  }
}
